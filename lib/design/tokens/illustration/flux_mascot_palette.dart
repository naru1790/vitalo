// @frozen
// Illustrative-only color tokens.
// Must not be used by interactive UI components.
import 'dart:ui' show Color;

import '../color.dart';

/// Flux mascot brand palette (vibrant orange gradient).
///
/// Defines the exact colors for the FluxMascot illustrative widget.
/// These are illustration tokens, not semantic UI colors.
// @frozen
class FluxMascotPalette {
  const FluxMascotPalette({
    required this.aura,
    required this.mid,
    required this.core,
    required this.shine,
  });

  /// Outer aura layer color.
  final Color aura;

  /// Middle flow layer color.
  final Color mid;

  /// Core center layer color.
  final Color core;

  /// Shine highlight color.
  final Color shine;
}

/// Static light/dark palettes for FluxMascot.
///
/// Selection is inferred from semantic colors, not raw brightness.
// @frozen
abstract final class FluxMascotPalettes {
  FluxMascotPalettes._();

  /// Resolve palette from semantic colors.
  ///
  /// Infers dark mode from the neutralBase luminance.
  /// This avoids exposing brightness across scope boundaries.
  static FluxMascotPalette resolve(AppColors colors) {
    // Dark mode has low luminance neutralBase
    final isDark = colors.neutralBase.computeLuminance() < 0.5;
    return isDark ? dark : light;
  }

  /// Light theme palette (vibrant warm oranges).
  static const light = FluxMascotPalette(
    aura: Color(0xFFFDBA74), // Orange 300
    mid: Color(0xFFF97316), // Orange 500
    core: Color(0xFFEA580C), // Orange 600
    shine: Color(0xFFFFFFFF),
  );

  /// Dark theme palette (deep warm oranges).
  static const dark = FluxMascotPalette(
    aura: Color(0xFF7C2D12), // Orange 900
    mid: Color(0xFFFB923C), // Orange 400
    core: Color(0xFFC2410C), // Orange 700
    shine: Color(0xFFFDBA74),
  );
}
