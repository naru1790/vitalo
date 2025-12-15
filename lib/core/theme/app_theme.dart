// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

// LIGHT COLOR SCHEME — Vitalo Solar Mode
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryContainer,
  onPrimaryContainer: AppColors.onPrimaryContainer,

  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  secondaryContainer: AppColors.secondaryContainer,
  onSecondaryContainer: AppColors.onSecondaryContainer,

  tertiary: AppColors.info,
  onTertiary: AppColors.onPrimary,
  tertiaryContainer: Color(0xFFE3EEFF),
  onTertiaryContainer: Color(0xFF0E2347),

  error: AppColors.error,
  onError: AppColors.onError,
  errorContainer: Color(0xFFFFE7E7),
  onErrorContainer: Color(0xFF5A1A1A),

  background: AppColors.background,
  onBackground: AppColors.onBackground,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  surfaceVariant: AppColors.surfaceVariant,
  onSurfaceVariant: AppColors.onSurfaceVariant,

  outline: AppColors.outline,
  outlineVariant: Color(0xFFC7C7C7),
  shadow: AppColors.shadow,
  scrim: Colors.black54,

  inverseSurface: Color(0xFF1C1917),
  onInverseSurface: Color(0xFFF5F5F4),
  inversePrimary: AppColors.darkPrimary,
  surfaceTint: AppColors.primary,
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: VitaloTypography.lightTextTheme,

  // Soft Minimalist Card: Flat with subtle border
  cardTheme: const CardThemeData(
    elevation: 0, // Flat design preference
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.cardRadius)),
      side: BorderSide(color: AppColors.outline, width: 1),
    ),
    color: AppColors.surface,
  ),

  // Global Button Styling
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      textStyle: VitaloTypography.lightTextTheme.labelLarge,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
      ),
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: 0,
    ),
  ),

  // Modern Navigation Bar (Pill Shape)
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: AppColors.primaryContainer,
    labelTextStyle: MaterialStateProperty.all(
      VitaloTypography.lightTextTheme.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const IconThemeData(color: AppColors.onPrimaryContainer);
      }
      return const IconThemeData(color: AppColors.onSurfaceVariant);
    }),
    elevation: 2,
    shadowColor: AppColors.shadow,
  ),

  // Segmented Button (Gender Selector, etc.)
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        VitaloTypography.lightTextTheme.labelMedium,
      ),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.onPrimary;
        }
        return AppColors.onSurfaceVariant;
      }),
      side: MaterialStateProperty.all(
        const BorderSide(color: AppColors.outline),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
      ),
    ),
  ),

  // Input Fields (Inline Morph Friendly)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.inputRadius,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  ),
);

// DARK COLOR SCHEME — Vitalo Solar Night
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.darkPrimary,
  onPrimary: AppColors.darkOnPrimary,
  primaryContainer: AppColors.darkPrimaryContainer,
  onPrimaryContainer: AppColors.darkOnPrimaryContainer,

  secondary: AppColors.darkSecondary,
  onSecondary: AppColors.darkOnSecondary,
  secondaryContainer: AppColors.darkSecondaryContainer,
  onSecondaryContainer: AppColors.darkOnSecondaryContainer,

  tertiary: AppColors.info,
  onTertiary: AppColors.onPrimary,
  tertiaryContainer: Color(0xFF0D2B4A),
  onTertiaryContainer: Color(0xFFE3EEFF),

  error: AppColors.darkError,
  onError: Color(0xFF5A1A1A),
  errorContainer: Color(0xFF4B1515),
  onErrorContainer: Color(0xFFFFE7E7),

  background: AppColors.darkBackground,
  onBackground: AppColors.darkOnSurface,
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkOnSurface,
  surfaceVariant: AppColors.darkSurfaceVariant,
  onSurfaceVariant: AppColors.darkOnSurfaceVariant,

  outline: AppColors.darkOutline,
  outlineVariant: Color(0xFF3C3836),
  shadow: AppColors.darkShadow,
  scrim: Colors.black54,

  inverseSurface: Color(0xFFF5F5F4),
  onInverseSurface: Color(0xFF1C1917),
  inversePrimary: AppColors.primary,
  surfaceTint: AppColors.darkPrimary,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: AppColors.darkBackground,
  textTheme: VitaloTypography.darkTextTheme,

  cardTheme: const CardThemeData(
    elevation: 0,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.cardRadius)),
      side: BorderSide(color: AppColors.darkOutline, width: 1),
    ),
    color: AppColors.darkSurface,
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      textStyle: VitaloTypography.darkTextTheme.labelLarge,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusSmall),
      ),
      elevation: 0,
    ),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    indicatorColor: AppColors.darkPrimaryContainer,
    labelTextStyle: MaterialStateProperty.all(
      VitaloTypography.darkTextTheme.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const IconThemeData(color: AppColors.darkOnPrimaryContainer);
      }
      return const IconThemeData(color: AppColors.darkOnSurfaceVariant);
    }),
    elevation: 0,
  ),

  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        VitaloTypography.darkTextTheme.labelMedium,
      ),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkPrimary;
        }
        return Colors.transparent;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkOnPrimary;
        }
        return AppColors.darkOnSurfaceVariant;
      }),
      side: MaterialStateProperty.all(
        const BorderSide(color: AppColors.darkOutline),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.inputRadius,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.darkOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.darkOutline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: const BorderSide(color: AppColors.darkError),
    ),
  ),
);

ThemeData getTheme(Brightness brightness) =>
    brightness == Brightness.dark ? darkTheme : lightTheme;
