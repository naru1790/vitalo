// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tokens are resolved once per app run.
// TokenEnvironment must be initialized before access.
// Environment changes require app restart by design.
//
// This file defines the token environment injection point.
// Changes here are considered BREAKING CHANGES.
//
// Allowed changes:
// - Bug fixes with no semantic impact
// - Additive extensions approved via architecture review
//
// Forbidden changes:
// - Adding widget or BuildContext dependencies
// - Adding MediaQuery dependencies
// - Making tokens reactive
// - Reading platform APIs directly
// - Adding silent fallbacks or defaults

import 'package:flutter/foundation.dart' show visibleForTesting;

/// Platform identity for token resolution.
///
/// This is independent of the widget-layer AppPlatform to avoid
/// circular dependencies between tokens and adaptive widgets.
enum TokenPlatform {
  /// iOS platform — Apple HIG conventions
  ios,

  /// Android platform — Material Design conventions
  android,

  /// Fallback for web, desktop, or unknown platforms
  other,
}

/// Display density classification.
///
/// Determined once at app startup. Not reactive.
/// Compact devices have smaller touch targets and tighter spacing.
enum DensityClass {
  /// Smaller screens, tighter layouts (< 360 logical pixels width)
  compact,

  /// Standard density for most devices
  regular,
}

/// Text scale policy.
///
/// Determined once at app startup. Not reactive.
/// Large text policy increases base font sizes for accessibility.
enum TextScalePolicy {
  /// Standard text sizing
  normal,

  /// Larger text for accessibility (textScaleFactor >= 1.3)
  large,
}

/// Immutable environment snapshot for token resolution.
///
/// Constructed exactly once by [AdaptiveShell] at app startup.
/// Tokens read from this snapshot; they do not observe changes.
///
/// This design ensures:
/// - Tokens are deterministic for the entire app lifecycle
/// - No runtime platform checks in token code
/// - No widget/context dependencies in token layer
/// - Predictable performance (no rebuilds from environment changes)
///
/// Environment changes (e.g., user changes system font size) require
/// app restart to take effect. This is intentional — tokens are not reactive.
///
/// Initialization rules:
/// - Must be initialized exactly once via [initialize]
/// - Access before initialization throws in debug mode
/// - Re-initialization throws in debug mode
/// - No silent fallbacks or defaults
final class TokenEnvironment {
  const TokenEnvironment({
    required this.platform,
    required this.density,
    required this.textScalePolicy,
  });

  /// Platform identity for token selection.
  final TokenPlatform platform;

  /// Display density classification.
  final DensityClass density;

  /// Text scale policy for typography tokens.
  final TextScalePolicy textScalePolicy;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATIC INJECTION — STRICT SINGLE INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  static TokenEnvironment? _current;

  /// Current token environment.
  ///
  /// Must be initialized via [initialize] before accessing.
  /// Throws assertion error if accessed before initialization.
  static TokenEnvironment get current {
    assert(
      _current != null,
      'TokenEnvironment accessed before initialization. '
      'Ensure AdaptiveShell.initState() runs before any token access.',
    );
    return _current!;
  }

  /// Whether the environment has been initialized.
  static bool get isInitialized => _current != null;

  /// Initialize the token environment.
  ///
  /// Must be called exactly once by [AdaptiveShell] at app startup.
  /// Re-initialization throws assertion error in debug mode.
  ///
  /// This is the ONLY legal initializer. No other code may call this.
  static void initialize(TokenEnvironment env) {
    assert(
      _current == null,
      'TokenEnvironment.initialize() called more than once. '
      'This is an architectural violation.',
    );
    _current = env;
  }

  /// Reset for testing only.
  ///
  /// This is intentionally guarded and not part of the public API.
  /// Production code must never reset the environment.
  @visibleForTesting
  static void resetForTesting() {
    _current = null;
  }
}
