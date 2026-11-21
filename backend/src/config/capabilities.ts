import type { Plan } from './env.js';
import {
  assertEndpointUsable,
  isEndpointConfigured,
  configuredCapabilities,
} from '../providers/cricket/endpointRegistry.js';
import type { ProviderCapability } from '../providers/cricket/types.js';
import { AppError } from '../utils/errors.js';

export type Feature =
  | 'historicalMatches'
  | 'recentResults'
  | 'players'
  | 'teams'
  | 'competitions'
  | 'venues'
  | 'search'
  | 'scorecards'
  | 'deliveries'
  | 'liveMatches'
  | 'liveDeliveries'
  | 'liveStreaming';

const BASE_FEATURES: Feature[] = [
  'historicalMatches',
  'recentResults',
  'players',
  'teams',
  'competitions',
  'venues',
  'search',
  'scorecards',
  'deliveries',
];

const LIVE_FEATURES: Feature[] = ['liveMatches', 'liveDeliveries'];

/** Declared subscription entitlements. These are not claims about endpoint availability. */
const PLAN_DECLARATIONS: Record<Plan, Feature[]> = {
  free: BASE_FEATURES,
  match_week: [...BASE_FEATURES, ...LIVE_FEATURES],
  archive: BASE_FEATURES,
  pro: [...BASE_FEATURES, ...LIVE_FEATURES, 'liveStreaming'],
  analyst_pro: [...BASE_FEATURES, ...LIVE_FEATURES, 'liveStreaming'],
};

const FEATURE_ENDPOINTS: Record<Feature, ProviderCapability[]> = {
  historicalMatches: ['matches', 'matchDetails'],
  recentResults: ['recentResults'],
  players: ['players', 'playerDetails', 'playerStats'],
  teams: ['teams', 'teamDetails'],
  competitions: ['competitions'],
  venues: ['venues'],
  search: ['search'],
  scorecards: ['scorecards'],
  deliveries: ['deliveries'],
  liveMatches: ['liveMatches', 'liveMatchDetails'],
  liveDeliveries: ['liveDeliveries'],
  liveStreaming: ['liveStream'],
};

export function declaredFeatures(plan: Plan): Feature[] {
  return [...PLAN_DECLARATIONS[plan]];
}

/** A feature is active only if the plan allows it AND its schema is verified. */
export function effectiveFeatures(plan: Plan): Record<Feature, boolean> {
  const declared = declaredFeatures(plan);
  const result = {} as Record<Feature, boolean>;
  for (const feature of Object.keys(FEATURE_ENDPOINTS) as Feature[]) {
    const allowed = declared.includes(feature);
    const configured = FEATURE_ENDPOINTS[feature].every(isEndpointConfigured);
    result[feature] = allowed && configured;
  }
  return result;
}

export function capabilitySnapshot(plan: Plan): {
  plan: Plan;
  features: Record<Feature, boolean>;
  declared: Feature[];
  verifiedEndpoints: ProviderCapability[];
} {
  return {
    plan,
    features: effectiveFeatures(plan),
    declared: declaredFeatures(plan),
    verifiedEndpoints: configuredCapabilities(),
  };
}

/**
 * Fails closed. UPGRADE_REQUIRED is never confused with provider/server errors.
 */
export function assertFeatureAvailable(plan: Plan, feature: Feature): void {
  const declared = declaredFeatures(plan).includes(feature);
  if (!declared) {
    throw new AppError(
      'UPGRADE_REQUIRED',
      'This feature requires an eligible Cricket Database API subscription.',
    );
  }
  for (const capability of FEATURE_ENDPOINTS[feature]) {
    assertEndpointUsable(capability);
  }
}

export function endpointsForFeature(feature: Feature): ProviderCapability[] {
  return [...FEATURE_ENDPOINTS[feature]];
}
