import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

/// Arrow indicator pointing direction.
enum ArrowDirection { left, right }

/// Arrow indicator widget for wheel pickers.
/// Points to the currently selected value.
class WheelArrowIndicator extends StatelessWidget {
  const WheelArrowIndicator({
    super.key,
    required this.direction,
    this.size = 12,
  });

  final ArrowDirection direction;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CustomPaint(
      size: Size(size, size * 1.5),
      painter: _ArrowPainter(color: colorScheme.primary, direction: direction),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter({required this.color, required this.direction});

  final Color color;
  final ArrowDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (direction == ArrowDirection.right) {
      // Arrow pointing right (>)
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
      path.close();
    } else {
      // Arrow pointing left (<)
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.direction != direction;
}

/// Configuration for a measurement unit in the wheel picker.
class WheelUnit {
  const WheelUnit({
    required this.label,
    required this.minValue,
    required this.maxValue,
    required this.defaultValue,
    this.step = 1.0,
    this.precision = 1,
    this.labelFormatter,
  });

  /// Display label (e.g., "kg", "cm", "lbs").
  final String label;

  /// Minimum selectable value.
  final double minValue;

  /// Maximum selectable value.
  final double maxValue;

  /// Default value when none provided.
  final double defaultValue;

  /// Step increment between values.
  final double step;

  /// Decimal precision (1 = 0.1, 0 = whole numbers).
  final int precision;

  /// Custom formatter for wheel item labels. If null, uses default numeric format.
  final String Function(double value)? labelFormatter;

  /// Total number of items in the wheel.
  int get itemCount => ((maxValue - minValue) / step).round() + 1;

  /// Get value at index.
  double valueAt(int index) {
    final value = minValue + (index * step);
    return double.parse(value.toStringAsFixed(precision));
  }

  /// Get index for value.
  int indexFor(double value) {
    return ((value - minValue) / step).round().clamp(0, itemCount - 1);
  }
}

/// A Cupertino-style wheel picker for numeric values.
/// Uses ListWheelScrollView for smooth, natural scrolling.
class WheelPicker extends StatefulWidget {
  const WheelPicker({
    super.key,
    required this.value,
    required this.unit,
    required this.onChanged,
    this.height = 200,
    this.itemExtent = 50,
  });

  /// Current value.
  final double value;

  /// Unit configuration.
  final WheelUnit unit;

  /// Called when value changes.
  final ValueChanged<double> onChanged;

  /// Height of the picker widget.
  final double height;

  /// Height of each item in the wheel.
  final double itemExtent;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  late FixedExtentScrollController _controller;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value.clamp(
      widget.unit.minValue,
      widget.unit.maxValue,
    );
    _controller = FixedExtentScrollController(
      initialItem: widget.unit.indexFor(_currentValue),
    );
  }

  @override
  void didUpdateWidget(WheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle unit changes (e.g., kg to lbs conversion)
    if (oldWidget.unit.label != widget.unit.label) {
      _currentValue = widget.value.clamp(
        widget.unit.minValue,
        widget.unit.maxValue,
      );
      _controller.jumpToItem(widget.unit.indexFor(_currentValue));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (widget.unit.labelFormatter != null) {
      return widget.unit.labelFormatter!(value);
    }
    if (widget.unit.precision == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(widget.unit.precision);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Wheel picker
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: widget.itemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.5,
            perspective: 0.003,
            onSelectedItemChanged: (index) {
              HapticFeedback.selectionClick();
              final newValue = widget.unit.valueAt(index);
              setState(() => _currentValue = newValue);
              widget.onChanged(newValue);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.unit.itemCount,
              builder: (context, index) {
                final value = widget.unit.valueAt(index);
                final isSelected = (value - _currentValue).abs() < 0.01;
                return Center(
                  child: Text(
                    _formatValue(value),
                    style: textTheme.headlineMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),

          // Arrow indicators on both sides
          Positioned(
            left: AppSpacing.lg,
            top: 0,
            bottom: 0,
            child: Center(
              child: WheelArrowIndicator(direction: ArrowDirection.right),
            ),
          ),
          Positioned(
            right: AppSpacing.lg,
            top: 0,
            bottom: 0,
            child: Center(
              child: WheelArrowIndicator(direction: ArrowDirection.left),
            ),
          ),

          // Gradient fades - IgnorePointer so touch passes through
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: widget.height * 0.3,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.surface,
                      colorScheme.surface.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: widget.height * 0.3,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.surface.withValues(alpha: 0),
                      colorScheme.surface,
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

/// Builds the large value display widget.
class WheelValueDisplay extends StatelessWidget {
  const WheelValueDisplay({
    super.key,
    required this.value,
    required this.unitLabel,
    this.precision = 1,
    this.formatter,
  });

  final double value;
  final String unitLabel;
  final int precision;
  final String Function(double)? formatter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (formatter != null) {
      // Custom formatted display (e.g., feet'inches")
      return Text(
        formatter!(value),
        style: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
          height: 1,
        ),
      );
    }

    // Default numeric display
    String displayText;
    if (precision == 0) {
      displayText = '${value.toInt()} $unitLabel';
    } else {
      final wholePart = value.floor();
      final decimalPart = ((value - wholePart) * 10).round();
      if (decimalPart == 0) {
        displayText = '$wholePart $unitLabel';
      } else {
        displayText = '$wholePart.$decimalPart $unitLabel';
      }
    }

    return Text(
      displayText,
      style: textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
        height: 1,
      ),
    );
  }
}

/// A toggle button for switching between two units.
class WheelUnitToggle extends StatelessWidget {
  const WheelUnitToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                HapticFeedback.mediumImpact();
                onChanged(index);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  AppSpacing.buttonRadius - 4,
                ),
              ),
              child: Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
