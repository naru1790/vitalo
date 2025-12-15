import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Vitalo Typography System - Brand-aligned text styles
/// Uses GoogleFonts for seamless Poppins (Headings) and Inter (Body) integration.
class VitaloTypography {
  VitaloTypography._();

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
      // ───── Display styles (Poppins) ─────
      // Hero headlines, very large text
      displayLarge: GoogleFonts.poppins(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -1.0,
        height: 1.0,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.8,
        height: 1.1,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.5,
        height: 1.2,
      ),

      // ───── Headline styles (Poppins) ─────
      // Section headers
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.4,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: -0.2,
        height: 1.3,
      ),

      // ───── Title styles (Poppins) ─────
      // Card titles, Dialog titles
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
        height: 1.4,
      ),

      // ───── Body styles (Inter) ─────
      // Main content, paragraphs
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0.15, // Improved readability
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0.25,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0.4,
        height: 1.5,
      ),

      // ───── Label styles (Poppins) ─────
      // Buttons, chips, tags, navigation
      labelLarge: GoogleFonts.poppins(
        fontSize: 16, // M3 standard is 14, but 16 is nicer for "Soft" buttons
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
        height: 1.2,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    );
  }
}
