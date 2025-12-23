// @frozen
// Adaptive illustrative widget — changes require design + platform review.
//
// This widget uses dedicated illustration tokens (FluxMascotPalettes) instead of
// AppColors or theme color schemes. Illustrative widgets are exempt from semantic
// color contracts but must remain token-driven.
//
// Palette selection is inferred from semantic colors (not raw brightness).
import 'package:flutter/widgets.dart';

import '../../design/adaptive/platform/app_color_scope.dart';
import '../../design/tokens/illustration/flux_mascot_palette.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/opacity.dart';
import '../../design/tokens/shape.dart';

/// FluxMascot - 3-layer animated vitality indicator
/// Represents Physical (outer), Nutritional (middle), Mental (core) health dimensions
class FluxMascot extends StatefulWidget {
  const FluxMascot({super.key, this.size = 200});

  final double size;

  @override
  State<FluxMascot> createState() => _FluxMascotState();
}

class _FluxMascotState extends State<FluxMascot> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _floatController1;
  late AnimationController _floatController2;

  static const int _kRotationCycles = 30;
  static const int _kFloatPrimaryCycles = 24;
  static const int _kFloatSecondaryCycles = 32;

  @override
  void initState() {
    super.initState();
    final motion = AppMotionTokens.of;

    // Motion durations remain token-driven; multipliers preserve legacy timing
    // while honoring platform motion scales.
    // Rotation for outer aura (token-driven)
    _rotationController = AnimationController(
      vsync: this,
      duration: motion.slow * _kRotationCycles,
    )..repeat();

    // Float for middle layer
    _floatController1 = AnimationController(
      vsync: this,
      duration: motion.normal * _kFloatPrimaryCycles,
    )..repeat(reverse: true);

    // Float for core
    _floatController2 = AnimationController(
      vsync: this,
      duration: motion.normal * _kFloatSecondaryCycles,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController1.dispose();
    _floatController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Palette inferred from semantic colors, not raw brightness.
    final colors = AppColorScope.of(context).colors;
    final palette = FluxMascotPalettes.resolve(colors);
    final opacity = AppOpacityTokens.of;
    final shape = AppShapeTokens.of;
    final floatOffset = widget.size * 0.05;
    final blurRadius = widget.size * 0.125;
    final spreadRadius = widget.size * 0.025;
    final decorativeOpacity = opacity.scrimLight;

    return ExcludeSemantics(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Layer 1: Aura (Back) - Rotating
            RotationTransition(
              turns: _rotationController,
              child: Opacity(
                opacity: decorativeOpacity,
                child: CustomPaint(
                  size: Size(widget.size * 0.85, widget.size * 0.85),
                  painter: _BlobPainter(color: palette.aura, scale: 0.9),
                ),
              ),
            ),

            // Layer 2: Flow (Middle) - Floating
            AnimatedBuilder(
              animation: _floatController1,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -floatOffset * _floatController1.value),
                  child: Opacity(
                    opacity: opacity.barBackground,
                    child: CustomPaint(
                      size: Size(widget.size * 0.7, widget.size * 0.7),
                      painter: _BlobPainter(color: palette.mid),
                    ),
                  ),
                );
              },
            ),

            // Layer 3: Core (Front) - Pulsing float
            AnimatedBuilder(
              animation: _floatController2,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -floatOffset * _floatController2.value),
                  child: Container(
                    width: widget.size * 0.42,
                    height: widget.size * 0.42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: palette.core,
                      boxShadow: [
                        BoxShadow(
                          color: palette.core.withValues(
                            alpha: decorativeOpacity,
                          ),
                          blurRadius: blurRadius,
                          spreadRadius: spreadRadius,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Shine effect
                        Positioned(
                          top: widget.size * 0.08,
                          left: widget.size * 0.08,
                          child: Container(
                            width: widget.size * 0.12,
                            height: widget.size * 0.06,
                            decoration: BoxDecoration(
                              color: palette.shine.withValues(
                                alpha: opacity.scrimLight,
                              ),
                              borderRadius: BorderRadius.circular(shape.full),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for organic blob shapes
class _BlobPainter extends CustomPainter {
  final Color color;
  final double scale;

  _BlobPainter({required this.color, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width * scale;
    final h = size.height * scale;
    final offsetX = (size.width - w) / 2;
    final offsetY = (size.height - h) / 2;

    // Organic blob using quadratic bezier curves
    path.moveTo(w * 0.5 + offsetX, offsetY);
    path.quadraticBezierTo(
      w * 0.9 + offsetX,
      h * 0.1 + offsetY,
      w * 0.9 + offsetX,
      h * 0.5 + offsetY,
    );
    path.quadraticBezierTo(
      w * 0.9 + offsetX,
      h * 0.9 + offsetY,
      w * 0.5 + offsetX,
      h * 0.9 + offsetY,
    );
    path.quadraticBezierTo(
      w * 0.1 + offsetX,
      h * 0.9 + offsetY,
      w * 0.1 + offsetX,
      h * 0.5 + offsetY,
    );
    path.quadraticBezierTo(
      w * 0.1 + offsetX,
      h * 0.1 + offsetY,
      w * 0.5 + offsetX,
      offsetY,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BlobPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.scale != scale;
}
