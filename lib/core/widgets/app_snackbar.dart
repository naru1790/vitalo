import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

/// iOS-style toast notifications with Liquid Glass design.
/// Uses floating snackbar on Android, could be extended to use
/// overlay banners on iOS for more native feel.
class AppSnackBar {
  AppSnackBar._();

  /// Success notification (green checkmark)
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.checkmark_circle,
      const Color(0xFF34C759), // iOS system green
    );
  }

  /// Error notification (red exclamation)
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.exclamationmark_circle,
      const Color(0xFFFF3B30), // iOS system red
    );
  }

  /// Info notification (blue info)
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.info_circle,
      const Color(0xFF007AFF), // iOS system blue
    );
  }

  /// Warning notification (orange warning)
  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message,
      CupertinoIcons.exclamationmark_triangle,
      const Color(0xFFFF9500), // iOS system orange
    );
  }

  static void _show(
    BuildContext context,
    String message,
    IconData icon,
    Color accentColor,
  ) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;

    // iOS-style glass background
    final backgroundColor = isDark
        ? const Color(0xFF2C2C2E).withValues(alpha: 0.9) // iOS dark elevated
        : const Color(0xFFFFFFFF).withValues(alpha: 0.9); // iOS light
    final textColor = isDark ? CupertinoColors.white : CupertinoColors.black;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ClipRRect(
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
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF38383A)
                      : const Color(0xFFD1D1D6),
                  width: LiquidGlass.borderWidth,
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: accentColor, size: AppSpacing.iconSize),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15, // iOS Subhead
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: CupertinoColors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontalPadding,
          vertical: AppSpacing.md,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
