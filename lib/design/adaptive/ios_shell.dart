import 'package:flutter/cupertino.dart';

import '../tokens/color.dart';
import '../tokens/typography.dart';

/// iOS platform shell.
///
/// Owns all Cupertino visual styling using semantic design tokens.
/// Receives resolved brightness and colors from AdaptiveShell.
class IosShell extends StatelessWidget {
  const IosShell({
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

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: colors.brandPrimary,
        primaryContrastingColor: colors.textInverse,
        scaffoldBackgroundColor: colors.neutralBase,
        barBackgroundColor: colors.neutralBase.withOpacity(0.9),
        textTheme: CupertinoTextThemeData(
          primaryColor: colors.brandPrimary,
          textStyle: typography.body.copyWith(color: colors.textPrimary),
          navTitleTextStyle: typography.title.copyWith(
            color: colors.textPrimary,
          ),
          navLargeTitleTextStyle: typography.display.copyWith(
            color: colors.textPrimary,
          ),
          actionTextStyle: typography.label.copyWith(
            color: colors.brandPrimary,
          ),
        ),
      ),
      home: child,
    );
  }
}
