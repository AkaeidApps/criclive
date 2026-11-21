import type { NextFunction, Request, Response } from 'express';
import { z } from 'zod';
import { AppError } from '../utils/errors.js';

function validate(source: 'query' | 'params' | 'body', schema: z.ZodTypeAny) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req[source]);
    if (!result.success) {
      next(
        new AppError(
          'VALIDATION_ERROR',
          `Invalid ${source}: ${result.error.issues[0]?.message ?? 'unknown error'}`,
          result.error.issues,
        ),
      );
      return;
    }
    // Express 4 allows assignment; validated/coerced values replace raw input.
    (req as unknown as Record<string, unknown>)[source] = result.data;
    next();
  };
}

export const validateQuery = (schema: z.ZodTypeAny) => validate('query', schema);
export const validateParams = (schema: z.ZodTypeAny) => validate('params', schema);

export const idParam = z.object({
  matchId: z.string().trim().min(1).max(128),
});
export const playerIdParam = z.object({
  playerId: z.string().trim().min(1).max(128),
});
export const teamIdParam = z.object({
  teamId: z.string().trim().min(1).max(128),
});

export const listQuery = z.object({
  refresh: z.enum(['0', '1', 'true', 'false']).optional(),
  limit: z.coerce.number().int().min(1).max(100).optional(),
  offset: z.coerce.number().int().min(0).optional(),
});

export const searchQuery = z.object({
  q: z.string().trim().min(2).max(100),
  refresh: z.enum(['0', '1', 'true', 'false']).optional(),
});

export function wantsRefresh(value: unknown): boolean {
  return value === '1' || value === 'true';
}
