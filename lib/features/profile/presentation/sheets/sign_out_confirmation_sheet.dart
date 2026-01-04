import 'package:flutter/widgets.dart';

import '../../../../design/design.dart';

/// Sheet content for confirming sign out.
///
/// Returns `true` when confirmed, `false` when cancelled.
class SignOutConfirmationSheet extends StatelessWidget {
  const SignOutConfirmationSheet({super.key});

  void _confirm(BuildContext context) => Navigator.pop(context, true);
  void _cancel(BuildContext context) => Navigator.pop(context, false);

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'Sign Out',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.sm),
        const AppText(
          'Are you sure you want to sign out of your account?',
          variant: AppTextVariant.body,
          color: AppTextColor.secondary,
        ),
        SizedBox(height: spacing.lg),
        AppButton(
          label: 'Sign Out',
          variant: AppButtonVariant.destructive,
          onPressed: () => _confirm(context),
        ),
        SizedBox(height: spacing.sm),
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: () => _cancel(context),
        ),
      ],
    );
  }
}
