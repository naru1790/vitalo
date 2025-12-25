// @frozen
// Tier-0 adaptive primitive.
// Owns: scroll physics, controller lifecycle, selection mechanics, haptic feedback.
// Must NOT: import design tokens, decide visuals, read AppColorScope/AppText.
// Feature code MUST NOT use CupertinoPicker or ListWheelScrollView directly.

import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter/widgets.dart';

/// Fixed item extent for wheel picker items.
///
/// This value ensures proper touch targets and visual rhythm.
/// It is NOT derived from spacing tokens — touch targets require
/// specific minimum sizes per accessibility guidelines.
const double _kItemExtent = 40.0;

/// Tier-0 platform-adaptive wheel picker.
///
/// The ONLY legal way to render drum/wheel pickers in feature code.
/// Uses [ListWheelScrollView] for constraint-safe scrolling.
///
/// This widget is constraint-safe: it does NOT use [Expanded], [Spacer],
/// [Align], or any other widget that requires bounded parent constraints.
/// It works correctly inside [showCupertinoModalPopup] which provides
/// unbounded constraints during animation.
///
/// ## Tier-0 Responsibilities
/// - Scroll physics and gesture handling
/// - Controller lifecycle management
/// - Selection state and callbacks
/// - Haptic feedback on selection change
///
/// ## Tier-0 Does NOT Own
/// - Colors, gradients, or styling
/// - Text rendering or typography
/// - Selection overlay visuals
/// - Edge fade overlays
///
/// ## Usage
/// ```dart
/// AppWheelPicker<int>(
///   items: List.generate(100, (i) => 1920 + i),
///   selectedIndex: 50,
///   onSelectedItemChanged: (index) => print('Selected: ${items[index]}'),
///   itemBuilder: (context, item, isSelected) => Center(
///     child: Text(item.toString()),
///   ),
///   selectionOverlay: Container(
///     height: 40,
///     decoration: BoxDecoration(...),
///   ),
/// )
/// ```
class AppWheelPicker<T> extends StatefulWidget {
  const AppWheelPicker({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
    required this.itemBuilder,
    this.selectionOverlay,
    this.edgeOverlay,
    this.height = 200.0,
    this.diameterRatio = 2.0,
    this.perspective = 0.003,
    this.enableHaptics = true,
  });

  /// The list of items to display.
  final List<T> items;

  /// The index of the currently selected item.
  final int selectedIndex;

  /// Called when the selected item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// Builds the widget for each item.
  ///
  /// [context] — Build context for the item.
  /// [item] — The item data.
  /// [isSelected] — Whether this item is currently selected.
  ///
  /// Caller owns all visual decisions (text, color, styling).
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;

  /// Optional overlay widget for selection highlight.
  ///
  /// Rendered centered over the wheel at the selection position.
  /// Tier-0 does NOT decide what this looks like.
  /// Pass null to disable selection overlay.
  final Widget? selectionOverlay;

  /// Optional overlay widget for edge fading.
  ///
  /// Rendered over the entire wheel area.
  /// Caller owns gradient/fade visuals.
  /// Pass null to disable edge overlay.
  final Widget? edgeOverlay;

  /// The height of the picker widget.
  /// Default is 200.0 which shows ~5 items.
  final double height;

  /// Diameter ratio for the wheel curvature.
  /// Smaller values = more curved. Default 2.0.
  final double diameterRatio;

  /// Perspective for the 3D effect.
  /// Default 0.003.
  final double perspective;

  /// Whether to trigger haptic feedback on selection change.
  /// Default true.
  final bool enableHaptics;

  @override
  State<AppWheelPicker<T>> createState() => _AppWheelPickerState<T>();
}

class _AppWheelPickerState<T> extends State<AppWheelPicker<T>> {
  late FixedExtentScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    _scrollController = FixedExtentScrollController(
      initialItem: widget.selectedIndex,
    );
  }

  @override
  void didUpdateWidget(AppWheelPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex &&
        widget.selectedIndex != _currentIndex) {
      // Animate to new position if selection changed externally
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateToItem(
            widget.selectedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSelectionChanged(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      if (widget.enableHaptics) {
        HapticFeedback.selectionClick();
      }
      widget.onSelectedItemChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // SizedBox provides explicit height constraint.
    // This is constraint-safe — it provides its own bounds.
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // The wheel itself
          ListWheelScrollView.useDelegate(
            controller: _scrollController,
            itemExtent: _kItemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: widget.diameterRatio,
            perspective: widget.perspective,
            onSelectedItemChanged: _handleSelectionChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.items.length,
              builder: (context, index) {
                if (index < 0 || index >= widget.items.length) {
                  return null;
                }
                final item = widget.items[index];
                final isSelected = index == _currentIndex;

                return SizedBox(
                  height: _kItemExtent,
                  child: widget.itemBuilder(context, item, isSelected),
                );
              },
            ),
          ),

          // Selection overlay (if provided)
          if (widget.selectionOverlay != null)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: SizedBox(
                    height: _kItemExtent,
                    child: widget.selectionOverlay,
                  ),
                ),
              ),
            ),

          // Edge overlay (if provided)
          if (widget.edgeOverlay != null)
            Positioned.fill(child: IgnorePointer(child: widget.edgeOverlay)),
        ],
      ),
    );
  }
}
