import '../../core/enums/app_enums.dart';
import '../models/match.dart';
import '../sources/demo/demo_matches.dart';
import 'demo_helpers.dart';

/// Phase 1 repository. Reads bundled fixtures only — no network access.
class MatchRepository {
  const MatchRepository();

  Future<List<CricketMatch>> liveMatches() =>
      loadDemo(() => demoMatchesByStatus(MatchStatus.live));

  Future<List<CricketMatch>> upcomingMatches() =>
      loadDemo(() => demoMatchesByStatus(MatchStatus.upcoming));

  Future<List<CricketMatch>> recentResults() =>
      loadDemo(() => demoMatchesByStatus(MatchStatus.completed));

  Future<List<CricketMatch>> allMatches() => loadDemo(() => List.of(demoMatches));

  Future<List<CricketMatch>> matchesForSeries(String seriesId) =>
      loadDemo(() => demoMatchesForSeries(seriesId));

  Future<CricketMatch?> match(String id) => loadDemo(() => findDemoMatch(id));

  /// Synchronous lookup for already-loaded screens and deep links.
  CricketMatch? cachedMatch(String id) => findDemoMatch(id);
}
