import '../../core/utils/formatters.dart';

class BattingFigure {
  final String playerId;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final String dismissal;
  final bool notOut;
  final bool onStrike;

  const BattingFigure({
    required this.playerId,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.dismissal,
    this.notOut = false,
    this.onStrike = false,
  });

  double get strikeRate =>
      balls == 0 ? 0 : (runs / balls) * 100;

  String get strikeRateLabel => strikeRate.toStringAsFixed(1);
}

class BowlingFigure {
  final String playerId;
  final int balls;
  final int maidens;
  final int runs;
  final int wickets;
  final int wides;
  final int noBalls;
  final bool bowling;

  const BowlingFigure({
    required this.playerId,
    required this.balls,
    required this.maidens,
    required this.runs,
    required this.wickets,
    this.wides = 0,
    this.noBalls = 0,
    this.bowling = false,
  });

  double get economy => balls == 0 ? 0 : (runs / balls) * 6;

  String get economyLabel => economy.toStringAsFixed(2);

  String get oversLabel => AppFormatters.oversFromBalls(balls);

  String get figuresLabel => '$wickets/$runs';
}

class ExtrasFigure {
  final int wides;
  final int noBalls;
  final int byes;
  final int legByes;

  const ExtrasFigure({
    this.wides = 0,
    this.noBalls = 0,
    this.byes = 0,
    this.legByes = 0,
  });

  int get total => wides + noBalls + byes + legByes;

  String get detail =>
      'w $wides · nb $noBalls · b $byes · lb $legByes';
}

class Partnership {
  final String playerAId;
  final String playerBId;
  final int runs;
  final int balls;

  const Partnership({
    required this.playerAId,
    required this.playerBId,
    required this.runs,
    required this.balls,
  });
}

class FallOfWicket {
  final int wicket;
  final int score;
  final int over;
  final String playerId;

  const FallOfWicket({
    required this.wicket,
    required this.score,
    required this.over,
    required this.playerId,
  });

  @override
  String toString() => '$wicket-$score ($over ov)';
}

class Innings {
  final String id;
  final int number;
  final String battingTeamId;
  final String bowlingTeamId;
  final int runs;
  final int wickets;
  final int balls;
  final int? target;
  final bool declared;
  final List<BattingFigure> batting;
  final List<BowlingFigure> bowling;
  final ExtrasFigure extras;
  final List<FallOfWicket> fallOfWickets;
  final List<Partnership> partnerships;

  const Innings({
    required this.id,
    required this.number,
    required this.battingTeamId,
    required this.bowlingTeamId,
    required this.runs,
    required this.wickets,
    required this.balls,
    this.target,
    this.declared = false,
    required this.batting,
    required this.bowling,
    this.extras = const ExtrasFigure(),
    this.fallOfWickets = const [],
    this.partnerships = const [],
  });

  String get oversLabel => AppFormatters.oversFromBalls(balls);

  double get runRate => balls == 0 ? 0 : (runs / balls) * 6;

  String get runRateLabel => runRate.toStringAsFixed(2);

  Partnership? get currentPartnership =>
      partnerships.isEmpty ? null : partnerships.last;
}
