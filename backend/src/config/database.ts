import type { PrismaClient } from '@prisma/client';
import type { Env } from './env.js';
import { logger } from '../utils/logger.js';

let client: PrismaClient | undefined;

/** Lazily creates Prisma only when persistence is enabled. */
export async function connectDatabase(env: Env): Promise<PrismaClient | undefined> {
  if (!env.ENABLE_PERSISTENCE) return undefined;
  if (client) return client;

  const { PrismaClient } = await import('@prisma/client');
  client = new PrismaClient({ datasources: { db: { url: env.DATABASE_URL } } });
  await client.$connect();
  logger.info('PostgreSQL connected via Prisma');
  return client;
}

export async function disconnectDatabase(): Promise<void> {
  if (!client) return;
  await client.$disconnect();
  client = undefined;
}

export function databaseClient(): PrismaClient | undefined {
  return client;
}
