import '../../core/enums/app_enums.dart';

enum ExtraType { none, wide, noBall, bye, legBye }

class BallEvent {
  final String id;
  final String inningsId;
  final int over;
  final int ballInOver;
  final int runs;
  final String batterId;
  final String bowlerId;
  final ExtraType extra;
  final bool isWicket;
  final String? wicketType;
  final String? dismissedPlayerId;
  final String commentary;
  final DateTime timestamp;
  final int totalAfterBall;
  final int wicketsAfterBall;

  const BallEvent({
    required this.id,
    required this.inningsId,
    required this.over,
    required this.ballInOver,
    required this.runs,
    required this.batterId,
    required this.bowlerId,
    this.extra = ExtraType.none,
    this.isWicket = false,
    this.wicketType,
    this.dismissedPlayerId,
    required this.commentary,
    required this.timestamp,
    this.totalAfterBall = 0,
    this.wicketsAfterBall = 0,
  });

  bool get isFour => runs == 4 && extra == ExtraType.none;

  bool get isSix => runs == 6 && extra == ExtraType.none;

  bool get isBoundary => isFour || isSix;

  bool get isDot => runs == 0 && extra == ExtraType.none && !isWicket;

  String get overLabel => '$over.$ballInOver';

  String get shortLabel {
    if (isWicket) return 'W';
    if (extra == ExtraType.wide) return 'wd';
    if (extra == ExtraType.noBall) return 'nb';
    return '$runs';
  }
}

class OverSummary {
  final int number;
  final String teamId;
  final int runs;
  final int wickets;
  final List<BallEvent> balls;

  const OverSummary({
    required this.number,
    required this.teamId,
    required this.runs,
    required this.wickets,
    required this.balls,
  });

  int get dotBalls => balls.where((ball) => ball.isDot).length;
}

class BallFilter {
  final String label;
  final bool Function(BallEvent ball) predicate;

  const BallFilter({required this.label, required this.predicate});

  static const all = BallFilter(label: 'All balls', predicate: _all);
  static const boundaries = BallFilter(label: 'Boundaries', predicate: _boundaries);
  static const wickets = BallFilter(label: 'Wickets', predicate: _wickets);

  static bool _all(BallEvent ball) => true;
  static bool _boundaries(BallEvent ball) => ball.isBoundary;
  static bool _wickets(BallEvent ball) => ball.isWicket;

  static const List<BallFilter> values = [all, boundaries, wickets];
}

extension ExtraTypeX on ExtraType {
  String get label => switch (this) {
        ExtraType.none => '',
        ExtraType.wide => 'wide',
        ExtraType.noBall => 'no ball',
        ExtraType.bye => 'bye',
        ExtraType.legBye => 'leg bye',
      };
}

extension MatchFormatScoreExtension on MatchFormat {
  int get defaultOvers => switch (this) {
        MatchFormat.t20 => 20,
        MatchFormat.odi || MatchFormat.listA => 50,
        MatchFormat.test || MatchFormat.firstClass => 0,
        MatchFormat.other => 0,
      };
}
