// @frozen
// PAGE ARCHETYPE: STAGE / LANDING
// ═══════════════════════════════════════════════════════════════════════════
//
// Intent: Establish identity, orient the user, provide navigation anchors.
//
// Encodes:
// - Split layout: flexible hero top, anchored actions bottom
// - No scroll by default
// - Full-width regions, constrained inner content
//
// Typical use cases:
// - App entry / welcome screen
// - Home screen (post-login anchor)
// - Marketing-style introduction pages
// - Feature gate pages
//
// This page MUST NOT:
// - Display dense content or lists
// - Allow horizontal scrolling
// - Include inline forms
// - Compete for attention with multiple equal-weight actions
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import '../widgets/app_page_body.dart';
import '../widgets/app_scaffold.dart';

/// Stage / Landing Page archetype.
///
/// Split layout with flexible hero section and anchored actions.
/// No scroll by default — content is minimal and impactful.
///
/// Use for orientation and navigation anchor screens:
/// - App entry / welcome
/// - Home screen
/// - Marketing pages
class StagePage extends StatelessWidget {
  const StagePage({
    super.key,
    required this.hero,
    required this.actions,
    this.title,
    this.leadingAction,
    this.trailingActions = const [],
    this.backgroundSurface = AppBackgroundSurface.base,
  });

  /// The hero section (brand, mascot, value proposition).
  ///
  /// Placed in a Flexible container, vertically centered.
  /// Expands to fill available space above actions.
  final Widget hero;

  /// The actions section (CTAs, navigation).
  ///
  /// Anchored to the bottom of the safe area.
  /// Does not expand — uses intrinsic height.
  final Widget actions;

  /// Optional title displayed in the navigation bar.
  final String? title;

  /// Optional leading navigation action.
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
      body: _StageViewport(hero: hero, actions: actions),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE STRUCTURAL PRIMITIVES
// ═══════════════════════════════════════════════════════════════════════════

/// Split layout viewport for Stage / Landing pages.
///
/// Encodes:
/// - Hero region: expands to fill available space, content centered
/// - Actions region: bottom-anchored, intrinsic height
///
/// Relies on finite constraints from AppScaffold.
/// Does NOT scroll — Stage pages are guaranteed to fit the viewport.
/// If content overflows, that is a design error, not a layout concern.
class _StageViewport extends StatelessWidget {
  const _StageViewport({required this.hero, required this.actions});

  final Widget hero;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero region: expands and centers content
        Expanded(
          child: Center(child: AppPageBody(child: hero)),
        ),

        // Actions region: bottom-anchored, intrinsic height
        AppPageBody(child: actions),
      ],
    );
  }
}
