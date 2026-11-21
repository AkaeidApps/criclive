import { logger } from './logger.js';

interface CacheEntry {
  value: unknown;
  expiresAt: number;
}

export interface CacheStore {
  get(key: string): Promise<unknown | undefined>;
  set(key: string, value: unknown, ttlSeconds: number): Promise<void>;
  delete(key: string): Promise<void>;
}

export class MemoryCacheStore implements CacheStore {
  private readonly entries = new Map<string, CacheEntry>();

  async get(key: string): Promise<unknown | undefined> {
    const entry = this.entries.get(key);
    if (!entry) return undefined;
    if (entry.expiresAt <= Date.now()) {
      this.entries.delete(key);
      return undefined;
    }
    return entry.value;
  }

  async set(key: string, value: unknown, ttlSeconds: number): Promise<void> {
    this.entries.set(key, { value, expiresAt: Date.now() + ttlSeconds * 1000 });
  }

  async delete(key: string): Promise<void> {
    this.entries.delete(key);
  }

  clear(): void {
    this.entries.clear();
  }
}

interface RedisLike {
  get(key: string): Promise<string | null>;
  set(key: string, value: string, mode: 'EX', ttl: number): Promise<unknown>;
  del(key: string): Promise<number>;
  quit(): Promise<void>;
}

export class RedisCacheStore implements CacheStore {
  private constructor(private readonly redis: RedisLike) {}

  static async connect(url: string): Promise<RedisCacheStore> {
    const { default: Redis } = await import('ioredis');
    const redis = new Redis(url, {
      lazyConnect: true,
      maxRetriesPerRequest: 1,
      enableOfflineQueue: false,
    });
    await redis.connect();
    return new RedisCacheStore(redis as unknown as RedisLike);
  }

  async get(key: string): Promise<unknown | undefined> {
    const raw = await this.redis.get(key);
    if (raw === null) return undefined;
    try {
      return JSON.parse(raw) as unknown;
    } catch {
      return undefined;
    }
  }

  async set(key: string, value: unknown, ttlSeconds: number): Promise<void> {
    const ttl = Math.max(1, Math.floor(ttlSeconds));
    await this.redis.set(key, JSON.stringify(value), 'EX', ttl);
  }

  async delete(key: string): Promise<void> {
    await this.redis.del(key);
  }

  async close(): Promise<void> {
    await this.redis.quit();
  }
}

export interface CacheResult<T> {
  value: T;
  cached: boolean;
  updatedAt: string;
}

/** TTL cache with in-flight request deduplication. */
export class CacheService {
  private readonly inflight = new Map<string, Promise<unknown>>();

  constructor(
    private readonly store: CacheStore = new MemoryCacheStore(),
    private readonly defaultTtlSeconds = 300,
  ) {}

  async getOrLoad<T>(
    key: string,
    loader: () => Promise<T>,
    options: { ttlSeconds?: number; refresh?: boolean } = {},
  ): Promise<CacheResult<T>> {
    const ttl = options.ttlSeconds ?? this.defaultTtlSeconds;

    if (!options.refresh) {
      const hit = await this.store.get(key);
      if (hit !== undefined) {
        const envelope = hit as { updatedAt: string; value: T };
        return { value: envelope.value, cached: true, updatedAt: envelope.updatedAt };
      }
    }

    const existing = this.inflight.get(key);
    if (existing) {
      const value = (await existing) as T;
      return { value, cached: true, updatedAt: new Date().toISOString() };
    }

    const task = loader().then(async (value) => {
      await this.store.set(key, { value, updatedAt: new Date().toISOString() }, ttl);
      return value;
    });
    this.inflight.set(key, task);

    try {
      const value = await task;
      return { value, cached: false, updatedAt: new Date().toISOString() };
    } finally {
      this.inflight.delete(key);
    }
  }

  async invalidate(key: string): Promise<void> {
    await this.store.delete(key);
  }
}

export async function createCacheStore(redisUrl?: string): Promise<CacheStore> {
  if (!redisUrl) return new MemoryCacheStore();
  try {
    return await RedisCacheStore.connect(redisUrl);
  } catch (error) {
    logger.warn(
      { err: redactError(error) },
      'Redis unavailable; falling back to in-memory cache',
    );
    return new MemoryCacheStore();
  }
}

function redactError(error: unknown): string {
  return error instanceof Error ? error.message : 'unknown error';
}
