import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Reusable inline editable header - tap to edit in bottom sheet.
///
/// Clean, fixed layout - no inline resizing or shifting.
class InlineEditableHeader extends StatefulWidget {
  const InlineEditableHeader({
    super.key,
    required this.initialText,
    required this.onSave,
    this.placeholder = 'Add text',
    this.fontSize = AppSpacing.iconSize - 2,
  });

  final String initialText;
  final Future<bool> Function(String newText) onSave;
  final String placeholder;
  final double fontSize;

  @override
  State<InlineEditableHeader> createState() => _InlineEditableHeaderState();
}

class _InlineEditableHeaderState extends State<InlineEditableHeader> {
  late String _currentText;

  @override
  void initState() {
    super.initState();
    _currentText = widget.initialText;
  }

  @override
  void didUpdateWidget(InlineEditableHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText) {
      _currentText = widget.initialText;
    }
  }

  void _openEditSheet() {
    talker.info('Inline header edit sheet opened');
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditSheet(
        initialText: _currentText,
        placeholder: widget.placeholder,
        onSave: widget.onSave,
      ),
    ).then((result) {
      if (result != null && mounted) {
        setState(() => _currentText = result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEmpty = _currentText.isEmpty;

    final textColor = isDark ? AppColors.darkOnSurface : AppColors.onSurface;
    final subtleColor = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.onSurfaceVariant;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    final textStyle = GoogleFonts.poppins(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w600,
      color: isEmpty ? subtleColor : textColor,
      height: 1.0,
    );

    final displayText = isEmpty ? widget.placeholder : _currentText;

    return GestureDetector(
      onTap: () {
        talker.info('Name tapped - opening edit sheet');
        _openEditSheet();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.iconSize + 2,
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Centered name
            Text(
              displayText,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Icon positioned to the right, outside of text
            Positioned(
              right: -(AppSpacing.iconSize + 2),
              child: Icon(
                Icons.edit_outlined,
                size: AppSpacing.md,
                color: isEmpty ? primaryColor : subtleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet for editing
class _EditSheet extends StatefulWidget {
  const _EditSheet({
    required this.initialText,
    required this.placeholder,
    required this.onSave,
  });

  final String initialText;
  final String placeholder;
  final Future<bool> Function(String) onSave;

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newText = _controller.text.trim();
    if (newText.isEmpty || newText == widget.initialText) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await widget.onSave(newText);
      if (!mounted) return;

      if (success) {
        talker.info('Header saved successfully');
        Navigator.pop(context, newText);
      } else {
        setState(() => _isSaving = false);
      }
    } catch (e, stack) {
      talker.error('Header save failed', e, stack);
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.md),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: AppSpacing.xxxl,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant.withValues(alpha: 0.3)
                      : AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Text field
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              style: GoogleFonts.poppins(
                fontSize: AppSpacing.lg,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cardRadiusSmall,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cardRadiusSmall,
                  ),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Save button
            SizedBox(
              height: AppSpacing.huge,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: AppSpacing.iconSizeSmall,
                        height: AppSpacing.iconSizeSmall,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
