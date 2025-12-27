// @frozen
// Tier-1 adaptive primitive.
// Owns: platform-appropriate weight picking UI + unit conversion.
// Must NOT: open/close modals, call Navigator, fetch data, show feedback UI.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../models/app_unit_system.dart';
import '../widgets/app_tappable.dart';
import '../widgets/app_text.dart';
import '../widgets/app_wheel_picker.dart';
import '../../tokens/spacing.dart';

/// Tier-1 adaptive weight picker.
///
/// - Reads [AppPlatformScope] internally for platform-appropriate behavior.
/// - Renders a wheel-style picker on iOS and a Material-appropriate variant
///   on Android.
/// - Displays the currently selected value explicitly above the wheels.
/// - Unit system is provided by feature code; this widget does not own or
///   mutate user preferences.
/// - Switching [unitSystem] rebuilds picker subtrees and re-derives wheel
///   indices from the canonical kilogram value; this is local and
///   non-persistent.
/// - Displays a passive converted value in the opposite unit inline with the
///   primary value. Tapping the secondary value temporarily switches the
///   wheel input mode (metric ↔ imperial) for this widget instance only.
/// - Wheels are input; displayed values are output.
/// - Emits weight in kilograms only.
class AppWeightPicker extends StatefulWidget {
  const AppWeightPicker({
    super.key,
    required this.initialKg,
    required this.unitSystem,
    required this.onChanged,
  });

  final double? initialKg;
  final AppUnitSystem unitSystem;
  final ValueChanged<double> onChanged;

  static const double _kKgToLbs = 2.20462;
  static const double _kLbsToKg = 0.453592;

  static const int _minKgWhole = 20;
  static const int _maxKgWhole = 250;
  static const int _minLbs = 44;
  static const int _maxLbs = 551;

  static const double _defaultKg = 70.0;

  @override
  State<AppWeightPicker> createState() => _AppWeightPickerState();
}

class _AppWeightPickerState extends State<AppWeightPicker> {
  late double _selectedKg;

  /// Null = follow preference
  /// Metric / imperial = temporary input override
  AppUnitSystem? _inputUnitOverride;

  @override
  void initState() {
    super.initState();
    _selectedKg = _clampKg(widget.initialKg ?? AppWeightPicker._defaultKg);
  }

  @override
  void didUpdateWidget(covariant AppWeightPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Preference is authoritative. If the preference unit changes upstream,
    // reset any temporary local override.
    if (widget.unitSystem != oldWidget.unitSystem &&
        _inputUnitOverride != null) {
      setState(() => _inputUnitOverride = null);
    }

    // If the caller changes the initial value, treat it as a controlled update.
    if (widget.initialKg != oldWidget.initialKg) {
      final next = _clampKg(widget.initialKg ?? AppWeightPicker._defaultKg);
      if (next != _selectedKg) setState(() => _selectedKg = next);
      return;
    }

    // Ensure our local state stays within bounds.
    final clamped = _clampKg(_selectedKg);
    if (clamped != _selectedKg) setState(() => _selectedKg = clamped);
  }

  double _clampKg(double kg) {
    return kg.clamp(
      AppWeightPicker._minKgWhole.toDouble(),
      AppWeightPicker._maxKgWhole.toDouble() + 0.99,
    );
  }

  void _emitKg(double kg) {
    final next = _clampKg(kg);
    setState(() => _selectedKg = next);
    widget.onChanged(next);
  }

  AppUnitSystem get _effectiveInputUnit =>
      _inputUnitOverride ?? widget.unitSystem;

  void _toggleInputOverride() {
    setState(() {
      _inputUnitOverride = _effectiveInputUnit == AppUnitSystem.metric
          ? AppUnitSystem.imperial
          : AppUnitSystem.metric;
    });
  }

  String get _primaryDisplayValue => _formatValue(
    unit: widget.unitSystem,
    kg: _selectedKg,
    includeApproxPrefix: false,
  );

  String get _secondaryDisplayValue => _formatValue(
    unit: widget.unitSystem == AppUnitSystem.metric
        ? AppUnitSystem.imperial
        : AppUnitSystem.metric,
    kg: _selectedKg,
    includeApproxPrefix: true,
  );

  String _formatValue({
    required AppUnitSystem unit,
    required double kg,
    required bool includeApproxPrefix,
  }) {
    final prefix = includeApproxPrefix ? '≈ ' : '';

    if (unit == AppUnitSystem.imperial) {
      final lbs = (kg * AppWeightPicker._kKgToLbs).round().clamp(
        AppWeightPicker._minLbs,
        AppWeightPicker._maxLbs,
      );
      return '$prefix$lbs lbs';
    }

    return '$prefix${kg.toStringAsFixed(1)} kg';
  }

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final spacing = Spacing.of;

    // Platform-resolved geometry.
    final diameterRatio = platform == AppPlatform.ios ? 1.6 : 2.0;

    final wheels = _effectiveInputUnit == AppUnitSystem.imperial
        ? _buildImperialWheel(diameterRatio: diameterRatio)
        : _buildMetricWheels(spacing: spacing, diameterRatio: diameterRatio);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

  Widget _buildImperialWheel({required double diameterRatio}) {
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

    final selectedLbs = (_selectedKg * AppWeightPicker._kKgToLbs).round().clamp(
      AppWeightPicker._minLbs,
      AppWeightPicker._maxLbs,
    );
    final lbsItems = List<int>.generate(
      AppWeightPicker._maxLbs - AppWeightPicker._minLbs + 1,
      (i) => AppWeightPicker._minLbs + i,
    );

    final selectedIndex = selectedLbs - AppWeightPicker._minLbs;

    return AppWheelPicker<int>(
      items: lbsItems,
      selectedIndex: selectedIndex,
      onSelectedItemChanged: (index) {
        final lbs = lbsItems[index];
        final kg = lbs * AppWeightPicker._kLbsToKg;
        _emitKg(kg);
      },
      itemBuilder: (context, lbs, isSelected) =>
          buildWheelText('$lbs', isSelected),
      selectionOverlay: buildSelectionOverlay(),
      edgeOverlay: buildEdgeOverlay(height: pickerHeight),
      height: pickerHeight,
      diameterRatio: diameterRatio,
    );
  }

  Widget _buildMetricWheels({
    required AppSpacing spacing,
    required double diameterRatio,
  }) {
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

    // Metric: whole kg + fractional (0-99) wheels.
    final wholeKg = _selectedKg.floor().clamp(
      AppWeightPicker._minKgWhole,
      AppWeightPicker._maxKgWhole,
    );
    final grams = ((_selectedKg - wholeKg) * 100).round().clamp(0, 99);

    final kgItems = List<int>.generate(
      AppWeightPicker._maxKgWhole - AppWeightPicker._minKgWhole + 1,
      (i) => AppWeightPicker._minKgWhole + i,
    );
    final gramsItems = List<int>.generate(100, (i) => i);

    final kgIndex = wholeKg - AppWeightPicker._minKgWhole;
    final gramsIndex = grams;

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
                items: kgItems,
                selectedIndex: kgIndex,
                onSelectedItemChanged: (index) {
                  final nextWhole = kgItems[index];
                  final currentGrams = ((_selectedKg - wholeKg) * 100)
                      .round()
                      .clamp(0, 99);
                  _emitKg(nextWhole + (currentGrams / 100.0));
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
                items: gramsItems,
                selectedIndex: gramsIndex,
                onSelectedItemChanged: (index) {
                  final nextGrams = gramsItems[index];
                  _emitKg(wholeKg + (nextGrams / 100.0));
                },
                itemBuilder: (context, value, isSelected) => buildWheelText(
                  value.toString().padLeft(2, '0'),
                  isSelected,
                ),
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
