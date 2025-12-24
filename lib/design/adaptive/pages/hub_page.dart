// @frozen
// PAGE ARCHETYPE: HUB
// ═══════════════════════════════════════════════════════════════════════════
//
// Intent: Dense, section-driven navigation anchor screens.
//
// HubPage exists for screens where:
// - Multiple independent content sections are presented
// - Content may exceed the viewport height
// - Users view, configure, or manage multiple concerns
//
// Typical use cases:
// - Profile screen
// - Settings hub
// - Account management
// - Health overview dashboard
// - Preference editors
//
// HubPage OWNS:
// - Scaffold instantiation
// - Scroll behavior
// - Safe area handling
// - Page-level padding
// - Navigation chrome
// - Keyboard inset handling
//
// Feature code MUST NOT:
// - Use scaffolds, scroll views, or safe area wrappers
// - Apply padding for page margins
// - Branch on platform
// - Apply visual styling
//
// HubPage vs DocumentPage:
// Both scroll. HubPage is for dense, multi-section management screens.
// DocumentPage is for linear, long-form reading content.
// API is intentionally identical — difference is semantic intent.
//
// HubPage is NOT for form-heavy flows.
// Form-heavy flows must use FlowFormPage.
//
// HubPage vs StagePage:
// - StagePage: Brand moments, orientation, fixed viewport, hero + actions
// - HubPage: Dense hubs, continuous vertical flow, multiple sections
//
// These archetypes are mutually exclusive.
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import '../widgets/app_page_body.dart';
import '../widgets/app_scaffold.dart';

/// Hub Page archetype.
///
/// Section-driven layout for dense navigation anchor screens.
/// Owns structural concerns: scroll, padding, safe areas, chrome.
///
/// Use for screens where users view, configure, or manage multiple concerns:
/// - Profile screen
/// - Settings hub
/// - Account management
/// - Health overview
///
/// Feature code provides pure content declarations only.
/// HubPage owns all structural and layout concerns.
///
/// API mirrors [DocumentPage] intentionally — both are scrollable archetypes.
/// The distinction is semantic: HubPage is for management, DocumentPage for reading.
/// This similarity is intentional and must not be diverged. If the APIs drift,
/// the archetype boundary has been violated.
///
/// This archetype is @frozen. Escape hatches are forbidden.
class HubPage extends StatelessWidget {
  const HubPage({
    super.key,
    required this.title,
    required this.content,
    this.leadingAction,
    this.trailingActions = const [],
    this.backgroundSurface = AppBackgroundSurface.base,
  });

  /// The semantic title for navigation chrome.
  ///
  /// Represents the screen's identity in the navigation hierarchy.
  /// Presentation is owned by HubPage.
  final String title;

  /// The feature-provided content subtree.
  ///
  /// Contains the hub's sections expressed in semantic order.
  ///
  /// Content must not include:
  /// - Scroll views (HubPage owns scrolling)
  /// - Page-level padding (HubPage owns padding)
  /// - Safe area wrappers (HubPage owns safe areas)
  /// - Scaffold or chrome widgets (HubPage owns structure)
  final Widget content;

  /// Optional leading navigation action (back, close).
  ///
  /// Uses [AppBarAction] — the shared action vocabulary across all archetypes.
  /// May be omitted for root hub screens where navigation gestures
  /// or system chrome handle back navigation implicitly.
  final AppBarAction? leadingAction;

  /// Optional trailing actions in the navigation bar.
  ///
  /// Uses [AppBarAction] — the shared action vocabulary across all archetypes.
  /// Feature code should limit to 0–2 actions to prevent chrome bloat.
  final List<AppBarAction> trailingActions;

  /// Semantic surface layer for page background.
  final AppBackgroundSurface backgroundSurface;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      leadingAction: leadingAction,
      trailingActions: trailingActions,

      // HubPage owns scrolling — content may exceed viewport.
      scrollBehavior: AppScrollBehavior.body,

      // HubPage owns all safe area edges.
      safeArea: AppSafeArea.all,

      // Page surface.
      backgroundSurface: backgroundSurface,

      // Standard navigation chrome.
      chromeStyle: AppChromeStyle.standard,

      // HubPage owns keyboard inset handling.
      resizeToAvoidBottomInset: true,

      // Content wrapped in AppPageBody for padding and width constraints.
      body: AppPageBody(child: content),
    );
  }
}
