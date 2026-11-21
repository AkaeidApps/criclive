import path from 'node:path';
import dotenv from 'dotenv';
import { z } from 'zod';

const planSchema = z.enum(['free', 'match_week', 'archive', 'pro', 'analyst_pro']);
const nodeEnvSchema = z.enum(['development', 'test', 'production']);

const envSchema = z
  .object({
    CDB_KEY: z.string().trim().optional(),
    CDB_BASE_URL: z.string().url().default('https://api.cricketdatabase.com/v1'),
    CDB_PLAN: planSchema.default('free'),
    PORT: z.coerce.number().int().min(1).max(65535).default(3000),
    NODE_ENV: nodeEnvSchema.default('development'),
    LOG_LEVEL: z
      .enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent'])
      .default('info'),
    CORS_ORIGIN: z
      .string()
      .default('*')
      .transform((value) =>
        value
          .split(',')
          .map((origin) => origin.trim())
          .filter(Boolean),
      ),
    DAILY_REQUEST_LIMIT: z.coerce.number().int().positive().default(50),
    PER_MINUTE_LIMIT: z.coerce.number().int().positive().default(10),
    CACHE_TTL_SECONDS: z.coerce.number().int().nonnegative().default(300),
    DATABASE_URL: z.string().trim().optional(),
    REDIS_URL: z.string().trim().optional(),
    ENABLE_PERSISTENCE: z
      .enum(['true', 'false'])
      .default('false')
      .transform((value) => value === 'true'),
  })
  .superRefine((value, ctx) => {
    if (value.CDB_KEY === '' || value.CDB_KEY === 'YOUR_CRICKET_DATABASE_API_KEY') {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['CDB_KEY'],
        message: 'CDB_KEY is a placeholder; set a real key in .env',
      });
    }
    if (value.NODE_ENV === 'production' && !value.CDB_KEY) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['CDB_KEY'],
        message: 'CDB_KEY is required in production',
      });
    }
    if (value.NODE_ENV === 'production' && value.CORS_ORIGIN.includes('*')) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['CORS_ORIGIN'],
        message: 'Wildcard CORS is not allowed in production',
      });
    }
    if (value.ENABLE_PERSISTENCE && !value.DATABASE_URL) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['DATABASE_URL'],
        message: 'DATABASE_URL is required when ENABLE_PERSISTENCE=true',
      });
    }
  });

export type Env = z.infer<typeof envSchema>;
export type Plan = z.infer<typeof planSchema>;

let cached: Env | undefined;

/** Loads and validates environment variables once. Secrets are never logged. */
export function loadEnv(overrides: Record<string, string | undefined> = {}): Env {
  if (cached && Object.keys(overrides).length === 0) return cached;

  if (Object.keys(overrides).length === 0) {
    dotenv.config({ path: path.resolve(process.cwd(), '.env') });
  }

  const source = { ...process.env, ...overrides };
  // Treat empty strings as absent for optional connection strings.
  for (const key of ['CDB_KEY', 'DATABASE_URL', 'REDIS_URL']) {
    if (source[key] === '') delete source[key];
  }

  const parsed = envSchema.safeParse(source);
  if (!parsed.success) {
    const details = parsed.error.issues
      .map((issue) => `${issue.path.join('.')}: ${issue.message}`)
      .join('; ');
    throw new Error(`Invalid backend environment configuration: ${details}`);
  }

  if (Object.keys(overrides).length === 0) cached = parsed.data;
  return parsed.data;
}

export function resetEnvCache(): void {
  cached = undefined;
}
