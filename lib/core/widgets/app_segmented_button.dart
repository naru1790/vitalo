import 'package:flutter/cupertino.dart';

import '../theme.dart';

/// iOS-style sliding segmented control following Apple HIG.
/// Thin wrapper around CupertinoSlidingSegmentedControl.
///
/// Features:
/// - Native iOS pill-shaped sliding thumb animation
/// - Built-in dark/light mode support
/// - iOS 26 Liquid Glass design
class AppSegmentedButton<T extends Object> extends StatelessWidget {
  const AppSegmentedButton({
    super.key,
    required this.children,
    required this.groupValue,
    required this.onValueChanged,
    this.padding,
  });

  /// Map of segment values to their widget labels.
  /// Example: {0: Text('Day'), 1: Text('Week'), 2: Text('Month')}
  final Map<T, Widget> children;

  /// The currently selected value.
  final T groupValue;

  /// Callback when selection changes.
  final ValueChanged<T?> onValueChanged;

  /// Padding around the control. Defaults to iOS standard.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // CupertinoSlidingSegmentedControl handles all styling natively
    return CupertinoSlidingSegmentedControl<T>(
      groupValue: groupValue,
      onValueChanged: onValueChanged,
      padding: padding ?? const EdgeInsets.all(AppSpacing.xxs),
      children: children.map(
        (key, widget) => MapEntry(
          key,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            child: widget,
          ),
        ),
      ),
    );
  }
}
