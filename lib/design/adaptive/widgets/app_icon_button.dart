import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/motion.dart';
import 'app_icon.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Tier-0 adaptive icon button primitive.
///
/// The only legal way to render interactive icons in feature code.
/// Abstracts platform-specific tap feedback while enforcing accessibility
/// and minimum hit-target requirements.
///
/// Feature code MUST use this instead of:
/// - [IconButton]
/// - [CupertinoButton]
/// - [InkWell] / [InkResponse]
/// - [GestureDetector]
///
/// ## Responsibility Boundaries
///
/// This widget handles:
/// - Icon-only tap interaction
/// - Platform-appropriate feedback (ripple on Android, opacity on iOS)
/// - Minimum 44×44 hit target (accessibility)
/// - Disabled state semantics
///
/// This widget does **NOT** handle:
/// - Labels or text
/// - Custom shapes or decoration
/// - Hover or focus states
/// - Long-press actions
///
/// For visual-only icons, use [AppIcon].
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = AppIconSize.medium,
    this.color = AppIconColor.primary,
    this.semanticLabel,
    this.enabled = true,
  });

  /// Semantic icon identifier.
  final icons.AppIcon icon;

  /// Callback invoked on tap.
  ///
  /// Non-nullable by contract: disabled behavior is controlled solely via
  /// [enabled]. This prevents ambiguous double-disabled states.
  final VoidCallback onPressed;

  /// Semantic size passed to [AppIcon].
  final AppIconSize size;

  /// Semantic color role passed to [AppIcon].
  final AppIconColor color;

  /// Accessibility label for screen readers.
  final String? semanticLabel;

  /// Whether the button is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    if (platform == AppPlatform.ios) {
      return _CupertinoIconButton(
        icon: icon,
        onPressed: onPressed,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
        enabled: enabled,
      );
    }

    return _MaterialIconButton(
      icon: icon,
      onPressed: onPressed,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      enabled: enabled,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE IMPLEMENTATIONS
// ═══════════════════════════════════════════════════════════════════════════

/// Minimum hit target size per WCAG/Apple/Material guidelines.
const double _kMinHitTarget = 44.0;

/// Material implementation with ink ripple feedback.
class _MaterialIconButton extends StatelessWidget {
  const _MaterialIconButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    required this.color,
    required this.semanticLabel,
    required this.enabled,
  });

  final icons.AppIcon icon;
  final VoidCallback onPressed;
  final AppIconSize size;
  final AppIconColor color;
  final String? semanticLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final motion = AppMotionTokens.of;

    // Contract: disabled visual treatment is opacity ONLY.
    // Do NOT also apply AppIconColor.disabled — that would be double-disabled.
    // The icon retains its semantic color; reduced opacity signals disabled state.

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.38,
        duration: motion.fast,
        curve: motion.easeOut,
        child: SizedBox(
          width: _kMinHitTarget,
          height: _kMinHitTarget,
          child: Material(
            type: MaterialType.transparency,
            child: InkResponse(
              onTap: enabled ? onPressed : null,
              containedInkWell: false,
              highlightShape: BoxShape.circle,
              radius: _kMinHitTarget / 2,
              child: Center(
                // semanticLabel: null — parent Semantics owns accessibility.
                child: AppIcon(icon, size: size, color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cupertino implementation with opacity feedback.
class _CupertinoIconButton extends StatelessWidget {
  const _CupertinoIconButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    required this.color,
    required this.semanticLabel,
    required this.enabled,
  });

  final icons.AppIcon icon;
  final VoidCallback onPressed;
  final AppIconSize size;
  final AppIconColor color;
  final String? semanticLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final motion = AppMotionTokens.of;

    // Contract: disabled visual treatment is opacity ONLY.
    // Do NOT also apply AppIconColor.disabled — that would be double-disabled.
    // The icon retains its semantic color; reduced opacity signals disabled state.

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.38,
        duration: motion.fast,
        curve: motion.easeOut,
        child: SizedBox(
          width: _kMinHitTarget,
          height: _kMinHitTarget,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size.square(_kMinHitTarget),
            onPressed: enabled ? onPressed : null,
            child: Center(
              // semanticLabel: null — parent Semantics owns accessibility.
              child: AppIcon(icon, size: size, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
