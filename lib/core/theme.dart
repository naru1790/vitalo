import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

// ═══════════════════════════════════════════════════════════════════════════
// APPLE TEXT STYLES - Pure Cupertino Typography
// Use these in Cupertino screens for consistent iOS HIG typography.
// These are context-independent base styles. Apply color via .copyWith()
//
// Usage:
//   Text('Title', style: AppleTextStyles.largeTitle(context))
//   Text('Body', style: AppleTextStyles.body(context))
// ═══════════════════════════════════════════════════════════════════════════

/// Apple HIG Typography for pure Cupertino screens.
/// All methods return TextStyle with proper color from CupertinoColors.
abstract class AppleTextStyles {
  // ─────────────────────────────────────────────────────────────────────────
  // Primary Text Styles (with CupertinoColors.label)
  // ─────────────────────────────────────────────────────────────────────────

  /// Large Title - 34pt Bold (main screen titles)
  static TextStyle largeTitle(BuildContext context) => TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.37,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Title 1 - 28pt Bold (section headers)
  static TextStyle title1(BuildContext context) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.36,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Title 2 - 22pt Bold (subsection headers)
  static TextStyle title2(BuildContext context) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.35,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Title 3 - 20pt Semibold (smaller headers)
  static TextStyle title3(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Headline - 17pt Semibold (emphasized body text)
  static TextStyle headline(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Body - 17pt Regular (primary content)
  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Callout - 16pt Regular (secondary content)
  static TextStyle callout(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Subhead - 15pt Regular (tertiary content)
  static TextStyle subhead(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Footnote - 13pt Regular (supporting text)
  static TextStyle footnote(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Caption 1 - 12pt Regular (smallest readable text)
  static TextStyle caption1(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Caption 2 - 11pt Regular (micro text)
  static TextStyle caption2(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    color: CupertinoColors.label.resolveFrom(context),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Secondary Text Styles (with CupertinoColors.secondaryLabel)
  // ─────────────────────────────────────────────────────────────────────────

  /// Body Secondary - 17pt Regular (secondary content)
  static TextStyle bodySecondary(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  /// Footnote Secondary - 13pt Regular
  static TextStyle footnoteSecondary(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  /// Caption Secondary - 12pt Regular
  static TextStyle captionSecondary(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );
}

/// Vitalo iOS-first color scheme configuration
/// Provides light/dark color schemes with iOS 26 Liquid Glass design language
class VitaloTheme {
  VitaloTheme._();

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

  /// Lifestyle choices - Teal (balance, wellness)
  static const Color lifestyle = Color(0xFFB2DFDB);
  static const Color lifestyleBorder = Color(0xFF009688);

  /// Allergies - Red tint (caution, medical)
  static const Color allergy = Color(0xFFFFCDD2);
  static const Color allergyBorder = Color(0xFFD32F2F);

  /// Diet goals - Purple tint (aspiration, focus)
  static const Color goal = Color(0xFFE1BEE7);
  static const Color goalBorder = Color(0xFF7B1FA2);
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
