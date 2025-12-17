import 'package:flutter/material.dart';

import '../theme.dart';

/// Generic sign-in button with consistent styling
class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final Widget icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: AppSpacing.iconSizeSmall,
                height: AppSpacing.iconSizeSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(effectiveForegroundColor),
                ),
              )
            : icon,
        label: Text(
          isLoading ? 'Signing in...' : label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: effectiveForegroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
        ),
      ),
    );
  }
}

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(AppSpacing.iconSizeSmall, AppSpacing.iconSizeSmall),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  // Official Google brand colors
  static const _blue = Color(0xFF4285F4);
  static const _red = Color(0xFFEA4335);
  static const _yellow = Color(0xFFFBBC05);
  static const _green = Color(0xFF34A853);

  @override
  void paint(Canvas canvas, Size size) {
    // Scale factor to fit the 20x20 size (original viewBox is 24x24)
    final scale = size.width / 24;
    canvas.scale(scale, scale);

    // Blue section (right side with horizontal bar)
    final bluePath = Path()
      ..moveTo(23.745, 12.27)
      ..cubicTo(23.745, 11.48, 23.675, 10.73, 23.545, 10)
      ..lineTo(12.255, 10)
      ..lineTo(12.255, 14.51)
      ..lineTo(18.725, 14.51)
      ..cubicTo(18.435, 15.99, 17.585, 17.24, 16.325, 18.09)
      ..lineTo(16.325, 21.09)
      ..lineTo(20.185, 21.09)
      ..cubicTo(22.445, 19, 23.745, 15.92, 23.745, 12.27);
    canvas.drawPath(bluePath, Paint()..color = _blue);

    // Green section (bottom right)
    final greenPath = Path()
      ..moveTo(12.255, 24)
      ..cubicTo(15.495, 24, 18.205, 22.92, 20.185, 21.09)
      ..lineTo(16.325, 18.09)
      ..cubicTo(15.245, 18.81, 13.875, 19.25, 12.255, 19.25)
      ..cubicTo(9.125, 19.25, 6.475, 17.14, 5.525, 14.29)
      ..lineTo(1.545, 14.29)
      ..lineTo(1.545, 17.38)
      ..cubicTo(3.515, 21.3, 7.565, 24, 12.255, 24);
    canvas.drawPath(greenPath, Paint()..color = _green);

    // Yellow section (bottom left)
    final yellowPath = Path()
      ..moveTo(5.525, 14.29)
      ..cubicTo(5.275, 13.57, 5.145, 12.8, 5.145, 12)
      ..cubicTo(5.145, 11.2, 5.285, 10.43, 5.525, 9.71)
      ..lineTo(5.525, 6.62)
      ..lineTo(1.545, 6.62)
      ..cubicTo(0.725, 8.24, 0.255, 10.06, 0.255, 12)
      ..cubicTo(0.255, 13.94, 0.725, 15.76, 1.545, 17.38)
      ..lineTo(5.525, 14.29);
    canvas.drawPath(yellowPath, Paint()..color = _yellow);

    // Red section (top)
    final redPath = Path()
      ..moveTo(12.255, 4.75)
      ..cubicTo(14.025, 4.75, 15.605, 5.36, 16.855, 6.55)
      ..lineTo(20.275, 3.13)
      ..cubicTo(18.195, 1.19, 15.495, 0, 12.255, 0)
      ..cubicTo(7.565, 0, 3.515, 2.7, 1.545, 6.62)
      ..lineTo(5.525, 9.71)
      ..cubicTo(6.475, 6.86, 9.125, 4.75, 12.255, 4.75);
    canvas.drawPath(redPath, Paint()..color = _red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
