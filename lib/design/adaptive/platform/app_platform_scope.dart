import 'package:flutter/widgets.dart';

/// Platform identity for layout decisions.
///
/// Orthogonal to motion — layout is not animation.
/// Shells inject this; AppScaffold reads it.
enum AppPlatform { ios, android }

/// Provides platform identity to the widget tree.
///
/// Injected by [IosShell] or [AndroidShell].
/// AppScaffold reads this to select platform-appropriate structure.
///
/// This is NOT platform detection — it is explicit shell declaration.
class AppPlatformScope extends InheritedWidget {
  const AppPlatformScope({
    super.key,
    required this.platform,
    required super.child,
  });

  final AppPlatform platform;

  static AppPlatform of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppPlatformScope>();
    assert(() {
      if (scope == null) {
        throw FlutterError.fromParts([
          ErrorSummary('AppPlatformScope is missing.'),
          ErrorDescription(
            'AppScaffold requires platform identity from a shell.',
          ),
          ErrorHint(
            'Ensure your app is wrapped with IosShell or AndroidShell.',
          ),
        ]);
      }
      return true;
    }());
    return scope!.platform;
  }

  @override
  bool updateShouldNotify(AppPlatformScope oldWidget) {
    return oldWidget.platform != platform;
  }
}
