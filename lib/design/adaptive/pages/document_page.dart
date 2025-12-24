// @frozen
// PAGE ARCHETYPE: DOCUMENT
// ═══════════════════════════════════════════════════════════════════════════
//
// Intent: Present long-form legal, informational, or reference content.
//
// Encodes:
// - Vertical scrolling for variable-length content
// - Top-anchored content (reading flow)
// - Horizontal padding via AppPageBody
// - Safe area handling
//
// Typical use cases:
// - Privacy Policy
// - Terms of Service
// - Licenses
// - Help articles
// - Reference documentation
//
// This page MUST NOT:
// - Center content vertically
// - Use hero layouts or split regions
// - Constrain max width (content should flow naturally)
// - Allow feature screens to manage scroll or padding
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import '../widgets/app_page_body.dart';
import '../widgets/app_scaffold.dart';

/// Document Page archetype.
///
/// Scrollable, top-anchored layout for long-form content.
/// Owns scroll behavior, padding, and safe area handling.
///
/// Use for legal, informational, or reference screens:
/// - Privacy Policy
/// - Terms of Service
/// - Licenses
/// - Help articles
class DocumentPage extends StatelessWidget {
  const DocumentPage({
    super.key,
    required this.child,
    this.title,
    this.leadingAction,
    this.trailingActions = const [],
    this.backgroundSurface = AppBackgroundSurface.base,
  });

  /// The document content to display.
  ///
  /// Should be a Column with headings, paragraphs, and sections.
  /// May be arbitrarily long — scroll is handled by this archetype.
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
      chromeStyle: AppChromeStyle.standard,

      // Document pages scroll — content length is variable.
      scrollBehavior: AppScrollBehavior.body,

      body: AppPageBody(child: child),
    );
  }
}
