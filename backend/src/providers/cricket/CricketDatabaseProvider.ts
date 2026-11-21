import type { CricketApiClient } from './cricketApi.client.js';
import type {
  CricketDataProvider,
  DeliveriesDTO,
  MatchDetailDTO,
  MatchSummaryDTO,
  PlayerDTO,
  PlayerStatsDTO,
  ScorecardDTO,
  SearchResultsDTO,
  StreamEventDTO,
  TeamDTO,
  CompetitionDTO,
  VenueDTO,
  ProviderRequestParams,
} from './types.js';

/** Cricket Database adapter. All provider-specific knowledge lives here. */
export class CricketDatabaseProvider implements CricketDataProvider {
  constructor(private readonly client: CricketApiClient) {}

  getMatches(params: ProviderRequestParams = {}): Promise<MatchSummaryDTO[]> {
    return this.client.get<MatchSummaryDTO[]>('matches', params);
  }

  getMatchDetails(matchId: string): Promise<MatchDetailDTO> {
    return this.client.get<MatchDetailDTO>('matchDetails', {
      match: matchId,
      matchId,
    });
  }

  getScorecard(matchId: string): Promise<ScorecardDTO> {
    return this.client.get<ScorecardDTO>('scorecards', { match: matchId, matchId });
  }

  getDeliveries(matchId: string): Promise<DeliveriesDTO> {
    return this.client.get<DeliveriesDTO>('deliveries', { match: matchId, matchId });
  }

  getRecentResults(params: ProviderRequestParams = {}): Promise<MatchSummaryDTO[]> {
    return this.client.get<MatchSummaryDTO[]>('recentResults', params);
  }

  searchCricket(query: string): Promise<SearchResultsDTO> {
    return this.client.get<SearchResultsDTO>('search', { query });
  }

  getPlayers(params: ProviderRequestParams = {}): Promise<PlayerDTO[]> {
    return this.client.get<PlayerDTO[]>('players', params);
  }

  getPlayerDetails(playerId: string): Promise<PlayerDTO> {
    return this.client.get<PlayerDTO>('playerDetails', { player: playerId, playerId });
  }

  getPlayerStats(playerId: string): Promise<PlayerStatsDTO> {
    return this.client.get<PlayerStatsDTO>('playerStats', { player: playerId, playerId });
  }

  getTeams(params: ProviderRequestParams = {}): Promise<TeamDTO[]> {
    return this.client.get<TeamDTO[]>('teams', params);
  }

  getTeamDetails(teamId: string): Promise<TeamDTO> {
    return this.client.get<TeamDTO>('teamDetails', { team: teamId, teamId });
  }

  getCompetitions(params: ProviderRequestParams = {}): Promise<CompetitionDTO[]> {
    return this.client.get<CompetitionDTO[]>('competitions', params);
  }

  getVenues(params: ProviderRequestParams = {}): Promise<VenueDTO[]> {
    return this.client.get<VenueDTO[]>('venues', params);
  }

  getLiveMatches(params: ProviderRequestParams = {}): Promise<MatchSummaryDTO[]> {
    return this.client.get<MatchSummaryDTO[]>('liveMatches', params);
  }

  getLiveMatchDetails(matchId: string): Promise<MatchDetailDTO> {
    return this.client.get<MatchDetailDTO>('liveMatchDetails', { match: matchId, matchId });
  }

  getLiveDeliveries(matchId: string): Promise<DeliveriesDTO> {
    return this.client.get<DeliveriesDTO>('liveDeliveries', { match: matchId, matchId });
  }

  getLiveStream(matchId: string): Promise<StreamEventDTO[]> {
    return this.client.get<StreamEventDTO[]>('liveStream', { match: matchId, matchId });
  }
}
