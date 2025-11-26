import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color searchBarBackground = Color(0xFFF3F4F4);
  static const Color projectBackground = Color(0xFFF3F4F4);

  // Disabled
  static const Color border = Color(0xFFE5E9E9);
  static const Color lowContrastCursor = Color(0xFFE5E9E9);
  static const Color handle = Color(0xFFD1D4D6);

  // Primary
  static const Color button = Color(0xFF2392D4);
  static const Color blue100 = Color(0xFF2392D4);
  static const Color blue25 = Color(0x402392D4);
  static const Color highContrastCursor = Color(0xFF2392D4);

  // Error
  static const Color red = Color(0xFFF84616);
  static const Color redBackground = Color(0x40F84616);

  // Text
  static const Color buttonText = Color(0xFFF1F8FE);
  static const Color primaryText = Color(0xFF262B2C);
  static const Color descriptiveText = Color(0xFF848D90);
  static const Color highContrastDescriptiveText = Color(0xFF60686B);
  static const Color textOnBlack = Color(0xFFFAFAFA);

  // Icons
  static const Color iconPrimary = Color(0xFF262B2C);
  static const Color iconSecondary = Color(0xFF848D90);
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

extension ColorTools on Color {
  /// Gets the lightness component (L) of the color as a double (0.0 to 1.0).
  double get colorLightness {
    return HSLColor.fromColor(this).lightness;
  }

  /// Changes the lightness component of the color to the specified value.
  /// The new lightness value must be between 0.0 and 1.0.
  Color changeColorLightness(double newLightness) {
    if (newLightness < 0.0 || newLightness > 1.0) {
      throw ArgumentError('New lightness must be between 0.0 and 1.0');
    }

    HSLColor hslColor = HSLColor.fromColor(this);

    // Create a new HSL color with the updated lightness.
    HSLColor newHslColor = hslColor.withLightness(newLightness);

    // Convert back to a standard RGB Color.
    return newHslColor.toColor();
  }

  /// Changes colors lightness to make them more readable
  Color getReadableColor() {
    if (colorLightness <= 0.7) return this;

    return changeColorLightness(0.7);
  }
}
