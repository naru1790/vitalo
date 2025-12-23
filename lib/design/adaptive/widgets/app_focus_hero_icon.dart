// @frozen
// CENTERED FOCUS HERO ICON
// ═══════════════════════════════════════════════════════════════════════════
//
// Semantic hero icon for Centered Focus page archetypes.
//
// This widget encodes the canonical visual size for hero icons in
// single-task, attention-critical screens (Email, OTP, Password reset).
//
// Feature code must NOT define hero icon sizing — this primitive owns it.
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import '../../tokens/icons.dart' as icons;
import 'app_icon.dart';

/// Canonical hero icon size for Centered Focus pages.
///
/// Uses 44pt for prominent visual presentation in focused layouts.
/// This is a frozen layout constant, not a spacing token.
const double _kHeroIconSize = 44.0;

/// Semantic hero icon for Centered Focus page archetypes.
///
/// Encodes the canonical visual size and presentation for hero icons
/// in single-task, attention-critical screens.
///
/// This is a layout-only primitive. It does not manage interaction.
///
/// Use in:
/// - Email sign-in
/// - OTP verification
/// - Password reset
/// - Single-question prompts
class AppFocusHeroIcon extends StatelessWidget {
  const AppFocusHeroIcon({super.key, required this.icon});

  /// The semantic icon to display.
  final icons.AppIcon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kHeroIconSize,
      height: _kHeroIconSize,
      child: FittedBox(
        fit: BoxFit.contain,
        child: AppIcon(icon, size: AppIconSize.large),
      ),
    );
  }
}
