// Pure domain models for Profile → Lifestyle.
//
// No Flutter imports.
// No UI labels, icons, or semantics.
// No sentinel values for “not set”.

enum LifestyleActivityLevel { sedentary, lightlyActive, active, veryActive }

enum DietPreference { omnivore, vegetarian, vegan, pescatarian }

class LifestyleData {
  const LifestyleData({
    this.activityLevel,
    this.sleepDuration,
    this.bedTime,
    this.dietPreference,
  });

  final LifestyleActivityLevel? activityLevel;

  /// Typical sleep duration.
  final Duration? sleepDuration;

  /// Time from midnight representing a bedtime.
  final Duration? bedTime;

  final DietPreference? dietPreference;

  LifestyleData copyWith({
    LifestyleActivityLevel? activityLevel,
    Duration? sleepDuration,
    Duration? bedTime,
    DietPreference? dietPreference,
  }) {
    return LifestyleData(
      activityLevel: activityLevel ?? this.activityLevel,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      bedTime: bedTime ?? this.bedTime,
      dietPreference: dietPreference ?? this.dietPreference,
    );
  }
}
