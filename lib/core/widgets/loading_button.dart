import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.enabled = true,
    this.height = AppSpacing.buttonHeight - AppSpacing.xs, // 52
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: isLoading || !enabled ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: AppSpacing.iconSizeSmall,
                width: AppSpacing.iconSizeSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Text(label),
      ),
    );
  }
}
