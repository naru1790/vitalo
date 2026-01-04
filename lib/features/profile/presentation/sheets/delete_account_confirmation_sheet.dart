import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../../../../design/design.dart';

/// Sheet content for confirming account deletion.
///
/// Contract:
/// - Summary-only UI.
/// - Emits `true` when confirmed, otherwise `false`.
/// - Does not perform deletion; feature code owns the operation.
class DeleteAccountConfirmationSheet extends StatefulWidget {
  const DeleteAccountConfirmationSheet({super.key});

  @override
  State<DeleteAccountConfirmationSheet> createState() =>
      _DeleteAccountConfirmationSheetState();
}

class _DeleteAccountConfirmationSheetState
    extends State<DeleteAccountConfirmationSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validate);
  }

  void _validate() {
    final isValid = _controller.text.trim().toUpperCase() == 'DELETE';
    if (isValid != _isValid) {
      setState(() => _isValid = isValid);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_validate)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _confirm() => Navigator.pop(context, true);
  void _cancel() => Navigator.pop(context, false);

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
              'Delete Account',
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ],
        ),
        SizedBox(height: spacing.sm),
        const AppText(
          'This will permanently delete your account and all data. This action cannot be undone.',
          variant: AppTextVariant.body,
          color: AppTextColor.secondary,
        ),
        SizedBox(height: spacing.lg),
        const AppText(
          'Type DELETE to confirm',
          variant: AppTextVariant.caption,
          color: AppTextColor.secondary,
        ),
        SizedBox(height: spacing.sm),
        AppTextField(
          controller: _controller,
          focusNode: _focusNode,
          placeholder: 'DELETE',
          textInputAction: TextInputAction.done,
          onSubmitted: _isValid ? _confirm : null,
        ),
        SizedBox(height: spacing.lg),
        AppButton(
          label: 'Delete Account',
          variant: AppButtonVariant.destructive,
          enabled: _isValid,
          onPressed: _confirm,
        ),
        SizedBox(height: spacing.sm),
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: _cancel,
        ),
      ],
    );
  }
}
