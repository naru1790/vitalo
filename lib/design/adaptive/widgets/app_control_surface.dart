// @frozen
// Tier-0 visual primitive.
// Owns: subtle elevated surface for inline controls.
// Must NOT: perform navigation, fetch data, apply semantics.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../../tokens/shape.dart';

/// Subtle elevated surface for inline controls.
///
/// Provides background + padding + shape for controls that need
/// visual separation from their container. Common use case:
/// segmented controls on flat backgrounds that need contrast.
///
/// This is a mechanical wrapper, not a semantic container.
/// Does not imply meaning—only visual treatment.
class AppControlSurface extends StatelessWidget {
  const AppControlSurface({super.key, required this.child});

  /// The control to wrap with elevated surface.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;
    final shape = AppShapeTokens.of;

    // No padding - surface provides only background + shape.
    // Control's intrinsic padding is sufficient.
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(shape.sm),
      ),
      child: child,
    );
  }
}
