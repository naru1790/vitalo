// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_colors.dart';
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
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFE3EEFF),
  onTertiaryContainer: Color(0xFF0E2347),

  error: AppColors.error,
  onError: Colors.white,
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
  cardTheme: const CardThemeData(
    elevation: 2,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      textStyle: VitaloTypography.lightTextTheme.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: 0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface, // light card/surface
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
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
  onTertiary: Colors.white,
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
    elevation: 2,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      textStyle: VitaloTypography.darkTextTheme.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.darkOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.darkOutline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.2),
    ),
  ),
);

ThemeData getTheme(Brightness brightness) =>
    brightness == Brightness.dark ? darkTheme : lightTheme;
