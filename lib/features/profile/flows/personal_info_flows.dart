import 'package:flutter/widgets.dart';

import '../../../design/design.dart';
import '../pickers/birth_year/birth_year_picker_sheet.dart';

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
}
