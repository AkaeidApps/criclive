import '../../models/statistics.dart';

/// BUNDLED DEMO DATA — fictional career leaders and records.
final List<BattingStatRow> demoBattingStats = [
  const BattingStatRow(rank: 1, playerId: 'p_rohan_kapoor', playerName: 'Rohan Kapoor', teamCode: 'IND', format: 'ODI', matches: 96, innings: 92, runs: 4120, highestScore: 154, average: 48.47, strikeRate: 88.35, hundreds: 9, fifties: 27),
  const BattingStatRow(rank: 2, playerId: 'p_oliver_bennett', playerName: 'Oliver Bennett', teamCode: 'ENG', format: 'ODI', matches: 84, innings: 82, runs: 3542, highestScore: 148, average: 46.60, strikeRate: 89.10, hundreds: 8, fifties: 21),
  const BattingStatRow(rank: 3, playerId: 'p_jack_wilson', playerName: 'Jack Wilson', teamCode: 'AUS', format: 'ODI', matches: 72, innings: 70, runs: 2986, highestScore: 143, average: 45.78, strikeRate: 92.40, hundreds: 7, fifties: 18),
  const BattingStatRow(rank: 4, playerId: 'p_dwayne_carter', playerName: 'Dwayne Carter', teamCode: 'WI', format: 'ODI', matches: 79, innings: 76, runs: 2841, highestScore: 139, average: 41.18, strikeRate: 94.60, hundreds: 5, fifties: 17),
  const BattingStatRow(rank: 5, playerId: 'p_aarav_mehta', playerName: 'Aarav Mehta', teamCode: 'IND', format: 'T20I', matches: 62, innings: 60, runs: 1842, highestScore: 112, average: 34.18, strikeRate: 148.42, hundreds: 1, fifties: 12),
  const BattingStatRow(rank: 6, playerId: 'p_mitchell_reid', playerName: 'Mitchell Reid', teamCode: 'AUS', format: 'T20I', matches: 81, innings: 78, runs: 2389, highestScore: 92, average: 35.72, strikeRate: 134.80, hundreds: 0, fifties: 17),
  const BattingStatRow(rank: 7, playerId: 'p_jacob_du_preez', playerName: 'Jacob du Preez', teamCode: 'SA', format: 'T20I', matches: 55, innings: 53, runs: 1642, highestScore: 96, average: 36.48, strikeRate: 142.10, hundreds: 0, fifties: 11),
  const BattingStatRow(rank: 8, playerId: 'p_sam_wright', playerName: 'Sam Wright', teamCode: 'ENG', format: 'ODI', matches: 58, innings: 52, runs: 1712, highestScore: 98, average: 37.20, strikeRate: 91.30, hundreds: 0, fifties: 12),
];

final List<BowlingStatRow> demoBowlingStats = [
  const BowlingStatRow(rank: 1, playerId: 'p_nathan_brooks', playerName: 'Nathan Brooks', teamCode: 'AUS', format: 'ODI', matches: 63, wickets: 91, runsConceded: 2841, average: 31.21, economy: 5.13, bestFigures: '5/4', fiveWicketHauls: 2),
  const BowlingStatRow(rank: 2, playerId: 'p_james_atkinson', playerName: 'James Atkinson', teamCode: 'ENG', format: 'ODI', matches: 42, wickets: 68, runsConceded: 2112, average: 31.05, economy: 5.48, bestFigures: '5/2', fiveWicketHauls: 1),
  const BowlingStatRow(rank: 3, playerId: 'p_kemar_johnson', playerName: 'Kemar Johnson', teamCode: 'WI', format: 'ODI', matches: 51, wickets: 74, runsConceded: 2104, average: 28.43, economy: 4.89, bestFigures: '5/1', fiveWicketHauls: 1),
  const BowlingStatRow(rank: 4, playerId: 'p_arjun_rao', playerName: 'Arjun Rao', teamCode: 'IND', format: 'T20I', matches: 44, wickets: 61, runsConceded: 1210, average: 19.83, economy: 7.38, bestFigures: '5/3', fiveWicketHauls: 1),
  const BowlingStatRow(rank: 5, playerId: 'p_nikhil_chaturvedi', playerName: 'Nikhil Chaturvedi', teamCode: 'IND', format: 'T20I', matches: 59, wickets: 68, runsConceded: 1452, average: 21.35, economy: 6.63, bestFigures: '4/1', fiveWicketHauls: 0),
  const BowlingStatRow(rank: 6, playerId: 'p_ahmad_raza', playerName: 'Ahmad Raza', teamCode: 'PAK', format: 'T20I', matches: 64, wickets: 71, runsConceded: 1512, average: 21.29, economy: 6.35, bestFigures: '4/2', fiveWicketHauls: 0),
  const BowlingStatRow(rank: 7, playerId: 'p_harry_miller', playerName: 'Harry Miller', teamCode: 'AUS', format: 'T20I', matches: 33, wickets: 38, runsConceded: 812, average: 21.36, economy: 6.54, bestFigures: '3/2', fiveWicketHauls: 0),
  const BowlingStatRow(rank: 8, playerId: 'p_tanvir_ahmed', playerName: 'Tanvir Ahmed', teamCode: 'BAN', format: 'ODI', matches: 38, wickets: 52, runsConceded: 1624, average: 31.23, economy: 4.75, bestFigures: '4/6', fiveWicketHauls: 0),
];

final List<RecordRow> demoRecords = [
  const RecordRow(
    title: 'Highest individual score',
    value: '154',
    holder: 'Rohan Kapoor (IND)',
    detail: 'vs West Indies · Demo ODI',
    icon: '🏏',
  ),
  const RecordRow(
    title: 'Best bowling figures',
    value: '5/4',
    holder: 'Nathan Brooks (AUS)',
    detail: 'vs England · Demo ODI',
    icon: '🎯',
  ),
  const RecordRow(
    title: 'Most runs in a series',
    value: '612',
    holder: 'Jack Wilson (AUS)',
    detail: 'T20 World Cup 2026 · Demo',
    icon: '📈',
  ),
  const RecordRow(
    title: 'Highest partnership',
    value: '214',
    holder: 'Mehta / Kapoor (IND)',
    detail: '2nd wicket · Demo ODI',
    icon: '🤝',
  ),
];
