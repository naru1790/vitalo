import 'package:flutter/widgets.dart';

import '../../../design/design.dart';
import '../pickers/display_name/display_name_edit_sheet.dart';

// @frozen
// Flows: Identity (Display Name)
// Owns: modal presentation only (AppBottomSheet.show)
// Emits: edited values via Navigator.pop
// Must NOT: render UI, access services/repositories, show feedback UI

/// Navigation entrypoints for Identity editing flows (avatar/name/email).
abstract final class IdentityFlows {
  IdentityFlows._();

  static Future<String?> editDisplayName({
    required BuildContext context,
    required String initialText,
    required Future<bool> Function(String newText) onSave,
    String placeholder = 'Add name',
  }) {
    return AppBottomSheet.show<String>(
      context,
      sheet: SheetPage(
        child: DisplayNameEditSheet(
          initialText: initialText,
          placeholder: placeholder,
          onSave: onSave,
        ),
      ),
    );
  }
}
