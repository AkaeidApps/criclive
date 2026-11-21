import '../../core/enums/app_enums.dart';
import '../../core/utils/formatters.dart';

class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final NewsCategory category;
  final DateTime publishedAt;
  final String source;
  final String author;
  final int readMinutes;
  final List<String> body;
  final bool featured;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.publishedAt,
    required this.source,
    required this.author,
    required this.readMinutes,
    required this.body,
    this.featured = false,
  });

  String get timeLabel => AppFormatters.relativeTime(publishedAt);

  String get dateLabel => AppFormatters.dateTime(publishedAt);

  String get categoryLabel => category.label;
}
