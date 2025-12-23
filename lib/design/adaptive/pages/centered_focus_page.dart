// @frozen
// PAGE ARCHETYPE: CENTERED FOCUS
// ═══════════════════════════════════════════════════════════════════════════
//
// Intent: Capture complete user attention for a single, focused task.
//
// Encodes:
// - Vertically centered content within safe area
// - Horizontally constrained content (maxWidth: 400pt)
// - No scroll by default (keyboard-safe shifting only)
//
// Typical use cases:
// - OTP verification
// - Email sign-in
// - Password reset
// - Single-question prompts
//
// This page MUST NOT:
// - Anchor content to top of screen
// - Allow horizontal scrolling
// - Contain lists, feeds, or browsable content
// - Include bottom navigation
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import '../widgets/app_page_body.dart';
import '../widgets/app_scaffold.dart';

/// Maximum content width for focused pages.
///
/// Prevents content from stretching on wide screens.
/// Improves focus and readability.
const double _kMaxContentWidth = 400.0;

/// Centered Focus Page archetype.
///
/// Vertically centers content within the viewport.
/// Applies horizontal constraint for focus.
/// No scroll by default — content must fit the viewport.
///
/// Use for single-task completion screens:
/// - OTP verification
/// - Email sign-in
/// - Password reset
class CenteredFocusPage extends StatelessWidget {
  const CenteredFocusPage({
    super.key,
    required this.child,
    this.title,
    this.leadingAction,
    this.trailingActions = const [],
    this.backgroundSurface = AppBackgroundSurface.base,
  });

  /// The focused content to display.
  ///
  /// Should be a Column with hero icon, title, subtitle, input, and action.
  /// Must fit within the viewport without scrolling.
  final Widget child;

  /// Optional title displayed in the navigation bar.
  final String? title;

  /// Optional leading navigation action (back, close).
  final AppBarAction? leadingAction;

  /// Optional trailing actions in the navigation bar.
  final List<AppBarAction> trailingActions;

  /// Semantic surface layer for page background.
  final AppBackgroundSurface backgroundSurface;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      leadingAction: leadingAction,
      trailingActions: trailingActions,
      safeArea: AppSafeArea.all,
      backgroundSurface: backgroundSurface,
      chromeStyle: AppChromeStyle.transparent,

      // Keyboard handling via scaffold resize — no scroll needed.
      resizeToAvoidBottomInset: true,

      body: Center(
        child: AppPageBody(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
