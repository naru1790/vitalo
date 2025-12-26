import 'package:flutter/widgets.dart';

import '../../../design/design.dart';
import '../repositories/location_repository.dart';
import '../pickers/birth_year/birth_year_picker_sheet.dart';
import '../pickers/location/location_picker_sheet.dart';

/// Navigation entrypoints for Personal Info editing flows.
///
/// Owns modal presentation and any required async data-loading.
///
/// Does not own UI state.
abstract final class PersonalInfoFlows {
  PersonalInfoFlows._();

  static Future<int?> selectBirthYear({
    required BuildContext context,
    int? initialYear,
  }) {
    return AppBottomSheet.show<int>(
      context,
      sheet: SheetPage(child: BirthYearPickerSheet(initialYear: initialYear)),
    );
  }

  static Future<LocationResult?> selectLocation({
    required BuildContext context,
    LocationResult? initialValue,
  }) async {
    const popularCodes = [
      'US',
      'GB',
      'CA',
      'AU',
      'IN',
      'DE',
      'FR',
      'JP',
      'BR',
      'MX',
    ];
    final repo = LocationRepository();

    final results = await Future.wait<List<LocationCountry>>([
      repo.getCountries(),
      repo.getPopularCountries(popularCodes),
    ]);

    return AppBottomSheet.show<LocationResult>(
      context,
      sheet: SheetPage(
        child: LocationPickerSheet(
          countries: results[0],
          popularCountries: results[1],
          statesLoader: repo.getStates,
          initialValue: initialValue,
        ),
      ),
    );
  }
}
