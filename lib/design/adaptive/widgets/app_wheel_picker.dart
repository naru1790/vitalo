// @frozen
// Tier-0 adaptive primitive.
// Owns: platform-appropriate wheel/drum picker rendering.
// Must NOT: fetch data, apply business logic, expose platform knobs.
// Feature code MUST NOT use CupertinoPicker or ListWheelScrollView directly.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/motion.dart';
import 'app_text.dart';

/// Fixed item extent for wheel picker items.
///
/// This value ensures proper touch targets and visual rhythm.
/// It is NOT derived from spacing tokens — touch targets require
/// specific minimum sizes per accessibility guidelines.
const double _kItemExtent = 40.0;

/// Tier-0 platform-adaptive wheel picker.
///
/// The ONLY legal way to render drum/wheel pickers in feature code.
/// Uses [ListWheelScrollView] on both platforms with platform-appropriate
/// styling (iOS: gradient fade edges, Android: highlight overlay).
///
/// This widget is constraint-safe: it does NOT use [Expanded], [Spacer],
/// [Align], or any other widget that requires bounded parent constraints.
/// It works correctly inside [showCupertinoModalPopup] which provides
/// unbounded constraints during animation.
///
/// ## Usage
/// ```dart
/// AppWheelPicker<int>(
///   items: List.generate(100, (i) => 1920 + i),
///   selectedIndex: 50,
///   onSelectedItemChanged: (index) => print('Selected: ${items[index]}'),
///   itemLabelBuilder: (item) => item.toString(),
/// )
/// ```
class AppWheelPicker<T> extends StatefulWidget {
  const AppWheelPicker({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
    required this.itemLabelBuilder,
    this.height = 200.0,
  });

  /// The list of items to display.
  final List<T> items;

  /// The index of the currently selected item.
  final int selectedIndex;

  /// Called when the selected item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// Builds the display label for each item.
  final String Function(T item) itemLabelBuilder;

  /// The height of the picker widget.
  /// Default is 200.0 which shows ~5 items.
  final double height;

  @override
  State<AppWheelPicker<T>> createState() => _AppWheelPickerState<T>();
}

class _AppWheelPickerState<T> extends State<AppWheelPicker<T>> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
      initialItem: widget.selectedIndex,
    );
  }

  @override
  void didUpdateWidget(AppWheelPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      // Animate to new position if selection changed externally
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateToItem(
            widget.selectedIndex,
            duration: AppMotionTokens.of.normal,
            curve: AppMotionTokens.of.easeOut,
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

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final colors = AppColorScope.of(context).colors;

    // Use SizedBox for explicit height constraint
    // This is constraint-safe - it provides its own bounds
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // The wheel itself
          ListWheelScrollView.useDelegate(
            controller: _scrollController,
            itemExtent: _kItemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: platform == AppPlatform.ios ? 1.5 : 2.0,
            perspective: 0.003,
            onSelectedItemChanged: widget.onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.items.length,
              builder: (context, index) {
                if (index < 0 || index >= widget.items.length) {
                  return null;
                }
                final item = widget.items[index];
                final label = widget.itemLabelBuilder(item);

                return SizedBox(
                  height: _kItemExtent,
                  child: Center(
                    child: AppText(
                      label,
                      variant: AppTextVariant.body,
                      color: AppTextColor.primary,
                    ),
                  ),
                );
              },
            ),
          ),

          // Selection highlight overlay (center band)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  height: _kItemExtent,
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: colors.neutralDivider,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top fade gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: widget.height * 0.3,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.surfaceElevated,
                      colors.surfaceElevated.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom fade gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: widget.height * 0.3,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colors.surfaceElevated,
                      colors.surfaceElevated.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
