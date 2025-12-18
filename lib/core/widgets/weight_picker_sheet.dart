import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import 'wheel_picker.dart';

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
  String toString() =>
      '${value.toStringAsFixed(unit == WeightUnit.kg ? 2 : 0)} ${unit.label}';
}

/// A Cupertino-style wheel picker for weight selection.
/// Uses dual wheels for kg (whole kg + grams) and single wheel for lbs.
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
    final effectiveWeight = initialWeight ?? 70.0;

    return showCupertinoModalPopup<WeightResult>(
      context: context,
      barrierDismissible: true,
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
  late WeightUnit _currentUnit;
  late AnimationController _animationController;

  // For kg mode: dual wheels (whole kg + grams)
  late int _wholeKg;
  late int _grams; // 0-99
  late FixedExtentScrollController _kgController;
  late FixedExtentScrollController _gramsController;

  // For lbs mode: single wheel
  late int _lbs;
  late FixedExtentScrollController _lbsController;

  // Ranges
  static const _minKg = 20;
  static const _maxKg = 250;
  static const _minLbs = 44;
  static const _maxLbs = 551;

  double get _currentValueKg => _wholeKg + (_grams / 100);
  double get _currentValueLbs => _lbs.toDouble();
  double get _currentValue =>
      _currentUnit == WeightUnit.kg ? _currentValueKg : _currentValueLbs;

  @override
  void initState() {
    super.initState();
    _currentUnit = widget.initialUnit;

    // Initialize kg values
    final kgValue = widget.initialUnit == WeightUnit.kg
        ? widget.initialWeight
        : widget.initialWeight * 0.453592;
    _wholeKg = kgValue.floor().clamp(_minKg, _maxKg);
    _grams = ((kgValue - _wholeKg) * 100).round().clamp(0, 99);

    // Initialize lbs value
    final lbsValue = widget.initialUnit == WeightUnit.lbs
        ? widget.initialWeight
        : widget.initialWeight * 2.20462;
    _lbs = lbsValue.round().clamp(_minLbs, _maxLbs);

    // Initialize controllers
    _kgController = FixedExtentScrollController(initialItem: _wholeKg - _minKg);
    _gramsController = FixedExtentScrollController(initialItem: _grams);
    _lbsController = FixedExtentScrollController(initialItem: _lbs - _minLbs);

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
    _kgController.dispose();
    _gramsController.dispose();
    _lbsController.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      if (_currentUnit == WeightUnit.kg) {
        // Convert kg to lbs
        _lbs = (_currentValueKg * 2.20462).round().clamp(_minLbs, _maxLbs);
        _lbsController.jumpToItem(_lbs - _minLbs);
        _currentUnit = WeightUnit.lbs;
      } else {
        // Convert lbs to kg
        final kgValue = _lbs * 0.453592;
        _wholeKg = kgValue.floor().clamp(_minKg, _maxKg);
        _grams = ((kgValue - _wholeKg) * 100).round().clamp(0, 99);
        _kgController.jumpToItem(_wholeKg - _minKg);
        _gramsController.jumpToItem(_grams);
        _currentUnit = WeightUnit.kg;
      }
    });
  }

  void _onKgChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _wholeKg = index + _minKg;
      // Keep lbs in sync
      _lbs = (_currentValueKg * 2.20462).round().clamp(_minLbs, _maxLbs);
    });
  }

  void _onGramsChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _grams = index;
      // Keep lbs in sync
      _lbs = (_currentValueKg * 2.20462).round().clamp(_minLbs, _maxLbs);
    });
  }

  void _onLbsChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _lbs = index + _minLbs;
      // Keep kg in sync
      final kgValue = _lbs * 0.453592;
      _wholeKg = kgValue.floor().clamp(_minKg, _maxKg);
      _grams = ((kgValue - _wholeKg) * 100).round().clamp(0, 99);
    });
  }

  void _confirmSelection() {
    widget.onWeightSelected(
      WeightResult(value: _currentValue, unit: _currentUnit),
    );
  }

  String get _displayValue {
    if (_currentUnit == WeightUnit.kg) {
      return '$_wholeKg.${_grams.toString().padLeft(2, '0')} kg';
    }
    return '$_lbs lbs';
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideOffset = Offset(0, 1 - _animationController.value);
        return FractionalTranslation(translation: slideOffset, child: child);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLarge),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.cardRadiusLarge),
              ),
              border: Border(
                top: BorderSide(
                  color: labelColor.withValues(alpha: 0.1),
                  width: LiquidGlass.borderWidth,
                ),
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
                      width: 36,
                      height: 5,
                      decoration: BoxDecoration(
                        color: labelColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.5),
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
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: labelColor,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                'Scroll to set your weight',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: secondaryLabel,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          minSize: 0,
                          onPressed: _confirmSelection,
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Large value display
                  Text(
                    _displayValue,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Unit toggle
                  WheelUnitToggle(
                    options: const ['kg', 'lbs'],
                    selectedIndex: _currentUnit == WeightUnit.kg ? 0 : 1,
                    onChanged: (_) => _toggleUnit(),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Wheel picker - different layout for kg vs lbs
                  SizedBox(
                    height: 220,
                    child: _currentUnit == WeightUnit.kg
                        ? _buildKgPicker()
                        : _buildLbsPicker(),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKgPicker() {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    const arrowSpace = AppSpacing.lg + 12;

    return Column(
      children: [
        // Headers for kg and grams - aligned with wheels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: arrowSpace),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secondaryLabel,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'g',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secondaryLabel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Wheels with arrows
        Expanded(
          child: Stack(
            children: [
              // Kg and grams wheels side by side - with padding for arrows
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: arrowSpace),
                child: Row(
                  children: [
                    // Whole kg wheel
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: _kgController,
                        itemExtent: WheelConstants.itemExtent,
                        physics: const FixedExtentScrollPhysics(),
                        diameterRatio: WheelConstants.diameterRatio,
                        perspective: WheelConstants.perspective,
                        onSelectedItemChanged: _onKgChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _maxKg - _minKg + 1,
                          builder: (context, index) {
                            final kg = index + _minKg;
                            final isSelected = kg == _wholeKg;
                            return Center(
                              child: Text(
                                '$kg',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? primaryColor
                                      : secondaryLabel,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Decimal point indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '.',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    // Grams wheel (00-99)
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: _gramsController,
                        itemExtent: WheelConstants.itemExtent,
                        physics: const FixedExtentScrollPhysics(),
                        diameterRatio: WheelConstants.diameterRatio,
                        perspective: WheelConstants.perspective,
                        onSelectedItemChanged: _onGramsChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 100, // 00-99
                          builder: (context, index) {
                            final isSelected = index == _grams;
                            return Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? primaryColor
                                      : secondaryLabel,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow indicators - outer edges only
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

              // Gradient fades
              const WheelGradientOverlay(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLbsPicker() {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      children: [
        // Spacer to match kg header height
        const SizedBox(height: AppSpacing.xs + 20),

        // Wheel with arrows
        Expanded(
          child: Stack(
            children: [
              // Lbs wheel
              ListWheelScrollView.useDelegate(
                controller: _lbsController,
                itemExtent: WheelConstants.itemExtent,
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: WheelConstants.diameterRatio,
                perspective: WheelConstants.perspective,
                onSelectedItemChanged: _onLbsChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _maxLbs - _minLbs + 1,
                  builder: (context, index) {
                    final lbs = index + _minLbs;
                    final isSelected = lbs == _lbs;
                    return Center(
                      child: Text(
                        '$lbs',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? primaryColor : secondaryLabel,
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

              // Gradient fades
              const WheelGradientOverlay(),
            ],
          ),
        ),
      ],
    );
  }
}
