export type ProviderCapability =
  | 'matches'
  | 'matchDetails'
  | 'scorecards'
  | 'deliveries'
  | 'recentResults'
  | 'search'
  | 'players'
  | 'playerDetails'
  | 'playerStats'
  | 'teams'
  | 'teamDetails'
  | 'competitions'
  | 'venues'
  | 'liveMatches'
  | 'liveMatchDetails'
  | 'liveDeliveries'
  | 'liveStream';

export type NormalizedMatchStatus =
  | 'live'
  | 'upcoming'
  | 'completed'
  | 'abandoned'
  | 'delayed'
  | 'unknown';

export interface MatchSummaryDTO {
  id: string;
  title: string;
  seriesId?: string;
  seriesName?: string;
  round?: string;
  teamIds: string[];
  teamNames?: Record<string, string>;
  teamLogos?: Record<string, string | undefined>;
  status: NormalizedMatchStatus;
  format: string;
  venue?: string;
  city?: string;
  startTime?: string;
  lastUpdated?: string;
  statusText?: string;
  resultText?: string;
  toss?: string;
}

export interface BattingFigureDTO {
  playerId: string;
  runs: number;
  balls: number;
  fours: number;
  sixes: number;
  dismissal?: string;
  notOut?: boolean;
  onStrike?: boolean;
}

export interface BowlingFigureDTO {
  playerId: string;
  balls: number;
  maidens: number;
  runs: number;
  wickets: number;
  wides?: number;
  noBalls?: number;
  bowling?: boolean;
}

export interface InningsDTO {
  id: string;
  number: number;
  battingTeamId: string;
  bowlingTeamId: string;
  runs: number;
  wickets: number;
  balls: number;
  target?: number;
  declared?: boolean;
  batting: BattingFigureDTO[];
  bowling: BowlingFigureDTO[];
  extras?: { wides?: number; noBalls?: number; byes?: number; legByes?: number };
  fallOfWickets?: Array<{ wicket: number; score: number; over: number; playerId?: string }>;
  partnerships?: Array<{ playerAId: string; playerBId: string; runs: number; balls: number }>;
}

export interface DeliveryDTO {
  id: string;
  inningsId: string;
  over: number;
  ballInOver: number;
  runs: number;
  batterId: string;
  bowlerId: string;
  extra?: 'wide' | 'noBall' | 'bye' | 'legBye' | 'none';
  isWicket?: boolean;
  wicketType?: string;
  dismissedPlayerId?: string;
  commentary: string;
  timestamp?: string;
  totalAfterBall?: number;
  wicketsAfterBall?: number;
}

export interface OverSummaryDTO {
  number: number;
  teamId: string;
  runs: number;
  wickets: number;
  balls: DeliveryDTO[];
}

export interface MatchDetailDTO extends MatchSummaryDTO {
  innings: InningsDTO[];
  commentary: DeliveryDTO[];
  overs: OverSummaryDTO[];
  playingXIs: Record<string, string[]>;
  umpires: string[];
  note?: string;
  currentInningsIndex: number;
}

export interface ScorecardDTO {
  matchId: string;
  innings: InningsDTO[];
}

export interface DeliveriesDTO {
  matchId: string;
  deliveries: DeliveryDTO[];
  sample: boolean;
}

export interface PlayerDTO {
  id: string;
  name: string;
  teamId?: string;
  role?: string;
  battingStyle?: string;
  bowlingStyle?: string;
  age?: number;
  bio?: string;
  imageUrl?: string;
}

export interface PlayerStatsDTO {
  playerId: string;
  battingByFormat: Record<string, unknown>;
  bowlingByFormat: Record<string, unknown>;
  recentScores?: string[];
}

export interface TeamDTO {
  id: string;
  name: string;
  shortName?: string;
  abbreviation?: string;
  logoUrl?: string;
  flag?: string;
  city?: string;
  international?: boolean;
  primaryColor?: string;
  secondaryColor?: string;
  founded?: string;
  squad?: string[];
}

export interface CompetitionDTO {
  id: string;
  name: string;
  shortName?: string;
  format?: string;
  host?: string;
  startDate?: string;
  endDate?: string;
  champion?: string;
}

export interface VenueDTO {
  id: string;
  name: string;
  city?: string;
  country?: string;
}

export interface SearchResultsDTO {
  query: string;
  matches: MatchSummaryDTO[];
  teams: TeamDTO[];
  players: PlayerDTO[];
  competitions: CompetitionDTO[];
}

export interface StreamEventDTO {
  matchId: string;
  sequence: number;
  type: string;
  payload: Record<string, unknown>;
  emittedAt: string;
}

export interface ProviderRequestParams {
  matchId?: string;
  playerId?: string;
  teamId?: string;
  competitionId?: string;
  query?: string;
  limit?: number;
  offset?: number;
  status?: string;
  from?: string;
  to?: string;
}

export interface CricketDataProvider {
  getMatches(params?: ProviderRequestParams): Promise<MatchSummaryDTO[]>;
  getMatchDetails(matchId: string): Promise<MatchDetailDTO>;
  getScorecard(matchId: string): Promise<ScorecardDTO>;
  getDeliveries(matchId: string): Promise<DeliveriesDTO>;
  getRecentResults(params?: ProviderRequestParams): Promise<MatchSummaryDTO[]>;
  searchCricket(query: string): Promise<SearchResultsDTO>;
  getPlayers(params?: ProviderRequestParams): Promise<PlayerDTO[]>;
  getPlayerDetails(playerId: string): Promise<PlayerDTO>;
  getPlayerStats(playerId: string): Promise<PlayerStatsDTO>;
  getTeams(params?: ProviderRequestParams): Promise<TeamDTO[]>;
  getTeamDetails(teamId: string): Promise<TeamDTO>;
  getCompetitions(params?: ProviderRequestParams): Promise<CompetitionDTO[]>;
  getVenues(params?: ProviderRequestParams): Promise<VenueDTO[]>;
  getLiveMatches(params?: ProviderRequestParams): Promise<MatchSummaryDTO[]>;
  getLiveMatchDetails(matchId: string): Promise<MatchDetailDTO>;
  getLiveDeliveries(matchId: string): Promise<DeliveriesDTO>;
  getLiveStream(matchId: string): Promise<StreamEventDTO[]>;
}
