import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

/// Configuration for a measurement unit in the ruler picker.
class RulerUnit {
  const RulerUnit({
    required this.label,
    required this.minValue,
    required this.maxValue,
    required this.defaultValue,
    this.precision = 1,
    this.majorTickInterval = 10.0,
    this.minorTickInterval = 1.0,
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

  /// Decimal precision (1 = 0.1, 0 = whole numbers).
  final int precision;

  /// Interval for major tick marks with labels.
  final double majorTickInterval;

  /// Interval for medium tick marks.
  final double minorTickInterval;

  /// Custom formatter for ruler tick labels. If null, uses default numeric format.
  final String Function(double value)? labelFormatter;
}

/// A reusable horizontal scrollable ruler/scale picker.
/// Used for weight, height, and other numeric measurements.
class HorizontalRulerPicker extends StatefulWidget {
  const HorizontalRulerPicker({
    super.key,
    required this.value,
    required this.unit,
    required this.onChanged,
    this.displayFormatter,
  });

  /// Current value.
  final double value;

  /// Unit configuration.
  final RulerUnit unit;

  /// Called when value changes.
  final ValueChanged<double> onChanged;

  /// Custom formatter for the large display. If null, uses default.
  final String Function(double value)? displayFormatter;

  @override
  State<HorizontalRulerPicker> createState() => _HorizontalRulerPickerState();
}

class _HorizontalRulerPickerState extends State<HorizontalRulerPicker> {
  late ScrollController _scrollController;
  late double _currentValue;

  // Pixels per smallest unit (0.1 for precision=1, 1.0 for precision=0)
  static const double _tickSpacing = 8.0;

  double get _multiplier => widget.unit.precision == 0 ? 1.0 : 10.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value.clamp(
      widget.unit.minValue,
      widget.unit.maxValue,
    );
    _scrollController = ScrollController(
      initialScrollOffset: _valueToOffset(_currentValue),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(HorizontalRulerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle unit changes (e.g., kg to lbs conversion)
    if (oldWidget.unit.label != widget.unit.label) {
      _currentValue = widget.value.clamp(
        widget.unit.minValue,
        widget.unit.maxValue,
      );
      _scrollController.removeListener(_onScroll);
      _scrollController.jumpTo(_valueToOffset(_currentValue));
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  double _valueToOffset(double value) {
    return (value - widget.unit.minValue) * _tickSpacing * _multiplier;
  }

  double _offsetToValue(double offset) {
    final rawValue =
        (offset / (_tickSpacing * _multiplier)) + widget.unit.minValue;
    if (widget.unit.precision == 0) {
      return rawValue.roundToDouble();
    }
    return (rawValue * _multiplier).round() / _multiplier;
  }

  void _onScroll() {
    final newValue = _offsetToValue(
      _scrollController.offset,
    ).clamp(widget.unit.minValue, widget.unit.maxValue);
    if (newValue != _currentValue) {
      HapticFeedback.selectionClick();
      setState(() => _currentValue = newValue);
      widget.onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final totalTicks =
        ((widget.unit.maxValue - widget.unit.minValue) * _multiplier).toInt();
    final totalWidth = totalTicks * _tickSpacing;
    final sidePadding = screenWidth / 2;

    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Scrollable ruler
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                // Snap to nearest value
                final targetOffset = _valueToOffset(_currentValue);
                if ((_scrollController.offset - targetOffset).abs() > 0.5) {
                  _scrollController.animateTo(
                    targetOffset,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                  );
                }
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                child: CustomPaint(
                  size: Size(totalWidth, 80),
                  painter: _RulerPainter(
                    minValue: widget.unit.minValue,
                    maxValue: widget.unit.maxValue,
                    tickSpacing: _tickSpacing,
                    multiplier: _multiplier,
                    tickColor: colorScheme.outlineVariant,
                    labelColor: colorScheme.onSurfaceVariant,
                    majorTickInterval: widget.unit.majorTickInterval,
                    minorTickInterval: widget.unit.minorTickInterval,
                    precision: widget.unit.precision,
                    labelFormatter: widget.unit.labelFormatter,
                  ),
                ),
              ),
            ),
          ),

          // Center indicator (triangle pointer)
          Positioned(
            top: 0,
            child: CustomPaint(
              size: const Size(20, 12),
              painter: _PointerPainter(color: colorScheme.primary),
            ),
          ),

          // Center line
          Container(
            width: 2,
            height: 50,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),

          // Gradient overlays for fade effect
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surface.withValues(alpha: 0),
                    colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the ruler scale.
class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.tickSpacing,
    required this.multiplier,
    required this.tickColor,
    required this.labelColor,
    required this.majorTickInterval,
    required this.minorTickInterval,
    required this.precision,
    this.labelFormatter,
  });

  final double minValue;
  final double maxValue;
  final double tickSpacing;
  final double multiplier;
  final Color tickColor;
  final Color labelColor;
  final double majorTickInterval;
  final double minorTickInterval;
  final int precision;
  final String Function(double value)? labelFormatter;

  @override
  void paint(Canvas canvas, Size size) {
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final majorTickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final textStyle = TextStyle(
      color: labelColor,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    final totalTicks = ((maxValue - minValue) * multiplier).toInt();

    for (int i = 0; i <= totalTicks; i++) {
      final value = minValue + (i / multiplier);
      final x = i * tickSpacing;

      final isMajorTick = (value % majorTickInterval).abs() < 0.01;
      final isMinorTick = (value % minorTickInterval).abs() < 0.01;

      double tickHeight;
      Paint paint;

      if (isMajorTick) {
        tickHeight = 40;
        paint = majorTickPaint;

        // Draw label for major ticks
        String labelText;
        if (labelFormatter != null) {
          labelText = labelFormatter!(value);
        } else {
          // Default formatting - hide .0 for whole numbers
          final isWholeNumber = (value - value.floor()).abs() < 0.01;
          labelText = (precision == 0 || isWholeNumber)
              ? '${value.toInt()}'
              : value.toStringAsFixed(precision);
        }
        final textSpan = TextSpan(text: labelText, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - 20),
        );
      } else if (isMinorTick) {
        tickHeight = 24;
        paint = tickPaint;
      } else {
        tickHeight = 12;
        paint = Paint()
          ..color = tickColor.withValues(alpha: 0.5)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;
      }

      canvas.drawLine(Offset(x, 12), Offset(x, 12 + tickHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) {
    return oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.tickColor != tickColor ||
        oldDelegate.multiplier != multiplier;
  }
}

/// Pointer/indicator triangle.
class _PointerPainter extends CustomPainter {
  _PointerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PointerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// Builds the large value display widget.
class RulerValueDisplay extends StatelessWidget {
  const RulerValueDisplay({
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            formatter!(value),
            style: textTheme.displayLarge?.copyWith(
              fontSize: 72,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              height: 1,
            ),
          ),
        ],
      );
    }

    // Default numeric display with decimal
    final wholePart = value.floor();
    final decimalPart = ((value - wholePart) * 10).round();
    final showDecimal = precision > 0 && decimalPart != 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$wholePart',
          style: textTheme.displayLarge?.copyWith(
            fontSize: 72,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            height: 1,
          ),
        ),
        if (showDecimal) ...[
          Text(
            '.$decimalPart',
            style: textTheme.displayMedium?.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
              height: 1,
            ),
          ),
        ],
        const SizedBox(width: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            unitLabel,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// A toggle button for switching between two units.
class RulerUnitToggle extends StatelessWidget {
  const RulerUnitToggle({
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
