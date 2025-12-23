import 'package:flutter/cupertino.dart';

import '../tokens/color.dart';
import '../tokens/opacity.dart';
import '../tokens/typography.dart';
import 'ios_nav_motion_delegate.dart';
import 'nav_motion.dart';
import 'platform/app_platform_scope.dart';

// @frozen
// TIER-0 INFRASTRUCTURE — ACTIVE FREEZE ZONE
//
// Platform shell. Consumes brightness for theme configuration.
// Never exposes brightness to descendants.
//
// What this shell DOES:
// - Receives brightness + colors from AdaptiveShell
// - Configures CupertinoThemeData with brightness
// - Injects AppPlatformScope (ios)
// - Injects NavMotionScope (IosNavMotionDelegate)
//
// What this shell does NOT do:
// - Expose brightness via any scope
// - Allow children to read raw brightness
// - Make policy decisions that should be in tokens

/// iOS platform shell.
///
/// Owns all Cupertino visual styling using semantic design tokens.
/// Receives resolved brightness and colors from AdaptiveShell.
/// Brightness terminates here — only scopes flow to children.
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
    final opacity = AppOpacityTokens.of;

    final theme = CupertinoThemeData(
      brightness: brightness,
      primaryColor: colors.brandPrimary,
      primaryContrastingColor: colors.textInverse,
      scaffoldBackgroundColor: colors.neutralBase,
      barBackgroundColor: colors.neutralBase.withValues(
        alpha: opacity.barBackground,
      ),
      textTheme: CupertinoTextThemeData(
        primaryColor: colors.brandPrimary,
        textStyle: typography.body.copyWith(color: colors.textPrimary),
        navTitleTextStyle: typography.title.copyWith(color: colors.textPrimary),
        navLargeTitleTextStyle: typography.display.copyWith(
          color: colors.textPrimary,
        ),
        actionTextStyle: typography.label.copyWith(color: colors.brandPrimary),
      ),
    );

    return NavMotionScope(
      delegate: const IosNavMotionDelegate(),
      child: AppPlatformScope(
        platform: AppPlatform.ios,
        child: CupertinoTheme(data: theme, child: child),
      ),
    );
  }
}
