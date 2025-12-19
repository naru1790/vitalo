import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/widgets.dart' show Brightness;

import 'android_dark_colors.dart';
import 'android_light_colors.dart';
import 'app_colors.dart';
import 'default_dark_colors.dart';
import 'default_light_colors.dart';
import 'ios_dark_colors.dart';
import 'ios_light_colors.dart';

/// Single resolution point for semantic color tokens.
///
/// Responsibility boundary:
/// - Inputs: platform + brightness
/// - Output: one concrete [AppColors] instance
///
/// No caching is performed here. Callers may cache the returned instance.
abstract final class AppColorsResolver {
  AppColorsResolver._();

  static AppColors resolve({required Brightness brightness}) {
    final bool isDark = brightness == Brightness.dark;

    // Platform selection uses Flutter's target platform.
    // This keeps the resolver compatible with platforms where `dart:io` is
    // unavailable (e.g., web).
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return isDark ? const IosDarkColors() : const IosLightColors();
      case TargetPlatform.android:
        return isDark ? const AndroidDarkColors() : const AndroidLightColors();
      default:
        return isDark ? const DefaultDarkColors() : const DefaultLightColors();
    }
  }
}
