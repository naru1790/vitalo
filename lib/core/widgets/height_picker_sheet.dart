import 'package:flutter/material.dart';

import '../theme.dart';
import 'horizontal_ruler_picker.dart';

/// Height unit for the picker.
enum HeightUnit {
  cm('cm'),
  ftIn('ft');

  const HeightUnit(this.label);
  final String label;
}

/// Result returned from the height picker.
class HeightResult {
  const HeightResult({required this.valueCm, required this.unit});

  final double valueCm;
  final HeightUnit unit;

  /// Height in cm.
  double get asCm => valueCm;

  /// Height in feet (decimal).
  double get asFeet => valueCm / 30.48;

  /// Formatted feet and inches string (e.g., "5'10"").
  String get asFtIn {
    final totalInches = valueCm / 2.54;
    final feet = (totalInches / 12).floor();
    final inches = (totalInches % 12).round();
    return "$feet'$inches\"";
  }

  @override
  String toString() => unit == HeightUnit.cm ? '${valueCm.toInt()} cm' : asFtIn;
}

/// Unit configurations for height.
const _cmUnit = RulerUnit(
  label: 'cm',
  minValue: 100.0,
  maxValue: 250.0,
  defaultValue: 170.0,
  precision: 0, // whole numbers only
  majorTickInterval: 10.0,
  minorTickInterval: 5.0,
);

/// Formats inches as feet'inches" for ruler labels
String _formatInchesLabel(double inches) {
  final feet = (inches / 12).floor();
  final remainingInches = (inches % 12).round();
  return "$feet'$remainingInches\"";
}

/// Feet ruler - values in inches for precision, displayed as feet'inches"
const _inchesUnit = RulerUnit(
  label: 'in',
  minValue: 39.0, // ~100cm = 39.4 inches
  maxValue: 98.0, // ~250cm = 98.4 inches
  defaultValue: 67.0, // ~170cm = 66.9 inches
  precision: 0,
  majorTickInterval: 6.0, // Every 6 inches (half foot)
  minorTickInterval: 1.0, // Every inch
  labelFormatter: _formatInchesLabel,
);

/// A horizontal scrollable scale for height selection.
class HeightPickerSheet extends StatefulWidget {
  const HeightPickerSheet({
    super.key,
    required this.initialHeightCm,
    required this.initialUnit,
    required this.onHeightSelected,
  });

  final double initialHeightCm;
  final HeightUnit initialUnit;
  final ValueChanged<HeightResult> onHeightSelected;

  /// Shows the height picker as a modal bottom sheet.
  static Future<HeightResult?> show({
    required BuildContext context,
    double? initialHeightCm,
    HeightUnit initialUnit = HeightUnit.cm,
  }) async {
    final effectiveHeight = initialHeightCm ?? _cmUnit.defaultValue;

    return showModalBottomSheet<HeightResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HeightPickerSheet(
        initialHeightCm: effectiveHeight,
        initialUnit: initialUnit,
        onHeightSelected: (result) => Navigator.pop(context, result),
      ),
    );
  }

  @override
  State<HeightPickerSheet> createState() => _HeightPickerSheetState();
}

class _HeightPickerSheetState extends State<HeightPickerSheet>
    with SingleTickerProviderStateMixin {
  double _currentValueCm = 170.0;
  double _currentValueInches = 67.0;
  HeightUnit _currentUnit = HeightUnit.cm;
  AnimationController? _animationController;

  RulerUnit get _unit => _currentUnit == HeightUnit.cm ? _cmUnit : _inchesUnit;

  double get _rulerValue =>
      _currentUnit == HeightUnit.cm ? _currentValueCm : _currentValueInches;

  @override
  void initState() {
    super.initState();
    _currentValueCm = widget.initialHeightCm.clamp(
      _cmUnit.minValue,
      _cmUnit.maxValue,
    );
    _currentValueInches = (_currentValueCm / 2.54).roundToDouble().clamp(
      _inchesUnit.minValue,
      _inchesUnit.maxValue,
    );
    _currentUnit = widget.initialUnit;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController?.forward();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      if (_currentUnit == HeightUnit.cm) {
        // Switching to ft/in - convert cm to inches
        _currentValueInches = (_currentValueCm / 2.54).roundToDouble().clamp(
          _inchesUnit.minValue,
          _inchesUnit.maxValue,
        );
        _currentUnit = HeightUnit.ftIn;
      } else {
        // Switching to cm - convert inches to cm
        _currentValueCm = (_currentValueInches * 2.54).roundToDouble().clamp(
          _cmUnit.minValue,
          _cmUnit.maxValue,
        );
        _currentUnit = HeightUnit.cm;
      }
    });
  }

  void _onRulerChanged(double value) {
    setState(() {
      if (_currentUnit == HeightUnit.cm) {
        _currentValueCm = value;
        _currentValueInches = (value / 2.54).roundToDouble().clamp(
          _inchesUnit.minValue,
          _inchesUnit.maxValue,
        );
      } else {
        _currentValueInches = value;
        _currentValueCm = (value * 2.54).roundToDouble().clamp(
          _cmUnit.minValue,
          _cmUnit.maxValue,
        );
      }
    });
  }

  void _confirmSelection() {
    widget.onHeightSelected(
      HeightResult(valueCm: _currentValueCm, unit: _currentUnit),
    );
  }

  String _formatFeetInches(double inches) {
    final feet = (inches / 12).floor();
    final remainingInches = (inches % 12).round();
    return "$feet'$remainingInches\"";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final controller = _animationController;
    if (controller == null) {
      return _buildContent(colorScheme, textTheme);
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final slideOffset = Offset(0, 1 - controller.value);
        return FractionalTranslation(translation: slideOffset, child: child);
      },
      child: _buildContent(colorScheme, textTheme),
    );
  }

  Widget _buildContent(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with Done button
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
                          'Height',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Slide the scale to set your height',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _confirmSelection,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Large value display - fixed height to prevent layout shifts
            SizedBox(
              height: 80,
              child: _buildHeightDisplay(colorScheme, textTheme),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Unit toggle
            RulerUnitToggle(
              options: const ['cm', 'ft/in'],
              selectedIndex: _currentUnit == HeightUnit.cm ? 0 : 1,
              onChanged: (_) => _toggleUnit(),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Horizontal scale
            HorizontalRulerPicker(
              key: ValueKey(_currentUnit),
              value: _rulerValue,
              unit: _unit,
              onChanged: _onRulerChanged,
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightDisplay(ColorScheme colorScheme, TextTheme textTheme) {
    if (_currentUnit == HeightUnit.ftIn) {
      // Display as feet'inches"
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            _formatFeetInches(_currentValueInches),
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

    // Display as cm (whole number)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '${_currentValueCm.toInt()}',
          style: textTheme.displayLarge?.copyWith(
            fontSize: 72,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            height: 1,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'cm',
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
