// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0 adaptive primitive. Feature code depends on stable semantics.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_color_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/motion.dart';

/// Tier-0 adaptive boolean toggle control.
///
/// Stateless, boolean-only, domain-agnostic.
///
/// Feature code MUST compose labels separately using primitives such as
/// [AppListTile] or selector composites.
class AppToggle extends StatelessWidget {
  const AppToggle({super.key, required this.value, required this.onChanged});

  final bool value;

  /// When null, the toggle renders disabled.
  final ValueChanged<bool>? onChanged;

  bool get _enabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);
    final colors = AppColorScope.of(context).colors;
    final motion = AppMotionTokens.of;

    // Control mechanics MUST NOT reuse content (text*) or selection (stateSelected)
    // semantics. Even if numeric values match, the meaning must be expressed via
    // dedicated mechanical control roles.
    final active = colors.controlActive;
    // Off-state track should be a neutral mechanical surface, not a faded divider.
    final inactiveTrack = colors.neutralDivider;
    final thumb = colors.controlOnInverse;

    final toggle = switch (platform) {
      AppPlatform.ios => CupertinoSwitch(
        value: value,
        onChanged: (v) => onChanged?.call(v),
        activeTrackColor: active,
        inactiveTrackColor: inactiveTrack,
        thumbColor: thumb,
      ),
      AppPlatform.android => SwitchTheme(
        data: const SwitchThemeData(
          // Material 3 renders a track outline by default.
          // That outline must be expressed via control semantics, not defaults.
          // We remove the outline entirely; the track color carries the state.
          // (Using MaterialStateProperty ensures the override actually applies.)
          trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
          trackOutlineWidth: WidgetStatePropertyAll(0.0),
        ),
        child: Switch(
          value: value,
          onChanged: (v) => onChanged?.call(v),
          activeThumbColor: thumb,
          activeTrackColor: active,
          inactiveThumbColor: colors.neutralSurface,
          inactiveTrackColor: inactiveTrack,
        ),
      ),
    };

    return Semantics(
      enabled: _enabled,
      toggled: value,
      child: AnimatedOpacity(
        // Contract: disabled visual treatment is opacity ONLY.
        opacity: _enabled ? 1.0 : 0.38,
        duration: motion.fast,
        curve: motion.easeOut,
        child: IgnorePointer(ignoring: !_enabled, child: toggle),
      ),
    );
  }
}
