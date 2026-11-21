import '../models/news.dart';
import '../models/player.dart';
import '../models/ranking.dart';
import '../models/series.dart';
import '../models/statistics.dart';
import '../models/team.dart';
import '../sources/demo/demo_news.dart';
import '../sources/demo/demo_players.dart';
import '../sources/demo/demo_rankings.dart';
import '../sources/demo/demo_series.dart';
import '../sources/demo/demo_stats.dart';
import '../sources/demo/demo_teams.dart';
import 'demo_helpers.dart';

/// Bundled demo repositories for Phase 1. No provider calls are made.
class SeriesRepository {
  const SeriesRepository();

  List<Series> cachedAll() => List.of(demoSeries);

  Future<List<Series>> all() => loadDemo(() => List.of(demoSeries));

  Future<Series?> find(String id) => loadDemo(() => findDemoSeries(id));

  Future<List<PointsTable>> pointsTables(String seriesId) =>
      loadDemo(() => pointsTablesForSeries(seriesId));
}

class TeamRepository {
  const TeamRepository();

  Future<List<Team>> all() => loadDemo(() => List.of(demoTeams));

  Future<List<Team>> international({required bool value}) =>
      loadDemo(() => demoTeamsByFormat(international: value));

  Future<Team?> find(String id) =>
      loadDemo(() => demoTeams.where((team) => team.id == id).firstOrNullSafe);

  Team? cached(String id) => findDemoTeam(id);
}

class PlayerRepository {
  const PlayerRepository();

  Future<List<Player>> all() => loadDemo(() => List.of(demoPlayers));

  Future<List<Player>> forTeam(String teamId) =>
      loadDemo(() => demoPlayersForTeam(teamId));

  Future<Player?> find(String id) => loadDemo(() => findDemoPlayer(id));

  Player? cached(String id) => findDemoPlayer(id);
}

class StatsRepository {
  const StatsRepository();

  Future<List<BattingStatRow>> batting() =>
      loadDemo(() => List.of(demoBattingStats));

  Future<List<BowlingStatRow>> bowling() =>
      loadDemo(() => List.of(demoBowlingStats));

  Future<List<RecordRow>> records() => loadDemo(() => List.of(demoRecords));
}

class RankingRepository {
  const RankingRepository();

  Future<List<RankingBoard>> all() => loadDemo(() => List.of(demoRankings));
}

class NewsRepository {
  const NewsRepository();

  Future<List<NewsArticle>> all() => loadDemo(() => List.of(demoNews));

  Future<NewsArticle?> find(String id) => loadDemo(() => findDemoArticle(id));
}

extension _SafeFirst<T> on Iterable<T> {
  T? get firstOrNullSafe => isEmpty ? null : first;
}
