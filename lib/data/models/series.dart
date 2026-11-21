import '../../core/enums/app_enums.dart';
import '../../core/utils/formatters.dart';

class Series {
  final String id;
  final String name;
  final String shortName;
  final MatchFormat format;
  final String host;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final List<String> matchIds;
  final List<String> teamIds;
  final String? champion;

  const Series({
    required this.id,
    required this.name,
    required this.shortName,
    required this.format,
    required this.host,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.matchIds,
    required this.teamIds,
    this.champion,
  });

  String get dateRange =>
      '${AppFormatters.shortDate(startDate)} – ${AppFormatters.date(endDate)}';

  bool get isDomestic => host.toLowerCase().contains('league');
}

class PointsTableRow {
  final String teamId;
  final int position;
  final int played;
  final int won;
  final int lost;
  final int tied;
  final int noResult;
  final int points;
  final double netRunRate;
  final List<String> form;

  const PointsTableRow({
    required this.teamId,
    required this.position,
    required this.played,
    required this.won,
    required this.lost,
    this.tied = 0,
    this.noResult = 0,
    required this.points,
    required this.netRunRate,
    this.form = const [],
  });

  String get nrrLabel =>
      '${netRunRate >= 0 ? '+' : ''}${netRunRate.toStringAsFixed(3)}';
}

class PointsTable {
  final String seriesId;
  final String title;
  final String group;
  final List<PointsTableRow> rows;

  const PointsTable({
    required this.seriesId,
    required this.title,
    required this.group,
    required this.rows,
  });
}
