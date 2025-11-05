import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primarySeed,
  brightness: Brightness.light,
).copyWith(surface: AppColors.surface, onSurface: AppColors.onSurface);

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
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

final ColorScheme darkColorScheme =
    ColorScheme.fromSeed(
      seedColor: AppColors.primarySeed,
      brightness: Brightness.dark,
    ).copyWith(
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkOnPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
