// @frozen
// Tier-1 adaptive primitive.
// Owns: platform-appropriate waist picking UI + unit conversion.
// Must NOT: open/close modals, call Navigator, fetch data, show feedback UI.

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../models/app_unit_system.dart';
import 'app_tappable.dart';
import 'app_text.dart';
import 'app_wheel_picker.dart';
import '../../tokens/spacing.dart';

/// Tier-1 adaptive waist picker.
///
/// - Reads [AppPlatformScope] internally for platform-appropriate behavior.
/// - Displays the currently selected value explicitly above the wheels.
/// - Unit system is provided by feature code; this widget does not own or
///   mutate user preferences.
/// - Supports a local, temporary input-unit override by tapping the secondary
///   value; preference remains authoritative.
/// - Imperial display precision is asymmetric by design:
///   - Primary (preference) inches are whole numbers to match the wheel.
///   - Secondary (≈) inches may be fractional to reduce conversion friction.
/// - Emits waist in centimeters only.
class AppWaistPicker extends StatefulWidget {
  const AppWaistPicker({
    super.key,
    required this.initialCm,
    required this.unitSystem,
    required this.onChanged,
  });

  final double? initialCm;
  final AppUnitSystem unitSystem;
  final ValueChanged<double> onChanged;

  static const double _kInchesToCm = 2.54;

  static const int _minCm = 50;
  static const int _maxCm = 200;

  static const int _minInches = 20;
  static const int _maxInches = 79;

  static const double _defaultCm = 80.0;

  @override
  State<AppWaistPicker> createState() => _AppWaistPickerState();
}

class _AppWaistPickerState extends State<AppWaistPicker> {
  late double _selectedCm;

  // When in imperial input mode, the inches wheel should be stable.
  // This drives the wheel index directly to avoid cm↔in rounding jitter.
  int _imperialInches = AppWaistPicker._minInches;
  bool _imperialInitialized = false;

  /// Null = follow preference.
  /// Metric / imperial = temporary input override.
  AppUnitSystem? _inputUnitOverride;

  @override
  void initState() {
    super.initState();
    _selectedCm = _clampCm(widget.initialCm ?? AppWaistPicker._defaultCm);
    _syncImperialFromCm();
  }

  @override
  void didUpdateWidget(covariant AppWaistPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Preference is authoritative. If the preference unit changes upstream,
    // reset any temporary local override.
    if (widget.unitSystem != oldWidget.unitSystem &&
        _inputUnitOverride != null) {
      setState(() => _inputUnitOverride = null);
    }

    // If preference changes to imperial (and override resets), ensure the
    // imperial wheel index is aligned with the current canonical value.
    if (widget.unitSystem != oldWidget.unitSystem &&
        _effectiveInputUnit == AppUnitSystem.imperial) {
      _syncImperialFromCm();
    }

    // If the caller changes the initial value, treat it as a controlled update.
    if (widget.initialCm != oldWidget.initialCm) {
      final next = _clampCm(widget.initialCm ?? AppWaistPicker._defaultCm);
      if (next != _selectedCm) {
        setState(() {
          _selectedCm = next;
          _syncImperialFromCm();
        });
      }
      return;
    }

    final clamped = _clampCm(_selectedCm);
    if (clamped != _selectedCm) {
      setState(() {
        _selectedCm = clamped;
        _syncImperialFromCm();
      });
    }
  }

  double _clampCm(double cm) {
    return cm.clamp(
      AppWaistPicker._minCm.toDouble(),
      AppWaistPicker._maxCm.toDouble(),
    );
  }

  void _emitCm(double cm) {
    final next = _clampCm(cm);
    setState(() {
      _selectedCm = next;
      _syncImperialFromCm();
    });
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

  void _syncImperialFromCm() {
    _imperialInches = (_selectedCm / AppWaistPicker._kInchesToCm).round().clamp(
      AppWaistPicker._minInches,
      AppWaistPicker._maxInches,
    );
    _imperialInitialized = true;
  }

  void _ensureImperialInitialized() {
    if (_imperialInitialized) return;
    _syncImperialFromCm();
  }

  void _emitImperial({required int inches}) {
    final nextInches = inches.clamp(
      AppWaistPicker._minInches,
      AppWaistPicker._maxInches,
    );
    final nextCm = _clampCm(nextInches * AppWaistPicker._kInchesToCm);

    setState(() {
      _imperialInches = nextInches;
      _selectedCm = nextCm;
      _imperialInitialized = true;
    });
    widget.onChanged(nextCm);
  }

  String get _primaryDisplayValue => _formatValue(
    unit: widget.unitSystem,
    cm: _selectedCm,
    includeApproxPrefix: false,
  );

  String get _secondaryDisplayValue => _formatValue(
    unit: widget.unitSystem == AppUnitSystem.metric
        ? AppUnitSystem.imperial
        : AppUnitSystem.metric,
    cm: _selectedCm,
    includeApproxPrefix: true,
  );

  String _formatValue({
    required AppUnitSystem unit,
    required double cm,
    required bool includeApproxPrefix,
  }) {
    final prefix = includeApproxPrefix ? '≈ ' : '';

    if (unit == AppUnitSystem.metric) {
      return '$prefix${cm.round()} cm';
    }

    // Imperial display.
    // - When shown as the converted (≈) value, allow fractional inches since
    //   metric cm values frequently map to non-integer inches.
    // - When shown as the primary (preference) value, keep it integer to stay
    //   consistent with the inches wheel.
    if (includeApproxPrefix) {
      final inches = (cm / AppWaistPicker._kInchesToCm).clamp(
        AppWaistPicker._minInches.toDouble(),
        AppWaistPicker._maxInches.toDouble(),
      );
      return '$prefix${inches.toStringAsFixed(1)}"';
    }

    final inchesWhole = (cm / AppWaistPicker._kInchesToCm).round().clamp(
      AppWaistPicker._minInches,
      AppWaistPicker._maxInches,
    );
    return '$prefix$inchesWhole"';
  }

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final spacing = Spacing.of;

    final diameterRatio = platform == AppPlatform.ios ? 1.6 : 2.0;

    final wheels = _effectiveInputUnit == AppUnitSystem.imperial
        ? _buildImperialWheel(diameterRatio: diameterRatio)
        : _buildMetricWheel(diameterRatio: diameterRatio);

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
      AppWaistPicker._maxCm - AppWaistPicker._minCm + 1,
      (i) => AppWaistPicker._minCm + i,
    );

    final selectedCm = _selectedCm.round().clamp(
      AppWaistPicker._minCm,
      AppWaistPicker._maxCm,
    );
    final selectedIndex = selectedCm - AppWaistPicker._minCm;

    return AppWheelPicker<int>(
      items: cmItems,
      selectedIndex: selectedIndex,
      onSelectedItemChanged: (index) {
        final cm = cmItems[index].toDouble();
        _emitCm(cm);
      },
      itemBuilder: (context, cm, isSelected) =>
          buildWheelText('$cm', isSelected),
      selectionOverlay: buildSelectionOverlay(),
      edgeOverlay: buildEdgeOverlay(height: pickerHeight),
      height: pickerHeight,
      diameterRatio: diameterRatio,
    );
  }

  Widget _buildImperialWheel({required double diameterRatio}) {
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

    final inchesItems = List<int>.generate(
      AppWaistPicker._maxInches - AppWaistPicker._minInches + 1,
      (i) => AppWaistPicker._minInches + i,
    );

    final selectedIndex = _imperialInches - AppWaistPicker._minInches;

    return AppWheelPicker<int>(
      items: inchesItems,
      selectedIndex: selectedIndex,
      onSelectedItemChanged: (index) {
        final inches = inchesItems[index];
        _emitImperial(inches: inches);
      },
      itemBuilder: (context, inches, isSelected) =>
          buildWheelText('$inches', isSelected),
      selectionOverlay: buildSelectionOverlay(),
      edgeOverlay: buildEdgeOverlay(height: pickerHeight),
      height: pickerHeight,
      diameterRatio: diameterRatio,
    );
  }
}
