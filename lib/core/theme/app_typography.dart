import 'package:flutter/material.dart';

import 'app_colors.dart';

class VitaloTypography {
  VitaloTypography._();

  static TextTheme lightTextTheme = _buildTextTheme(
    primaryColor: AppColors.onBackground,
    secondaryColor: AppColors.onSurfaceVariant,
  );

  static TextTheme darkTextTheme = _buildTextTheme(
    primaryColor: AppColors.darkTextPrimary,
    secondaryColor: AppColors.darkTextSecondary,
  );

  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    const baseFontFamily = 'Roboto';

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: secondaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: secondaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: baseFontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
