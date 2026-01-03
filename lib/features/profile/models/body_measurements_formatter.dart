import '../../../design/design.dart';

/// Stateless presentation helper for formatting body measurement values.
///
/// Accepts primitives only and must not depend on feature model classes.
abstract final class BodyMeasurementsFormatter {
  BodyMeasurementsFormatter._();

  static String weightLabel({
    required double? weightKg,
    required AppUnitSystem unitSystem,
  }) {
    if (weightKg == null) return '—';
    if (unitSystem == AppUnitSystem.metric) {
      return '${weightKg.toStringAsFixed(1)} kg';
    }
    final lbs = weightKg * 2.20462;
    return '${lbs.toStringAsFixed(0)} lbs';
  }

  static String heightLabel({
    required double? heightCm,
    required AppUnitSystem unitSystem,
  }) {
    if (heightCm == null) return '—';
    if (unitSystem == AppUnitSystem.metric) return '${heightCm.toInt()} cm';

    // Imperial: cm → feet/inches
    // - Floor inches (no rounding)
    // - Prevent invalid results like 5'12"
    final totalInches = heightCm / 2.54;
    final feet = (totalInches / 12).floor();
    final inches = (totalInches - (feet * 12)).floor();

    return "$feet'$inches\"";
  }

  static String waistLabel({
    required double? waistCm,
    required AppUnitSystem unitSystem,
  }) {
    if (waistCm == null) return '—';
    if (unitSystem == AppUnitSystem.metric) return '${waistCm.toInt()} cm';
    final inches = waistCm / 2.54;
    return '${inches.toStringAsFixed(1)}"';
  }
}
