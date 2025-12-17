import 'package:flutter/material.dart';

import '../theme.dart';
import 'horizontal_ruler_picker.dart';

/// Weight unit for the picker.
enum WeightUnit {
  kg('kg'),
  lbs('lbs');

  const WeightUnit(this.label);
  final String label;
}

/// Result returned from the weight picker.
class WeightResult {
  const WeightResult({required this.value, required this.unit});

  final double value;
  final WeightUnit unit;

  /// Converts weight to kg regardless of original unit.
  double get asKg => unit == WeightUnit.kg ? value : value * 0.453592;

  /// Converts weight to lbs regardless of original unit.
  double get asLbs => unit == WeightUnit.lbs ? value : value * 2.20462;

  @override
  String toString() => '${value.toStringAsFixed(1)} ${unit.label}';
}

/// Unit configurations for weight.
const _kgUnit = RulerUnit(
  label: 'kg',
  minValue: 20.0,
  maxValue: 250.0,
  defaultValue: 70.0,
  precision: 1,
  majorTickInterval: 1.0,
  minorTickInterval: 0.5,
);

const _lbsUnit = RulerUnit(
  label: 'lbs',
  minValue: 44.0,
  maxValue: 551.0,
  defaultValue: 154.0,
  precision: 1,
  majorTickInterval: 1.0,
  minorTickInterval: 0.5,
);

/// A horizontal scrollable scale for weight selection.
/// Mimics a physical medical scale for intuitive input.
class WeightPickerSheet extends StatefulWidget {
  const WeightPickerSheet({
    super.key,
    required this.initialWeight,
    required this.initialUnit,
    required this.onWeightSelected,
  });

  final double initialWeight;
  final WeightUnit initialUnit;
  final ValueChanged<WeightResult> onWeightSelected;

  /// Shows the weight picker as a modal bottom sheet.
  static Future<WeightResult?> show({
    required BuildContext context,
    double? initialWeight,
    WeightUnit initialUnit = WeightUnit.kg,
  }) async {
    final unit = initialUnit == WeightUnit.kg ? _kgUnit : _lbsUnit;
    final effectiveWeight = initialWeight ?? unit.defaultValue;

    return showModalBottomSheet<WeightResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WeightPickerSheet(
        initialWeight: effectiveWeight,
        initialUnit: initialUnit,
        onWeightSelected: (result) => Navigator.pop(context, result),
      ),
    );
  }

  @override
  State<WeightPickerSheet> createState() => _WeightPickerSheetState();
}

class _WeightPickerSheetState extends State<WeightPickerSheet>
    with SingleTickerProviderStateMixin {
  late double _currentValue;
  late WeightUnit _currentUnit;
  late AnimationController _animationController;

  RulerUnit get _unit => _currentUnit == WeightUnit.kg ? _kgUnit : _lbsUnit;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialWeight;
    _currentUnit = widget.initialUnit;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      if (_currentUnit == WeightUnit.kg) {
        _currentValue = (_currentValue * 2.20462 * 10).round() / 10;
        _currentUnit = WeightUnit.lbs;
      } else {
        _currentValue = (_currentValue * 0.453592 * 10).round() / 10;
        _currentUnit = WeightUnit.kg;
      }
      _currentValue = _currentValue.clamp(_unit.minValue, _unit.maxValue);
    });
  }

  void _confirmSelection() {
    widget.onWeightSelected(
      WeightResult(value: _currentValue, unit: _currentUnit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideOffset = Offset(0, 1 - _animationController.value);
        return FractionalTranslation(translation: slideOffset, child: child);
      },
      child: Container(
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
                            'Weight',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Slide the scale to set your weight',
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

              // Large value display
              RulerValueDisplay(
                value: _currentValue,
                unitLabel: _unit.label,
                precision: _unit.precision,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Unit toggle
              RulerUnitToggle(
                options: const ['kg', 'lbs'],
                selectedIndex: _currentUnit == WeightUnit.kg ? 0 : 1,
                onChanged: (_) => _toggleUnit(),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Horizontal scale
              HorizontalRulerPicker(
                key: ValueKey(_currentUnit),
                value: _currentValue,
                unit: _unit,
                onChanged: (value) => setState(() => _currentValue = value),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
