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
