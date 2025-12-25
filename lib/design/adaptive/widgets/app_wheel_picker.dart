// @frozen
// Tier-0 adaptive primitive.
// Owns: platform-appropriate wheel selection mechanics.
// Uses: ListWheelScrollView, haptic feedback.
// Must NOT: know about years, ages, domain semantics, or interpret colors.

import 'package:flutter/cupertino.dart'
    show CupertinoPicker, FixedExtentScrollPhysics;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter/widgets.dart';

import '../platform/app_platform_scope.dart';

/// Tier-0 wheel picker primitive.
///
/// Provides platform-adaptive wheel selection mechanics.
/// Owns haptic feedback, scroll physics, and controller lifecycle.
///
/// Tier-0 does NOT interpret semantic colors or visual policy.
/// All styling is injected from Tier-1 composites.
///
/// Consumers provide items and receive selection changes.
/// This primitive knows nothing about domain semantics.
class AppWheelPicker<T> extends StatelessWidget {
  const AppWheelPicker({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.itemBuilder,
    this.itemExtent = 50.0,
    this.height = 200.0,
    this.selectionOverlay,
    this.edgeOverlay,
    this.emphasizeSelection = true,
  });

  /// Items to display in the wheel.
  final List<T> items;

  /// Currently selected index.
  final int selectedIndex;

  /// Called when selection changes.
  final ValueChanged<int> onSelectedIndexChanged;

  /// Builds the widget for each item.
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;

  /// Height of each item.
  final double itemExtent;

  /// Total height of the wheel.
  final double height;

  /// Optional overlay widget for selection highlight.
  /// Tier-1 provides semantic styling.
  final Widget? selectionOverlay;

  /// Optional overlay for edge fades.
  /// Tier-1 provides semantic styling.
  final Widget? edgeOverlay;

  /// Whether to emphasize the selected item (magnification on iOS).
  /// Tier-1 decides intent, Tier-0 implements mechanics.
  final bool emphasizeSelection;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    return platform == AppPlatform.ios
        ? _CupertinoWheelPicker<T>(
            items: items,
            selectedIndex: selectedIndex,
            onSelectedIndexChanged: onSelectedIndexChanged,
            itemBuilder: itemBuilder,
            itemExtent: itemExtent,
            height: height,
            selectionOverlay: selectionOverlay,
            edgeOverlay: edgeOverlay,
            emphasizeSelection: emphasizeSelection,
          )
        : _MaterialWheelPicker<T>(
            items: items,
            selectedIndex: selectedIndex,
            onSelectedIndexChanged: onSelectedIndexChanged,
            itemBuilder: itemBuilder,
            itemExtent: itemExtent,
            height: height,
            selectionOverlay: selectionOverlay,
            edgeOverlay: edgeOverlay,
          );
  }
}

class _CupertinoWheelPicker<T> extends StatefulWidget {
  const _CupertinoWheelPicker({
    required this.items,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.itemBuilder,
    required this.itemExtent,
    required this.height,
    required this.selectionOverlay,
    required this.edgeOverlay,
    required this.emphasizeSelection,
  });

  final List<T> items;
  final int selectedIndex;
  final ValueChanged<int> onSelectedIndexChanged;
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;
  final double itemExtent;
  final double height;
  final Widget? selectionOverlay;
  final Widget? edgeOverlay;
  final bool emphasizeSelection;

  @override
  State<_CupertinoWheelPicker<T>> createState() =>
      _CupertinoWheelPickerState<T>();
}

class _CupertinoWheelPickerState<T> extends State<_CupertinoWheelPicker<T>> {
  late FixedExtentScrollController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
  }

  @override
  void didUpdateWidget(covariant _CupertinoWheelPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _currentIndex) {
      _currentIndex = widget.selectedIndex;
      _controller.jumpToItem(_currentIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          CupertinoPicker.builder(
            scrollController: _controller,
            itemExtent: widget.itemExtent,
            diameterRatio: 1.5,
            useMagnifier: widget.emphasizeSelection,
            magnification: widget.emphasizeSelection ? 1.1 : 1.0,
            selectionOverlay:
                widget.selectionOverlay ?? const SizedBox.shrink(),
            onSelectedItemChanged: (index) {
              HapticFeedback.selectionClick();
              _currentIndex = index;
              widget.onSelectedIndexChanged(index);
            },
            childCount: widget.items.length,
            itemBuilder: (context, index) {
              return Center(
                child: widget.itemBuilder(
                  context,
                  widget.items[index],
                  index == _currentIndex,
                ),
              );
            },
          ),
          if (widget.edgeOverlay != null) widget.edgeOverlay!,
        ],
      ),
    );
  }
}

class _MaterialWheelPicker<T> extends StatefulWidget {
  const _MaterialWheelPicker({
    required this.items,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.itemBuilder,
    required this.itemExtent,
    required this.height,
    required this.selectionOverlay,
    required this.edgeOverlay,
  });

  final List<T> items;
  final int selectedIndex;
  final ValueChanged<int> onSelectedIndexChanged;
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;
  final double itemExtent;
  final double height;
  final Widget? selectionOverlay;
  final Widget? edgeOverlay;

  @override
  State<_MaterialWheelPicker<T>> createState() =>
      _MaterialWheelPickerState<T>();
}

class _MaterialWheelPickerState<T> extends State<_MaterialWheelPicker<T>> {
  late FixedExtentScrollController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
  }

  @override
  void didUpdateWidget(covariant _MaterialWheelPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _currentIndex) {
      _currentIndex = widget.selectedIndex;
      _controller.jumpToItem(_currentIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Wheel
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: widget.itemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.5,
            perspective: 0.003,
            onSelectedItemChanged: (index) {
              HapticFeedback.selectionClick();
              _currentIndex = index;
              widget.onSelectedIndexChanged(index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.items.length,
              builder: (context, index) {
                return Center(
                  child: widget.itemBuilder(
                    context,
                    widget.items[index],
                    index == _currentIndex,
                  ),
                );
              },
            ),
          ),

          // Selection highlight (injected from Tier-1)
          if (widget.selectionOverlay != null)
            Center(
              child: IgnorePointer(
                child: SizedBox(
                  height: widget.itemExtent,
                  child: widget.selectionOverlay,
                ),
              ),
            ),

          // Edge overlay (injected from Tier-1)
          if (widget.edgeOverlay != null) widget.edgeOverlay!,
        ],
      ),
    );
  }
}
