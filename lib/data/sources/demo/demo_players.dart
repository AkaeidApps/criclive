import '../../../core/enums/app_enums.dart';
import '../../models/player.dart';

/// BUNDLED DEMO DATA — all player names and career numbers are fictional.
final List<Player> demoPlayers = [
  Player(
    id: 'p_aarav_mehta',
    name: 'Aarav Mehta',
    teamId: 'ind',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Occasional off-spin',
    age: 27,
    bio: 'Aggressive opening batter known for fast starts and a high strike rate in the powerplay.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 62, innings: 60, runs: 1842, highestScore: 112,
          average: 34.18, strikeRate: 148.42, hundreds: 1, fifties: 12,
          fours: 176, sixes: 84),
      'ODI': BattingCareer(
          matches: 41, innings: 41, runs: 1523, highestScore: 134,
          average: 39.05, strikeRate: 96.21, hundreds: 3, fifties: 9,
          fours: 149, sixes: 31),
    },
    bowlingByFormat: const {},
    recentScores: const ['74(42)', '18(14)', '112(63)', '45(31)', '61(38)'],
  ),
  Player(
    id: 'p_rohan_kapoor',
    name: 'Rohan Kapoor',
    teamId: 'ind',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 30,
    bio: 'Technically sound top-order batter who anchors the innings and rotates strike efficiently.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 78, innings: 74, runs: 2310, highestScore: 89,
          average: 38.5, strikeRate: 132.7, hundreds: 0, fifties: 19,
          fours: 211, sixes: 61),
      'ODI': BattingCareer(
          matches: 96, innings: 92, runs: 4120, highestScore: 154,
          average: 48.47, strikeRate: 88.35, hundreds: 9, fifties: 27,
          fours: 372, sixes: 74),
    },
    bowlingByFormat: const {},
    recentScores: const ['42(36)', '68(51)', '31(24)', '89(60)', '27(19)'],
  ),
  Player(
    id: 'p_devansh_sharma',
    name: 'Devansh Sharma',
    teamId: 'ind',
    role: PlayerRole.batter,
    battingStyle: 'Left-hand bat',
    bowlingStyle: '—',
    age: 25,
    bio: 'Powerful middle-order hitter with a clean strike of the ball against pace and spin.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 34, innings: 31, runs: 812, highestScore: 74,
          average: 32.48, strikeRate: 156.9, hundreds: 0, fifties: 5,
          fours: 72, sixes: 44),
    },
    bowlingByFormat: const {},
    recentScores: const ['29(17)', '74(39)', '12(9)', '51(28)', '38(22)'],
  ),
  Player(
    id: 'p_ishaan_verma',
    name: 'Ishaan Verma',
    teamId: 'ind',
    role: PlayerRole.wicketKeeper,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 28,
    bio: 'Wicketkeeper-batter with sharp reflexes and a useful counter-attacking game lower down.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 48, innings: 40, runs: 742, highestScore: 63,
          average: 28.53, strikeRate: 141.2, hundreds: 0, fifties: 3,
          fours: 66, sixes: 28),
    },
    bowlingByFormat: const {},
    recentScores: const ['22(13)', '8(7)', '63(34)', '19(15)', '31(20)'],
  ),
  Player(
    id: 'p_kabir_patel',
    name: 'Kabir Patel',
    teamId: 'ind',
    role: PlayerRole.allRounder,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm off-break',
    age: 29,
    bio: 'Dependable all-rounder who contributes with the bat in the middle order and tight off-spin.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 71, innings: 61, runs: 1296, highestScore: 68,
          average: 29.45, strikeRate: 135.2, hundreds: 0, fifties: 7,
          fours: 112, sixes: 38),
    },
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 71, innings: 68, wickets: 74, runsConceded: 1786,
          balls: 1488, average: 24.13, economy: 7.2, bestFigures: 4.2,
          fiveWicketHauls: 0),
    },
    recentScores: const ['31(19)', '24(12)', '12(8)', '44(26)', '18(11)'],
  ),
  Player(
    id: 'p_arjun_rao',
    name: 'Arjun Rao',
    teamId: 'ind',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm fast-medium',
    age: 26,
    bio: 'Express pace bowler with a sharp yorker and an improving short ball.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 44, innings: 44, wickets: 61, runsConceded: 1210,
          balls: 984, average: 19.83, economy: 7.38, bestFigures: 5.3,
          fiveWicketHauls: 1),
      'ODI': BowlingCareer(
          matches: 28, innings: 28, wickets: 46, runsConceded: 1384,
          balls: 1428, average: 30.08, economy: 5.81, bestFigures: 4.5,
          fiveWicketHauls: 0),
    },
    recentScores: const ['2/28', '1/34', '3/21', '0/41', '2/26'],
  ),
  Player(
    id: 'p_nikhil_chaturvedi',
    name: 'Nikhil Chaturvedi',
    teamId: 'ind',
    role: PlayerRole.bowler,
    battingStyle: 'Left-hand bat',
    bowlingStyle: 'Left-arm orthodox',
    age: 31,
    bio: 'Flighted left-arm spinner who controls the middle overs and builds pressure.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 59, innings: 57, wickets: 68, runsConceded: 1452,
          balls: 1314, average: 21.35, economy: 6.63, bestFigures: 4.1,
          fiveWicketHauls: 0),
    },
    recentScores: const ['1/24', '2/31', '2/22', '1/29', '3/18'],
  ),
  Player(
    id: 'p_siddharth_jain',
    name: 'Siddharth Jain',
    teamId: 'ind',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm leg-break',
    age: 24,
    bio: 'Young wrist-spinner with a threatening googly and growing confidence at the death.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 22, innings: 22, wickets: 29, runsConceded: 542,
          balls: 492, average: 18.68, economy: 6.61, bestFigures: 4.0,
          fiveWicketHauls: 0),
    },
    recentScores: const ['2/33', '1/27', '3/19', '2/30', '1/22'],
  ),
  Player(
    id: 'p_jack_wilson',
    name: 'Jack Wilson',
    teamId: 'aus',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 28,
    bio: 'Explorative opening batter with a strong pull shot and excellent running between wickets.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 67, innings: 65, runs: 2054, highestScore: 101,
          average: 36.68, strikeRate: 146.1, hundreds: 1, fifties: 14,
          fours: 198, sixes: 79),
      'ODI': BattingCareer(
          matches: 72, innings: 70, runs: 2986, highestScore: 143,
          average: 45.78, strikeRate: 92.4, hundreds: 7, fifties: 18,
          fours: 288, sixes: 52),
    },
    bowlingByFormat: const {},
    recentScores: const ['56(34)', '33(22)', '81(48)', '9(8)', '67(41)'],
  ),
  Player(
    id: 'p_mitchell_reid',
    name: 'Mitchell Reid',
    teamId: 'aus',
    role: PlayerRole.batter,
    battingStyle: 'Left-hand bat',
    bowlingStyle: '—',
    age: 32,
    bio: 'Experienced top-order batter, strong against spin and reliable in chase situations.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 81, innings: 78, runs: 2389, highestScore: 92,
          average: 35.72, strikeRate: 134.8, hundreds: 0, fifties: 17,
          fours: 221, sixes: 56),
    },
    bowlingByFormat: const {},
    recentScores: const ['41(29)', '52(37)', '18(13)', '63(42)', '25(18)'],
  ),
  Player(
    id: 'p_liam_foster',
    name: 'Liam Foster',
    teamId: 'aus',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 26,
    bio: 'Middle-order power hitter who finishes innings with intent.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 39, innings: 36, runs: 894, highestScore: 78,
          average: 30.13, strikeRate: 152.6, hundreds: 0, fifties: 4,
          fours: 79, sixes: 48),
    },
    bowlingByFormat: const {},
    recentScores: const ['22(12)', '47(25)', '6(7)', '78(40)', '35(19)'],
  ),
  Player(
    id: 'p_owen_clarke',
    name: 'Owen Clarke',
    teamId: 'aus',
    role: PlayerRole.wicketKeeper,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 29,
    bio: 'Athletic wicketkeeper-batter, equally effective with the gloves and in the middle order.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 52, innings: 46, runs: 1024, highestScore: 71,
          average: 29.25, strikeRate: 139.4, hundreds: 0, fifties: 5,
          fours: 91, sixes: 37),
    },
    bowlingByFormat: const {},
    recentScores: const ['14(10)', '29(18)', '4(6)', '71(43)', '18(12)'],
  ),
  Player(
    id: 'p_cooper_hayes',
    name: 'Cooper Hayes',
    teamId: 'aus',
    role: PlayerRole.allRounder,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm fast-medium',
    age: 27,
    bio: 'Genuine all-rounder providing balance with bat and ball across all three formats.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 58, innings: 52, runs: 1108, highestScore: 66,
          average: 27.7, strikeRate: 141.3, hundreds: 0, fifties: 6,
          fours: 98, sixes: 41),
    },
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 58, innings: 56, wickets: 63, runsConceded: 1409,
          balls: 1260, average: 22.36, economy: 6.71, bestFigures: 4.3,
          fiveWicketHauls: 0),
    },
    recentScores: const ['24(15)', '2/26', '38(21)', '1/32', '12(9)'],
  ),
  Player(
    id: 'p_nathan_brooks',
    name: 'Nathan Brooks',
    teamId: 'aus',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm fast',
    age: 30,
    bio: 'Tall fast bowler who hits the deck hard and generates extra bounce.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 51, innings: 51, wickets: 66, runsConceded: 1320,
          balls: 1140, average: 20.0, economy: 6.94, bestFigures: 4.2,
          fiveWicketHauls: 0),
      'ODI': BowlingCareer(
          matches: 63, innings: 63, wickets: 91, runsConceded: 2841,
          balls: 3318, average: 31.21, economy: 5.13, bestFigures: 5.4,
          fiveWicketHauls: 2),
    },
    recentScores: const ['2/31', '1/38', '3/24', '2/29', '1/35'],
  ),
  Player(
    id: 'p_harry_miller',
    name: 'Harry Miller',
    teamId: 'aus',
    role: PlayerRole.bowler,
    battingStyle: 'Left-hand bat',
    bowlingStyle: 'Left-arm orthodox',
    age: 25,
    bio: 'Controlled left-arm spinner with excellent accuracy in the middle overs.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 33, innings: 33, wickets: 38, runsConceded: 812,
          balls: 744, average: 21.36, economy: 6.54, bestFigures: 3.2,
          fiveWicketHauls: 0),
    },
    recentScores: const ['1/22', '2/28', '1/31', '2/19', '0/26'],
  ),
  Player(
    id: 'p_oliver_bennett',
    name: 'Oliver Bennett',
    teamId: 'eng',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 29,
    bio: 'Composed opening batter with a wide range of strokes and a strong first-class base.',
    battingByFormat: const {
      'ODI': BattingCareer(
          matches: 84, innings: 82, runs: 3542, highestScore: 148,
          average: 46.6, strikeRate: 89.1, hundreds: 8, fifties: 21,
          fours: 332, sixes: 61),
      'T20I': BattingCareer(
          matches: 49, innings: 47, runs: 1216, highestScore: 84,
          average: 30.4, strikeRate: 137.5, hundreds: 0, fifties: 7,
          fours: 118, sixes: 39),
    },
    bowlingByFormat: const {},
    recentScores: const ['62(71)', '18(26)', '104(112)', '41(48)', '77(83)'],
  ),
  Player(
    id: 'p_george_hall',
    name: 'George Hall',
    teamId: 'eng',
    role: PlayerRole.batter,
    battingStyle: 'Left-hand bat',
    bowlingStyle: '—',
    age: 27,
    bio: 'Left-handed middle-order batter with a strong back-foot game.',
    battingByFormat: const {
      'ODI': BattingCareer(
          matches: 46, innings: 44, runs: 1628, highestScore: 119,
          average: 40.7, strikeRate: 86.2, hundreds: 2, fifties: 11,
          fours: 152, sixes: 27),
    },
    bowlingByFormat: const {},
    recentScores: const ['44(52)', '71(76)', '12(20)', '58(61)', '23(31)'],
  ),
  Player(
    id: 'p_henry_ellis',
    name: 'Henry Ellis',
    teamId: 'eng',
    role: PlayerRole.wicketKeeper,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 31,
    bio: 'Experienced wicketkeeper-batter and a calm presence in pressure chases.',
    battingByFormat: const {
      'ODI': BattingCareer(
          matches: 92, innings: 78, runs: 2410, highestScore: 102,
          average: 36.2, strikeRate: 88.4, hundreds: 1, fifties: 14,
          fours: 214, sixes: 38),
    },
    bowlingByFormat: const {},
    recentScores: const ['31(38)', '9(14)', '67(72)', '22(29)', '45(50)'],
  ),
  Player(
    id: 'p_sam_wright',
    name: 'Sam Wright',
    teamId: 'eng',
    role: PlayerRole.allRounder,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm off-break',
    age: 28,
    bio: 'Versatile all-rounder who can bat in the top order and bowl useful off-spin.',
    battingByFormat: const {
      'ODI': BattingCareer(
          matches: 58, innings: 52, runs: 1712, highestScore: 98,
          average: 37.2, strikeRate: 91.3, hundreds: 0, fifties: 12,
          fours: 161, sixes: 29),
    },
    bowlingByFormat: const {
      'ODI': BowlingCareer(
          matches: 58, innings: 54, wickets: 61, runsConceded: 2341,
          balls: 2904, average: 38.37, economy: 4.84, bestFigures: 4.4,
          fiveWicketHauls: 0),
    },
    recentScores: const ['48(54)', '2/44', '19(24)', '1/51', '36(42)'],
  ),
  Player(
    id: 'p_james_atkinson',
    name: 'James Atkinson',
    teamId: 'eng',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm fast-medium',
    age: 26,
    bio: 'New-ball bowler with genuine swing and an economic death-over game.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'ODI': BowlingCareer(
          matches: 42, innings: 42, wickets: 68, runsConceded: 2112,
          balls: 2310, average: 31.05, economy: 5.48, bestFigures: 5.2,
          fiveWicketHauls: 1),
    },
    recentScores: const ['3/58', '1/67', '2/49', '4/41', '2/55'],
  ),
  Player(
    id: 'p_tom_osborne',
    name: 'Tom Osborne',
    teamId: 'eng',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm leg-break',
    age: 24,
    bio: 'Leg-spinner with a sharp googly, used as a wicket-taking option in the middle overs.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'ODI': BowlingCareer(
          matches: 27, innings: 27, wickets: 39, runsConceded: 1284,
          balls: 1485, average: 32.92, economy: 5.18, bestFigures: 4.3,
          fiveWicketHauls: 0),
    },
    recentScores: const ['2/61', '1/48', '3/52', '1/44', '2/58'],
  ),
  Player(
    id: 'p_dwayne_carter',
    name: 'Dwayne Carter',
    teamId: 'wi',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm medium',
    age: 30,
    bio: 'Hard-hitting top-order batter, strongest through the leg side.',
    battingByFormat: const {
      'ODI': BattingCareer(
          matches: 79, innings: 76, runs: 2841, highestScore: 139,
          average: 41.18, strikeRate: 94.6, hundreds: 5, fifties: 17,
          fours: 261, sixes: 82),
    },
    bowlingByFormat: const {},
    recentScores: const ['38(44)', '72(61)', '15(22)', '91(78)', '24(31)'],
  ),
  Player(
    id: 'p_kemar_johnson',
    name: 'Kemar Johnson',
    teamId: 'wi',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm fast',
    age: 29,
    bio: 'Express fast bowler with a dangerous bouncer and strong death-over skills.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'ODI': BowlingCareer(
          matches: 51, innings: 51, wickets: 74, runsConceded: 2104,
          balls: 2580, average: 28.43, economy: 4.89, bestFigures: 5.1,
          fiveWicketHauls: 1),
    },
    recentScores: const ['2/62', '3/48', '1/74', '2/55', '3/41'],
  ),
  Player(
    id: 'p_finn_harris',
    name: 'Finn Harris',
    teamId: 'nz',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 26,
    bio: 'Solid top-order batter with an unconventional stance and a strong cut shot.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 43, innings: 41, runs: 1082, highestScore: 87,
          average: 31.82, strikeRate: 138.9, hundreds: 0, fifties: 6,
          fours: 104, sixes: 34),
    },
    bowlingByFormat: const {},
    recentScores: const ['34(24)', '51(36)', '11(9)', '47(29)', '28(18)'],
  ),
  Player(
    id: 'p_jacob_du_preez',
    name: 'Jacob du Preez',
    teamId: 'sa',
    role: PlayerRole.batter,
    battingStyle: 'Right-hand bat',
    bowlingStyle: '—',
    age: 28,
    bio: 'Flush timing and a strong square drive make him a key middle-order batter.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 55, innings: 53, runs: 1642, highestScore: 96,
          average: 36.48, strikeRate: 142.1, hundreds: 0, fifties: 11,
          fours: 151, sixes: 57),
    },
    bowlingByFormat: const {},
    recentScores: const ['48(31)', '22(15)', '66(42)', '17(12)', '53(35)'],
  ),
  Player(
    id: 'p_ahmad_raza',
    name: 'Ahmad Raza',
    teamId: 'pak',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm off-break',
    age: 30,
    bio: 'Wily off-spinner who variations and flight to deceive batters in the middle overs.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 64, innings: 62, wickets: 71, runsConceded: 1512,
          balls: 1428, average: 21.29, economy: 6.35, bestFigures: 4.2,
          fiveWicketHauls: 0),
    },
    recentScores: const ['2/27', '1/33', '3/22', '2/29', '1/25'],
  ),
  Player(
    id: 'p_kavindu_perera',
    name: 'Kavindu Perera',
    teamId: 'sl',
    role: PlayerRole.allRounder,
    battingStyle: 'Left-hand bat',
    bowlingStyle: 'Left-arm orthodox',
    age: 25,
    bio: 'Left-handed batting all-rounder with a calm temperament and accurate spin.',
    battingByFormat: const {
      'T20I': BattingCareer(
          matches: 40, innings: 36, runs: 842, highestScore: 71,
          average: 28.06, strikeRate: 131.4, hundreds: 0, fifties: 4,
          fours: 81, sixes: 22),
    },
    bowlingByFormat: const {
      'T20I': BowlingCareer(
          matches: 40, innings: 38, wickets: 41, runsConceded: 932,
          balls: 852, average: 22.73, economy: 6.56, bestFigures: 3.1,
          fiveWicketHauls: 0),
    },
    recentScores: const ['26(19)', '1/24', '41(28)', '2/31', '14(11)'],
  ),
  Player(
    id: 'p_tanvir_ahmed',
    name: 'Tanvir Ahmed',
    teamId: 'ban',
    role: PlayerRole.bowler,
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm fast-medium',
    age: 27,
    bio: 'Hard-working seamer with a well-disguised slower ball.',
    battingByFormat: const {},
    bowlingByFormat: const {
      'ODI': BowlingCareer(
          matches: 38, innings: 38, wickets: 52, runsConceded: 1624,
          balls: 2052, average: 31.23, economy: 4.75, bestFigures: 4.6,
          fiveWicketHauls: 0),
    },
    recentScores: const ['2/58', '1/63', '3/47', '2/52', '1/49'],
  ),
];

Player? findDemoPlayer(String id) {
  for (final player in demoPlayers) {
    if (player.id == id) return player;
  }
  return null;
}

List<Player> demoPlayersForTeam(String teamId) =>
    demoPlayers.where((player) => player.teamId == teamId).toList();

List<String> demoPlayerIdsForTeam(String teamId) =>
    demoPlayersForTeam(teamId).map((player) => player.id).toList();
