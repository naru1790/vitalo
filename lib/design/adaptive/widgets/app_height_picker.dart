// @frozen
// Tier-1 adaptive primitive.
// Owns: platform-appropriate height picking UI + unit conversion.
// Must NOT: open/close modals, call Navigator, fetch data, show feedback UI.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../models/app_unit_system.dart';
import 'app_tappable.dart';
import 'app_text.dart';
import 'app_wheel_picker.dart';
import '../../tokens/spacing.dart';

/// Tier-1 adaptive height picker.
///
/// - Reads [AppPlatformScope] internally for platform-appropriate behavior.
/// - Displays the currently selected value explicitly above the wheels.
/// - Unit system is provided by feature code; this widget does not own or
///   mutate user preferences.
/// - Supports a local, temporary input-unit override by tapping the secondary
///   value; preference remains authoritative.
/// - Emits height in centimeters only.
class AppHeightPicker extends StatefulWidget {
  const AppHeightPicker({
    super.key,
    required this.initialCm,
    required this.unitSystem,
    required this.onChanged,
  });

  final double? initialCm;
  final AppUnitSystem unitSystem;
  final ValueChanged<double> onChanged;

  static const double _kInchesToCm = 2.54;

  // Range is constrained by imperial bounds: 3'0" – 8'11".
  static const int _minCm = 91;
  static const int _maxCm = 272;

  static const int _minFeet = 3;
  static const int _maxFeet = 8;

  static const double _defaultCm = 170.0;

  @override
  State<AppHeightPicker> createState() => _AppHeightPickerState();
}

class _AppHeightPickerState extends State<AppHeightPicker> {
  late double _selectedCm;

  // When in imperial input mode, wheels should be independent.
  // These drive the wheel indices directly.
  int _imperialFeet = AppHeightPicker._minFeet;
  int _imperialInches = 0;
  bool _imperialInitialized = false;

  /// Null = follow preference.
  /// Metric / imperial = temporary input override.
  AppUnitSystem? _inputUnitOverride;

  @override
  void initState() {
    super.initState();
    _selectedCm = _clampCm(widget.initialCm ?? AppHeightPicker._defaultCm);
    _syncImperialFromCm();
  }

  @override
  void didUpdateWidget(covariant AppHeightPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Preference is authoritative. If the preference unit changes upstream,
    // reset any temporary local override.
    if (widget.unitSystem != oldWidget.unitSystem &&
        _inputUnitOverride != null) {
      setState(() => _inputUnitOverride = null);
    }

    // If the caller changes the initial value, treat it as a controlled update.
    if (widget.initialCm != oldWidget.initialCm) {
      final next = _clampCm(widget.initialCm ?? AppHeightPicker._defaultCm);
      if (next != _selectedCm) {
        setState(() {
          _selectedCm = next;
          _syncImperialFromCm();
        });
      }
      return;
    }

    // Ensure our local state stays within bounds.
    final clamped = _clampCm(_selectedCm);
    if (clamped != _selectedCm) {
      setState(() {
        _selectedCm = clamped;
        _syncImperialFromCm();
      });
    }
  }

  double _clampCm(double cm) {
    return cm
        .clamp(
          AppHeightPicker._minCm.toDouble(),
          AppHeightPicker._maxCm.toDouble(),
        )
        .toDouble();
  }

  void _emitCm(double cm) {
    final next = _clampCm(cm);
    setState(() => _selectedCm = next);
    widget.onChanged(next);
  }

  AppUnitSystem get _effectiveInputUnit =>
      _inputUnitOverride ?? widget.unitSystem;

  void _toggleInputOverride() {
    setState(() {
      final next = _effectiveInputUnit == AppUnitSystem.metric
          ? AppUnitSystem.imperial
          : AppUnitSystem.metric;

      _inputUnitOverride = next;

      if (next == AppUnitSystem.imperial) {
        _syncImperialFromCm();
      }
    });
  }

  String get _primaryDisplayValue => _formatDisplayValue(
    unit: widget.unitSystem,
    cm: _selectedCm,
    includeApproxPrefix: false,
  );

  String get _secondaryDisplayValue => _formatDisplayValue(
    unit: widget.unitSystem == AppUnitSystem.metric
        ? AppUnitSystem.imperial
        : AppUnitSystem.metric,
    cm: _selectedCm,
    includeApproxPrefix: true,
  );

  String _formatDisplayValue({
    required AppUnitSystem unit,
    required double cm,
    required bool includeApproxPrefix,
  }) {
    final prefix = includeApproxPrefix ? '≈ ' : '';

    if (unit == AppUnitSystem.metric) {
      return '$prefix${cm.round()} cm';
    }

    final (feet, inches) = _cmToFeetInches(cm);
    return '$prefix$feet\'$inches"';
  }

  (int feet, int inches) _cmToFeetInches(double cm) {
    final minTotalInches = (AppHeightPicker._minFeet * 12);
    final maxTotalInches = (AppHeightPicker._maxFeet * 12) + 11;

    final totalInches = (cm / AppHeightPicker._kInchesToCm).round().clamp(
      minTotalInches,
      maxTotalInches,
    );

    final feet = (totalInches ~/ 12).clamp(
      AppHeightPicker._minFeet,
      AppHeightPicker._maxFeet,
    );
    final inches = (totalInches % 12).clamp(0, 11);
    return (feet, inches);
  }

  int _cmToSelectedIndexCm(double cm) {
    final cmInt = cm.round().clamp(
      AppHeightPicker._minCm,
      AppHeightPicker._maxCm,
    );
    return cmInt - AppHeightPicker._minCm;
  }

  void _syncImperialFromCm() {
    final (feet, inches) = _cmToFeetInches(_selectedCm);
    _imperialFeet = feet;
    _imperialInches = inches;
    _imperialInitialized = true;
  }

  void _ensureImperialInitialized() {
    if (_imperialInitialized) return;
    _syncImperialFromCm();
  }

  void _emitImperial({required int feet, required int inches}) {
    final nextFeet = feet.clamp(
      AppHeightPicker._minFeet,
      AppHeightPicker._maxFeet,
    );
    final nextInches = inches.clamp(0, 11);
    final nextCm = _clampCm(
      ((nextFeet * 12) + nextInches) * AppHeightPicker._kInchesToCm,
    );

    setState(() {
      _imperialFeet = nextFeet;
      _imperialInches = nextInches;
      _selectedCm = nextCm;
    });
    widget.onChanged(nextCm);
  }

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final spacing = Spacing.of;

    final diameterRatio = platform == AppPlatform.ios ? 1.6 : 2.0;

    final wheels = _effectiveInputUnit == AppUnitSystem.metric
        ? _buildMetricWheel(diameterRatio: diameterRatio)
        : _buildImperialWheels(spacing: spacing, diameterRatio: diameterRatio);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_inputUnitOverride != null)
                AppTappable(
                  onPressed: () => setState(() => _inputUnitOverride = null),
                  semanticLabel: 'Use preferred units',
                  child: AppText(
                    _primaryDisplayValue,
                    variant: AppTextVariant.title,
                    color: AppTextColor.primary,
                  ),
                )
              else
                AppText(
                  _primaryDisplayValue,
                  variant: AppTextVariant.title,
                  color: AppTextColor.primary,
                ),
              SizedBox(width: spacing.sm),
              AppTappable(
                onPressed: _toggleInputOverride,
                semanticLabel: 'Switch input units',
                child: AppText(
                  _secondaryDisplayValue,
                  variant: AppTextVariant.body,
                  color: AppTextColor.secondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        wheels,
      ],
    );
  }

  Widget _buildMetricWheel({required double diameterRatio}) {
    final colors = AppColorScope.of(context).colors;

    Widget buildSelectionOverlay() {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: colors.neutralDivider, width: 1.0),
          ),
        ),
        child: const SizedBox.expand(),
      );
    }

    Widget buildEdgeOverlay({required double height}) {
      final fadeHeight = height * 0.3;
      final fadeColor = colors.surfaceElevated;

      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: fadeHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [fadeColor, fadeColor.withValues(alpha: 0.0)],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fadeHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [fadeColor, fadeColor.withValues(alpha: 0.0)],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      );
    }

    const pickerHeight = 200.0;

    Widget buildWheelText(String text, bool isSelected) {
      return Center(
        child: AppText(
          text,
          variant: isSelected ? AppTextVariant.title : AppTextVariant.body,
          color: isSelected ? AppTextColor.primary : AppTextColor.secondary,
        ),
      );
    }

    final cmItems = List<int>.generate(
      AppHeightPicker._maxCm - AppHeightPicker._minCm + 1,
      (i) => AppHeightPicker._minCm + i,
    );

    final selectedIndex = _cmToSelectedIndexCm(_selectedCm);

    return AppWheelPicker<int>(
      items: cmItems,
      selectedIndex: selectedIndex,
      onSelectedItemChanged: (index) {
        final cm = cmItems[index].toDouble();
        _emitCm(cm);
        _syncImperialFromCm();
      },
      itemBuilder: (context, cm, isSelected) =>
          buildWheelText('$cm', isSelected),
      selectionOverlay: buildSelectionOverlay(),
      edgeOverlay: buildEdgeOverlay(height: pickerHeight),
      height: pickerHeight,
      diameterRatio: diameterRatio,
    );
  }

  Widget _buildImperialWheels({
    required AppSpacing spacing,
    required double diameterRatio,
  }) {
    _ensureImperialInitialized();

    final colors = AppColorScope.of(context).colors;

    Widget buildSelectionOverlay() {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: colors.neutralDivider, width: 1.0),
          ),
        ),
        child: const SizedBox.expand(),
      );
    }

    Widget buildEdgeOverlay({required double height}) {
      final fadeHeight = height * 0.3;
      final fadeColor = colors.surfaceElevated;

      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: fadeHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [fadeColor, fadeColor.withValues(alpha: 0.0)],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fadeHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [fadeColor, fadeColor.withValues(alpha: 0.0)],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      );
    }

    const pickerHeight = 200.0;

    Widget buildWheelText(String text, bool isSelected) {
      return Center(
        child: AppText(
          text,
          variant: isSelected ? AppTextVariant.title : AppTextVariant.body,
          color: isSelected ? AppTextColor.primary : AppTextColor.secondary,
        ),
      );
    }

    final selectedFeet = _imperialFeet;
    final selectedInches = _imperialInches;

    final feetItems = List<int>.generate(
      AppHeightPicker._maxFeet - AppHeightPicker._minFeet + 1,
      (i) => AppHeightPicker._minFeet + i,
    );
    final inchesItems = List<int>.generate(12, (i) => i);

    final feetIndex = selectedFeet - AppHeightPicker._minFeet;
    final inchesIndex = selectedInches;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wheelWidth =
            (constraints.maxWidth - spacing.md).clamp(0.0, double.infinity) / 2;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: wheelWidth,
              child: AppWheelPicker<int>(
                items: feetItems,
                selectedIndex: feetIndex,
                onSelectedItemChanged: (index) {
                  final nextFeet = feetItems[index];
                  _emitImperial(feet: nextFeet, inches: selectedInches);
                },
                itemBuilder: (context, value, isSelected) =>
                    buildWheelText('$value', isSelected),
                selectionOverlay: buildSelectionOverlay(),
                edgeOverlay: buildEdgeOverlay(height: pickerHeight),
                height: pickerHeight,
                diameterRatio: diameterRatio,
              ),
            ),
            SizedBox(width: spacing.md),
            SizedBox(
              width: wheelWidth,
              child: AppWheelPicker<int>(
                items: inchesItems,
                selectedIndex: inchesIndex,
                onSelectedItemChanged: (index) {
                  final nextInches = inchesItems[index];
                  _emitImperial(feet: selectedFeet, inches: nextInches);
                },
                itemBuilder: (context, value, isSelected) =>
                    buildWheelText('$value', isSelected),
                selectionOverlay: buildSelectionOverlay(),
                edgeOverlay: buildEdgeOverlay(height: pickerHeight),
                height: pickerHeight,
                diameterRatio: diameterRatio,
              ),
            ),
          ],
        );
      },
    );
  }
}
