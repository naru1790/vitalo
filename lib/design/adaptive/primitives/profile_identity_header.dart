// @frozen
// PRIMITIVE: PROFILE IDENTITY HEADER
// ═══════════════════════════════════════════════════════════════════════════
//
// ProfileIdentityHeader — communicates user identity and allows inline
// editing of display name.
//
// This primitive exists to present the user's identity at the top of
// profile-style hub screens. It owns the avatar, display name, and
// optional email display.
//
// ProfileIdentityHeader OWNS:
// - Avatar rendering (initial-based circle, non-interactive)
// - Display name presentation with inline edit affordance
// - Email display (read-only)
// - Internal spacing between identity elements
//
// ProfileIdentityHeader MUST NOT:
// - Contain platform detection logic
// - Apply page-level padding (owned by page archetype)
// - Include navigation affordances
// - Manage scroll behavior
// - Access authentication or user services directly
// - Render success/error/toast/snackbar/dialog feedback
// - Add tap or gesture behavior to the avatar
//
// The primitive only invokes onDisplayNameSave.
// It does not render success, error, or any feedback UI.
// Feedback is the responsibility of higher-level orchestration.
//
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/widgets.dart';

import '../../../core/widgets/inline_editable_header.dart';
import '../platform/app_color_scope.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shape.dart';
import '../widgets/app_text.dart';

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
