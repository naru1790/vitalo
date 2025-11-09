import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientCTA extends StatelessWidget {
  const GradientCTA({
    super.key,
    required this.child,
    required this.onPressed,
    this.dark = false,
  });

  final Widget child;
  final VoidCallback onPressed;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final colors = dark ? AppGradients.darkPrimary : AppGradients.lightPrimary;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
