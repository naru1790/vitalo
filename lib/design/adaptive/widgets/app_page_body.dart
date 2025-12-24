// @frozen
// Tier-0 canonical page body.
// Owns: semantic padding only.
// Must NOT: own scroll (owned by page archetypes).

import 'package:flutter/widgets.dart';

import '../../tokens/spacing.dart';

enum AppPagePadding { none, compact, standard, spacious }

/// Tier-0 canonical page body.
///
/// Provides semantic padding only. Does NOT own scroll.
/// Scroll ownership belongs to page archetypes.
///
/// This widget is constraint-neutral: it accepts finite constraints
/// from its parent and preserves them unchanged.
class AppPageBody extends StatelessWidget {
  const AppPageBody({
    super.key,
    required this.child,
    this.padding = AppPagePadding.standard,
  });

  final Widget child;
  final AppPagePadding padding;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    final resolvedPadding = switch (padding) {
      AppPagePadding.none => EdgeInsets.zero,
      AppPagePadding.compact => EdgeInsets.all(spacing.md),
      AppPagePadding.standard => EdgeInsets.all(spacing.lg),
      AppPagePadding.spacious => EdgeInsets.all(spacing.xl),
    };

    return Padding(padding: resolvedPadding, child: child);
  }
}
