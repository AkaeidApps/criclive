class BattingStatRow {
  final int rank;
  final String playerId;
  final String playerName;
  final String teamCode;
  final String format;
  final int matches;
  final int innings;
  final int runs;
  final int highestScore;
  final double average;
  final double strikeRate;
  final int hundreds;
  final int fifties;

  const BattingStatRow({
    required this.rank,
    required this.playerId,
    required this.playerName,
    required this.teamCode,
    required this.format,
    required this.matches,
    required this.innings,
    required this.runs,
    required this.highestScore,
    required this.average,
    required this.strikeRate,
    required this.hundreds,
    required this.fifties,
  });
}

class BowlingStatRow {
  final int rank;
  final String playerId;
  final String playerName;
  final String teamCode;
  final String format;
  final int matches;
  final int wickets;
  final int runsConceded;
  final double average;
  final double economy;
  final String bestFigures;
  final int fiveWicketHauls;

  const BowlingStatRow({
    required this.rank,
    required this.playerId,
    required this.playerName,
    required this.teamCode,
    required this.format,
    required this.matches,
    required this.wickets,
    required this.runsConceded,
    required this.average,
    required this.economy,
    required this.bestFigures,
    required this.fiveWicketHauls,
  });
}

class RecordRow {
  final String title;
  final String value;
  final String holder;
  final String detail;
  final String icon;

  const RecordRow({
    required this.title,
    required this.value,
    required this.holder,
    required this.detail,
    required this.icon,
  });
}
