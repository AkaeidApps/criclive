import pino from 'pino';

const level = process.env.LOG_LEVEL ?? 'info';

/** Structured logger. Authorization headers and provider keys are redacted. */
export const logger = pino({
  level: level === 'silent' ? 'silent' : level,
  redact: {
    paths: [
      'req.headers.authorization',
      'req.headers.cookie',
      'CDB_KEY',
      'apiKey',
      'api_key',
      'key',
      '*.CDB_KEY',
      '*.apiKey',
    ],
    censor: '[REDACTED]',
  },
  formatters: {
    bindings: () => ({ service: 'criclive-backend' }),
  },
});

/** Removes anything that looks like a credential from a free-form string. */
export function redactSecrets(value: string): string {
  return value
    .replace(/Bearer\s+[A-Za-z0-9._-]+/gi, 'Bearer [REDACTED]')
    .replace(/(api[_-]?key|token|secret)\s*[=:]\s*\S+/gi, '$1=[REDACTED]');
}
