// @frozen
// PAGE ARCHETYPE: SHEET
//
// Tier-1 adaptive page archetype.
//
// Intent:
// - Provide a canonical modal bottom-sheet layout
// - Own all sheet-level structure and behavior
//
// SheetPage OWNS:
// - SafeArea (bottom only)
// - Keyboard insets handling
// - Canonical sheet padding
// - Surface/background styling
//
// SheetPage MUST NOT:
// - Fetch or mutate business data
// - Perform navigation
// - Show snackbars, toasts, or dialogs
// - Branch on platform
// - Expose styling or layout configuration

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shape.dart';

/// Tier-1 modal bottom-sheet page archetype.
///
/// Provides canonical sheet structure: surface background, safe area,
/// keyboard inset handling, and standard padding.
///
/// Use with [AppBottomSheet.show] to present modal content:
/// ```dart
/// AppBottomSheet.show(
///   context,
///   child: SheetPage(
///     child: MySheetContent(),
///   ),
/// );
/// ```
///
/// SheetPage treats [child] as pure content — it knows nothing about
/// what is rendered inside. All business logic belongs in the child.
class SheetPage extends StatelessWidget {
  const SheetPage({super.key, required this.child});

  /// The content to display inside the sheet.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;

    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(shape.lg)),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            bottomInset + spacing.lg,
          ),
          child: child,
        ),
      ),
    );
  }
}
