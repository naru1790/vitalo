// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
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

import 'package:flutter/widgets.dart' show Brightness;

import 'colors/app_colors.dart' show AppColors;
import 'colors/colors_resolver.dart' show AppColorsResolver;

export 'colors/app_colors.dart' show AppColors;
export 'colors/colors_resolver.dart' show AppColorsResolver;

/// Backwards-compatible entry point.
///
/// Legacy code can call `AppColorsTokens.resolve(brightness: ...)`.
/// Caching is the caller's responsibility.
abstract final class AppColorsTokens {
  AppColorsTokens._();

  static AppColors resolve({required Brightness brightness}) {
    return AppColorsResolver.resolve(brightness: brightness);
  }
}
