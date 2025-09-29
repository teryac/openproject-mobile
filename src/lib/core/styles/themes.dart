import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.button,
      splashColor: AppColors.blue25,
      disabledColor: AppColors.handle,
      dividerColor: AppColors.border,
      colorScheme: const ColorScheme(
        primary: AppColors.blue100,
        secondary: AppColors.blue25,
        onPrimary: AppColors.buttonText,
        brightness: Brightness.light,
        onSecondary: AppColors.buttonText,
        error: AppColors.redBackground,
        onError: AppColors.red,
        surface: AppColors.background,
        onSurface: AppColors.primaryText,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.extraLarge,
        displayMedium: AppTextStyles.large,
        displaySmall: AppTextStyles.medium,
        headlineLarge: AppTextStyles.large,
        headlineMedium: AppTextStyles.medium,
        headlineSmall: AppTextStyles.small,
        titleLarge: AppTextStyles.large,
        titleMedium: AppTextStyles.medium,
        titleSmall: AppTextStyles.small,
        bodyLarge: AppTextStyles.medium,
        bodyMedium: AppTextStyles.small,
        bodySmall: AppTextStyles.extraSmall,
        labelLarge: AppTextStyles.medium,
        labelMedium: AppTextStyles.small,
        labelSmall: AppTextStyles.extraSmall,
      ),
    );
  }
}
