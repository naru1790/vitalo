import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';

/// Semantic typography scale.
///
/// Defines text roles with complete typographic specifications.
/// Platform implementations interpret roles to feel native while
/// preserving brand voice. Values are guided by brand typography
/// guidelines, not framework defaults.
///
/// Resolution is static: platform is detected once at app startup.
/// Consumers access values via [AppTextStyles.of] without runtime checks.
abstract class AppTypography {
  const AppTypography();

  /// Hero moments and celebratory messages.
  /// Largest text in the system. Used sparingly for maximum impact.
  TextStyle get display;

  /// Screen and section headings.
  /// Establishes context and organizes content hierarchy.
  TextStyle get title;

  /// Primary reading text.
  /// Optimized for comfortable extended reading. Most-used role.
  TextStyle get body;

  /// Supporting and metadata text.
  /// Secondary information that aids comprehension without competing.
  TextStyle get caption;

  /// Interactive element text.
  /// Buttons, tabs, navigation items. Optimized for quick recognition.
  TextStyle get label;
}

/// iOS interpretation.
///
/// Light, airy, and elegant. Generous line heights create calm reading
/// rhythm. Softer weight progression feels refined rather than demanding.
/// Body text prioritizes breathing room over information density.
class _IosTypography extends AppTypography {
  const _IosTypography();

  @override
  TextStyle get display => const TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.5,
  );

  @override
  TextStyle get title => const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.25,
  );

  @override
  TextStyle get body => const TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  @override
  TextStyle get caption => const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  @override
  TextStyle get label => const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    height: 1.30,
  );
}

/// Android interpretation.
///
/// Warm, grounded, and readable. Comfortable line heights balance
/// breathing room with efficient use of space. Slightly bolder weights
/// create confident hierarchy that feels native to the platform.
class _AndroidTypography extends AppTypography {
  const _AndroidTypography();

  @override
  TextStyle get display => const TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    height: 1.20,
  );

  @override
  TextStyle get title => const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    height: 1.30,
  );

  @override
  TextStyle get body => const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  @override
  TextStyle get caption => const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.40,
  );

  @override
  TextStyle get label => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.25,
  );
}

/// Neutral fallback.
///
/// Used when platform detection is unavailable (web, tests, desktop).
/// Values are intentionally balanced between iOS and Android interpretations.
class _DefaultTypography extends AppTypography {
  const _DefaultTypography();

  @override
  TextStyle get display => const TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w600,
    height: 1.22,
  );

  @override
  TextStyle get title => const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    height: 1.32,
  );

  @override
  TextStyle get body => const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  @override
  TextStyle get caption => const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.42,
  );

  @override
  TextStyle get label => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.28,
  );
}

/// Static typography resolver.
///
/// Platform detection occurs once when this class is first loaded.
/// The resolved scale is cached for the lifetime of the application.
/// This guarantees deterministic typography and avoids runtime branching.
abstract final class AppTextStyles {
  AppTextStyles._();

  /// Platform-appropriate typography scale.
  static AppTypography get of => _resolved;

  static final AppTypography _resolved = _resolve();

  static AppTypography _resolve() {
    try {
      if (Platform.isIOS) return const _IosTypography();
      if (Platform.isAndroid) return const _AndroidTypography();
    } catch (_) {
      // Platform unavailable (e.g., web)
    }
    return const _DefaultTypography();
  }
}
