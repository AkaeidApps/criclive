import '../../../core/enums/app_enums.dart';
import '../../models/ranking.dart';

/// BUNDLED DEMO DATA — illustrative ICC-style rankings, not official ratings.
final List<RankingBoard> demoRankings = [
  RankingBoard(
    category: RankingCategory.batting,
    title: 'Men’s ODI Batting',
    subtitle: 'Demo ratings · fictional players',
    entries: const [
      RankingEntry(rank: 1, previousRank: 1, name: 'Rohan Kapoor', countryCode: 'IND', rating: 872, playerId: 'p_rohan_kapoor'),
      RankingEntry(rank: 2, previousRank: 3, name: 'Jack Wilson', countryCode: 'AUS', rating: 856, playerId: 'p_jack_wilson'),
      RankingEntry(rank: 3, previousRank: 2, name: 'Oliver Bennett', countryCode: 'ENG', rating: 849, playerId: 'p_oliver_bennett'),
      RankingEntry(rank: 4, previousRank: 5, name: 'Dwayne Carter', countryCode: 'WI', rating: 821, playerId: 'p_dwayne_carter'),
      RankingEntry(rank: 5, previousRank: 4, name: 'Mitchell Reid', countryCode: 'AUS', rating: 814, playerId: 'p_mitchell_reid'),
      RankingEntry(rank: 6, previousRank: 7, name: 'Jacob du Preez', countryCode: 'SA', rating: 798, playerId: 'p_jacob_du_preez'),
      RankingEntry(rank: 7, previousRank: 6, name: 'Sam Wright', countryCode: 'ENG', rating: 791, playerId: 'p_sam_wright'),
      RankingEntry(rank: 8, previousRank: 9, name: 'Finn Harris', countryCode: 'NZ', rating: 776, playerId: 'p_finn_harris'),
      RankingEntry(rank: 9, previousRank: 8, name: 'Aarav Mehta', countryCode: 'IND', rating: 768, playerId: 'p_aarav_mehta'),
      RankingEntry(rank: 10, previousRank: 10, name: 'Kavindu Perera', countryCode: 'SL', rating: 752, playerId: 'p_kavindu_perera'),
    ],
  ),
  RankingBoard(
    category: RankingCategory.bowling,
    title: 'Men’s ODI Bowling',
    subtitle: 'Demo ratings · fictional players',
    entries: const [
      RankingEntry(rank: 1, previousRank: 2, name: 'Nathan Brooks', countryCode: 'AUS', rating: 889, playerId: 'p_nathan_brooks'),
      RankingEntry(rank: 2, previousRank: 1, name: 'James Atkinson', countryCode: 'ENG', rating: 881, playerId: 'p_james_atkinson'),
      RankingEntry(rank: 3, previousRank: 3, name: 'Arjun Rao', countryCode: 'IND', rating: 854, playerId: 'p_arjun_rao'),
      RankingEntry(rank: 4, previousRank: 5, name: 'Kemar Johnson', countryCode: 'WI', rating: 838, playerId: 'p_kemar_johnson'),
      RankingEntry(rank: 5, previousRank: 4, name: 'Ahmad Raza', countryCode: 'PAK', rating: 826, playerId: 'p_ahmad_raza'),
      RankingEntry(rank: 6, previousRank: 7, name: 'Nikhil Chaturvedi', countryCode: 'IND', rating: 812, playerId: 'p_nikhil_chaturvedi'),
      RankingEntry(rank: 7, previousRank: 6, name: 'Tanvir Ahmed', countryCode: 'BAN', rating: 801, playerId: 'p_tanvir_ahmed'),
      RankingEntry(rank: 8, previousRank: 8, name: 'Tom Osborne', countryCode: 'ENG', rating: 788, playerId: 'p_tom_osborne'),
      RankingEntry(rank: 9, previousRank: 10, name: 'Harry Miller', countryCode: 'AUS', rating: 774, playerId: 'p_harry_miller'),
      RankingEntry(rank: 10, previousRank: 9, name: 'Siddharth Jain', countryCode: 'IND', rating: 766, playerId: 'p_siddharth_jain'),
    ],
  ),
  RankingBoard(
    category: RankingCategory.allRounder,
    title: 'Men’s T20I All-rounder',
    subtitle: 'Demo ratings · fictional players',
    entries: const [
      RankingEntry(rank: 1, previousRank: 1, name: 'Kabir Patel', countryCode: 'IND', rating: 842, playerId: 'p_kabir_patel'),
      RankingEntry(rank: 2, previousRank: 3, name: 'Cooper Hayes', countryCode: 'AUS', rating: 829, playerId: 'p_cooper_hayes'),
      RankingEntry(rank: 3, previousRank: 2, name: 'Sam Wright', countryCode: 'ENG', rating: 817, playerId: 'p_sam_wright'),
      RankingEntry(rank: 4, previousRank: 4, name: 'Kavindu Perera', countryCode: 'SL', rating: 796, playerId: 'p_kavindu_perera'),
      RankingEntry(rank: 5, previousRank: 6, name: 'Ahmad Raza', countryCode: 'PAK', rating: 781, playerId: 'p_ahmad_raza'),
    ],
  ),
  RankingBoard(
    category: RankingCategory.teams,
    title: 'Men’s T20I Teams',
    subtitle: 'Demo ratings · illustrative only',
    entries: const [
      RankingEntry(rank: 1, previousRank: 1, name: 'India', countryCode: 'IND', rating: 268, teamId: 'ind'),
      RankingEntry(rank: 2, previousRank: 3, name: 'Australia', countryCode: 'AUS', rating: 261, teamId: 'aus'),
      RankingEntry(rank: 3, previousRank: 2, name: 'England', countryCode: 'ENG', rating: 258, teamId: 'eng'),
      RankingEntry(rank: 4, previousRank: 4, name: 'South Africa', countryCode: 'SA', rating: 249, teamId: 'sa'),
      RankingEntry(rank: 5, previousRank: 6, name: 'New Zealand', countryCode: 'NZ', rating: 242, teamId: 'nz'),
      RankingEntry(rank: 6, previousRank: 5, name: 'Pakistan', countryCode: 'PAK', rating: 238, teamId: 'pak'),
      RankingEntry(rank: 7, previousRank: 8, name: 'West Indies', countryCode: 'WI', rating: 229, teamId: 'wi'),
      RankingEntry(rank: 8, previousRank: 7, name: 'Sri Lanka', countryCode: 'SL', rating: 224, teamId: 'sl'),
    ],
  ),
];

RankingBoard rankingFor(RankingCategory category) => demoRankings.firstWhere(
      (board) => board.category == category,
      orElse: () => demoRankings.first,
    );
