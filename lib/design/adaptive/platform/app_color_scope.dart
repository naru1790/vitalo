import 'package:flutter/widgets.dart' show BuildContext, InheritedWidget;

import '../../tokens/color.dart';

// @frozen
// TIER-0 INFRASTRUCTURE — ACTIVE FREEZE ZONE
//
// Semantic color scope. Provides resolved colors to all descendants.
//
// Ownership rules:
// - AdaptiveShell resolves brightness and produces semantic colors.
// - Only semantic colors cross this boundary — brightness terminates.
// - Primitives must not branch on brightness or platform appearance.
// - All visual decisions must be expressed via semantic color roles.
//
// What flows down:
// - AppColors (semantic roles)
//
// What stops at AdaptiveShell (never enters scope):
// - Brightness
// - MediaQuery
// - Platform detection
// - System contrast rules
// - OS appearance flags

/// Semantic color scope.
///
/// Provides resolved [AppColors] to all descendants.
/// Colors are semantic contracts — not raw appearance signals.
///
/// Primitives read colors from this scope. They must never read brightness
/// or make appearance-based decisions. If a primitive needs to branch on
/// appearance, the color contract is incomplete — add a semantic role.
class AppColorScope extends InheritedWidget {
  const AppColorScope({super.key, required this.colors, required super.child});

  /// Semantic color contract.
  ///
  /// Resolved by AdaptiveShell from system brightness.
  /// Contains all color roles needed by primitives.
  final AppColors colors;

  /// Access the color scope from context.
  ///
  /// Throws if AdaptiveShell is missing from the widget tree.
  static AppColorScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppColorScope>();
    assert(
      scope != null,
      'AppColorScope is missing. Wrap the app with AdaptiveShell.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(AppColorScope oldWidget) {
    return oldWidget.colors != colors;
  }
}
