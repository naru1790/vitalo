// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0 adaptive primitive.
//
// Responsibility:
// - Present a modal bottom sheet via SheetPage
// - Branch between Cupertino vs Material presentation
//
// This primitive MUST NOT:
// - Accept generic Widget content (SheetPage only)
// - Apply padding, styling, or business logic
// - Return values beyond Navigator.pop

import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart' show BuildContext, showModalBottomSheet;

import '../pages/sheet_page.dart';
import '../platform/app_platform_scope.dart';

/// Platform-adaptive bottom sheet presenter.
///
/// Use this instead of calling [showCupertinoModalPopup] or [showModalBottomSheet]
/// directly in feature code.
///
/// Requires a [SheetPage] to enforce architectural layering.
abstract final class AppBottomSheet {
  AppBottomSheet._();

  /// Presents a modal bottom sheet with platform-appropriate behavior.
  ///
  /// The only way to dismiss with a value is calling `Navigator.pop(context, value)`
  /// from within [sheet].
  static Future<T?> show<T>(
    BuildContext context, {
    required SheetPage sheet,
    bool isDismissible = true,
    bool enableDrag = true,
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
      enableDrag: enableDrag,
      builder: (_) => sheet,
    );
  }
}
