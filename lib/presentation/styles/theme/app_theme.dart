import 'package:dicoding_submission_restaurant/presentation/styles/typography/app_typography.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        colorScheme: ColorScheme.light(
            primary: const Color(0xFF6D4C41), // Brown color
            onPrimary: const Color(0xFFFFFFFF),
            tertiary: const Color(0xFF8D6E63)), // Light brown color
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: _textTheme);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        colorScheme: ColorScheme.dark(
            primary: const Color(0xFF8D6E63), // Light brown color
            onPrimary: const Color(0xFF3E2723), // Dark brown color
            tertiary: const Color(0xFF6D4C41)), // Brown color
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: _textTheme);
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      displaySmall: AppTypography.displaySmall,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      titleSmall: AppTypography.titleSmall,
      bodyLarge: AppTypography.bodyLargeBold,
      bodyMedium: AppTypography.bodyLargeMedium,
      bodySmall: AppTypography.bodyLargeRegular,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    );
  }
}
