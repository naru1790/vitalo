import 'package:flutter/material.dart';

/// A reusable segmented button component with consistent styling.
/// Uses inputRadius (12px) for form control aesthetic.
class AppSegmentedButton<T extends Object> extends StatelessWidget {
  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.emptySelectionAllowed = false,
    this.multiSelectionEnabled = false,
  });

  /// The segments to display in the button.
  final List<ButtonSegment<T>> segments;

  /// The currently selected value(s).
  final Set<T> selected;

  /// Callback when selection changes.
  final ValueChanged<Set<T>> onSelectionChanged;

  /// Whether empty selection is allowed.
  final bool emptySelectionAllowed;

  /// Whether multiple segments can be selected.
  final bool multiSelectionEnabled;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      showSelectedIcon: false,
      segments: segments,
      selected: selected,
      emptySelectionAllowed: emptySelectionAllowed,
      multiSelectionEnabled: multiSelectionEnabled,
      onSelectionChanged: onSelectionChanged,
      // Style is handled by theme - just ensure no elevation
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
