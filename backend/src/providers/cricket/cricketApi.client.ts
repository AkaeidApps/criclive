import type { Env } from '../../config/env.js';
import { AppError, type AppErrorCode } from '../../utils/errors.js';
import { logger, redactSecrets } from '../../utils/logger.js';
import type { UsageTracker } from '../../utils/usage.js';
import {
  assertEndpointUsable,
  buildProviderPath,
  buildProviderQuery,
} from './endpointRegistry.js';
import type { ProviderCapability, ProviderRequestParams } from './types.js';

const RETRYABLE_CODES: AppErrorCode[] = [
  'PROVIDER_UNAVAILABLE',
  'PROVIDER_MAINTENANCE',
  'TIMEOUT',
  'NETWORK_ERROR',
];

export class CricketApiClient {
  private readonly inFlight = new Map<string, Promise<unknown>>();
  private readonly timeoutMs = 10_000;
  private readonly maxRetries = 2;

  constructor(
    private readonly env: Env,
    private readonly usage: UsageTracker,
  ) {}

  async get<T>(capability: ProviderCapability, params: ProviderRequestParams = {}): Promise<T> {
    const endpoint = assertEndpointUsable(capability);
    if (!this.env.CDB_KEY) {
      throw new AppError(
        'PROVIDER_NOT_CONFIGURED',
        'No Cricket Database key is configured on the backend.',
      );
    }

    const path = buildProviderPath(endpoint, params as Record<string, string | number | undefined>);
    const query = buildProviderQuery(endpoint, params as Record<string, string | number | undefined>);
    const requestKey = `${capability}:${path}:${query.toString()}`;

    const pending = this.inFlight.get(requestKey);
    if (pending) return (await pending) as T;

    const task = this.execute<T>(capability, path, query);
    this.inFlight.set(requestKey, task);
    try {
      return await task;
    } finally {
      this.inFlight.delete(requestKey);
    }
  }

  private async execute<T>(
    capability: ProviderCapability,
    path: string,
    query: URLSearchParams,
  ): Promise<T> {
    const endpoint = assertEndpointUsable(capability);

    for (let attempt = 0; attempt <= this.maxRetries; attempt += 1) {
      this.assertBudget();
      const url = new URL(path, `${this.env.CDB_BASE_URL.replace(/\/$/, '')}/`);
      for (const [key, value] of query) url.searchParams.set(key, value);
      this.usage.record();

      let response: Response;
      try {
        response = await fetch(url, {
          method: 'GET',
          headers: {
            Authorization: `Bearer ${this.env.CDB_KEY}`,
            Accept: 'application/json',
            'User-Agent': 'criclive-backend/0.1',
          },
          signal: AbortSignal.timeout(this.timeoutMs),
        });
      } catch (error) {
        const timedOut = error instanceof Error && /timeout|abort/i.test(error.message);
        const failure = new AppError(
          timedOut ? 'TIMEOUT' : 'NETWORK_ERROR',
          timedOut
            ? 'The cricket provider did not respond in time.'
            : 'The cricket provider could not be reached.',
        );
        if (!timedOut || attempt === this.maxRetries) throw failure;
        await this.waitForRetry(attempt, undefined);
        continue;
      }

      if (!response.ok) {
        const failure = this.mapHttpError(response.status);
        const retryable = RETRYABLE_CODES.includes(failure.code);
        if (!retryable || attempt === this.maxRetries) throw failure;
        const retryAfter = response.headers.get('retry-after') ?? undefined;
        await this.waitForRetry(attempt, retryAfter);
        continue;
      }

      let payload: unknown;
      try {
        const text = await response.text();
        if (!text.trim()) {
          throw new AppError('EMPTY_RESPONSE', 'The provider returned an empty response.');
        }
        payload = JSON.parse(text) as unknown;
      } catch (error) {
        if (error instanceof AppError) throw error;
        throw new AppError(
          'INVALID_PROVIDER_RESPONSE',
          'The provider returned a response that could not be parsed.',
        );
      }

      const parsed = endpoint.schema!.safeParse(payload);
      if (!parsed.success) {
        logger.warn(
          { capability, issues: parsed.error.issues.length },
          'Provider response failed schema validation',
        );
        throw new AppError(
          'INVALID_PROVIDER_RESPONSE',
          'The provider response did not match the verified schema.',
        );
      }

      try {
        return endpoint.map!(parsed.data) as T;
      } catch {
        throw new AppError(
          'INVALID_PROVIDER_RESPONSE',
          'The provider response could not be normalized.',
        );
      }
    }

    throw new AppError('PROVIDER_UNAVAILABLE', 'The cricket provider is unavailable.');
  }

  private assertBudget(): void {
    try {
      this.usage.assertAllowed();
    } catch (error) {
      const code = error instanceof Error ? error.message : 'RATE_LIMIT_EXCEEDED';
      if (code === 'DAILY_LIMIT_EXCEEDED') {
        throw new AppError(
          'DAILY_LIMIT_EXCEEDED',
          'The provider daily request limit has been reached.',
        );
      }
      throw new AppError('RATE_LIMIT_EXCEEDED', 'The provider minute request limit has been reached.');
    }
  }

  private mapHttpError(status: number): AppError {
    if (status === 401 || status === 403) {
      return new AppError('INVALID_API_KEY', 'The provider rejected the configured API key.');
    }
    if (status === 404) {
      return new AppError('PROVIDER_NOT_FOUND', 'The requested cricket resource was not found.');
    }
    if (status === 429) {
      return new AppError('RATE_LIMIT_EXCEEDED', 'The provider rate limit has been reached.');
    }
    if (status === 503 || status === 504) {
      return new AppError('PROVIDER_MAINTENANCE', 'The cricket provider is temporarily unavailable.');
    }
    if (status >= 500) {
      return new AppError('PROVIDER_UNAVAILABLE', 'The cricket provider returned a server error.');
    }
    return new AppError('PROVIDER_UNAVAILABLE', `The provider returned status ${status}.`);
  }

  private async waitForRetry(attempt: number, retryAfter?: string): Promise<void> {
    const headerMs = retryAfter ? Number(retryAfter) * 1000 : Number.NaN;
    const backoffMs = 400 * 2 ** attempt;
    const delayMs = Number.isFinite(headerMs) ? Math.min(headerMs, 30_000) : backoffMs;
    logger.warn(
      { attempt: attempt + 1, delayMs, reason: redactSecrets('provider retry') },
      'Retrying provider request',
    );
    await new Promise<void>((resolve) => setTimeout(resolve, delayMs));
  }
}
