import type { Response } from 'express';
import type { AppErrorCode } from './errors.js';

export interface SuccessMeta {
  source: 'cricket_database';
  updatedAt: string;
  cached: boolean;
  plan?: string;
  sample?: boolean;
}

export function sendSuccess<T>(
  res: Response,
  data: T,
  meta: Partial<SuccessMeta> = {},
): Response {
  return res.status(200).json({
    success: true,
    data,
    meta: {
      source: 'cricket_database',
      updatedAt: meta.updatedAt ?? new Date().toISOString(),
      cached: meta.cached ?? false,
      ...(meta.plan ? { plan: meta.plan } : {}),
      ...(meta.sample !== undefined ? { sample: meta.sample } : {}),
    },
  });
}

export interface ErrorBody {
  success: false;
  error: { code: AppErrorCode | string; message: string };
}

export function sendError(
  res: Response,
  status: number,
  code: AppErrorCode | string,
  message: string,
): Response {
  return res.status(status).json({ success: false, error: { code, message } } satisfies ErrorBody);
}
