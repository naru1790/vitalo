import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════
// VITALO THEME - Custom Brand Palette
// Primary: Vibrant Orange (#F97316) - Energy, Vitality, Warmth
// Secondary: Sky Blue (#0EA5E9) - Trust, Calm, Clarity
// Tertiary: Green (#22C55E) - Health, Growth, Success
// ═══════════════════════════════════════════════════════════════════════════

/// Creates a text theme using Google Fonts
/// [bodyFont] - Font for body and label styles (Inter)
/// [displayFont] - Font for display, headline, title styles (Manrope)
TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,
    baseTextTheme,
  );
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      // ───── Primary (Vibrant Orange) ─────
      primary: Color(0xFFF97316), // Orange 500 - Main brand
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFEDD5), // Orange 100 - Light container
      onPrimaryContainer: Color(0xFF7C2D12), // Orange 900 - Text on container
      // ───── Secondary (Sky Blue - Complementary) ─────
      secondary: Color(0xFF0EA5E9), // Sky 500 - Trust, calm
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE0F2FE), // Sky 100
      onSecondaryContainer: Color(0xFF0C4A6E), // Sky 900
      // ───── Tertiary (Green - Health) ─────
      tertiary: Color(0xFF22C55E), // Green 500 - Success, health
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFDCFCE7), // Green 100
      onTertiaryContainer: Color(0xFF14532D), // Green 900
      // ───── Error ─────
      error: Color(0xFFDC2626), // Red 600
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE2E2), // Red 100
      onErrorContainer: Color(0xFF7F1D1D), // Red 900
      // ───── Surface (Warm Neutrals) ─────
      surface: Color(0xFFFFFBF7), // Warm white
      onSurface: Color(0xFF1C1917), // Stone 900
      onSurfaceVariant: Color(0xFF57534E), // Stone 600
      // ───── Outline ─────
      outline: Color(0xFFA8A29E), // Stone 400
      outlineVariant: Color(0xFFE7E5E4), // Stone 200
      // ───── System ─────
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF292524), // Stone 800
      inversePrimary: Color(0xFFFDBA74), // Orange 300
      // ───── Fixed Colors ─────
      primaryFixed: Color(0xFFFFEDD5),
      onPrimaryFixed: Color(0xFF431407),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFEA580C),
      secondaryFixed: Color(0xFFE0F2FE),
      onSecondaryFixed: Color(0xFF082F49),
      secondaryFixedDim: Color(0xFF7DD3FC),
      onSecondaryFixedVariant: Color(0xFF0284C7),
      tertiaryFixed: Color(0xFFDCFCE7),
      onTertiaryFixed: Color(0xFF052E16),
      tertiaryFixedDim: Color(0xFF86EFAC),
      onTertiaryFixedVariant: Color(0xFF16A34A),
      // ───── Surface Containers (Elevation) ─────
      surfaceDim: Color(0xFFF5F5F4), // Stone 100
      surfaceBright: Color(0xFFFFFBF7),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFAFAF9), // Stone 50
      surfaceContainer: Color(0xFFF5F5F4), // Stone 100
      surfaceContainerHigh: Color(0xFFE7E5E4), // Stone 200
      surfaceContainerHighest: Color(0xFFD6D3D1), // Stone 300
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
      primary: Color(0xFFEA580C), // Orange 600 - Darker for contrast
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFB923C), // Orange 400
      onPrimaryContainer: Color(0xFF431407),
      secondary: Color(0xFF0284C7), // Sky 600
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF38BDF8), // Sky 400
      onSecondaryContainer: Color(0xFF082F49),
      tertiary: Color(0xFF16A34A), // Green 600
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF4ADE80), // Green 400
      onTertiaryContainer: Color(0xFF052E16),
      error: Color(0xFFB91C1C), // Red 700
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF87171), // Red 400
      onErrorContainer: Color(0xFF450A0A),
      surface: Color(0xFFFFFBF7),
      onSurface: Color(0xFF0C0A09), // Stone 950
      onSurfaceVariant: Color(0xFF44403C), // Stone 700
      outline: Color(0xFF78716C), // Stone 500
      outlineVariant: Color(0xFFA8A29E), // Stone 400
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF292524),
      inversePrimary: Color(0xFFFDBA74),
      primaryFixed: Color(0xFFFB923C),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFFEA580C),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF38BDF8),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF0284C7),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF4ADE80),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF16A34A),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFFE7E5E4),
      surfaceBright: Color(0xFFFFFBF7),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFAFAF9),
      surfaceContainer: Color(0xFFF5F5F4),
      surfaceContainerHigh: Color(0xFFE7E5E4),
      surfaceContainerHighest: Color(0xFFD6D3D1),
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
      secondary: Color(0xFF0369A1), // Sky 700
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF0C4A6E), // Sky 900
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFF15803D), // Green 700
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF14532D), // Green 900
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFF991B1B), // Red 800
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFF7F1D1D), // Red 900
      onErrorContainer: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFBF7),
      onSurface: Color(0xFF000000),
      onSurfaceVariant: Color(0xFF1C1917), // Stone 900
      outline: Color(0xFF44403C), // Stone 700
      outlineVariant: Color(0xFF57534E), // Stone 600
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF292524),
      inversePrimary: Color(0xFFFDBA74),
      primaryFixed: Color(0xFF7C2D12),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF431407),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF0C4A6E),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF082F49),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF14532D),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF052E16),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFFD6D3D1),
      surfaceBright: Color(0xFFFFFBF7),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF5F5F4),
      surfaceContainer: Color(0xFFE7E5E4),
      surfaceContainerHigh: Color(0xFFD6D3D1),
      surfaceContainerHighest: Color(0xFFA8A29E),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // ───── Primary (Orange - Lighter for dark mode) ─────
      primary: Color(0xFFFB923C), // Orange 400
      onPrimary: Color(0xFF431407), // Orange 950
      primaryContainer: Color(0xFFC2410C), // Orange 700
      onPrimaryContainer: Color(0xFFFFEDD5), // Orange 100
      // ───── Secondary (Sky Blue) ─────
      secondary: Color(0xFF38BDF8), // Sky 400
      onSecondary: Color(0xFF082F49), // Sky 950
      secondaryContainer: Color(0xFF0369A1), // Sky 700
      onSecondaryContainer: Color(0xFFE0F2FE), // Sky 100
      // ───── Tertiary (Green) ─────
      tertiary: Color(0xFF4ADE80), // Green 400
      onTertiary: Color(0xFF052E16), // Green 950
      tertiaryContainer: Color(0xFF15803D), // Green 700
      onTertiaryContainer: Color(0xFFDCFCE7), // Green 100
      // ───── Error ─────
      error: Color(0xFFF87171), // Red 400
      onError: Color(0xFF450A0A), // Red 950
      errorContainer: Color(0xFFB91C1C), // Red 700
      onErrorContainer: Color(0xFFFEE2E2), // Red 100
      // ───── Surface (Dark Warm Neutrals) ─────
      surface: Color(0xFF0C0A09), // Stone 950
      onSurface: Color(0xFFFAFAF9), // Stone 50
      onSurfaceVariant: Color(0xFFA8A29E), // Stone 400
      // ───── Outline ─────
      outline: Color(0xFF57534E), // Stone 600
      outlineVariant: Color(0xFF292524), // Stone 800
      // ───── System ─────
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFFAFAF9), // Stone 50
      inversePrimary: Color(0xFFF97316), // Orange 500
      // ───── Fixed Colors ─────
      primaryFixed: Color(0xFFFFEDD5),
      onPrimaryFixed: Color(0xFF431407),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFEA580C),
      secondaryFixed: Color(0xFFE0F2FE),
      onSecondaryFixed: Color(0xFF082F49),
      secondaryFixedDim: Color(0xFF7DD3FC),
      onSecondaryFixedVariant: Color(0xFF0284C7),
      tertiaryFixed: Color(0xFFDCFCE7),
      onTertiaryFixed: Color(0xFF052E16),
      tertiaryFixedDim: Color(0xFF86EFAC),
      onTertiaryFixedVariant: Color(0xFF16A34A),
      // ───── Surface Containers (Elevation) ─────
      surfaceDim: Color(0xFF0C0A09), // Stone 950
      surfaceBright: Color(0xFF292524), // Stone 800
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF1C1917), // Stone 900
      surfaceContainer: Color(0xFF292524), // Stone 800
      surfaceContainerHigh: Color(0xFF44403C), // Stone 700
      surfaceContainerHighest: Color(0xFF57534E), // Stone 600
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
      secondary: Color(0xFF7DD3FC), // Sky 300
      onSecondary: Color(0xFF082F49),
      secondaryContainer: Color(0xFF0EA5E9), // Sky 500
      onSecondaryContainer: Color(0xFF001B2E),
      tertiary: Color(0xFF86EFAC), // Green 300
      onTertiary: Color(0xFF052E16),
      tertiaryContainer: Color(0xFF22C55E), // Green 500
      onTertiaryContainer: Color(0xFF001F0C),
      error: Color(0xFFFCA5A5), // Red 300
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFFEF4444), // Red 500
      onErrorContainer: Color(0xFF1A0000),
      surface: Color(0xFF0C0A09),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFD6D3D1), // Stone 300
      outline: Color(0xFF78716C), // Stone 500
      outlineVariant: Color(0xFF44403C), // Stone 700
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFFAFAF9),
      inversePrimary: Color(0xFFEA580C),
      primaryFixed: Color(0xFFFFEDD5),
      onPrimaryFixed: Color(0xFF2C0E06),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFC2410C),
      secondaryFixed: Color(0xFFE0F2FE),
      onSecondaryFixed: Color(0xFF041E33),
      secondaryFixedDim: Color(0xFF7DD3FC),
      onSecondaryFixedVariant: Color(0xFF0369A1),
      tertiaryFixed: Color(0xFFDCFCE7),
      onTertiaryFixed: Color(0xFF02190A),
      tertiaryFixedDim: Color(0xFF86EFAC),
      onTertiaryFixedVariant: Color(0xFF15803D),
      surfaceDim: Color(0xFF0C0A09),
      surfaceBright: Color(0xFF44403C),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF1C1917),
      surfaceContainer: Color(0xFF292524),
      surfaceContainerHigh: Color(0xFF44403C),
      surfaceContainerHighest: Color(0xFF57534E),
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
      primary: Color(0xFFFFEDD5), // Orange 100
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFFFB923C), // Orange 400
      onPrimaryContainer: Color(0xFF1C0800),
      secondary: Color(0xFFE0F2FE), // Sky 100
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF38BDF8), // Sky 400
      onSecondaryContainer: Color(0xFF001020),
      tertiary: Color(0xFFDCFCE7), // Green 100
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF4ADE80), // Green 400
      onTertiaryContainer: Color(0xFF000F05),
      error: Color(0xFFFEE2E2), // Red 100
      onError: Color(0xFF000000),
      errorContainer: Color(0xFFF87171), // Red 400
      onErrorContainer: Color(0xFF0F0000),
      surface: Color(0xFF0C0A09),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFFFFFFF),
      outline: Color(0xFFE7E5E4), // Stone 200
      outlineVariant: Color(0xFFA8A29E), // Stone 400
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFFAFAF9),
      inversePrimary: Color(0xFFC2410C),
      primaryFixed: Color(0xFFFFEDD5),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFF2C0E06),
      secondaryFixed: Color(0xFFE0F2FE),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFF7DD3FC),
      onSecondaryFixedVariant: Color(0xFF041E33),
      tertiaryFixed: Color(0xFFDCFCE7),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFF86EFAC),
      onTertiaryFixedVariant: Color(0xFF02190A),
      surfaceDim: Color(0xFF0C0A09),
      surfaceBright: Color(0xFF57534E),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF292524),
      surfaceContainer: Color(0xFF44403C),
      surfaceContainerHigh: Color(0xFF57534E),
      surfaceContainerHighest: Color(0xFF78716C),
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
// APP SPACING - Material 3 Spacing Scale
// ═══════════════════════════════════════════════════════════════════════════

/// Material 3 compliant spacing based on 4dp grid system
class AppSpacing {
  AppSpacing._();

  // ───── Base Spacing Scale ─────
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;

  // ───── Page Layout ─────
  static const double pageHorizontalPadding = 24.0;
  static const double pageVerticalPadding = 24.0;
  static const double sectionSpacing = 32.0;

  // ───── Component Dimensions ─────
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 40.0;
  static const double inputHeight = 56.0;
  static const double touchTargetMin = 48.0;

  // ───── Border Radius ─────
  static const double cardRadius = 16.0;
  static const double cardRadiusLarge = 28.0;
  static const double cardRadiusSmall = 12.0;
  static const double buttonRadius = 28.0;
  static const double inputRadius = 12.0;

  // ───── Icon Sizes ─────
  static const double iconSizeSmall = 20.0;
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeHero = 40.0;

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

/// Brand colors for FluxMascot widget - all orange family for cohesive look
class FluxColors {
  FluxColors._();

  // ───── Light Theme ─────
  static const Color lightBack = Color(0xFFFDBA74); // Orange 300 - Outer aura
  static const Color lightMid = Color(0xFFF97316); // Orange 500 - Middle flow
  static const Color lightFront = Color(0xFFEA580C); // Orange 600 - Core center

  // ───── Dark Theme ─────
  static const Color darkBack = Color(0xFF7C2D12); // Orange 900 - Outer aura
  static const Color darkMid = Color(0xFFFB923C); // Orange 400 - Middle flow
  static const Color darkFront = Color(0xFFC2410C); // Orange 700 - Core center

  // ───── Shine Effect ─────
  static const Color lightShine = Color(0xFFFFFFFF); // White shine
  static const Color darkShine = Color(0xFFFDBA74); // Orange 300 shine
}
