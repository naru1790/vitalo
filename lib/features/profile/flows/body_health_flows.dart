import 'package:flutter/widgets.dart';

import '../../../design/design.dart';
import '../pickers/height/height_picker_sheet.dart';
import '../pickers/waist/waist_picker_sheet.dart';
import '../pickers/weight/weight_picker_sheet.dart';

/// Navigation entrypoints for Body & Health editing flows.
///
/// Owns modal presentation only. Returns values to feature code.
abstract final class BodyHealthFlows {
  BodyHealthFlows._();

  static Future<double?> editWeight({
    required BuildContext context,
    required double? initialKg,
    required AppUnitSystem unitSystem,
  }) {
    return AppBottomSheet.show<double>(
      context,
      sheet: WeightPickerSheet.page(
        initialKg: initialKg,
        unitSystem: unitSystem,
      ),
    );
  }

  static Future<double?> editHeight({
    required BuildContext context,
    required double? initialCm,
    required AppUnitSystem unitSystem,
  }) {
    return AppBottomSheet.show<double>(
      context,
      sheet: HeightPickerSheet.page(
        initialCm: initialCm,
        unitSystem: unitSystem,
      ),
    );
  }

  static Future<double?> editWaist({
    required BuildContext context,
    required double? initialCm,
    required AppUnitSystem unitSystem,
  }) {
    return AppBottomSheet.show<double>(
      context,
      sheet: WaistPickerSheet.page(
        initialCm: initialCm,
        unitSystem: unitSystem,
      ),
    );
  }
}
