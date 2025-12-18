import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════
// VITALO THEME - iOS 26 Liquid Glass Design
// Bright, vibrant colors with translucent glass materials
// Philosophy: Clarity, Depth, Vibrancy — Apple HIG iOS 26
//
// Typography (Platform-Adaptive):
// - iOS: SF Pro (system font) — Apple's native typeface
// - Android: Outfit (headings) + Inter (body) via Google Fonts
//
// Apple HIG Typography Scale:
// - Large Title: 34pt Bold
// - Title 1: 28pt Bold
// - Title 2: 22pt Bold
// - Title 3: 20pt Semibold
// - Headline: 17pt Semibold
// - Body: 17pt Regular
// - Callout: 16pt Regular
// - Subhead: 15pt Regular
// - Footnote: 13pt Regular
// - Caption 1: 12pt Regular
// - Caption 2: 11pt Regular
// ═══════════════════════════════════════════════════════════════════════════

/// Creates platform-adaptive text theme
/// iOS: SF Pro (system font) with Apple HIG sizes
/// Android: Outfit (headings) + Inter (body) via Google Fonts
TextTheme createTextTheme(BuildContext context) {
  if (Platform.isIOS || Platform.isMacOS) {
    return _createAppleTextTheme();
  }
  return _createAndroidTextTheme(context);
}

/// Apple SF Pro typography following iOS HIG exactly
TextTheme _createAppleTextTheme() {
  // SF Pro is the system font on iOS/macOS - no fontFamily needed
  return const TextTheme(
    // Large Title - 34pt Bold
    displayLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.37,
    ),
    // Title 1 - 28pt Bold
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.36,
    ),
    // Title 2 - 22pt Bold
    displaySmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.35,
    ),
    // Title 3 - 20pt Semibold
    headlineLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.38,
    ),
    // Headline - 17pt Semibold
    headlineMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.41,
    ),
    // Subheadline - 15pt Regular
    headlineSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.24,
    ),
    // Title Large - 20pt Semibold (for nav bars)
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.38,
    ),
    // Headline - 17pt Semibold
    titleMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.41,
    ),
    // Subheadline - 15pt Medium
    titleSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.24,
    ),
    // Body - 17pt Regular
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.41,
    ),
    // Callout - 16pt Regular
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.32,
    ),
    // Subhead - 15pt Regular
    bodySmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.24,
    ),
    // Button text - 17pt Semibold (iOS standard for buttons)
    labelLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.41,
    ),
    // Caption 1 - 12pt Regular
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    // Caption 2 - 11pt Regular
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.07,
    ),
  );
}

/// Android typography using Google Fonts (Outfit + Inter)
TextTheme _createAndroidTextTheme(BuildContext context) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;

  // Body text: Inter - designed specifically for screen legibility
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme('Inter', baseTextTheme);

  // Outfit for headings + Inter for body
  return TextTheme(
    // Display styles - Outfit SemiBold for main page titles
    displayLarge: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.w600),
    displayMedium: GoogleFonts.outfit(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600),
    // Headline styles - Outfit SemiBold for section headers
    headlineLarge: GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.outfit(
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.outfit(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
    // Title styles - Outfit for subtitles
    titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500),
    // Body styles - Inter for readable content
    bodyLarge: bodyTextTheme.bodyLarge?.copyWith(fontSize: 17),
    bodyMedium: bodyTextTheme.bodyMedium?.copyWith(fontSize: 16),
    bodySmall: bodyTextTheme.bodySmall?.copyWith(fontSize: 15),
    // Label styles - Outfit for buttons (17pt iOS standard), Inter for captions
    labelLarge: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600),
    labelMedium: bodyTextTheme.labelMedium?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: bodyTextTheme.labelSmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w400,
    ),
  );
}

/// Vitalo iOS-first theme configuration
/// Provides light/dark themes with iOS 26 Liquid Glass design language
class VitaloTheme {
  final TextTheme textTheme;

  const VitaloTheme(this.textTheme);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME - iOS 26 Liquid Glass (Bright & Vibrant)
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      // ───── Primary (Vibrant Orange - Energy & Vitality) ─────
      primary: Color(0xFFF97316), // Orange 500 - Bright brand
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFF7ED), // Orange 50 - Glass tint
      onPrimaryContainer: Color(0xFFC2410C), // Orange 700
      // ───── Secondary (Vibrant Pink - Fresh & Modern) ─────
      secondary: Color(0xFFEC4899), // Pink 500 - Bright accent
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFDF2F8), // Pink 50 - Glass tint
      onSecondaryContainer: Color(0xFFBE185D), // Pink 700
      // ───── Tertiary (Cyan - Cool Balance) ─────
      tertiary: Color(0xFF06B6D4), // Cyan 500 - Success/positive
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFECFEFF), // Cyan 50 - Glass tint
      onTertiaryContainer: Color(0xFF0E7490), // Cyan 700
      // ───── Error (Vibrant Red) ─────
      error: Color(0xFFEF4444), // Red 500
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEF2F2), // Red 50
      onErrorContainer: Color(0xFFB91C1C), // Red 700
      // ───── Surface (Pure White for Liquid Glass) ─────
      surface: Color(0xFFFFFFFF), // Pure white - glass base
      onSurface: Color(0xFF0F172A), // Slate 900 - crisp text
      onSurfaceVariant: Color(0xFF64748B), // Slate 500
      // ───── Outline (Subtle Glass Edges) ─────
      outline: Color(0xFFCBD5E1), // Slate 300
      outlineVariant: Color(0xFFE2E8F0), // Slate 200 - glass borders
      // ───── System ─────
      shadow: Color(0x14000000), // 8% opacity - soft shadow
      scrim: Color(0x66000000), // 40% opacity
      inverseSurface: Color(0xFF1E293B), // Slate 800
      inversePrimary: Color(0xFFFDBA74), // Orange 300
      // ───── Fixed Colors (Vibrant Trio) ─────
      primaryFixed: Color(0xFFFFF7ED),
      onPrimaryFixed: Color(0xFF7C2D12),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFEA580C),
      secondaryFixed: Color(0xFFFDF2F8),
      onSecondaryFixed: Color(0xFF9D174D),
      secondaryFixedDim: Color(0xFFF472B6),
      onSecondaryFixedVariant: Color(0xFFDB2777),
      tertiaryFixed: Color(0xFFECFEFF),
      onTertiaryFixed: Color(0xFF155E75),
      tertiaryFixedDim: Color(0xFF22D3EE),
      onTertiaryFixedVariant: Color(0xFF0891B2),
      // ───── Surface Containers (Liquid Glass Layers) ─────
      surfaceDim: Color(0xFFF1F5F9), // Slate 100
      surfaceBright: Color(0xFFFFFFFF), // Pure white
      surfaceContainerLowest: Color(0xFFFFFFFF), // Glass base
      surfaceContainerLow: Color(0xFFFAFAFA), // Subtle elevation
      surfaceContainer: Color(0xFFF8FAFC), // Slate 50 - cards
      surfaceContainerHigh: Color(0xFFF1F5F9), // Slate 100
      surfaceContainerHighest: Color(0xFFE2E8F0), // Slate 200
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT MEDIUM CONTRAST
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFEA580C), // Orange 600
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFB923C), // Orange 400
      onPrimaryContainer: Color(0xFF431407),
      secondary: Color(0xFFDB2777), // Pink 600
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF472B6), // Pink 400
      onSecondaryContainer: Color(0xFF500724),
      tertiary: Color(0xFF0891B2), // Cyan 600
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF22D3EE), // Cyan 400
      onTertiaryContainer: Color(0xFF083344),
      error: Color(0xFFDC2626), // Red 600
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF87171), // Red 400
      onErrorContainer: Color(0xFF450A0A),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF020617), // Slate 950
      onSurfaceVariant: Color(0xFF475569), // Slate 600
      outline: Color(0xFF64748B), // Slate 500
      outlineVariant: Color(0xFFCBD5E1), // Slate 300
      shadow: Color(0x1A000000),
      scrim: Color(0x80000000),
      inverseSurface: Color(0xFF1E293B),
      inversePrimary: Color(0xFFFDBA74),
      primaryFixed: Color(0xFFFFF7ED),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFFFB923C),
      onPrimaryFixedVariant: Color(0xFF7C2D12),
      secondaryFixed: Color(0xFFFDF2F8),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFF472B6),
      onSecondaryFixedVariant: Color(0xFF9D174D),
      tertiaryFixed: Color(0xFFECFEFF),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFF22D3EE),
      onTertiaryFixedVariant: Color(0xFF0E7490),
      surfaceDim: Color(0xFFE2E8F0),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF8FAFC),
      surfaceContainer: Color(0xFFF1F5F9),
      surfaceContainerHigh: Color(0xFFE2E8F0),
      surfaceContainerHighest: Color(0xFFCBD5E1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT HIGH CONTRAST
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFC2410C), // Orange 700
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF7C2D12), // Orange 900
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFFBE185D), // Pink 700
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF9D174D), // Pink 800
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFF0E7490), // Cyan 700
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF155E75), // Cyan 800
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFFB91C1C), // Red 700
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFF991B1B), // Red 800
      onErrorContainer: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      onSurfaceVariant: Color(0xFF1E293B), // Slate 800
      outline: Color(0xFF334155), // Slate 700
      outlineVariant: Color(0xFF475569), // Slate 600
      shadow: Color(0x33000000),
      scrim: Color(0x99000000),
      inverseSurface: Color(0xFF0F172A),
      inversePrimary: Color(0xFFFDBA74),
      primaryFixed: Color(0xFF7C2D12),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF431407),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF9D174D),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF500724),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF155E75),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF083344),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFFCBD5E1),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF1F5F9),
      surfaceContainer: Color(0xFFE2E8F0),
      surfaceContainerHigh: Color(0xFFCBD5E1),
      surfaceContainerHighest: Color(0xFF94A3B8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME - iOS 26 Liquid Glass (Bright on Dark)
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // ───── Primary (Bright Orange on dark) ─────
      primary: Color(0xFFFB923C), // Orange 400 - pops on dark
      onPrimary: Color(0xFF431407), // Orange 950
      primaryContainer: Color(0xFF7C2D12), // Orange 900
      onPrimaryContainer: Color(0xFFFED7AA), // Orange 200
      // ───── Secondary (Vibrant Pink on dark) ─────
      secondary: Color(0xFFF472B6), // Pink 400
      onSecondary: Color(0xFF500724), // Pink 950
      secondaryContainer: Color(0xFF9D174D), // Pink 800
      onSecondaryContainer: Color(0xFFFBCFE8), // Pink 200
      // ───── Tertiary (Bright Cyan on dark) ─────
      tertiary: Color(0xFF22D3EE), // Cyan 400
      onTertiary: Color(0xFF083344), // Cyan 950
      tertiaryContainer: Color(0xFF0E7490), // Cyan 700
      onTertiaryContainer: Color(0xFFCFFAFE), // Cyan 100
      // ───── Error (Bright Red on dark) ─────
      error: Color(0xFFF87171), // Red 400
      onError: Color(0xFF450A0A), // Red 950
      errorContainer: Color(0xFF991B1B), // Red 800
      onErrorContainer: Color(0xFFFECACA), // Red 200
      // ───── Surface (Deep Dark for Glass) ─────
      surface: Color(0xFF0F172A), // Slate 900 - deep base
      onSurface: Color(0xFFF8FAFC), // Slate 50 - crisp text
      onSurfaceVariant: Color(0xFF94A3B8), // Slate 400
      // ───── Outline (Subtle Glass Edges) ─────
      outline: Color(0xFF475569), // Slate 600
      outlineVariant: Color(0xFF334155), // Slate 700
      // ───── System ─────
      shadow: Color(0x40000000), // 25% opacity
      scrim: Color(0x80000000), // 50% opacity
      inverseSurface: Color(0xFFF1F5F9), // Slate 100
      inversePrimary: Color(0xFFEA580C), // Orange 600
      // ───── Fixed Colors (Bright Trio) ─────
      primaryFixed: Color(0xFFFFF7ED),
      onPrimaryFixed: Color(0xFF7C2D12),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFEA580C),
      secondaryFixed: Color(0xFFFDF2F8),
      onSecondaryFixed: Color(0xFF9D174D),
      secondaryFixedDim: Color(0xFFF472B6),
      onSecondaryFixedVariant: Color(0xFFDB2777),
      tertiaryFixed: Color(0xFFECFEFF),
      onTertiaryFixed: Color(0xFF155E75),
      tertiaryFixedDim: Color(0xFF22D3EE),
      onTertiaryFixedVariant: Color(0xFF0891B2),
      // ───── Surface Containers (Liquid Glass Layers) ─────
      surfaceDim: Color(0xFF020617), // Slate 950
      surfaceBright: Color(0xFF334155), // Slate 700
      surfaceContainerLowest: Color(0xFF020617), // Slate 950
      surfaceContainerLow: Color(0xFF0F172A), // Slate 900
      surfaceContainer: Color(0xFF1E293B), // Slate 800 - cards
      surfaceContainerHigh: Color(0xFF334155), // Slate 700
      surfaceContainerHighest: Color(0xFF475569), // Slate 600
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK MEDIUM CONTRAST
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFDBA74), // Orange 300
      onPrimary: Color(0xFF431407),
      primaryContainer: Color(0xFFF97316), // Orange 500
      onPrimaryContainer: Color(0xFF1C0800),
      secondary: Color(0xFFF9A8D4), // Pink 300
      onSecondary: Color(0xFF500724),
      secondaryContainer: Color(0xFFEC4899), // Pink 500
      onSecondaryContainer: Color(0xFF1A0412),
      tertiary: Color(0xFF67E8F9), // Cyan 300
      onTertiary: Color(0xFF083344),
      tertiaryContainer: Color(0xFF06B6D4), // Cyan 500
      onTertiaryContainer: Color(0xFF041F26),
      error: Color(0xFFFCA5A5), // Red 300
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFFEF4444), // Red 500
      onErrorContainer: Color(0xFF1A0000),
      surface: Color(0xFF0F172A),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFE2E8F0), // Slate 200
      outline: Color(0xFF94A3B8), // Slate 400
      outlineVariant: Color(0xFF64748B), // Slate 500
      shadow: Color(0x59000000),
      scrim: Color(0x99000000),
      inverseSurface: Color(0xFFF1F5F9),
      inversePrimary: Color(0xFFEA580C),
      primaryFixed: Color(0xFFFFF7ED),
      onPrimaryFixed: Color(0xFF2C0E06),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFC2410C),
      secondaryFixed: Color(0xFFFDF2F8),
      onSecondaryFixed: Color(0xFF2C0412),
      secondaryFixedDim: Color(0xFFF9A8D4),
      onSecondaryFixedVariant: Color(0xFFBE185D),
      tertiaryFixed: Color(0xFFECFEFF),
      onTertiaryFixed: Color(0xFF041F26),
      tertiaryFixedDim: Color(0xFF67E8F9),
      onTertiaryFixedVariant: Color(0xFF0E7490),
      surfaceDim: Color(0xFF020617),
      surfaceBright: Color(0xFF475569),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF0F172A),
      surfaceContainer: Color(0xFF1E293B),
      surfaceContainerHigh: Color(0xFF334155),
      surfaceContainerHighest: Color(0xFF475569),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK HIGH CONTRAST
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFF7ED), // Orange 50
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFFFB923C), // Orange 400
      onPrimaryContainer: Color(0xFF1C0800),
      secondary: Color(0xFFFDF2F8), // Pink 50
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFFF472B6), // Pink 400
      onSecondaryContainer: Color(0xFF1A0412),
      tertiary: Color(0xFFECFEFF), // Cyan 50
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF22D3EE), // Cyan 400
      onTertiaryContainer: Color(0xFF041F26),
      error: Color(0xFFFEF2F2), // Red 50
      onError: Color(0xFF000000),
      errorContainer: Color(0xFFF87171), // Red 400
      onErrorContainer: Color(0xFF0F0000),
      surface: Color(0xFF020617), // Slate 950
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFFFFFFF),
      outline: Color(0xFFF1F5F9), // Slate 100
      outlineVariant: Color(0xFFCBD5E1), // Slate 300
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFF8FAFC),
      inversePrimary: Color(0xFFC2410C),
      primaryFixed: Color(0xFFFFF7ED),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFF2C0E06),
      secondaryFixed: Color(0xFFFDF2F8),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFFBCFE8),
      onSecondaryFixedVariant: Color(0xFF2C0412),
      tertiaryFixed: Color(0xFFECFEFF),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFFA5F3FC),
      onTertiaryFixedVariant: Color(0xFF041F26),
      surfaceDim: Color(0xFF020617),
      surfaceBright: Color(0xFF64748B),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF1E293B),
      surfaceContainer: Color(0xFF334155),
      surfaceContainerHigh: Color(0xFF475569),
      surfaceContainerHighest: Color(0xFF64748B),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    // ───── Input Decoration Theme (iOS 26 Style) ─────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.0),
      ),
      floatingLabelStyle: TextStyle(color: colorScheme.primary),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),
    // ───── Filled Button Theme (iOS 26 Primary Actions) ─────
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, AppSpacing.buttonHeight),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17, // iOS standard
            letterSpacing: 0,
          ),
        ),
      ),
    ),
    // ───── Outlined Button Theme (iOS 26 Secondary Actions) ─────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, AppSpacing.buttonHeight),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: colorScheme.primary, width: 1.0);
          }
          return BorderSide(color: colorScheme.outlineVariant, width: 0.5);
        }),
        foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            letterSpacing: 0,
          ),
        ),
      ),
    ),
    // ───── Text Button Theme (iOS 26 Tertiary Actions) ─────
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(AppSpacing.touchTargetMin, AppSpacing.buttonHeightSmall),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
          ),
        ),
        foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    ),
    // ───── Segmented Button Theme (iOS 26 Sliding Control Style) ─────
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        // Remove icon from selected state
        iconSize: WidgetStateProperty.all(0),
        // iOS-aligned padding
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
        ),
        // Subtle glass-edge border
        side: WidgetStateProperty.all(
          BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
        // iOS rounded corners
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
          ),
        ),
        // Background colors - glass-inspired
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerLow;
        }),
        // Text/icon colors
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        // Text styling
        textStyle: WidgetStateProperty.resolveWith((states) {
          return textTheme.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            fontSize: 13,
          );
        }),
        // iOS minimum touch target
        minimumSize: WidgetStateProperty.all(
          const Size(AppSpacing.touchTargetMin, 32),
        ),
        // No elevation for flat glass look
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
    // ───── Card Theme (iOS 26 Glass-Ready) ─────
    cardTheme: CardTheme(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),
    // ───── AppBar Theme (iOS 26 Style) ─────
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      centerTitle: true,
      titleTextStyle: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 17, // iOS standard
      ),
    ),
    // ───── Bottom Sheet Theme (iOS 26 Modal Style) ─────
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: colorScheme.onSurfaceVariant.withOpacity(0.3),
      dragHandleSize: const Size(36, 5),
    ),
    // ───── Dialog Theme (iOS 26 Alert Style) ─────
    dialogTheme: DialogTheme(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      titleTextStyle: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontSize: 13,
      ),
    ),
    // ───── Switch Theme (iOS Style) ─────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    // ───── Slider Theme (iOS Style) ─────
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
      thumbColor: Colors.white,
      overlayColor: colorScheme.primary.withOpacity(0.12),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
    ),
    // ───── Divider Theme (iOS Separator) ─────
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 0.5,
      space: 0,
    ),
    // ───── List Tile Theme (iOS Settings Style) ─────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontalPadding,
        vertical: AppSpacing.xs,
      ),
      minVerticalPadding: AppSpacing.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      titleTextStyle: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 17,
      ),
      subtitleTextStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontSize: 15,
      ),
    ),
    // ───── Chip Theme (iOS Tag Style) ─────
    chipTheme: ChipThemeData(
      elevation: 0,
      pressElevation: 0,
      backgroundColor: colorScheme.surfaceContainerLow,
      selectedColor: colorScheme.primaryContainer,
      disabledColor: colorScheme.surfaceContainerLow,
      labelStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 13,
      ),
      side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
    ),
    // ───── Icon Theme ─────
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
      size: AppSpacing.iconSize,
    ),
    // ───── Progress Indicator Theme ─────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
    ),
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

// ═══════════════════════════════════════════════════════════════════════════
// APP SPACING - iOS HIG Aligned (4pt/8pt Grid)
// ═══════════════════════════════════════════════════════════════════════════

/// iOS Human Interface Guidelines spacing - 4pt/8pt grid system
class AppSpacing {
  AppSpacing._();

  // ───── Base Spacing Scale (iOS Standard) ─────
  static const double xxs = 4.0; // Minimum unit
  static const double xs = 8.0; // Tight spacing
  static const double sm = 12.0; // Compact spacing
  static const double md = 16.0; // Standard margin (iOS default)
  static const double lg = 20.0; // Comfortable spacing
  static const double xl = 24.0; // Section gaps
  static const double xxl = 32.0; // Large section breaks
  static const double xxxl = 40.0; // Major section separators

  // ───── Page Layout (iOS Safe Area) ─────
  static const double pageHorizontalPadding = 20.0; // iOS standard
  static const double pageVerticalPadding = 20.0;
  static const double sectionSpacing = 35.0; // iOS grouped list section gap

  // ───── Component Dimensions (iOS HIG) ─────
  static const double buttonHeight = 50.0; // iOS standard
  static const double buttonHeightSmall = 36.0; // Compact
  static const double inputHeight = 44.0; // iOS standard row height
  static const double touchTargetMin = 44.0; // iOS minimum touch target

  // ───── Border Radius (iOS Rounded Rectangle) ─────
  static const double cardRadius = 14.0; // iOS card/grouped style
  static const double cardRadiusLarge = 20.0; // Modal corners
  static const double cardRadiusSmall = 10.0; // Chips, small cards
  static const double buttonRadius = 14.0; // iOS button corners
  static const double buttonRadiusPill = 25.0; // Pill-shaped buttons
  static const double inputRadius = 10.0; // Text field corners

  // ───── Icon Sizes (SF Symbol Scale) ─────
  static const double iconSizeSmall = 17.0; // SF Symbol small
  static const double iconSize = 22.0; // SF Symbol default
  static const double iconSizeLarge = 28.0; // SF Symbol large
  static const double iconSizeHero = 44.0; // Hero/app icons

  // ───── Avatar Sizes ─────
  static const double avatarSize = 48.0;
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeLarge = 72.0;

  // ───── Card Sizes ─────
  static const double cardHeightSmall = 140.0;
  static const double cardHeightMedium = 160.0;

  // ───── Edge Insets Helpers ─────
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: pageHorizontalPadding,
    vertical: pageVerticalPadding,
  );

  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(
    horizontal: pageHorizontalPadding,
  );

  // ───── Animation Durations ─────
  static const Duration durationFast = Duration(milliseconds: 100);
  static const Duration durationMedium = Duration(milliseconds: 200);
  static const Duration durationSlow = Duration(milliseconds: 300);
}

// ═══════════════════════════════════════════════════════════════════════════
// FLUX MASCOT COLORS - Solar Orange Theme
// ═══════════════════════════════════════════════════════════════════════════

/// Brand colors for FluxMascot widget - vibrant orange family for energetic look
class FluxColors {
  FluxColors._();

  // ───── Light Theme (Vibrant Solar Orange) ─────
  static const Color lightBack = Color(0xFFFDBA74); // Orange 300 - Outer aura
  static const Color lightMid = Color(0xFFF97316); // Orange 500 - Middle flow
  static const Color lightFront = Color(0xFFEA580C); // Orange 600 - Core center

  // ───── Dark Theme (Warm Orange Glow) ─────
  static const Color darkBack = Color(0xFF7C2D12); // Orange 900 - Outer aura
  static const Color darkMid = Color(0xFFFB923C); // Orange 400 - Middle flow
  static const Color darkFront = Color(0xFFC2410C); // Orange 700 - Core center

  // ───── Shine Effect ─────
  static const Color lightShine = Color(0xFFFFFFFF); // White shine
  static const Color darkShine = Color(0xFFFDBA74); // Orange 300 shine
}

// ═══════════════════════════════════════════════════════════════════════════
// ACTIVITY LEVEL COLORS - Intensity progression
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic colors for activity level categories
/// Cool to warm progression representing increasing physical intensity
class ActivityColors {
  ActivityColors._();

  /// Desk Bound - Indigo (calm, focused work)
  static const Color deskBound = Color(0xFF5C6BC0);

  /// Lightly Active - Teal (balanced, moderate)
  static const Color lightlyActive = Color(0xFF26A69A);

  /// Active Lifestyle - Deep Orange (energetic, busy)
  static const Color activeLifestyle = Color(0xFFFF8A65);

  /// Very Active - Red (high intensity, power)
  static const Color veryActive = Color(0xFFEF5350);
}

// ═══════════════════════════════════════════════════════════════════════════
// DIETARY IDENTITY COLORS - Food philosophy
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic colors for dietary identity categories
class DietColors {
  DietColors._();

  /// Vegan - Green (plant-based purity)
  static const Color vegan = Color(0xFF4CAF50);

  /// Vegetarian - Light Green (plant-forward)
  static const Color vegetarian = Color(0xFF8BC34A);

  /// Eggetarian - Orange (warmth, eggs)
  static const Color eggetarian = Color(0xFFFF9800);

  /// Omnivore - Pink (flexibility, variety)
  static const Color omnivore = Color(0xFFE91E63);

  /// Veg days indicator
  static const Color vegDay = Color(0xFF4CAF50);
}

// ═══════════════════════════════════════════════════════════════════════════
// HEALTH GOAL COLORS - Motivation themes
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic colors for health goal categories
class GoalColors {
  GoalColors._();

  /// Lose Weight - Blue (calm, trust, control)
  static const Color loseWeight = Color(0xFF42A5F5);

  /// Build Muscle - Red (power, strength)
  static const Color buildMuscle = Color(0xFFEF5350);

  /// Improve Sleep - Indigo (night, tranquility)
  static const Color improveSleep = Color(0xFF5C6BC0);

  /// Manage Stress - Teal (calm, balance)
  static const Color manageStress = Color(0xFF26A69A);

  /// Boost Stamina - Orange (energy, vitality)
  static const Color boostStamina = Color(0xFFFF9800);

  /// Maintain Weight - Green (stability, balance)
  static const Color maintainWeight = Color(0xFF66BB6A);

  /// Gain Weight - Purple (growth, abundance)
  static const Color gainWeight = Color(0xFFAB47BC);
}

// ═══════════════════════════════════════════════════════════════════════════
// COACHING STYLE COLORS - Personality themes
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic colors for AI coach personality styles
class CoachColors {
  CoachColors._();

  /// Supportive Friend - Warm Pink (nurturing, caring)
  static const Color supportiveFriend = Color(0xFFEC407A);

  /// Tough Coach - Deep Red (intensity, discipline)
  static const Color toughCoach = Color(0xFFD32F2F);

  /// Calm Mentor - Sage Green (wisdom, patience)
  static const Color calmMentor = Color(0xFF66BB6A);

  /// Energetic Hype - Bright Orange (energy, excitement)
  static const Color energeticHype = Color(0xFFFF9800);

  /// Data Analyst - Cool Blue (logic, precision)
  static const Color dataAnalyst = Color(0xFF42A5F5);

  /// Mindful Guide - Soft Purple (spirituality, balance)
  static const Color mindfulGuide = Color(0xFF9575CD);
}

// ═══════════════════════════════════════════════════════════════════════════
// BRAND & INTEGRATION COLORS - Third-party services
// ═══════════════════════════════════════════════════════════════════════════

/// Brand colors for external service integrations
class BrandColors {
  BrandColors._();

  // ───── Health App Icons ─────
  /// Apple Health pink/red
  static const Color appleHealth = Color(0xFFFF2D55);

  /// Google Health Connect blue
  static const Color healthConnect = Color(0xFF4285F4);

  // ───── Google Brand Colors ─────
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);
}

// ═══════════════════════════════════════════════════════════════════════════
// LIQUID GLASS - iOS 26 Glass Material Constants
// ═══════════════════════════════════════════════════════════════════════════

/// Constants for implementing iOS 26 Liquid Glass design language
class LiquidGlass {
  LiquidGlass._();

  // ───── Blur Values ─────
  static const double blurLight = 15.0; // Subtle glass
  static const double blurMedium = 20.0; // Standard glass
  static const double blurHeavy = 30.0; // Modal/sheet glass

  // ───── Opacity Values ─────
  static const double opacityLight = 0.7; // Light mode glass tint
  static const double opacityDark = 0.3; // Dark mode glass tint
  static const double opacitySheet = 0.85; // Modal sheet

  // ───── Border Width ─────
  static const double borderWidth = 0.5; // Glass edge refraction
  static const double borderWidthThick = 1.0;

  // ───── Shadow ─────
  static const double shadowBlur = 20.0;
  static const double shadowOpacity = 0.08;
  static const Offset shadowOffset = Offset(0, 8);
}
