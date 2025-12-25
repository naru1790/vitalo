// @frozen
// Infrastructure → Domain adapter for location data.
// Wraps country_state_city package and provides domain models.

import 'package:country_state_city/country_state_city.dart' as csc;

import '../../../domain/location/location_country.dart';
import '../../../domain/location/location_state.dart';

/// Extension for safe collection lookup.
extension _IterableExt<T> on Iterable<T> {
  /// Returns the first element matching [test], or null if none found.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Repository for location data (countries and states).
///
/// Wraps the `country_state_city` package and converts to domain models.
/// This is the only place where infrastructure (package) meets domain.
class LocationRepository {
  LocationRepository();

  /// Cache for countries (loaded once).
  List<LocationCountry>? _countriesCache;

  /// Cache for states by country code.
  final Map<String, List<LocationState>> _statesCache = {};

  /// Get popular countries by ISO codes.
  ///
  /// Returns countries matching the provided [codes] in the order given.
  /// Silently skips any codes that don't match known countries.
  Future<List<LocationCountry>> getPopularCountries(List<String> codes) async {
    final allCountries = await getCountries();

    return codes
        .map((code) => allCountries.firstWhereOrNull((c) => c.isoCode == code))
        .whereType<LocationCountry>()
        .toList();
  }

  /// Get all countries, sorted alphabetically.
  Future<List<LocationCountry>> getCountries() async {
    if (_countriesCache != null) return _countriesCache!;

    final countries = await csc.getAllCountries();

    // Sort alphabetically
    countries.sort((a, b) => a.name.compareTo(b.name));

    // Convert to domain models
    _countriesCache = countries
        .map(
          (c) =>
              LocationCountry(name: c.name, isoCode: c.isoCode, flag: c.flag),
        )
        .toList();

    return _countriesCache!;
  }

  /// Get states for a country, sorted alphabetically.
  Future<List<LocationState>> getStates(String countryCode) async {
    if (_statesCache.containsKey(countryCode)) {
      return _statesCache[countryCode]!;
    }

    final states = await csc.getStatesOfCountry(countryCode);

    // Sort alphabetically
    states.sort((a, b) => a.name.compareTo(b.name));

    // Convert to domain models
    final domainStates = states
        .map(
          (s) => LocationState(
            name: s.name,
            isoCode: s.isoCode,
            countryCode: countryCode,
          ),
        )
        .toList();

    _statesCache[countryCode] = domainStates;
    return domainStates;
  }

  /// Find a country by ISO code.
  Future<LocationCountry?> findCountry(String isoCode) async {
    final countries = await getCountries();
    return countries.firstWhereOrNull((c) => c.isoCode == isoCode);
  }

  /// Find a state by ISO code within a country.
  Future<LocationState?> findState(String countryCode, String stateCode) async {
    final states = await getStates(countryCode);
    return states.firstWhereOrNull((s) => s.isoCode == stateCode);
  }
}
