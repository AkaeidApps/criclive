export type AppErrorCode =
  | 'VALIDATION_ERROR'
  | 'UPGRADE_REQUIRED'
  | 'PROVIDER_UNCONFIGURED'
  | 'PROVIDER_SCHEMA_UNVERIFIED'
  | 'PROVIDER_NOT_CONFIGURED'
  | 'INVALID_API_KEY'
  | 'EXPIRED_API_KEY'
  | 'DAILY_LIMIT_EXCEEDED'
  | 'RATE_LIMIT_EXCEEDED'
  | 'PROVIDER_UNAVAILABLE'
  | 'PROVIDER_MAINTENANCE'
  | 'UNSUPPORTED_ENDPOINT'
  | 'INVALID_PROVIDER_RESPONSE'
  | 'PROVIDER_NOT_FOUND'
  | 'TIMEOUT'
  | 'NETWORK_ERROR'
  | 'EMPTY_RESPONSE'
  | 'NOT_FOUND'
  | 'OFFLINE'
  | 'INTERNAL_ERROR';

const STATUS: Record<AppErrorCode, number> = {
  VALIDATION_ERROR: 400,
  UPGRADE_REQUIRED: 403,
  PROVIDER_UNCONFIGURED: 503,
  PROVIDER_SCHEMA_UNVERIFIED: 503,
  PROVIDER_NOT_CONFIGURED: 503,
  INVALID_API_KEY: 502,
  EXPIRED_API_KEY: 502,
  DAILY_LIMIT_EXCEEDED: 429,
  RATE_LIMIT_EXCEEDED: 429,
  PROVIDER_UNAVAILABLE: 502,
  PROVIDER_MAINTENANCE: 503,
  UNSUPPORTED_ENDPOINT: 404,
  INVALID_PROVIDER_RESPONSE: 502,
  PROVIDER_NOT_FOUND: 404,
  TIMEOUT: 504,
  NETWORK_ERROR: 502,
  EMPTY_RESPONSE: 502,
  NOT_FOUND: 404,
  OFFLINE: 503,
  INTERNAL_ERROR: 500,
};

export class AppError extends Error {
  readonly code: AppErrorCode;
  readonly status: number;
  readonly details?: unknown;

  constructor(code: AppErrorCode, message: string, details?: unknown) {
    super(message);
    this.name = 'AppError';
    this.code = code;
    this.status = STATUS[code];
    if (details !== undefined) this.details = details;
  }
}

export function httpStatusFor(code: AppErrorCode): number {
  return STATUS[code];
}

export function isAppError(error: unknown): error is AppError {
  return error instanceof AppError;
}
