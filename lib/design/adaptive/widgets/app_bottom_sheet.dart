// @frozen
// Tier-0 adaptive primitive.
// Owns: platform-appropriate modal presentation.
// Must NOT: accept generic Widget, apply styling, expose platform knobs.
// Feature code MUST NOT call showCupertinoModalPopup or showModalBottomSheet.

import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart' show BuildContext, showModalBottomSheet;

import '../pages/sheet_page.dart';
import '../platform/app_platform_scope.dart';

/// Tier-0 platform-adaptive bottom sheet presenter.
///
/// The ONLY legal way to present bottom sheets in feature code.
/// Requires [SheetPage] to enforce content structure.
/// Dismiss with value via `Navigator.pop(context, value)`.
abstract final class AppBottomSheet {
  AppBottomSheet._();

  /// Presents a modal bottom sheet.
  ///
  /// [sheet] — The [SheetPage] containing sheet content.
  /// [isDismissible] — Whether barrier tap dismisses. Default `true`.
  static Future<T?> show<T>(
    BuildContext context, {
    required SheetPage sheet,
    bool isDismissible = true,
  }) {
    final platform = AppPlatformScope.of(context);

    if (platform == AppPlatform.ios) {
      return showCupertinoModalPopup<T>(
        context: context,
        barrierDismissible: isDismissible,
        builder: (_) => sheet,
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: true,
      builder: (_) => sheet,
    );
  }
}
