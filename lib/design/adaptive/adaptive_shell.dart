import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

import '../tokens/color.dart';
import 'android_shell.dart';
import 'ios_shell.dart';

/// Adaptive shell that owns platform + appearance resolution.
///
/// Resolves brightness from system, resolves tokens, and branches
/// to platform-specific shells. Contains no UI or routing logic.
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final colors = AppColorsTokens.resolve(brightness: brightness);

    if (_isIos) {
      return IosShell(brightness: brightness, colors: colors, child: child);
    }
    return AndroidShell(brightness: brightness, colors: colors, child: child);
  }

  static bool get _isIos {
    try {
      return Platform.isIOS;
    } catch (_) {
      return false;
    }
  }
}
