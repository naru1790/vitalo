import 'package:flutter/foundation.dart' show immutable;

import '../../../domain/location/location.dart';

export '../../../domain/location/location.dart';

/// Selection result from location picker.
///
/// This is a presentation-layer model representing the user's selection.
/// It aggregates domain entities (LocationCountry, LocationState) into
/// a single selection outcome shaped for UI consumption.
///
/// This belongs in presentation, not domain, because:
/// - It's a selection outcome (UI state)
/// - It aggregates multiple domain entities
/// - It contains display-oriented helpers
@immutable
class LocationResult {
  const LocationResult({required this.country, this.state});

  /// Selected country.
  final LocationCountry country;

  /// Selected state/region (null if country has no states or none selected).
  final LocationState? state;

  /// Country name.
  String get countryName => country.name;

  /// Country ISO code.
  String get countryCode => country.isoCode;

  /// State name (if any).
  String? get stateName => state?.name;

  /// State code (if any).
  String? get stateCode => state?.isoCode;

  /// Country flag emoji.
  String? get flag => country.flag;

  /// Formatted display string.
  String get displayName {
    if (state != null) return '${state!.name}, ${country.name}';
    return country.name;
  }

  /// Short display with flag.
  String get displayWithFlag => '${flag ?? ''} $displayName'.trim();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationResult &&
          runtimeType == other.runtimeType &&
          country == other.country &&
          state == other.state;

  @override
  int get hashCode => Object.hash(country, state);

  @override
  String toString() => 'LocationResult($displayName)';
}
