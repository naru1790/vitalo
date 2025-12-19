import 'package:flutter/material.dart';

import '../tokens/color.dart';
import '../tokens/typography.dart';

/// Android platform shell.
///
/// Owns all Material visual styling using semantic design tokens.
/// Receives resolved brightness and colors from AdaptiveShell.
class AndroidShell extends StatelessWidget {
  const AndroidShell({
    super.key,
    required this.brightness,
    required this.colors,
    required this.child,
  });

  final Brightness brightness;
  final AppColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final typography = AppTextStyles.of;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.brandPrimary,
      onPrimary: colors.textInverse,
      secondary: colors.brandSecondary,
      onSecondary: colors.textInverse,
      error: colors.feedbackError,
      onError: colors.textInverse,
      surface: colors.neutralSurface,
      onSurface: colors.textPrimary,
    );

    final textTheme = TextTheme(
      displayLarge: typography.display.copyWith(color: colors.textPrimary),
      headlineMedium: typography.title.copyWith(color: colors.textPrimary),
      bodyLarge: typography.body.copyWith(color: colors.textPrimary),
      bodyMedium: typography.body.copyWith(color: colors.textSecondary),
      labelLarge: typography.label.copyWith(color: colors.textPrimary),
      bodySmall: typography.caption.copyWith(color: colors.textSecondary),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        brightness: brightness,
        scaffoldBackgroundColor: colors.neutralBase,
        textTheme: textTheme,
        dividerTheme: DividerThemeData(
          color: colors.neutralDivider,
          thickness: 1.0,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colors.neutralSurface,
          foregroundColor: colors.textPrimary,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: colors.neutralDivider),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.neutralDivider),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.brandPrimary, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.feedbackError),
          ),
        ),
      ),
      home: child,
    );
  }
}
