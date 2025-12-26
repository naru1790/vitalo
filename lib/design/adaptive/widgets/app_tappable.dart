// @frozen
// Tier-0 adaptive tap control.
// Owns: platform-correct tap feedback + semantics.
// Must NOT: fetch data, perform navigation, show feedback UI.
// Must NOT: impose layout (no padding, constraints, min sizes).

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/motion.dart';

/// Tier-0 adaptive tappable wrapper.
///
/// Use this instead of raw gesture primitives in composites.
/// Provides platform-appropriate interaction feedback and accessibility
/// semantics without imposing layout.
class AppTappable extends StatelessWidget {
  const AppTappable({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.semanticLabel,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final motion = AppMotionTokens.of;

    final opacity = enabled ? 1.0 : 0.38;

    final Widget interactive = switch (platform) {
      AppPlatform.ios => _CupertinoTappable(
        opacity: opacity,
        motion: motion,
        onTap: enabled ? onPressed : null,
        child: child,
      ),
      AppPlatform.android => _MaterialTappable(
        opacity: opacity,
        motion: motion,
        onTap: enabled ? onPressed : null,
        child: child,
      ),
    };

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: interactive,
    );
  }
}

class _MaterialTappable extends StatelessWidget {
  const _MaterialTappable({
    required this.opacity,
    required this.motion,
    required this.onTap,
    required this.child,
  });

  final double opacity;
  final AppMotion motion;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: motion.fast,
          curve: motion.easeOut,
          child: child,
        ),
      ),
    );
  }
}

class _CupertinoTappable extends StatelessWidget {
  const _CupertinoTappable({
    required this.opacity,
    required this.motion,
    required this.onTap,
    required this.child,
  });

  final double opacity;
  final AppMotion motion;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // ignore: deprecated_member_use
      minSize: 0,
      onPressed: onTap,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: motion.fast,
        curve: motion.easeOut,
        child: child,
      ),
    );
  }
}
