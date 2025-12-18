import 'package:flutter/cupertino.dart';

import '../theme.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.enabled = true,
    this.height = AppSpacing.buttonHeight,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final isDisabled = isLoading || !enabled;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        color: isDisabled ? primaryColor.withValues(alpha: 0.5) : primaryColor,
        onPressed: isDisabled ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : Text(
                label,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
