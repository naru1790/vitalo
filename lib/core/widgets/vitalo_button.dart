import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

enum VitaloButtonVariant { primary, secondary, danger }

class VitaloButton extends StatelessWidget {
  const VitaloButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = VitaloButtonVariant.primary,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final VitaloButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (Color background, Color foreground) = switch (variant) {
      VitaloButtonVariant.primary => (
        colorScheme.primary,
        colorScheme.onPrimary,
      ),
      VitaloButtonVariant.secondary => (
        colorScheme.secondary,
        colorScheme.onSecondary,
      ),
      VitaloButtonVariant.danger => (colorScheme.error, colorScheme.onError),
    };

    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle:
            theme.textTheme.labelLarge ??
            VitaloTypography.lightTextTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: _buildContent(theme.textTheme),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildContent(TextTheme textTheme) {
    if (icon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon!,
        const SizedBox(width: 8),
        Text(label, style: textTheme.labelLarge),
      ],
    );
  }
}
