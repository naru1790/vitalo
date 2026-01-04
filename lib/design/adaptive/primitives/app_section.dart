// @frozen
// Tier-1 composite primitive.
// Owns: section title rendering, complete vertical rhythm.
// Must NOT: own cards, surfaces, scrolling, page padding.

import 'package:flutter/widgets.dart';

import '../widgets/app_text.dart';
import '../../tokens/spacing.dart';

/// Tier-1 section primitive for grouping content with a titled header.
///
/// Renders a section label and applies consistent vertical rhythm.
/// Used for grouping related content blocks (e.g. Personal Info).
///
/// Scope note:
/// This primitive is introduced first for the Personal Info section.
/// Other sections will be migrated incrementally.
class AppSection extends StatelessWidget {
  const AppSection({super.key, this.title, required this.child});

  /// Section label text.
  final String? title;

  /// Section content (cards, lists, etc.).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final hasTitle = title != null && title!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section top spacing
        SizedBox(height: spacing.xl),

        if (hasTitle) ...[
          // Section label
          AppText(title!, variant: AppTextVariant.label),

          // Space between label and content
          SizedBox(height: spacing.sm),
        ],

        // Section body
        child,
      ],
    );
  }
}
