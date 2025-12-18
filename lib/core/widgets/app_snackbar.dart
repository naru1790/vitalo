import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

/// iOS-style bottom toast notifications with Liquid Glass design.
/// Uses VitaloColors for consistency with theme.dart.
class AppSnackBar {
  AppSnackBar._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;
  static bool _isDismissing = false;

  /// Success notification (green checkmark)
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.checkmark_circle_fill,
      VitaloColors.success.resolveFrom(context),
    );
  }

  /// Error notification (red exclamation)
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.exclamationmark_circle_fill,
      VitaloColors.destructive.resolveFrom(context),
    );
  }

  /// Info notification (blue info)
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.info_circle_fill,
      VitaloColors.accent.resolveFrom(context),
    );
  }

  /// Warning notification (orange warning)
  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.exclamationmark_triangle_fill,
      VitaloColors.warning.resolveFrom(context),
    );
  }

  static void _show(
    BuildContext context,
    String message,
    IconData icon,
    Color accentColor,
  ) {
    // Dismiss any existing toast
    _dismiss();

    // Reset dismissing flag for new toast
    _isDismissing = false;

    final overlay = Overlay.of(context);

    _currentEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        icon: icon,
        accentColor: accentColor,
        onDismiss: _dismiss,
      ),
    );

    overlay.insert(_currentEntry!);

    // Auto-dismiss after 3 seconds
    _dismissTimer = Timer(const Duration(seconds: 3), _dismiss);
  }

  static void _dismiss() {
    // Prevent double-dismiss race condition
    if (_isDismissing) return;
    _isDismissing = true;

    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.message,
    required this.icon,
    required this.accentColor,
    required this.onDismiss,
  });

  final String message;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onDismiss;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isAnimatingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    // Prevent multiple dismiss calls
    if (_isAnimatingOut) return;
    _isAnimatingOut = true;

    // iOS haptic feedback on dismiss
    HapticFeedback.lightImpact();

    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final backgroundColor = VitaloColors.backgroundElevated.resolveFrom(
      context,
    );
    final textColor = CupertinoColors.label.resolveFrom(context);

    return Positioned(
      left: AppSpacing.pageHorizontalPadding,
      right: AppSpacing.pageHorizontalPadding,
      bottom: bottomPadding + AppSpacing.xl,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: _handleDismiss,
            onVerticalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy > 0) {
                _handleDismiss();
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: LiquidGlass.blurMedium,
                  sigmaY: LiquidGlass.blurMedium,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(
                      color: VitaloColors.glassBorder.resolveFrom(context),
                      width: LiquidGlass.borderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withValues(alpha: 0.15),
                        blurRadius: LiquidGlass.shadowBlur,
                        offset: LiquidGlass.shadowOffset,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: AppSpacing.iconSize,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: AppleTextStyles.subhead(
                            context,
                          ).copyWith(color: textColor),
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
        ),
      ),
    );
  }
}
