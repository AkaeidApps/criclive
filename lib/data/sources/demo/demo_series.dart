import '../../../core/enums/app_enums.dart';
import '../../models/series.dart';

/// BUNDLED DEMO DATA — fictional schedules and tables.
final List<Series> demoSeries = [
  Series(
    id: 's_t20_world_cup',
    name: 'ICC Men’s T20 World Cup 2026',
    shortName: 'T20 World Cup',
    format: MatchFormat.t20,
    host: 'India & Sri Lanka',
    startDate: DateTime(2026, 10, 12),
    endDate: DateTime(2026, 11, 29),
    description:
        'A global T20 showcase bringing together 20 nations across four groups, '
        'followed by the Super 8 and knockout stages. Demo tournament data.',
    matchIds: ['m_live_ind_aus', 'm_up_pak_sl', 'm_res_ind_aus'],
    teamIds: ['ind', 'aus', 'pak', 'sl', 'eng', 'nz', 'sa', 'wi'],
  ),
  Series(
    id: 's_continental_league',
    name: 'Continental Premier League 2026',
    shortName: 'CPL 2026',
    format: MatchFormat.t20,
    host: 'India',
    startDate: DateTime(2026, 9, 18),
    endDate: DateTime(2026, 11, 30),
    description:
        'An original fictional domestic T20 league with six city franchises, '
        'a double round-robin and playoffs. Demo tournament data.',
    matchIds: ['m_live_blz_chn', 'm_up_mum_del'],
    teamIds: ['blz', 'chn', 'mum', 'del', 'kol', 'hyd'],
  ),
  Series(
    id: 's_test_championship',
    name: 'World Test Championship 2026',
    shortName: 'WTC 2026',
    format: MatchFormat.test,
    host: 'Multiple hosts',
    startDate: DateTime(2026, 6, 1),
    endDate: DateTime(2027, 5, 31),
    description:
        'A two-year Test competition culminating in a final. '
        'Demo tournament data.',
    matchIds: ['m_up_sa_nz'],
    teamIds: ['sa', 'nz', 'ind', 'aus', 'eng'],
  ),
  Series(
    id: 's_eng_wi_odi',
    name: 'England vs West Indies ODI Series 2026',
    shortName: 'ENG v WI ODI',
    format: MatchFormat.odi,
    host: 'England',
    startDate: DateTime(2026, 11, 14),
    endDate: DateTime(2026, 11, 24),
    description:
        'A three-match one-day series. Demo tournament data.',
    matchIds: ['m_live_eng_wi', 'm_res_eng_wi'],
    teamIds: ['eng', 'wi'],
  ),
  Series(
    id: 's_odi_series',
    name: 'Tri-Nation ODI Series 2026',
    shortName: 'Tri-Nation ODI',
    format: MatchFormat.odi,
    host: 'New Zealand',
    startDate: DateTime(2026, 11, 2),
    endDate: DateTime(2026, 11, 18),
    description: 'A triangular ODI event. Demo tournament data.',
    matchIds: ['m_res_nz_ban'],
    teamIds: ['nz', 'ban', 'ire'],
  ),
];

Series? findDemoSeries(String id) {
  for (final series in demoSeries) {
    if (series.id == id) return series;
  }
  return null;
}

final List<PointsTable> demoPointsTables = [
  const PointsTable(
    seriesId: 's_t20_world_cup',
    title: 'Super 8 · Group 1',
    group: 'Group 1',
    rows: [
      PointsTableRow(
          teamId: 'ind', position: 1, played: 5, won: 4, lost: 1,
          points: 8, netRunRate: 1.284, form: ['W', 'W', 'L', 'W', 'W']),
      PointsTableRow(
          teamId: 'aus', position: 2, played: 5, won: 3, lost: 2,
          points: 6, netRunRate: 0.746, form: ['W', 'L', 'W', 'W', 'L']),
      PointsTableRow(
          teamId: 'nz', position: 3, played: 5, won: 3, lost: 2,
          points: 6, netRunRate: 0.312, form: ['L', 'W', 'W', 'L', 'W']),
      PointsTableRow(
          teamId: 'eng', position: 4, played: 5, won: 2, lost: 3,
          points: 4, netRunRate: -0.218, form: ['L', 'L', 'W', 'W', 'L']),
    ],
  ),
  const PointsTable(
    seriesId: 's_continental_league',
    title: 'League Stage',
    group: 'Points Table',
    rows: [
      PointsTableRow(
          teamId: 'blz', position: 1, played: 12, won: 9, lost: 3,
          points: 18, netRunRate: 1.102, form: ['W', 'W', 'W', 'L', 'W']),
      PointsTableRow(
          teamId: 'chn', position: 2, played: 12, won: 8, lost: 4,
          points: 16, netRunRate: 0.684, form: ['W', 'L', 'W', 'W', 'W']),
      PointsTableRow(
          teamId: 'mum', position: 3, played: 12, won: 7, lost: 5,
          points: 14, netRunRate: 0.285, form: ['L', 'W', 'W', 'L', 'W']),
      PointsTableRow(
          teamId: 'del', position: 4, played: 12, won: 6, lost: 6,
          points: 12, netRunRate: -0.119, form: ['W', 'W', 'L', 'L', 'W']),
      PointsTableRow(
          teamId: 'kol', position: 5, played: 12, won: 4, lost: 8,
          points: 8, netRunRate: -0.642, form: ['L', 'L', 'W', 'L', 'L']),
      PointsTableRow(
          teamId: 'hyd', position: 6, played: 12, won: 3, lost: 9,
          points: 6, netRunRate: -1.054, form: ['L', 'L', 'L', 'W', 'L']),
    ],
  ),
];

List<PointsTable> pointsTablesForSeries(String seriesId) => demoPointsTables
    .where((table) => table.seriesId == seriesId)
    .toList();
