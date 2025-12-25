// @frozen
// Tier-1 composite primitive.
// Owns: card background color, corner radius, border.
// Must NOT: own padding, elevation, or expose styling knobs.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../../tokens/shape.dart';

/// Semantic surface variants.
///
/// NOTE:
/// New variants require architectural review.
/// Do NOT add visual-only variants.
enum AppSurfaceVariant {
  /// Card surface for grouped content.
  card,
}

/// Tier-1 semantic surface primitive.
///
/// Provides platform-adaptive background, corner radius, and border.
/// Feature code uses this instead of Container, DecoratedBox, or ProfileCard.
class AppSurface extends StatelessWidget {
  const AppSurface({super.key, required this.variant, required this.child});

  /// Surface variant determining semantic treatment.
  final AppSurfaceVariant variant;

  /// Surface content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;
    final shape = AppShapeTokens.of;

    return switch (variant) {
      AppSurfaceVariant.card => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(shape.md),
          border: Border.all(
            color: colors.surfaceBorder,
            width: shape.strokeSubtle,
          ),
        ),
        child: child,
      ),
    };
  }
}
