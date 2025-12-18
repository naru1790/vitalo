import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WHEEL PICKER CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

/// Shared constants for wheel pickers across the app.
abstract final class WheelConstants {
  /// Height of each wheel item.
  static const double itemExtent = 50.0;

  /// Diameter ratio for the wheel curvature.
  static const double diameterRatio = 1.5;

  /// Perspective value for 3D effect.
  static const double perspective = 0.003;

  /// Default wheel height.
  static const double defaultHeight = 200.0;

  /// Gradient overlay height at top and bottom.
  static const double gradientHeight = 60.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// WHEEL GRADIENT OVERLAY
// ─────────────────────────────────────────────────────────────────────────────

/// Gradient fades at top and bottom of wheel pickers.
/// Wrapped in IgnorePointer to allow touch pass-through.
class WheelGradientOverlay extends StatelessWidget {
  const WheelGradientOverlay({
    super.key,
    this.height = WheelConstants.gradientHeight,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [surfaceColor, surfaceColor.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [surfaceColor.withValues(alpha: 0), surfaceColor],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET HEADER
// ─────────────────────────────────────────────────────────────────────────────

/// Reusable header for bottom sheets with drag handle, title, subtitle,
/// and optional Done button.
class SheetHeader extends StatelessWidget {
  const SheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onDone,
    this.doneEnabled = true,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onDone;
  final bool doneEnabled;

  @override
  Widget build(BuildContext context) {
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: separatorColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Header content
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: TextStyle(fontSize: 15, color: secondaryLabel),
                      ),
                    ],
                  ],
                ),
              ),
              if (onDone != null)
                CupertinoButton.filled(
                  onPressed: doneEnabled ? onDone : null,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  minSize: 0,
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: doneEnabled
                          ? CupertinoColors.white
                          : CupertinoColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ARROW INDICATOR
// ─────────────────────────────────────────────────────────────────────────────

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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    return CustomPaint(
      size: Size(size, size * 1.5),
      painter: _ArrowPainter(color: primaryColor, direction: direction),
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

// ─────────────────────────────────────────────────────────────────────────────
// WHEEL UNIT CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────

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
    this.height = WheelConstants.defaultHeight,
    this.itemExtent = WheelConstants.itemExtent,
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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Wheel picker
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: widget.itemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: WheelConstants.diameterRatio,
            perspective: WheelConstants.perspective,
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
                    style: TextStyle(
                      fontSize: 28,
                      color: isSelected ? primaryColor : secondaryLabel,
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
          const Positioned(
            left: AppSpacing.lg,
            top: 0,
            bottom: 0,
            child: Center(
              child: WheelArrowIndicator(direction: ArrowDirection.right),
            ),
          ),
          const Positioned(
            right: AppSpacing.lg,
            top: 0,
            bottom: 0,
            child: Center(
              child: WheelArrowIndicator(direction: ArrowDirection.left),
            ),
          ),

          // Gradient fades
          const WheelGradientOverlay(),
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
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    if (formatter != null) {
      // Custom formatted display (e.g., feet'inches")
      return Text(
        formatter!(value),
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w600,
          color: primaryColor,
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
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: primaryColor,
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
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final tertiaryFill = CupertinoColors.tertiarySystemFill.resolveFrom(
      context,
    );
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Container(
      decoration: BoxDecoration(
        color: tertiaryFill,
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
                color: isSelected ? primaryColor : const Color(0x00000000),
                borderRadius: BorderRadius.circular(
                  AppSpacing.buttonRadius - 4,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? CupertinoColors.white : secondaryLabel,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
