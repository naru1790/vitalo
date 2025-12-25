// @frozen
// Tier-0 adaptive primitive.
// Owns: platform-appropriate modal presentation.
// Must NOT: accept generic Widget, apply styling, expose platform knobs.
// Feature code MUST NOT call showCupertinoModalPopup or showModalBottomSheet.

import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart'
    show BuildContext, MediaQuery, showModalBottomSheet;
import 'package:flutter/widgets.dart'
    show
        Column,
        MainAxisAlignment,
        MainAxisSize,
        SizedBox,
        StatelessWidget,
        Widget;

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
      // CRITICAL: Capture width from caller's context BEFORE entering modal.
      // showCupertinoModalPopup provides infinite width/height constraints
      // during animation, which causes layout failures in many widgets.
      // By capturing the screen width here and wrapping the sheet,
      // we provide bounded constraints to all descendant widgets.
      final screenWidth = MediaQuery.sizeOf(context).width;

      return showCupertinoModalPopup<T>(
        context: context,
        barrierDismissible: isDismissible,
        builder: (_) => _ConstrainedIosSheet(width: screenWidth, child: sheet),
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

/// Wrapper that constrains iOS sheet content to bounded width.
///
/// This solves the fundamental constraint issue with showCupertinoModalPopup.
class _ConstrainedIosSheet extends StatelessWidget {
  const _ConstrainedIosSheet({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Column with mainAxisSize.min provides intrinsic height sizing.
    // SizedBox constrains width. Together they provide bounded constraints.
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [SizedBox(width: width, child: child)],
    );
  }
}
