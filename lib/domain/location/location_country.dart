/// Domain model for a country.
///
/// This is a pure domain object — no UI, no infrastructure dependencies.
class LocationCountry {
  const LocationCountry({required this.name, required this.isoCode, this.flag});

  /// Display name of the country.
  final String name;

  /// ISO 3166-1 alpha-2 country code.
  final String isoCode;

  /// Emoji flag representation.
  final String? flag;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationCountry &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;

  @override
  String toString() => 'LocationCountry($isoCode, $name)';
}
