// @frozen
// Tier-0 layout primitive.
// Owns: standard content insets for children of AppSurface.
// Must NOT: fetch data, navigate, branch on brightness.

import 'package:flutter/widgets.dart';

import '../../tokens/spacing.dart';

enum AppSurfaceBodyPadding { standard }

class AppSurfaceBody extends StatelessWidget {
  const AppSurfaceBody({
    super.key,
    required this.child,
    this.padding = AppSurfaceBodyPadding.standard,
  });

  final Widget child;
  final AppSurfaceBodyPadding padding;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    final double inset = switch (padding) {
      AppSurfaceBodyPadding.standard => spacing.md,
    };

    return Padding(padding: EdgeInsets.all(inset), child: child);
  }
}
