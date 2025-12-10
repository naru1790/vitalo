// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

// LIGHT COLOR SCHEME — Vitalo (Calm & Fresh)
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary, // #00B894
  onPrimary: AppColors.onPrimary, // #FFFFFF
  primaryContainer: AppColors.primaryContainer, // #BDF3E6
  onPrimaryContainer: AppColors.onPrimaryContainer, // #00382D

  secondary: AppColors.secondary, // #006D77
  onSecondary: AppColors.onSecondary, // #FFFFFF
  secondaryContainer: AppColors.secondaryContainer, // #B2EBF2
  onSecondaryContainer: AppColors.onSecondaryContainer, // #002C30

  tertiary: AppColors.info,
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFE3EEFF),
  onTertiaryContainer: Color(0xFF0E2347),

  error: AppColors.error, // #FF6B6B
  onError: Colors.white,
  errorContainer: Color(0xFFFFE7E7),
  onErrorContainer: Color(0xFF5A1A1A),

  background: AppColors.background, // #F6F5F2 (Porcelain)
  onBackground: AppColors.onBackground, // #212121
  surface: AppColors.surface, // #FFFFFF
  onSurface: AppColors.onSurface, // #2B2B2B
  surfaceVariant: AppColors.surfaceVariant, // #E0E0E0
  onSurfaceVariant: AppColors.onSurfaceVariant, // #616161

  outline: AppColors.outline, // #DADADA
  outlineVariant: Color(0xFFBDBDBD),
  shadow: AppColors.shadow, // mint-tinted shadow (alpha)
  scrim: Colors.black54,

  inverseSurface: Color(0xFF10151C),
  onInverseSurface: Color(0xFFE6E9EF),
  inversePrimary: AppColors.primary, // mint
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

// DARK COLOR SCHEME — Vitalo (Calm & Focused)
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.darkPrimary, // #00D8A0
  onPrimary: AppColors.darkOnPrimary, // #00221B
  primaryContainer: Color(0xFF103D36), // deep mint container
  onPrimaryContainer: Colors.white,

  secondary: AppColors.darkSecondary, // #FF9E57 (warm accent)
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF2B2552),
  onSecondaryContainer: Colors.white,

  tertiary: AppColors.info, // info blue
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFF0D2B4A),
  onTertiaryContainer: Color(0xFFE3EEFF),

  error: AppColors.error,
  onError: Colors.white,
  errorContainer: Color(0xFF4B1515),
  onErrorContainer: Color(0xFFFFE7E7),

  background: AppColors.darkBackground, // #121212
  onBackground: AppColors.darkTextPrimary, // #EDEDED
  surface: AppColors.darkSurface, // #1E1E1E
  onSurface: AppColors.darkTextPrimary, // #EDEDED
  surfaceVariant: AppColors.darkSurfaceVariant, // #2A2A2A
  onSurfaceVariant: AppColors.darkTextSecondary, // #B0B0B0

  outline: AppColors.darkOutline, // #3A3A3A
  outlineVariant: Color(0xFF2F2F2F),
  shadow: AppColors.darkShadow, // mint aura (alpha)
  scrim: Colors.black54,

  inverseSurface: Color(0xFFEFF3FA),
  onInverseSurface: Color(0xFF12151B),
  inversePrimary: AppColors.darkPrimary,
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
