import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Vitalo Typography System - Brand-aligned text styles
class VitaloTypography {
  VitaloTypography._();

  // Font Families
  static const String displayFont = 'Poppins';
  static const String bodyFont = 'Inter';

  // Brand Text Styles - Light Theme
  static TextTheme lightTextTheme = _buildTextTheme(
    primaryColor: AppColors.onSurface,
    secondaryColor: AppColors.onSurfaceVariant,
  );

  // Brand Text Styles - Dark Theme
  static TextTheme darkTextTheme = _buildTextTheme(
    primaryColor: AppColors.darkOnSurface,
    secondaryColor: AppColors.darkOnSurfaceVariant,
  );

  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      // Display styles - Hero headlines (Poppins)
      displayLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -1.0,
        height: 1.0,
      ),
      displayMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.8,
        height: 1.1,
      ),
      displaySmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.5,
        height: 1.2,
      ),

      // Headline styles - Section headers (Poppins)
      headlineLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.4,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.2,
        height: 1.3,
      ),

      // Title styles - Card titles, dialogs (Poppins)
      titleLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
        height: 1.4,
      ),

      // Body styles - Main content (Inter)
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0,
        height: 1.5,
      ),

      // Label styles - Buttons, chips, tags (Poppins)
      labelLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: 0.2,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.3,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    );
  }
}
