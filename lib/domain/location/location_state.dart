/// Domain model for a state/region within a country.
///
/// This is a pure domain object — no UI, no infrastructure dependencies.
class LocationState {
  const LocationState({
    required this.name,
    required this.isoCode,
    required this.countryCode,
  });

  /// Display name of the state/region.
  final String name;

  /// State/region code.
  final String isoCode;

  /// Parent country's ISO code.
  final String countryCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationState &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode &&
          countryCode == other.countryCode;

  @override
  int get hashCode => Object.hash(isoCode, countryCode);

  @override
  String toString() => 'LocationState($isoCode, $name)';
}
