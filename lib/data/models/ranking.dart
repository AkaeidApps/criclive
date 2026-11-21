import '../../core/enums/app_enums.dart';

class RankingEntry {
  final int rank;
  final int previousRank;
  final String name;
  final String countryCode;
  final double rating;
  final String? playerId;
  final String? teamId;

  const RankingEntry({
    required this.rank,
    required this.previousRank,
    required this.name,
    required this.countryCode,
    required this.rating,
    this.playerId,
    this.teamId,
  });

  int get movement => previousRank - rank;

  String get ratingLabel => rating.toStringAsFixed(0);
}

class RankingBoard {
  final RankingCategory category;
  final String title;
  final String subtitle;
  final List<RankingEntry> entries;

  const RankingBoard({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.entries,
  });
}
