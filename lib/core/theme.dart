import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════
// VITALO THEME - Generated from Material Theme Builder
// Primary: Solar Orange (#9D4300)
// https://material-foundation.github.io/material-theme-builder/
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

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff9d4300),
      surfaceTint: Color(0xff9d4300),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfff97316),
      onPrimaryContainer: Color(0xff582200),
      secondary: Color(0xff8f4d27),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfffda77a),
      onSecondaryContainer: Color(0xff773a16),
      tertiary: Color(0xff656100),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffb7af1d),
      onTertiaryContainer: Color(0xff454100),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff251913),
      onSurfaceVariant: Color(0xff584237),
      outline: Color(0xff8c7164),
      outlineVariant: Color(0xffe0c0b1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3c2d26),
      inversePrimary: Color(0xffffb690),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff341100),
      primaryFixedDim: Color(0xffffb690),
      onPrimaryFixedVariant: Color(0xff783200),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff341100),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff713612),
      tertiaryFixed: Color(0xfff0e755),
      onTertiaryFixed: Color(0xff1e1c00),
      tertiaryFixedDim: Color(0xffd3cb3b),
      onTertiaryFixedVariant: Color(0xff4c4800),
      surfaceDim: Color(0xffedd5cb),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xffffeae0),
      surfaceContainerHigh: Color(0xfffce3d9),
      surfaceContainerHighest: Color(0xfff6ded3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5e2500),
      surfaceTint: Color(0xff9d4300),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb54e00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5c2603),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa05b34),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3b3700),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff756f00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff1a0f09),
      onSurfaceVariant: Color(0xff463127),
      outline: Color(0xff654d42),
      outlineVariant: Color(0xff81685b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3c2d26),
      inversePrimary: Color(0xffffb690),
      primaryFixed: Color(0xffb54e00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff8e3c00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffa05b34),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff83441e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff756f00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5b5700),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd9c2b8),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1eb),
      surfaceContainer: Color(0xfffce3d9),
      surfaceContainerHigh: Color(0xfff0d8cd),
      surfaceContainerHighest: Color(0xffe4cdc3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4e1e00),
      surfaceTint: Color(0xff9d4300),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7c3300),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4e1e00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff743814),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff302d00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4f4b00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff3b281e),
      outlineVariant: Color(0xff5b4439),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3c2d26),
      inversePrimary: Color(0xffffb690),
      primaryFixed: Color(0xff7c3300),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff582300),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff743814),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff582301),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4f4b00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff373400),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcab4aa),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede6),
      surfaceContainer: Color(0xfff6ded3),
      surfaceContainerHigh: Color(0xffe7d0c5),
      surfaceContainerHighest: Color(0xffd9c2b8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb690),
      surfaceTint: Color(0xffffb690),
      onPrimary: Color(0xff552100),
      primaryContainer: Color(0xfff97316),
      onPrimaryContainer: Color(0xff582200),
      secondary: Color(0xffffb690),
      onSecondary: Color(0xff552100),
      secondaryContainer: Color(0xff743814),
      onSecondaryContainer: Color(0xfff9a477),
      tertiary: Color(0xffd3cb3b),
      onTertiary: Color(0xff343200),
      tertiaryContainer: Color(0xffb7af1d),
      onTertiaryContainer: Color(0xff454100),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1c110b),
      onSurface: Color(0xfff6ded3),
      onSurfaceVariant: Color(0xffe0c0b1),
      outline: Color(0xffa78b7d),
      outlineVariant: Color(0xff584237),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff6ded3),
      inversePrimary: Color(0xff9d4300),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff341100),
      primaryFixedDim: Color(0xffffb690),
      onPrimaryFixedVariant: Color(0xff783200),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff341100),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff713612),
      tertiaryFixed: Color(0xfff0e755),
      onTertiaryFixed: Color(0xff1e1c00),
      tertiaryFixedDim: Color(0xffd3cb3b),
      onTertiaryFixedVariant: Color(0xff4c4800),
      surfaceDim: Color(0xff1c110b),
      surfaceBright: Color(0xff45362f),
      surfaceContainerLowest: Color(0xff160c06),
      surfaceContainerLow: Color(0xff251913),
      surfaceContainer: Color(0xff291d16),
      surfaceContainerHigh: Color(0xff352720),
      surfaceContainerHighest: Color(0xff40322a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd3be),
      surfaceTint: Color(0xffffb690),
      onPrimary: Color(0xff441900),
      primaryContainer: Color(0xfff97316),
      onPrimaryContainer: Color(0xff180500),
      secondary: Color(0xffffd3be),
      onSecondary: Color(0xff441900),
      secondaryContainer: Color(0xffcb7e53),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeae14f),
      onTertiary: Color(0xff292700),
      tertiaryContainer: Color(0xffb7af1d),
      onTertiaryContainer: Color(0xff242100),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1c110b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff7d6c6),
      outline: Color(0xffcaac9d),
      outlineVariant: Color(0xffa78a7d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff6ded3),
      inversePrimary: Color(0xff7a3300),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff230900),
      primaryFixedDim: Color(0xffffb690),
      onPrimaryFixedVariant: Color(0xff5e2500),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff230900),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff5c2603),
      tertiaryFixed: Color(0xfff0e755),
      onTertiaryFixed: Color(0xff131200),
      tertiaryFixedDim: Color(0xffd3cb3b),
      onTertiaryFixedVariant: Color(0xff3b3700),
      surfaceDim: Color(0xff1c110b),
      surfaceBright: Color(0xff51413a),
      surfaceContainerLowest: Color(0xff0f0502),
      surfaceContainerLow: Color(0xff271b14),
      surfaceContainer: Color(0xff32251e),
      surfaceContainerHigh: Color(0xff3e2f28),
      surfaceContainerHighest: Color(0xff4a3a33),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece4),
      surfaceTint: Color(0xffffb690),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb087),
      onPrimaryContainer: Color(0xff1a0600),
      secondary: Color(0xffffece4),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffb087),
      onSecondaryContainer: Color(0xff1a0600),
      tertiary: Color(0xfffef561),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffcfc737),
      onTertiaryContainer: Color(0xff0d0c00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1c110b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece4),
      outlineVariant: Color(0xffdcbcad),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff6ded3),
      inversePrimary: Color(0xff7a3300),
      primaryFixed: Color(0xffffdbca),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb690),
      onPrimaryFixedVariant: Color(0xff230900),
      secondaryFixed: Color(0xffffdbca),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb690),
      onSecondaryFixedVariant: Color(0xff230900),
      tertiaryFixed: Color(0xfff0e755),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd3cb3b),
      onTertiaryFixedVariant: Color(0xff131200),
      surfaceDim: Color(0xff1c110b),
      surfaceBright: Color(0xff5d4d45),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff291d16),
      surfaceContainer: Color(0xff3c2d26),
      surfaceContainerHigh: Color(0xff473831),
      surfaceContainerHighest: Color(0xff53433c),
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
