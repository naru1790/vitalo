// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-1 layout primitive.
// Centralizes keyboard dismissal policy for tap-outside behavior.
//
// Hard rules:
// - No visual output (no padding, decoration, background)
// - No business logic
// - No state
// - Must not block scrolling or interfere with child gestures

import 'package:flutter/widgets.dart';

class KeyboardDismissSurface extends StatelessWidget {
  const KeyboardDismissSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      excludeFromSemantics: true,
      onTapDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
