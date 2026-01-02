import '../../../design/design.dart';

enum HealthConditionIcon { metabolic, heart, hormone, kidney, liver, female }

/// Predefined health conditions with simple, user-friendly labels.
///
/// Focus on conditions that significantly impact diet/nutrition recommendations.
///
/// NOTE: This enum is part of the feature domain model and is shared across
/// Profile → Body & Health flows and sheets.
enum HealthCondition {
  none('I\'m healthy', null),
  // Metabolic conditions
  diabetes('Diabetes (Type 2)', HealthConditionIcon.metabolic),
  preDiabetes('Pre-diabetic', HealthConditionIcon.metabolic),
  highBP('High Blood Pressure', HealthConditionIcon.heart),
  cholesterol('High Cholesterol', HealthConditionIcon.metabolic),
  // Hormonal conditions
  thyroid('Thyroid Issues', HealthConditionIcon.hormone),
  pcos('PCOS', HealthConditionIcon.hormone),
  // Kidney & Liver
  kidneyDisease('Kidney Disease', HealthConditionIcon.kidney),
  fattyLiver('Fatty Liver', HealthConditionIcon.liver),
  // Heart
  heartDisease('Heart Disease', HealthConditionIcon.heart),
  // Female-specific conditions
  pregnant('Pregnant', HealthConditionIcon.female),
  lactating('Breastfeeding', HealthConditionIcon.female);

  const HealthCondition(this.label, this.icon);
  final String label;
  final HealthConditionIcon? icon;

  bool get isFemaleOnly => this == pregnant || this == lactating;
}

extension HealthConditionAvailability on HealthCondition {
  /// Lists health conditions available for the given gender.
  ///
  /// Domain rules live here; sheets must not infer availability.
  static List<HealthCondition> availableFor(AppGender gender) {
    return HealthCondition.values
        .where((c) => c != HealthCondition.none)
        .where((c) => !c.isFemaleOnly || gender == AppGender.female)
        .toList(growable: false);
  }
}

class BodyHealthData {
  const BodyHealthData({
    this.weightKg,
    this.heightCm,
    this.waistCm,
    this.conditions = const {},
    this.customConditions = const [],
  });

  final double? weightKg;
  final double? heightCm;
  final double? waistCm;
  final Set<HealthCondition> conditions;
  final List<String> customConditions;

  BodyHealthData copyWith({
    double? weightKg,
    double? heightCm,
    double? waistCm,
    Set<HealthCondition>? conditions,
    List<String>? customConditions,
  }) {
    return BodyHealthData(
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      waistCm: waistCm ?? this.waistCm,
      conditions: conditions ?? this.conditions,
      customConditions: customConditions ?? this.customConditions,
    );
  }

  bool get hasNoConditions =>
      conditions.isEmpty ||
      (conditions.length == 1 && conditions.contains(HealthCondition.none));
}

extension BodyHealthConditionsDisplay on BodyHealthData {
  String get conditionsSummary {
    final items = conditions
        .where((c) => c != HealthCondition.none)
        .map((c) => c.label)
        .toList();
    items.addAll(customConditions);

    if (items.isEmpty) {
      return 'I\'m healthy';
    }
    if (items.length <= 2) {
      return items.join(', ');
    }
    return '${items.take(2).join(', ')} +${items.length - 2} more';
  }
}

extension BodyHealthDisplay on BodyHealthData {
  String weightLabel(AppUnitSystem unitSystem) {
    if (weightKg == null) return '—';
    if (unitSystem == AppUnitSystem.metric) {
      return '${weightKg!.toStringAsFixed(1)} kg';
    }
    final lbs = weightKg! * 2.20462;
    return '${lbs.toStringAsFixed(0)} lbs';
  }

  String heightLabel(AppUnitSystem unitSystem) {
    if (heightCm == null) return '—';
    if (unitSystem == AppUnitSystem.metric) return '${heightCm!.toInt()} cm';
    final totalInches = heightCm! / 2.54;
    final feet = (totalInches / 12).floor();
    final inches = (totalInches % 12).round();
    return "$feet'$inches\"";
  }

  String waistLabel(AppUnitSystem unitSystem) {
    if (waistCm == null) return '—';
    if (unitSystem == AppUnitSystem.metric) return '${waistCm!.toInt()} cm';
    final inches = waistCm! / 2.54;
    return '${inches.toStringAsFixed(1)}"';
  }
}
