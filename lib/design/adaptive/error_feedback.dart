import 'dart:async';

import 'package:flutter/widgets.dart';

import '../tokens/icons.dart' as icons;
import '../tokens/feedback_timing.dart';
import '../tokens/shape.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'platform/app_color_scope.dart';
import 'platform/app_platform_scope.dart';
import 'widgets/app_icon.dart';

/// Semantic facade for transient error feedback.
///
/// Intentionally ONLY supports errors.
/// Success is silent by contract; informational/warning feedback is forbidden.
abstract final class AppErrorFeedback {
  AppErrorFeedback._();

  static void show(BuildContext context, String message) {
    ErrorFeedbackScope.of(context).show(message);
  }
}

/// Platform delegate interface.
///
/// Feature code must never know *how* errors render.
abstract class ErrorFeedbackDelegate {
  const ErrorFeedbackDelegate();

  void show(String message);
}

/// Delegate injection point.
///
/// Provided by platform scaffolding to keep lifecycle scoped to the
/// current page context (must not survive navigation).
class ErrorFeedbackScope extends InheritedWidget {
  const ErrorFeedbackScope({
    super.key,
    required this.delegate,
    required super.child,
  });

  final ErrorFeedbackDelegate delegate;

  static ErrorFeedbackDelegate of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ErrorFeedbackScope>();

    assert(() {
      if (scope == null) {
        throw FlutterError.fromParts([
          ErrorSummary('ErrorFeedbackScope is missing.'),
          ErrorDescription(
            'AppErrorFeedback requires an ErrorFeedbackDelegate provided by the platform scaffold.',
          ),
          ErrorHint(
            'Wrap the page body with an ErrorFeedbackHost (via AppScaffold).',
          ),
        ]);
      }
      return true;
    }());

    return scope!.delegate;
  }

  @override
  bool updateShouldNotify(ErrorFeedbackScope oldWidget) {
    return oldWidget.delegate.runtimeType != delegate.runtimeType;
  }
}

/// Internal host that provides the correct platform delegate.
///
/// This keeps ownership local to the current page, so feedback does not
/// survive navigation and does not require static global state.
class ErrorFeedbackHost extends StatelessWidget {
  const ErrorFeedbackHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    if (platform == AppPlatform.ios) {
      return _IosErrorFeedbackHost(child: child);
    }

    return _AndroidErrorFeedbackHost(child: child);
  }
}

/// iOS delegate.
///
/// Lightweight bottom banner:
/// - No blur/glass/shadows
/// - No haptics
/// - No celebratory motion
/// - Auto-dismisses quietly
class IosErrorFeedbackDelegate extends ErrorFeedbackDelegate {
  const IosErrorFeedbackDelegate(this._controller);

  final IosErrorFeedbackController _controller;

  @override
  void show(String message) {
    _controller.show(message);
  }
}

/// Android delegate.
///
/// Uses Material SnackBar semantics.
/// Feature code never touches Theme; delegate resolves semantic tokens.
class AndroidErrorFeedbackDelegate extends ErrorFeedbackDelegate {
  const AndroidErrorFeedbackDelegate(this._controller);

  final AndroidErrorFeedbackController _controller;

  @override
  void show(String message) {
    _controller.show(message);
  }
}

class _AndroidErrorFeedbackHost extends StatefulWidget {
  const _AndroidErrorFeedbackHost({required this.child});

  final Widget child;

  @override
  State<_AndroidErrorFeedbackHost> createState() =>
      _AndroidErrorFeedbackHostState();
}

class _AndroidErrorFeedbackHostState extends State<_AndroidErrorFeedbackHost>
    implements AndroidErrorFeedbackController {
  Timer? _timer;
  String? _message;

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  void show(String message) {
    // No queue: replace the previous message silently.
    _timer?.cancel();
    _timer = null;

    if (!mounted) return;
    setState(() => _message = message);

    // Duration from feedback timing tokens — semantic, centrally tunable.
    _timer = Timer(AppFeedbackTiming.errorDisplay, () {
      if (!mounted) return;
      setState(() => _message = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;
    final typography = AppTextStyles.of;
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;

    return ErrorFeedbackScope(
      delegate: AndroidErrorFeedbackDelegate(this),
      child: Stack(
        children: [
          widget.child,

          // Intentionally NO animation.
          // Error feedback must remain visually quiet and page-scoped.
          if (_message != null)
            Positioned(
              left: spacing.lg,
              right: spacing.lg,
              bottom: spacing.lg + MediaQuery.paddingOf(context).bottom,
              child: Semantics(
                liveRegion: true,
                label: 'Error',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.feedbackError,
                    borderRadius: BorderRadius.circular(shape.md),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.md,
                      vertical: spacing.sm,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon(
                          icons.AppIcon.feedbackError,
                          size: AppIconSize.small,
                          colorOverride: colors.textInverse,
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: Text(
                            _message!,
                            style: typography.body.copyWith(
                              color: colors.textInverse,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IosErrorFeedbackHost extends StatefulWidget {
  const _IosErrorFeedbackHost({required this.child});

  final Widget child;

  @override
  State<_IosErrorFeedbackHost> createState() => _IosErrorFeedbackHostState();
}

class _IosErrorFeedbackHostState extends State<_IosErrorFeedbackHost>
    implements IosErrorFeedbackController {
  Timer? _timer;
  String? _message;

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  void show(String message) {
    // No queue: replace the previous message silently.
    _timer?.cancel();
    _timer = null;

    if (!mounted) return;
    setState(() => _message = message);

    // Duration from feedback timing tokens — semantic, centrally tunable.
    _timer = Timer(AppFeedbackTiming.errorDisplay, () {
      if (!mounted) return;
      setState(() => _message = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;
    final typography = AppTextStyles.of;
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;

    return ErrorFeedbackScope(
      delegate: IosErrorFeedbackDelegate(this),
      child: Stack(
        children: [
          widget.child,

          // Intentionally NO animation.
          // This is error feedback (supportive, calm) and must remain visually quiet.
          if (_message != null)
            Positioned(
              left: spacing.lg,
              right: spacing.lg,
              bottom: spacing.lg + MediaQuery.paddingOf(context).bottom,
              child: Semantics(
                liveRegion: true,
                label: 'Error',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.feedbackError,
                    // Shape from tokens — no raw radii allowed.
                    borderRadius: BorderRadius.circular(shape.md),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.md,
                      vertical: spacing.sm,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // AppIcon is the only legal icon renderer.
                        AppIcon(
                          icons.AppIcon.feedbackError,
                          size: AppIconSize.small,
                          colorOverride: colors.textInverse,
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: Text(
                            _message!,
                            style: typography.body.copyWith(
                              color: colors.textInverse,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

abstract class IosErrorFeedbackController {
  void show(String message);
}

abstract class AndroidErrorFeedbackController {
  void show(String message);
}
