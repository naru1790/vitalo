import 'package:flutter/material.dart';

/// FluxMascot - 3-layer animated vitality indicator
/// Represents Physical (outer), Nutritional (middle), Mental (core) health dimensions
class FluxMascot extends StatefulWidget {
  const FluxMascot({
    super.key,
    this.size = 200,
    this.themeMode = Brightness.light,
  });

  final double size;
  final Brightness themeMode;

  @override
  State<FluxMascot> createState() => _FluxMascotState();
}

class _FluxMascotState extends State<FluxMascot> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _floatController1;
  late AnimationController _floatController2;

  @override
  void initState() {
    super.initState();

    // Slow rotation for outer aura
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    // Medium float for middle layer
    _floatController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // Slow float for core
    _floatController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
    final isSolar = widget.themeMode == Brightness.light;

    // Solar (Light) - Warm, energetic sunset colors
    const solarBack = Color(0xFFFDBA74); // Orange-300
    const solarMid = Color(0xFFF97316); // Orange-500
    const solarFront = Color(0xFFEA580C); // Orange-600

    // Lunar (Dark) - Cool, calm deep space colors
    const lunarBack = Color(0xFF818CF8); // Indigo-400
    const lunarMid = Color(0xFF6366F1); // Indigo-500
    const lunarFront = Color(0xFF4338CA); // Indigo-700

    final back = isSolar ? solarBack : lunarBack;
    final mid = isSolar ? solarMid : lunarMid;
    final front = isSolar ? solarFront : lunarFront;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: Aura (Back) - Rotating
          RotationTransition(
            turns: _rotationController,
            child: Opacity(
              opacity: 0.4,
              child: CustomPaint(
                size: Size(widget.size * 0.85, widget.size * 0.85),
                painter: _BlobPainter(color: back, scale: 0.9),
              ),
            ),
          ),

          // Layer 2: Flow (Middle) - Floating
          AnimatedBuilder(
            animation: _floatController1,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -10 * _floatController1.value),
                child: Opacity(
                  opacity: 0.8,
                  child: CustomPaint(
                    size: Size(widget.size * 0.7, widget.size * 0.7),
                    painter: _BlobPainter(color: mid),
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
                offset: Offset(0, -10 * _floatController2.value),
                child: Container(
                  width: widget.size * 0.42,
                  height: widget.size * 0.42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: front,
                    boxShadow: [
                      BoxShadow(
                        color: front.withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 5,
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
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(100),
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
