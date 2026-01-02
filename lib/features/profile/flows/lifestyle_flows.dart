import 'package:flutter/widgets.dart';

import '../../../design/design.dart';
import '../models/lifestyle_data.dart';
import '../pickers/lifestyle_activity/lifestyle_activity_sheet.dart';
import '../pickers/lifestyle_diet/lifestyle_diet_sheet.dart';
import '../pickers/lifestyle_sleep/lifestyle_sleep_sheet.dart';

/// Navigation entrypoints for Lifestyle editing flows.
///
/// Owns modal presentation only. Returns values to feature code.
abstract final class LifestyleFlows {
  LifestyleFlows._();

  static Future<LifestyleData?> editLifestyleActivity({
    required BuildContext context,
    required LifestyleData initialData,
  }) {
    return AppBottomSheet.show<LifestyleData>(
      context,
      sheet: LifestyleActivitySheet.page(initialData: initialData),
    );
  }

  static Future<LifestyleData?> editLifestyleSleep({
    required BuildContext context,
    required LifestyleData initialData,
  }) {
    return AppBottomSheet.show<LifestyleData>(
      context,
      sheet: LifestyleSleepSheet.page(initialData: initialData),
    );
  }

  static Future<LifestyleData?> editLifestyleDiet({
    required BuildContext context,
    required LifestyleData initialData,
  }) {
    return AppBottomSheet.show<LifestyleData>(
      context,
      sheet: LifestyleDietSheet.page(initialData: initialData),
    );
  }
}
