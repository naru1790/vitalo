// @adaptive-composite
// Semantics: Profile identity header
// Owns: avatar + display name (editable) + email display
// Emits: onDisplayNameSave callback only
// Must NOT:
//  - contain platform detection logic
//  - apply page-level padding (owned by HubPage)
//  - include navigation affordances
//  - manage scroll behavior
//  - access authentication or user services directly
//  - render success/error/toast/snackbar/dialog feedback
//  - add tap or gesture behavior to the avatar

import 'package:flutter/widgets.dart';

import '../platform/app_color_scope.dart';
import '../widgets/app_text.dart';
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';
import 'inline_editable_header.dart';

/// Profile identity header primitive.
///
/// Displays user identity: avatar, display name, and optional email.
/// Supports inline editing of the display name.
///
/// This primitive owns:
/// - Avatar circle with initial (non-interactive)
/// - Display name with edit affordance
/// - Email subtitle (read-only)
/// - Internal vertical spacing
///
/// This primitive does NOT own:
/// - Page padding (owned by HubPage)
/// - Platform-specific styling (delegated to child primitives)
/// - Navigation or back actions
/// - User data fetching or persistence
/// - Success/error feedback UI
///
/// The avatar is purely visual — no tap or gesture behavior is allowed.
///
/// Feature code provides data and callbacks only.
/// Rendering is owned by this primitive.
class ProfileIdentityHeader extends StatelessWidget {
  const ProfileIdentityHeader({
    super.key,
    required this.displayName,
    required this.email,
    required this.avatarInitial,
    required this.onDisplayNameSave,
  });

  /// The user's display name.
  ///
  /// Shown prominently and editable inline.
  final String displayName;

  /// The user's email address.
  ///
  /// Shown as a subtitle beneath the display name.
  /// May be null if email is not available.
  final String? email;

  /// The initial character for the avatar.
  ///
  /// Typically the first letter of the display name.
  /// Used when no profile image is available.
  final String avatarInitial;

  /// Callback invoked when the user saves a new display name.
  ///
  /// Returns true if the save succeeded, false otherwise.
  /// This primitive does not render feedback based on the result.
  final Future<bool> Function(String) onDisplayNameSave;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;
    final spacing = Spacing.of;
    final shape = AppShapeTokens.of;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar — non-interactive
        Container(
          width: spacing.xxl,
          height: spacing.xxl,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(shape.full),
            color: colors.neutralSurface,
            border: Border.all(
              color: colors.brandPrimary,
              width: shape.strokeVisible,
            ),
          ),
          child: Center(
            child: AppText(
              avatarInitial,
              variant: AppTextVariant.title,
              color: AppTextColor.primary,
            ),
          ),
        ),

        SizedBox(height: spacing.md),

        // Display name with inline edit
        InlineEditableHeader(
          initialText: displayName,
          onSave: onDisplayNameSave,
          placeholder: 'Add name',
        ),

        // Email subtitle
        if (email != null && email!.isNotEmpty) ...[
          SizedBox(height: spacing.xs),
          AppText(
            email!,
            variant: AppTextVariant.caption,
            color: AppTextColor.secondary,
          ),
        ],
      ],
    );
  }
}
