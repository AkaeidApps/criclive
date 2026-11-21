import type { CricketDataProvider } from './types.js';

/** Public provider contract. Business logic depends only on this interface. */
export type { CricketDataProvider } from './types.js';

/** Marker used by dependency injection. */
export const CRICKET_DATA_PROVIDER = Symbol('CricketDataProvider');

export function isCricketDataProvider(value: unknown): value is CricketDataProvider {
  return typeof value === 'object' && value !== null && 'getMatches' in value;
}
