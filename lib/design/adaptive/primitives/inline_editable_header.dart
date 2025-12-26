// @adaptive-composite
// Semantics: Inline editable identity text
// Owns: inline editable text rendering only
// Emits: onEdit intent only
// Must NOT:
//  - open dialogs/sheets
//  - persist data
//  - access services/repositories
//  - show feedback UI
//  - access platform APIs

import 'package:flutter/widgets.dart';

import '../widgets/app_tappable.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_text.dart';
import '../../tokens/icons.dart' as icons;
import '../../tokens/spacing.dart';

/// Reusable inline editable header.
///
/// Feature code owns presentation (sheet/dialog) and persistence.
class InlineEditableHeader extends StatelessWidget {
  const InlineEditableHeader({
    super.key,
    required this.text,
    required this.onEdit,
    this.placeholder = 'Add text',
  });

  final String text;
  final VoidCallback onEdit;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;
    final isEmpty = text.isEmpty;
    final displayText = isEmpty ? placeholder : text;

    return AppTappable(
      onPressed: onEdit,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            displayText,
            variant: AppTextVariant.title,
            color: isEmpty ? AppTextColor.secondary : AppTextColor.primary,
          ),
          SizedBox(width: spacing.sm),
          AppIcon(
            icons.AppIcon.actionEdit,
            size: AppIconSize.small,
            color: isEmpty ? AppIconColor.primary : AppIconColor.secondary,
          ),
        ],
      ),
    );
  }
}
