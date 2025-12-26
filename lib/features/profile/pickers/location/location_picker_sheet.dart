import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

/// Personal Info → Location picker sheet.
///
/// Stateless UI wrapper that returns a [LocationResult] via Navigator.pop.
///
/// Data fetching must be performed by flows.
class LocationPickerSheet extends StatelessWidget {
  const LocationPickerSheet({
    super.key,
    required this.countries,
    required this.popularCountries,
    required this.statesLoader,
    this.initialValue,
  });

  final List<LocationCountry> countries;
  final List<LocationCountry> popularCountries;
  final Future<List<LocationState>> Function(String countryCode) statesLoader;
  final LocationResult? initialValue;

  @override
  Widget build(BuildContext context) {
    return AppLocationPickerSheet(
      countries: countries,
      popularCountries: popularCountries,
      statesLoader: statesLoader,
      initialCountryCode: initialValue?.countryCode,
      initialStateCode: initialValue?.stateCode,
    );
  }
}
