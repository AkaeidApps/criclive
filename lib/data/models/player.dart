import '../../core/enums/app_enums.dart';
import '../../core/utils/formatters.dart';

class BattingCareer {
  final int matches;
  final int innings;
  final int runs;
  final int highestScore;
  final double average;
  final double strikeRate;
  final int hundreds;
  final int fifties;
  final int fours;
  final int sixes;

  const BattingCareer({
    required this.matches,
    required this.innings,
    required this.runs,
    required this.highestScore,
    required this.average,
    required this.strikeRate,
    required this.hundreds,
    required this.fifties,
    required this.fours,
    required this.sixes,
  });

  String get highestScoreLabel =>
      highestScore.isNegative ? '$highestScore*' : '$highestScore';
}

class BowlingCareer {
  final int matches;
  final int innings;
  final int wickets;
  final int runsConceded;
  final int balls;
  final double average;
  final double economy;
  final double bestFigures;
  final int fiveWicketHauls;

  const BowlingCareer({
    required this.matches,
    required this.innings,
    required this.wickets,
    required this.runsConceded,
    required this.balls,
    required this.average,
    required this.economy,
    required this.bestFigures,
    required this.fiveWicketHauls,
  });

  String get bestFiguresLabel => bestFigures.toStringAsFixed(1);

  String get oversLabel => AppFormatters.oversFromBalls(balls);
}

class Player {
  final String id;
  final String name;
  final String teamId;
  final PlayerRole role;
  final String battingStyle;
  final String bowlingStyle;
  final int age;
  final String bio;
  final Map<String, BattingCareer> battingByFormat;
  final Map<String, BowlingCareer> bowlingByFormat;
  final List<String> recentScores;

  const Player({
    required this.id,
    required this.name,
    required this.teamId,
    required this.role,
    required this.battingStyle,
    required this.bowlingStyle,
    required this.age,
    required this.bio,
    required this.battingByFormat,
    required this.bowlingByFormat,
    this.recentScores = const [],
  });

  String get initials => name
      .split(' ')
      .map((part) => part.isNotEmpty ? part[0] : '')
      .take(2)
      .join()
      .toUpperCase();

  BattingCareer? batting(String format) => battingByFormat[format] ??
      battingByFormat[format.toUpperCase()] ??
      (battingByFormat.isEmpty ? null : battingByFormat.values.first);

  BowlingCareer? bowling(String format) => bowlingByFormat[format] ??
      bowlingByFormat[format.toUpperCase()] ??
      (bowlingByFormat.isEmpty ? null : bowlingByFormat.values.first);
}
