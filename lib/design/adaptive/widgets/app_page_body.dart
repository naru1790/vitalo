import 'package:flutter/widgets.dart';

import '../../tokens/spacing.dart';

enum AppPageScroll {
  /// Scroll when content overflows.
  auto,

  /// Always scrollable (even if content fits).
  always,

  /// Fixed layout (no scrolling).
  never,
}

enum AppPagePadding { none, compact, standard, spacious }

/// Tier-0 canonical page body.
///
/// Owns:
/// - Scroll mechanics
/// - Page padding (semantic, token-driven)
/// - Safe default vertical layout container
class AppPageBody extends StatelessWidget {
  const AppPageBody({
    super.key,
    required this.child,
    this.scroll = AppPageScroll.auto,
    this.padding = AppPagePadding.standard,
  });

  final Widget child;
  final AppPageScroll scroll;
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

    final Widget content;
    if (child is Column) {
      content = child;
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [child],
      );
    }

    final padded = Padding(padding: resolvedPadding, child: content);

    return switch (scroll) {
      AppPageScroll.never => padded,
      AppPageScroll.always => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: padded,
      ),
      AppPageScroll.auto => LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: padded,
            ),
          );
        },
      ),
    };
  }
}
