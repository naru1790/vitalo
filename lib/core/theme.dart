import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════
// VITALO THEME - Soft Minimalistic Design
// Monochromatic palette with warm, desaturated tones
// Philosophy: Calm, approachable, clean
// ═══════════════════════════════════════════════════════════════════════════

/// Creates a text theme using Google Fonts
/// "Smart Companion" pairing - Modern, confident, distinctive
/// Heading: Outfit (SemiBold/Medium) - Geometric precision with warmth
/// Body: Inter (Regular/Medium) - Designed for screens, incredible legibility
TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;

  // Body text: Inter - designed specifically for screen legibility
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );

  // Smart Companion Typography Scale
  // ─────────────────────────────────────────────────────────────────────────
  // UI Element          | Font   | Weight        | Usage
  // ─────────────────────────────────────────────────────────────────────────
  // Main Page Titles    | Outfit | SemiBold (600)| Confident, modern headers
  // Section Headers     | Outfit | SemiBold (600)| "Today's Progress", "Your Goals"
  // Big Data/Stats      | Outfit | SemiBold (600)| Step counts, heart rate
  // Body Text           | Inter  | Regular (400) | Instructions, descriptions
  // Data Labels         | Inter  | Medium (500)  | "Steps", "Calories", "Sleep"
  // Data Values         | Inter  | SemiBold (600)| Actual metric numbers
  // Buttons             | Outfit | SemiBold (600)| Action-oriented CTAs
  // ─────────────────────────────────────────────────────────────────────────

  TextTheme textTheme = TextTheme(
    // Display styles - Outfit SemiBold (w600) for main page titles
    displayLarge: GoogleFonts.outfit(
      fontSize: baseTextTheme.displayLarge?.fontSize,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: GoogleFonts.outfit(
      fontSize: baseTextTheme.displayMedium?.fontSize,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.outfit(
      fontSize: baseTextTheme.displaySmall?.fontSize,
      fontWeight: FontWeight.w600,
    ),
    // Headline styles - Outfit SemiBold (w600) for section headers
    headlineLarge: GoogleFonts.outfit(
      fontSize: baseTextTheme.headlineLarge?.fontSize,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.outfit(
      fontSize: baseTextTheme.headlineMedium?.fontSize,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.outfit(
      fontSize: baseTextTheme.headlineSmall?.fontSize,
      fontWeight: FontWeight.w600,
    ),
    // Title styles - Outfit SemiBold for big stats and subtitles
    titleLarge: GoogleFonts.outfit(
      fontSize: baseTextTheme.titleLarge?.fontSize,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.outfit(
      fontSize: baseTextTheme.titleMedium?.fontSize,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.outfit(
      fontSize: baseTextTheme.titleSmall?.fontSize,
      fontWeight: FontWeight.w500,
    ),
    // Body styles - Inter Regular (w400) for readable content
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    // Label styles - Outfit SemiBold for buttons, Inter for data labels
    labelLarge: GoogleFonts.outfit(
      fontSize: bodyTextTheme.labelLarge?.fontSize,
      fontWeight: FontWeight.w600, // Buttons: confident action
    ),
    labelMedium: bodyTextTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w500, // Data labels: "Steps", "Calories"
    ),
    labelSmall: bodyTextTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w600, // Data values: actual numbers
    ),
  );
  return textTheme;
}

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME - Vibrant Analogous Warm Harmony
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      // ───── Primary (Solar Orange - Vibrant Energy) ─────
      primary: Color(0xFFF97316), // Solar Orange 500 - Bright brand
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFFE5CC), // Bright light orange
      onPrimaryContainer: Color(0xFF7C2D12), // Deep contrast
      // ───── Secondary (Vibrant Coral - Warm Adjacent) ─────
      secondary: Color(0xFFFF5733), // Bright coral red-orange
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFFDAD4), // Bright light coral
      onSecondaryContainer: Color(0xFF8B1F0F), // Deep red-brown
      // ───── Tertiary (Bright Amber - Cool Adjacent) ─────
      tertiary: Color(0xFFFFB627), // Vibrant golden amber
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFFEDC2), // Bright light amber
      onTertiaryContainer: Color(0xFF5C3D00), // Deep amber brown
      // ───── Error (Vibrant Red) ─────
      error: Color(0xFFDC2626), // Bright red
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFE5E5), // Light red
      onErrorContainer: Color(0xFF7F1D1D), // Deep red
      // ───── Surface (Clean White with Subtle Warmth) ─────
      surface: Color(0xFFFFFBF5), // Very light warm white
      onSurface: Color(0xFF1C1B1A), // Near black for contrast
      onSurfaceVariant: Color(0xFF52443D), // Darker warm grey
      // ───── Outline (Clear Borders) ─────
      outline: Color(0xFFA89A8E), // Clear warm outline
      outlineVariant: Color(0xFFD6CEC4), // Light warm outline
      // ───── System ─────
      shadow: Color(0x26000000), // Visible shadow (15% opacity)
      scrim: Color(0x66000000), // Clear scrim (40% opacity)
      inverseSurface: Color(0xFF31302E), // Dark surface
      inversePrimary: Color(0xFFFDBA74), // Orange 300
      // ───── Fixed Colors (Vibrant Analogous) ─────
      primaryFixed: Color(0xFFFFE5CC),
      onPrimaryFixed: Color(0xFF7C2D12),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFEA580C),
      secondaryFixed: Color(0xFFFFDAD4),
      onSecondaryFixed: Color(0xFF8B1F0F),
      secondaryFixedDim: Color(0xFFFFAA99),
      onSecondaryFixedVariant: Color(0xFFCC3D1F),
      tertiaryFixed: Color(0xFFFFEDC2),
      onTertiaryFixed: Color(0xFF5C3D00),
      tertiaryFixedDim: Color(0xFFFFD780),
      onTertiaryFixedVariant: Color(0xFFCC9320),
      // ───── Surface Containers (Clear Elevation) ─────
      surfaceDim: Color(0xFFF0EBE3), // Clear dim
      surfaceBright: Color(0xFFFFFBF5),
      surfaceContainerLowest: Color(0xFFFFFFFF), // Pure white
      surfaceContainerLow: Color(0xFFFFFAF3), // Very light
      surfaceContainer: Color(0xFFFAF4EB), // Light warm
      surfaceContainerHigh: Color(0xFFF0EBE3), // Medium warm
      surfaceContainerHighest: Color(0xFFE6E0D8), // Noticeable warm
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
      secondary: Color(0xFFCC3D1F), // Darker coral - Higher contrast
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFF7A5C), // Brighter coral
      onSecondaryContainer: Color(0xFF5D1609),
      tertiary: Color(0xFFCC9320), // Darker amber - Higher contrast
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFFD780), // Brighter amber
      onTertiaryContainer: Color(0xFF3D2800),
      error: Color(0xFFB91C1C), // Red 700
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFF6B6B), // Bright red
      onErrorContainer: Color(0xFF450A0A),
      surface: Color(0xFFFFFBF5),
      onSurface: Color(0xFF0F0E0D), // Near black - Higher contrast
      onSurfaceVariant: Color(0xFF3D352E), // Darker warm grey
      outline: Color(0xFF6B5D52), // Darker outline
      outlineVariant: Color(0xFFA89A8E), // Clear outline
      shadow: Color(0x33000000), // 20% opacity
      scrim: Color(0x80000000), // 50% opacity
      inverseSurface: Color(0xFF2B2724),
      inversePrimary: Color(0xFFFDBA74),
      primaryFixed: Color(0xFFFFE5CC),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFFFB923C),
      onPrimaryFixedVariant: Color(0xFF4D1F07),
      secondaryFixed: Color(0xFFFFDAD4),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFFF7A5C),
      onSecondaryFixedVariant: Color(0xFF5D1609),
      tertiaryFixed: Color(0xFFFFEDC2),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFFFFCC5C),
      onTertiaryFixedVariant: Color(0xFF3D2800),
      surfaceDim: Color(0xFFE6E0D8),
      surfaceBright: Color(0xFFFFFBF5),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFFFAF3),
      surfaceContainer: Color(0xFFFAF4EB),
      surfaceContainerHigh: Color(0xFFF0EBE3),
      surfaceContainerHighest: Color(0xFFE6E0D8),
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
      primary: Color(0xFFC2410C), // Orange 700 - Maximum contrast
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF7C2D12), // Orange 900
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFF991F0D), // Deep coral - Maximum contrast
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF5D1609), // Very deep coral
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFF996D00), // Deep amber - Maximum contrast
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF5C3D00), // Very deep amber
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFF991B1B), // Red 800
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFF7F1D1D), // Red 900
      onErrorContainer: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF), // Pure white
      onSurface: Color(0xFF000000), // Pure black - Maximum contrast
      onSurfaceVariant: Color(0xFF1C1814), // Near black
      outline: Color(0xFF3D352E), // Very dark outline
      outlineVariant: Color(0xFF52443D), // Dark outline
      shadow: Color(0x4D000000), // 30% opacity
      scrim: Color(0x99000000), // 60% opacity
      inverseSurface: Color(0xFF1A1816),
      inversePrimary: Color(0xFFFDBA74),
      primaryFixed: Color(0xFF7C2D12),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF431407),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF5D1609), // Very deep coral
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF3D0D05), // Deepest coral
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF5C3D00), // Very deep amber
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF3D2600), // Deepest amber
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
  // DARK THEME - Vibrant Analogous Warm Harmony
  // ═══════════════════════════════════════════════════════════════════════════
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // ───── Primary (Bright Orange for dark mode) ─────
      primary: Color(0xFFFB923C), // Bright Orange 400
      onPrimary: Color(0xFF4D1F07), // Deep orange brown
      primaryContainer: Color(0xFFC2410C), // Orange 700
      onPrimaryContainer: Color(0xFFFFE5CC), // Bright light orange
      // ───── Secondary (Vibrant Coral) ─────
      secondary: Color(0xFFFF7A5C), // Bright coral
      onSecondary: Color(0xFF4D1309), // Deep coral
      secondaryContainer: Color(0xFF992B17), // Medium coral
      onSecondaryContainer: Color(0xFFFFDAD4), // Bright light coral
      // ───── Tertiary (Bright Amber) ─────
      tertiary: Color(0xFFFFCC5C), // Bright golden amber
      onTertiary: Color(0xFF3D2800), // Deep amber
      tertiaryContainer: Color(0xFF6B4D00), // Medium amber
      onTertiaryContainer: Color(0xFFFFEDC2), // Bright light amber
      // ───── Error (Vibrant Red) ─────
      error: Color(0xFFFF6B6B), // Bright red
      onError: Color(0xFF5D2020), // Deep red
      errorContainer: Color(0xFF993333), // Medium red
      onErrorContainer: Color(0xFFFFE5E5), // Light red
      // ───── Surface (Deep Dark with Warmth) ─────
      surface: Color(0xFF1A1816), // Deep dark warm
      onSurface: Color(0xFFF0E7DF), // Light warm text
      onSurfaceVariant: Color(0xFFCDBEB3), // Light warm grey
      // ───── Outline (Clear Dark Borders) ─────
      outline: Color(0xFF6B5D52), // Clear warm outline
      outlineVariant: Color(0xFF3D352E), // Dark warm outline
      // ───── System ─────
      shadow: Color(0x40000000), // Visible shadow (25% opacity)
      scrim: Color(0x80000000), // Clear scrim (50% opacity)
      inverseSurface: Color(0xFFF0E7DF), // Light warm
      inversePrimary: Color(0xFFEA580C), // Orange 600
      // ───── Fixed Colors (Vibrant Analogous) ─────
      primaryFixed: Color(0xFFFFE5CC),
      onPrimaryFixed: Color(0xFF7C2D12),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFEA580C),
      secondaryFixed: Color(0xFFFFDAD4),
      onSecondaryFixed: Color(0xFF8B1F0F),
      secondaryFixedDim: Color(0xFFFFAA99),
      onSecondaryFixedVariant: Color(0xFFCC3D1F),
      tertiaryFixed: Color(0xFFFFEDC2),
      onTertiaryFixed: Color(0xFF5C3D00),
      tertiaryFixedDim: Color(0xFFFFD780),
      onTertiaryFixedVariant: Color(0xFFCC9320),
      // ───── Surface Containers (Clear Elevation) ─────
      surfaceDim: Color(0xFF1A1816), // Base dark
      surfaceBright: Color(0xFF3D352E), // Elevated dark
      surfaceContainerLowest: Color(0xFF0F0E0D), // Deep black
      surfaceContainerLow: Color(0xFF221F1D), // Very dark
      surfaceContainer: Color(0xFF2B2724), // Dark warm
      surfaceContainerHigh: Color(0xFF36322E), // Medium dark
      surfaceContainerHighest: Color(0xFF4A4541), // Lighter dark
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
      primary: Color(0xFFFDBA74), // Orange 300 - Brighter for dark mode
      onPrimary: Color(0xFF431407),
      primaryContainer: Color(0xFFF97316), // Orange 500
      onPrimaryContainer: Color(0xFF1C0800),
      secondary: Color(0xFFFFAA99), // Bright coral - Lighter for dark mode
      onSecondary: Color(0xFF3D0D05),
      secondaryContainer: Color(0xFFFF5733), // Bright Coral 500
      onSecondaryContainer: Color(0xFF1A0400),
      tertiary: Color(0xFFFFD780), // Bright amber - Lighter for dark mode
      onTertiary: Color(0xFF3D2600),
      tertiaryContainer: Color(0xFFFFB627), // Vibrant Amber 500
      onTertiaryContainer: Color(0xFF1A1000),
      error: Color(0xFFFCA5A5), // Red 300
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFFEF4444), // Red 500
      onErrorContainer: Color(0xFF1A0000),
      surface: Color(0xFF1A1816),
      onSurface: Color(0xFFFFFFFF), // Pure white for contrast
      onSurfaceVariant: Color(0xFFE0D6CC), // Very light warm
      outline: Color(0xFF8A7B70), // Lighter outline
      outlineVariant: Color(0xFF52443D), // Medium outline
      shadow: Color(0x59000000), // 35% opacity
      scrim: Color(0x99000000), // 60% opacity
      inverseSurface: Color(0xFFF0E7DF),
      inversePrimary: Color(0xFFEA580C),
      primaryFixed: Color(0xFFFFEDD5),
      onPrimaryFixed: Color(0xFF2C0E06),
      primaryFixedDim: Color(0xFFFDBA74),
      onPrimaryFixedVariant: Color(0xFFC2410C),
      secondaryFixed: Color(0xFFFFE5E0), // Very light coral
      onSecondaryFixed: Color(0xFF2C0800),
      secondaryFixedDim: Color(0xFFFFAA99), // Bright coral
      onSecondaryFixedVariant: Color(0xFF991F0D), // Deep coral
      tertiaryFixed: Color(0xFFFFF5D6), // Very light amber
      onTertiaryFixed: Color(0xFF241800),
      tertiaryFixedDim: Color(0xFFFFD780), // Bright amber
      onTertiaryFixedVariant: Color(0xFF996D00), // Deep amber
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
      secondary: Color(0xFFFFE5E0), // Very light coral
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFFFF7A5C), // Light bright coral
      onSecondaryContainer: Color(0xFF1A0400),
      tertiary: Color(0xFFFFF5D6), // Very light amber
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFFCC5C), // Light vibrant amber
      onTertiaryContainer: Color(0xFF1A1000),
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
      secondaryFixed: Color(0xFFFFF0ED), // Lightest coral
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFFFCBB8), // Very bright coral
      onSecondaryFixedVariant: Color(0xFF2C0800),
      tertiaryFixed: Color(0xFFFFFAE5), // Lightest amber
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFFFFE5A8), // Very bright amber
      onTertiaryFixedVariant: Color(0xFF241800),
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
    // ───── Input Decoration Theme ─────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      floatingLabelStyle: TextStyle(color: colorScheme.primary),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
    ),
    // ───── Filled Button Theme (Primary Actions) ─────
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, AppSpacing.buttonHeight),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
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
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
      ),
    ),
    // ───── Outlined Button Theme (Secondary Actions) ─────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, AppSpacing.buttonHeight),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: colorScheme.primary, width: 1.5);
          }
          return BorderSide(color: colorScheme.outline, width: 1.5);
        }),
        foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
      ),
    ),
    // ───── Text Button Theme (Tertiary Actions) ─────
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(48, AppSpacing.buttonHeightSmall),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
        foregroundColor: WidgetStateProperty.all(colorScheme.primary),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    ),
    // ───── Polished SegmentedButton Theme ─────
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        // Remove icon from selected state
        iconSize: WidgetStateProperty.all(0),
        // Compact padding for cleaner look
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        // Visible side borders
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorScheme.outline,
            width: 0,
          );
        }),
        // Rounded corners matching form controls
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          ),
        ),
        // Background colors
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
                : FontWeight.w400,
          );
        }),
        // Minimum touch target
        minimumSize: WidgetStateProperty.all(const Size(48, 36)),
        // No elevation - prevents top border thinning
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
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
  static const double buttonRadius = 28.0; // Pill-shaped (half of buttonHeight)
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
