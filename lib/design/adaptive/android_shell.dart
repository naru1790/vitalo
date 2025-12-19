import 'package:flutter/material.dart';

import '../tokens/color.dart';
import '../tokens/elevation.dart';
import '../tokens/shape.dart';
import '../tokens/typography.dart';
import 'android_nav_motion_delegate.dart';
import 'nav_motion.dart';

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
    final shape = AppShapeTokens.of;
    final elevation = AppElevationTokens.of;

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

    final theme = ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: colors.neutralBase,
      textTheme: textTheme,
      dividerTheme: DividerThemeData(
        color: colors.neutralDivider,
        thickness: shape.dividerSubtle,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.neutralSurface,
        foregroundColor: colors.textPrimary,
        elevation: elevation.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.neutralDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.neutralDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.brandPrimary,
            width: shape.strokeVisible,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.feedbackError),
        ),
      ),
    );

    return NavMotionScope(
      delegate: const AndroidNavMotionDelegate(),
      child: Theme(data: theme, child: child),
    );
  }
}
