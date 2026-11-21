import 'package:intl/intl.dart';

/// Formatting helpers shared across screens.
abstract final class AppFormatters {
  static String oversFromBalls(int balls) {
    if (balls <= 0) return '0.0';
    final complete = balls ~/ 6;
    final remaining = balls % 6;
    return '$complete.$remaining';
  }

  static String score(int runs, int wickets) => '$runs/$wickets';

  static String date(DateTime value) => DateFormat('d MMM yyyy').format(value);

  static String shortDate(DateTime value) => DateFormat('d MMM').format(value);

  static String weekday(DateTime value) => DateFormat('EEE').format(value);

  static String time(DateTime value) => DateFormat('HH:mm').format(value);

  static String dateTime(DateTime value) =>
      DateFormat('d MMM yyyy, HH:mm').format(value);

  static String relativeTime(DateTime value, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final difference = reference.difference(value);
    if (difference.isNegative) return dateTime(value);
    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return date(value);
  }

  static String signed(int value) => value > 0 ? '+$value' : '$value';

  static String ordinal(int value) {
    final lastTwo = value % 100;
    String suffix;
    if (lastTwo >= 11 && lastTwo <= 13) {
      suffix = 'th';
    } else {
      suffix = switch (value % 10) {
        1 => 'st',
        2 => 'nd',
        3 => 'rd',
        _ => 'th',
      };
    }
    return '$value$suffix';
  }

  static String percent(double value) => '${value.toStringAsFixed(1)}%';
}
