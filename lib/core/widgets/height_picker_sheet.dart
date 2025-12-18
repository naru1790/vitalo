import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import 'wheel_picker.dart';

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

/// A Cupertino-style wheel picker for height selection.
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
    final effectiveHeight = initialHeightCm ?? 170.0;

    return showModalBottomSheet<HeightResult>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
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
  late int _feet;
  late int _inches;
  late double _cm;
  late HeightUnit _currentUnit;
  late AnimationController _animationController;

  late FixedExtentScrollController _feetController;
  late FixedExtentScrollController _inchesController;
  late FixedExtentScrollController _cmController;

  // CM range: 100-250cm
  static const _minCm = 100;
  static const _maxCm = 250;

  // Feet range: 3-8 feet
  static const _minFeet = 3;
  static const _maxFeet = 8;

  @override
  void initState() {
    super.initState();
    _currentUnit = widget.initialUnit;

    // Initialize values
    _cm = widget.initialHeightCm.clamp(_minCm.toDouble(), _maxCm.toDouble());
    final totalInches = _cm / 2.54;
    _feet = (totalInches / 12).floor().clamp(_minFeet, _maxFeet);
    _inches = (totalInches % 12).round().clamp(0, 11);

    // Initialize controllers
    _cmController = FixedExtentScrollController(
      initialItem: _cm.toInt() - _minCm,
    );
    _feetController = FixedExtentScrollController(
      initialItem: _feet - _minFeet,
    );
    _inchesController = FixedExtentScrollController(initialItem: _inches);

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
    _cmController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    if (_currentUnit == HeightUnit.cm) {
      // Sync feet/inches from current cm
      final totalInches = _cm / 2.54;
      _feet = (totalInches / 12).floor().clamp(_minFeet, _maxFeet);
      _inches = (totalInches % 12).round().clamp(0, 11);

      setState(() {
        _currentUnit = HeightUnit.ftIn;
      });

      // Jump after frame renders (controller attached to new widget)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _feetController.jumpToItem(_feet - _minFeet);
        _inchesController.jumpToItem(_inches);
      });
    } else {
      // Sync cm from current feet/inches
      _cm = ((_feet * 12 + _inches) * 2.54).roundToDouble().clamp(
        _minCm.toDouble(),
        _maxCm.toDouble(),
      );

      setState(() {
        _currentUnit = HeightUnit.cm;
      });

      // Jump after frame renders
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cmController.jumpToItem(_cm.toInt() - _minCm);
      });
    }
  }

  void _onCmChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _cm = (index + _minCm).toDouble();
      // Keep feet/inches in sync
      final totalInches = _cm / 2.54;
      _feet = (totalInches / 12).floor().clamp(_minFeet, _maxFeet);
      _inches = (totalInches % 12).round().clamp(0, 11);
    });
  }

  void _onFeetChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _feet = index + _minFeet;
      _cm = ((_feet * 12 + _inches) * 2.54).roundToDouble().clamp(
        _minCm.toDouble(),
        _maxCm.toDouble(),
      );
    });
  }

  void _onInchesChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _inches = index;
      _cm = ((_feet * 12 + _inches) * 2.54).roundToDouble().clamp(
        _minCm.toDouble(),
        _maxCm.toDouble(),
      );
    });
  }

  void _confirmSelection() {
    widget.onHeightSelected(HeightResult(valueCm: _cm, unit: _currentUnit));
  }

  String get _displayValue {
    if (_currentUnit == HeightUnit.cm) {
      return '${_cm.toInt()} cm';
    }
    return "$_feet'$_inches\"";
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
                            'Height',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Scroll to set your height',
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

              const SizedBox(height: AppSpacing.lg),

              // Large value display
              Text(
                _displayValue,
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                  height: 1,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Unit toggle
              WheelUnitToggle(
                options: const ['cm', 'ft/in'],
                selectedIndex: _currentUnit == HeightUnit.cm ? 0 : 1,
                onChanged: (_) => _toggleUnit(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Wheel picker - uniform height container
              SizedBox(
                height: 220,
                child: _currentUnit == HeightUnit.cm
                    ? _buildCmPicker(colorScheme, textTheme)
                    : _buildFeetInchesPicker(colorScheme, textTheme),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCmPicker(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        // Spacer to match ft/in header height
        SizedBox(height: AppSpacing.xs + 20), // labelMedium height + spacing
        // Wheel with arrows
        Expanded(
          child: Stack(
            children: [
              // CM wheel
              ListWheelScrollView.useDelegate(
                controller: _cmController,
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: 1.5,
                perspective: 0.003,
                onSelectedItemChanged: _onCmChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _maxCm - _minCm + 1,
                  builder: (context, index) {
                    final cm = index + _minCm;
                    final isSelected = cm == _cm.toInt();
                    return Center(
                      child: Text(
                        '$cm',
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

              // Gradient fades
              _buildGradientOverlays(colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeetInchesPicker(ColorScheme colorScheme, TextTheme textTheme) {
    // Arrow width + padding for proper centering
    const arrowSpace = AppSpacing.lg + 12;

    return Column(
      children: [
        // Headers for feet and inches - aligned with wheels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: arrowSpace),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Feet',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Inches',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
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
              // Feet and inches wheels side by side - with padding for arrows
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: arrowSpace),
                child: Row(
                  children: [
                    // Feet wheel
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: _feetController,
                        itemExtent: 50,
                        physics: const FixedExtentScrollPhysics(),
                        diameterRatio: 1.5,
                        perspective: 0.003,
                        onSelectedItemChanged: _onFeetChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _maxFeet - _minFeet + 1,
                          builder: (context, index) {
                            final feet = index + _minFeet;
                            final isSelected = feet == _feet;
                            return Center(
                              child: Text(
                                "$feet'",
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
                    ),

                    // Inches wheel
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: _inchesController,
                        itemExtent: 50,
                        physics: const FixedExtentScrollPhysics(),
                        diameterRatio: 1.5,
                        perspective: 0.003,
                        onSelectedItemChanged: _onInchesChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 12, // 0-11 inches
                          builder: (context, index) {
                            final isSelected = index == _inches;
                            return Center(
                              child: Text(
                                '$index"',
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
              _buildGradientOverlays(colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGradientOverlays(ColorScheme colorScheme) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Top gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 60,
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

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
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
        ],
      ),
    );
  }
}
