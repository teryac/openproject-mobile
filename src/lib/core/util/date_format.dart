import 'package:intl/intl.dart';

class FormattedDate {
  final String year;
  final String month;
  final String day;
  final String daySuffix;

  FormattedDate({
    required this.year,
    required this.month,
    required this.day,
    required this.daySuffix,
  });

  @override
  String toString() {
    return '$day$daySuffix $month, $year';
  }
}

FormattedDate? getFormattedDate(DateTime? dateTime) {
  if (dateTime == null) return null;

  final day = dateTime.day;
  final suffix = _getDaySuffix(day);

  final month = DateFormat('MMMM').format(dateTime); // e.g. May
  final year = DateFormat('yy').format(dateTime); // e.g. 25

  return FormattedDate(
    year: year,
    month: month,
    day: day.toString(),
    daySuffix: suffix,
  );
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String deadlineText(DateTime dueDate) {
  final now = DateTime.now();
  final diff = dueDate.difference(now);
  final days = diff.inDays;

  // Helper to pick between singular/plural
  String plural(int value, String unit) =>
      '$value $unit${value == 1 ? '' : 's'}';

  if (days == 0) return 'Due today';
  if (days == -1) return 'Due yesterday';
  if (days == 1) return 'Due tomorrow';

  if (days > 0) {
    if (days < 7) return 'Due in ${plural(days, 'day')}';
    if (days < 30) {
      final weeks = (days / 7).round();
      return 'Due in about ${plural(weeks, 'week')}';
    }
    if (days < 365) {
      final months = (days / 30).round();
      return 'Due in about ${plural(months, 'month')}';
    }
    final years = (days / 365).round();
    return 'Due in about ${plural(years, 'year')}';
  } else {
    final overdueDays = -days;
    if (overdueDays < 7) return 'Overdue by ${plural(overdueDays, 'day')}';
    if (overdueDays < 30) {
      final weeks = (overdueDays / 7).round();
      return 'Overdue by about ${plural(weeks, 'week')}';
    }
    if (overdueDays < 365) {
      final months = (overdueDays / 30).round();
      return 'Overdue by about ${plural(months, 'month')}';
    }
    final years = (overdueDays / 365).round();
    return 'Overdue by about ${plural(years, 'year')}';
  }
}
