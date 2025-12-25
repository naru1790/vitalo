// @frozen
// Tier-0 widget.
// Owns: horizontal row layout with leading widget, label widget, trailing widget.
// Must NOT: fetch data, perform navigation, show feedback, impose semantics.

import 'package:flutter/widgets.dart';

import '../../tokens/spacing.dart';

/// Tier-0 labeled row with flexible trailing widget.
///
/// Similar to AppListTile but accepts any trailing widget,
/// not just AppIcon/AppIconButton. Use this when you need
/// to place controls like segmented buttons, switches, etc.
///
/// For simple rows with icons or chevrons, use AppListTile instead.
class AppLabeledRow extends StatelessWidget {
  const AppLabeledRow({
    super.key,
    this.leading,
    required this.label,
    required this.trailing,
  });

  /// Optional leading widget (usually AppIcon).
  final Widget? leading;

  /// Label widget (caller decides typography).
  final Widget label;

  /// Trailing widget (control, text, etc.).
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (leading != null) ...[leading!, SizedBox(width: spacing.md)],
              label,
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}
