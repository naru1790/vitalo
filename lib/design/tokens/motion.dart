// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tokens are resolved once per app run.
// TokenEnvironment must be initialized before access.
// Environment changes require app restart by design.
//
// This file defines system-level policy.
// Changes here are considered BREAKING CHANGES.
//
// Allowed changes:
// - Bug fixes with no semantic impact
// - Additive extensions approved via architecture review
//
// Forbidden changes:
// - Renaming semantics
// - Changing default values
// - Adding platform conditionals
// - Feature-driven modifications
// - Adding BuildContext or MediaQuery dependencies
// - Lazy or deferred token resolution
// - Silent fallbacks or defaults

import 'package:flutter/animation.dart';

import 'token_environment.dart';

/// Semantic motion tokens.
///
/// Defines duration and easing intent independent of animation logic.
/// Platform implementations interpret these to feel native while
/// preserving causality and communication purpose.
///
/// Resolution is static: platform is detected once at app startup.
/// Consumers access values via [AppMotionTokens.of] without runtime checks.
abstract class AppMotion {
  const AppMotion();

  // ──────────────────────────────────────────────────────────
  // Durations
  // ──────────────────────────────────────────────────────────

  /// Micro-feedback and immediate response.
  /// Users should not perceive waiting.
  Duration get fast;

  /// Standard transitions, navigation, overlays.
  /// Noticeable but not slow. Motion explains without delaying.
  Duration get normal;

  /// Deliberate, significant, cinematic moments.
  /// Reserved for importance. Overuse diminishes impact.
  Duration get slow;

  // ──────────────────────────────────────────────────────────
  // Easing
  // ──────────────────────────────────────────────────────────

  /// Arrival and reveal. Motion decelerates to rest.
  /// Use for elements entering, dialogs appearing, content revealing.
  Curve get easeOut;

  /// Departure and release. Motion accelerates away.
  /// Use for elements exiting, dismissals, leaving states.
  Curve get easeIn;

  /// Peer-to-peer transitions. Symmetric acceleration.
  /// Use for navigation between equals, carousels, paging.
  Curve get easeInOut;

  /// Constant velocity. Mechanical, progress-oriented.
  /// Use ONLY for progress indicators and loading bars.
  Curve get linear;

  /// Overshoot and settle. Energetic, attention-grabbing.
  /// Use for celebrations, pull-to-refresh, lively arrivals.
  Curve get settle;

  /// Decisive final placement. Committed landing.
  /// Use for snapping to grid, toggle completion, selection lock.
  Curve get snap;
}

/// iOS interpretation.
///
/// Fluid, continuous, and physically grounded. Motion has room to
/// breathe. Durations trend slightly longer. Easing feels smooth
/// and spring-influenced. Gesture-friendly and interruptible.
class _IosMotion extends AppMotion {
  const _IosMotion();

  @override
  Duration get fast => const Duration(milliseconds: 200);

  @override
  Duration get normal => const Duration(milliseconds: 350);

  @override
  Duration get slow => const Duration(milliseconds: 550);

  @override
  Curve get easeOut => Curves.easeOutCubic;

  @override
  Curve get easeIn => Curves.easeInCubic;

  @override
  Curve get easeInOut => Curves.easeInOutCubic;

  @override
  Curve get linear => Curves.linear;

  @override
  Curve get settle => Curves.easeOutQuart;

  @override
  Curve get snap => Curves.easeOutQuint;
}

/// Android interpretation.
///
/// Responsive, decisive, and efficient. Motion confirms action.
/// Durations trend slightly shorter. Easing feels snappy and
/// physics-grounded. Clear state changes without indulgence.
class _AndroidMotion extends AppMotion {
  const _AndroidMotion();

  @override
  Duration get fast => const Duration(milliseconds: 150);

  @override
  Duration get normal => const Duration(milliseconds: 250);

  @override
  Duration get slow => const Duration(milliseconds: 400);

  @override
  Curve get easeOut => Curves.fastOutSlowIn;

  @override
  Curve get easeIn => Curves.easeIn;

  @override
  Curve get easeInOut => Curves.easeInOut;

  @override
  Curve get linear => Curves.linear;

  @override
  Curve get settle => Curves.easeOutQuart;

  @override
  Curve get snap => Curves.easeOutQuint;
}

/// Neutral fallback.
///
/// Used when platform detection is unavailable (web, tests, desktop).
/// Values are intentionally balanced between iOS and Android.
class _DefaultMotion extends AppMotion {
  const _DefaultMotion();

  @override
  Duration get fast => const Duration(milliseconds: 175);

  @override
  Duration get normal => const Duration(milliseconds: 300);

  @override
  Duration get slow => const Duration(milliseconds: 475);

  @override
  Curve get easeOut => Curves.easeOutCubic;

  @override
  Curve get easeIn => Curves.easeInCubic;

  @override
  Curve get easeInOut => Curves.easeInOutCubic;

  @override
  Curve get linear => Curves.linear;

  @override
  Curve get settle => Curves.easeOutQuart;

  @override
  Curve get snap => Curves.easeOutQuint;
}

/// Static motion resolver.
///
/// Resolution occurs at class load after TokenEnvironment initialization.
/// The resolved scale is immutable for the lifetime of the application.
/// This guarantees deterministic motion and avoids runtime branching.
abstract final class AppMotionTokens {
  AppMotionTokens._();

  /// Platform-appropriate motion tokens.
  static AppMotion get of => _resolved;

  static final AppMotion _resolved = _resolve();

  static AppMotion _resolve() {
    final platform = TokenEnvironment.current.platform;
    return switch (platform) {
      TokenPlatform.ios => const _IosMotion(),
      TokenPlatform.android => const _AndroidMotion(),
      TokenPlatform.other => const _DefaultMotion(),
    };
  }
}
