import '../../core/enums/app_enums.dart';
import '../../core/utils/formatters.dart';
import 'ball_event.dart';
import 'innings.dart';
import 'team.dart';

class CricketMatch {
  final String id;
  final String seriesId;
  final String seriesName;
  final String title;
  final String round;
  final List<String> teamIds;
  final MatchStatus status;
  final MatchFormat format;
  final String venue;
  final String city;
  final DateTime startTime;
  final DateTime lastUpdated;
  final String statusText;
  final String? resultText;
  final String toss;
  final List<Innings> innings;
  final List<BallEvent> commentary;
  final List<OverSummary> overs;
  final Map<String, List<String>> playingXIs;
  final List<String> umpires;
  final String? note;
  final int currentInningsIndex;

  const CricketMatch({
    required this.id,
    required this.seriesId,
    required this.seriesName,
    required this.title,
    required this.round,
    required this.teamIds,
    required this.status,
    required this.format,
    required this.venue,
    required this.city,
    required this.startTime,
    required this.lastUpdated,
    required this.statusText,
    this.resultText,
    required this.toss,
    required this.innings,
    required this.commentary,
    required this.overs,
    required this.playingXIs,
    required this.umpires,
    this.note,
    this.currentInningsIndex = 0,
  });

  bool get isDemo => true; // Phase 1: every match is bundled demo data.

  String get teamAId => teamIds.first;

  String get teamBId => teamIds.last;

  Innings? get currentInnings =>
      innings.isEmpty ? null : innings[currentInningsIndex.clamp(0, innings.length - 1)];

  Innings? get firstInnings =>
      innings.isEmpty ? null : innings.first;

  Innings? get secondInnings => innings.length > 1 ? innings[1] : null;

  double get currentRunRate => currentInnings?.runRate ?? 0;

  String get currentRunRateLabel => currentRunRate.toStringAsFixed(2);

  double? get requiredRunRate {
    final inning = currentInnings;
    if (inning?.target == null || inning!.balls == 0) return null;
    final remaining = inning.target! - inning.runs;
    if (remaining <= 0) return 0;
    final oversLeft =
        format.defaultOvers - (inning.balls / 6);
    if (oversLeft <= 0) return null;
    return remaining / oversLeft;
  }

  String? get requiredRunRateLabel => requiredRunRate?.toStringAsFixed(2);

  int? get target => currentInnings?.target;

  int? get runsNeeded {
    final targetValue = target;
    if (targetValue == null) return null;
    final runs = currentInnings?.runs ?? 0;
    return targetValue - runs > 0 ? targetValue - runs : 0;
  }

  Partnership? get partnership => currentInnings?.currentPartnership;

  String get startTimeLabel =>
      '${AppFormatters.weekday(startTime)}, ${AppFormatters.date(startTime)} · ${AppFormatters.time(startTime)}';

  String get shortDateLabel => AppFormatters.shortDate(startTime);

  String get lastUpdatedLabel => AppFormatters.relativeTime(lastUpdated);

  Team? resolveTeam(Team Function(String id) lookup, String id) => lookup(id);

  CricketMatch copyWithStatus(MatchStatus newStatus) => CricketMatch(
        id: id,
        seriesId: seriesId,
        seriesName: seriesName,
        title: title,
        round: round,
        teamIds: teamIds,
        status: newStatus,
        format: format,
        venue: venue,
        city: city,
        startTime: startTime,
        lastUpdated: lastUpdated,
        statusText: statusText,
        resultText: resultText,
        toss: toss,
        innings: innings,
        commentary: commentary,
        overs: overs,
        playingXIs: playingXIs,
        umpires: umpires,
        note: note,
        currentInningsIndex: currentInningsIndex,
      );
}
