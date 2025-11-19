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
    // Handle the zero-duration case, which is a standard representation.
    if (this == Duration.zero) {
      return 'PT0S';
    }

    final buffer = StringBuffer();
    buffer.write('P');

    // Decompose the duration into its components
    // Note: We use inDays, which is the total number of full days.
    final days = inDays;

    // We use modulo to get the remaining hours, minutes, and seconds
    // after the full days have been accounted for.
    final hours = inHours % 24;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    // --- Date Part ---
    // Add days if they exist
    if (days > 0) {
      buffer.write('${days}D');
    }

    // --- Time Part ---
    // Check if any time components exist
    if (hours > 0 || minutes > 0 || seconds > 0) {
      buffer.write('T');

      if (hours > 0) {
        buffer.write('${hours}H');
      }
      if (minutes > 0) {
        buffer.write('${minutes}M');
      }
      if (seconds > 0) {
        buffer.write('${seconds}S');
      }
    }

    return buffer.toString();
  }

  /// Parses an ISO 8601 duration string (e.g., P2DT17H) to a Duration.
  static Duration fromIso8601(String input) {
    final regex = RegExp(r'^P'
        r'(?:(\d+)Y)?'
        r'(?:(\d+)M)?'
        r'(?:(\d+)W)?'
        r'(?:(\d+)D)?'
        r'(?:T'
        r'(?:(\d+)H)?'
        r'(?:(\d+)M)?'
        r'(?:(\d+)S)?'
        r')?$');

    final match = regex.firstMatch(input);
    if (match == null) {
      throw FormatException('Invalid ISO 8601 duration', input);
    }

    final years = int.tryParse(match.group(1) ?? '0') ?? 0;
    final months = int.tryParse(match.group(2) ?? '0') ?? 0;
    final weeks = int.tryParse(match.group(3) ?? '0') ?? 0;
    final days = int.tryParse(match.group(4) ?? '0') ?? 0;

    final hours = int.tryParse(match.group(5) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(6) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(7) ?? '0') ?? 0;

    // Convert years and months into days (approximate)
    final totalDays = days + weeks * 7 + months * 30 + years * 365;

    return Duration(
      days: totalDays,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
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
