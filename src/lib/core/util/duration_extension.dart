extension IntDurationExtension on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get s => Duration(seconds: this);
  Duration get m => Duration(minutes: this);
  Duration get h => Duration(hours: this);
  Duration get d => Duration(days: this);
}

extension Iso8601Duration on Duration {
  /// Converts a Duration to an ISO 8601 duration string (e.g., PT19H31M).
  String toIso8601() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    final buffer = StringBuffer('PT');
    if (hours > 0) buffer.write('${hours}H');
    if (minutes > 0) buffer.write('${minutes}M');
    if (seconds > 0) buffer.write('${seconds}S');

    // If duration is zero, explicitly return PT0S
    if (hours == 0 && minutes == 0 && seconds == 0) {
      buffer.write('0S');
    }

    return buffer.toString();
  }

  /// Parses an ISO 8601 duration string (e.g., PT19H31M) to a Duration.
  static Duration fromIso8601(String input) {
    final regex = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$');
    final match = regex.firstMatch(input);

    if (match == null) {
      throw FormatException('Invalid ISO 8601 duration', input);
    }

    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}

extension DurationFormatting on Duration {
  /// Formats the duration into a human-readable string.
  /// Examples:
  /// - 3 hours 30 minutes → "3.5 hours"
  /// - 32 minutes → "32 minutes"
  /// - 1 hour 15 minutes → "1.25 hours"
  String toReadableString({bool useDecimalHours = true}) {
    if (inHours > 0 && useDecimalHours) {
      final decimalHours = inHours + (inMinutes.remainder(60) / 60);
      return '${decimalHours.toStringAsFixed(2)} hours';
    } else if (inHours > 0) {
      final hours = inHours;
      final minutes = inMinutes.remainder(60);
      if (minutes == 0) {
        return '$hours ${hours == 1 ? "hour" : "hours"}';
      } else {
        return '$hours ${hours == 1 ? "hour" : "hours"} $minutes minutes';
      }
    } else if (inMinutes > 0) {
      return '$inMinutes ${inMinutes == 1 ? "minute" : "minutes"}';
    } else {
      return '$inSeconds ${inSeconds == 1 ? "second" : "seconds"}';
    }
  }
}
