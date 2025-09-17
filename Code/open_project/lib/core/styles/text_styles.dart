import 'package:flutter/material.dart';

class AppTextStyles {
  static const _poppins = 'Poppins';

  // Extra Large
  static TextStyle get extraLarge => const TextStyle(
        fontFamily: _poppins,
        fontWeight: FontWeight.w600,
        fontSize: 23,
        height: 1.2,
        letterSpacing: -2,
      );

  // Large
  static TextStyle get large => const TextStyle(
        fontFamily: _poppins,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 1.2,
        letterSpacing: 0,
      );

  // Medium
  static TextStyle get medium => const TextStyle(
        fontFamily: _poppins,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.3,
        letterSpacing: 0,
      );

  // Small
  static TextStyle get small => const TextStyle(
        fontFamily: _poppins,
        fontWeight: FontWeight.w400,
        fontSize: 13,
        height: 1.5,
        letterSpacing: 0,
      );

  // Extra Small
  static TextStyle get extraSmall => const TextStyle(
        fontFamily: _poppins,
        fontWeight: FontWeight.w400,
        fontSize: 11,
        height: 1.2,
        letterSpacing: 0,
      );
}
