// @frozen
// Illustrative-only color tokens.
// Must not be used by interactive UI components.
import 'dart:ui' show Color;

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
/// Selection is brightness-based only; no platform branching.
// @frozen
abstract final class FluxMascotPalettes {
  FluxMascotPalettes._();

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
