import type { z } from 'zod';
import { AppError } from '../../utils/errors.js';
import type { ProviderCapability } from './types.js';

/**
 * Application-level parameters are mapped to provider parameters only when the
 * mapping has been verified against the official documentation. Nothing here is
 * inferred from naming conventions.
 */
export interface EndpointDescriptor {
  capability: ProviderCapability;
  /** Provider path, e.g. /v1/live/{match}. Never contains a credential. */
  path: string;
  query: Record<string, string>;
  /** Zod schema for the verified provider response. Undefined = not verifiable. */
  schema?: z.ZodTypeAny;
  /** Converts a validated provider payload into the normalized app DTO. */
  map?: (parsed: unknown) => unknown;
  enabled: boolean;
  source: 'verified_documentation' | 'user_supplied_documentation';
  note?: string;
}

const registry = new Map<ProviderCapability, EndpointDescriptor>();

function register(descriptor: EndpointDescriptor): void {
  if (!descriptor.path.startsWith('/')) {
    throw new Error(`Provider path for ${descriptor.capability} must start with /`);
  }
  if (descriptor.path.includes('?') || /key|token|secret/i.test(descriptor.path)) {
    throw new Error(`Invalid provider path for ${descriptor.capability}`);
  }
  registry.set(descriptor.capability, descriptor);
}

/**
 * The only provider paths supplied with this project are the paid live endpoints.
 * They are registered for future upgrades but intentionally have no response
 * schema or mapper until the official documentation is available. The free plan
 * capability gate prevents them from ever being called with a free key.
 *
 * Free-plan endpoints are deliberately NOT listed here. Adding a guessed path
 * would violate the project rules. They must be added from verified docs with a
 * Zod schema and a mapper before use.
 */
register({
  capability: 'liveMatches',
  path: '/v1/live',
  query: {},
  enabled: true,
  source: 'user_supplied_documentation',
  note: 'Paid plan only. Response schema unverified; calls fail closed.',
});
register({
  capability: 'liveMatchDetails',
  path: '/v1/live/{match}',
  query: {},
  enabled: true,
  source: 'user_supplied_documentation',
  note: 'Paid plan only. Response schema unverified; calls fail closed.',
});
register({
  capability: 'liveDeliveries',
  path: '/v1/live/{match}/balls',
  query: {},
  enabled: true,
  source: 'user_supplied_documentation',
  note: 'Paid plan only. Response schema unverified; calls fail closed.',
});
register({
  capability: 'liveStream',
  path: '/v1/live/stream',
  query: {},
  enabled: true,
  source: 'user_supplied_documentation',
  note: 'Paid plan only. Streaming mechanism and schema unverified; calls fail closed.',
});

export function getEndpoint(capability: ProviderCapability): EndpointDescriptor | undefined {
  return registry.get(capability);
}

export function isEndpointConfigured(capability: ProviderCapability): boolean {
  const endpoint = registry.get(capability);
  return Boolean(endpoint?.enabled && endpoint.schema && endpoint.map);
}

/** Used when documentation becomes available; validates descriptors on registration. */
export function configureEndpoint(descriptor: EndpointDescriptor): void {
  register(descriptor);
}

export function assertEndpointUsable(capability: ProviderCapability): EndpointDescriptor {
  const endpoint = registry.get(capability);
  if (!endpoint || !endpoint.enabled) {
    throw new AppError(
      'PROVIDER_UNCONFIGURED',
      `No verified provider endpoint is configured for ${capability}.`,
    );
  }
  if (!endpoint.schema || !endpoint.map) {
    throw new AppError(
      'PROVIDER_SCHEMA_UNVERIFIED',
      `The provider response schema for ${capability} has not been verified from official documentation.`,
    );
  }
  return endpoint;
}

export function buildProviderPath(
  endpoint: EndpointDescriptor,
  params: Record<string, string | number | undefined>,
): string {
  return endpoint.path.replace(/\{([a-zA-Z]+)\}/g, (_token, name: string) => {
    const value = params[name];
    if (value === undefined || value === '') {
      throw new AppError('VALIDATION_ERROR', `Missing provider path parameter: ${name}`);
    }
    return encodeURIComponent(String(value));
  });
}

export function buildProviderQuery(
  endpoint: EndpointDescriptor,
  params: Record<string, string | number | undefined>,
): URLSearchParams {
  const query = new URLSearchParams();
  for (const [appKey, providerKey] of Object.entries(endpoint.query)) {
    const value = params[appKey];
    if (value !== undefined && value !== '') query.set(providerKey, String(value));
  }
  return query;
}

export function configuredCapabilities(): ProviderCapability[] {
  return [...registry.values()]
    .filter((endpoint) => endpoint.enabled && endpoint.schema && endpoint.map)
    .map((endpoint) => endpoint.capability);
}
