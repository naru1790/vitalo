/// ═══════════════════════════════════════════════════════════════════════════
/// DESIGN SYSTEM BARREL EXPORT — PUBLIC API BOUNDARY
/// ═══════════════════════════════════════════════════════════════════════════
///
/// This is the ONLY file that feature code should import from the design layer.
///
/// ┌──────────────────────────────────────────────────────────────────────────┐
/// │                     ARCHITECTURAL CONTRACT                               │
/// ├──────────────────────────────────────────────────────────────────────────┤
/// │  • Feature code MUST import 'package:vitalo/design/design.dart'          │
/// │  • Feature code MUST NOT import flutter/material.dart directly           │
/// │  • Feature code MUST NOT import flutter/cupertino.dart directly          │
/// │  • Feature code MUST NOT import internal design files directly           │
/// │  • All framework widgets are wrapped by adaptive primitives below        │
/// └──────────────────────────────────────────────────────────────────────────┘
///
/// The adaptive layer consumes raw platform primitives (Material/Cupertino)
/// and transforms them into semantic, cross-platform components. Features
/// consume these adaptive primitives and are shielded from platform details.
///
/// WHAT'S EXPORTED:
/// • Scopes — AppColorScope, AppPlatformScope, NavMotionScope
/// • Primitives — AppText, AppButton, AppScaffold, etc.
/// • Tokens — Spacing, AppTextStyles, AppShape, etc.
/// • Illustrations — FluxMascotPalettes
///
/// WHAT'S NOT EXPORTED (internal only):
/// • AdaptiveShell — only main.dart should touch this
/// • Platform shells (IosShell, AndroidShell) — internal to adaptive layer
/// • TokenEnvironment — initialized by AdaptiveShell only
/// • Raw color definitions — use resolved tokens only
///
library design;

// ═══════════════════════════════════════════════════════════════════════════
// SCOPES — Context providers for adaptive data
// ═══════════════════════════════════════════════════════════════════════════

export 'adaptive/platform/app_color_scope.dart' show AppColorScope;
export 'adaptive/platform/app_platform_scope.dart' show AppPlatformScope;
export 'adaptive/nav_motion.dart' show NavMotionScope;

// ═══════════════════════════════════════════════════════════════════════════
// PRIMITIVES — Adaptive widgets for feature consumption
// ═══════════════════════════════════════════════════════════════════════════

export 'adaptive/widgets/app_binary_segmented_control.dart';
export 'adaptive/widgets/app_button.dart';
export 'adaptive/widgets/app_bottom_sheet.dart';
export 'adaptive/widgets/app_divider.dart';
export 'adaptive/widgets/app_choice_chip.dart';
export 'adaptive/widgets/app_editable_pill.dart';
export 'adaptive/widgets/app_focus_hero_icon.dart';
export 'adaptive/widgets/app_height_picker.dart';
export 'adaptive/widgets/app_icon.dart';
export 'adaptive/widgets/app_icon_button.dart';
export 'adaptive/widgets/app_list_tile.dart';
export 'adaptive/widgets/app_otp_input.dart';
export 'adaptive/widgets/app_otp_resend_action.dart';
export 'adaptive/widgets/app_page_body.dart';
export 'adaptive/widgets/app_surface_body.dart';
export 'adaptive/widgets/app_scaffold.dart';
export 'adaptive/widgets/app_text.dart';
export 'adaptive/widgets/app_text_field.dart';
export 'adaptive/widgets/app_tappable.dart';
export 'adaptive/widgets/app_toggle.dart';
export 'adaptive/widgets/app_waist_picker.dart';
export 'adaptive/widgets/app_weight_picker.dart';
export 'adaptive/widgets/app_wheel_picker.dart';
export 'adaptive/widgets/app_labeled_binary_choice.dart';
export 'adaptive/widgets/auth_action_stack.dart';
export 'adaptive/widgets/auth_footer_links.dart';
export 'adaptive/widgets/auth_sign_in_button.dart';
export 'adaptive/widgets/flux_mascot.dart';
export 'adaptive/widgets/inline_feedback_message.dart';
export 'adaptive/widgets/keyboard_dismiss_surface.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PAGE ARCHETYPES — Semantic page wrappers encoding layout contracts
// ═══════════════════════════════════════════════════════════════════════════

export 'adaptive/pages/centered_focus_page.dart';
export 'adaptive/pages/document_page.dart';
export 'adaptive/pages/hub_page.dart';
export 'adaptive/pages/sheet_page.dart';
export 'adaptive/pages/stage_page.dart';

// ═══════════════════════════════════════════════════════════════════════════
// COMPOSITE PRIMITIVES — Higher-level adaptive building blocks
// ═══════════════════════════════════════════════════════════════════════════

export 'adaptive/primitives/app_gender_selector.dart';
export 'adaptive/models/app_unit_system.dart';
export 'adaptive/primitives/app_unit_system_selector.dart';
export 'adaptive/primitives/app_searchable_list_picker.dart';
export 'adaptive/primitives/app_section.dart';
export 'adaptive/primitives/app_surface.dart';
export 'adaptive/primitives/app_year_picker.dart';
export 'adaptive/primitives/app_year_picker_sheet.dart';
export 'adaptive/primitives/inline_editable_header.dart';
export 'adaptive/primitives/profile_identity_header.dart';

// ═══════════════════════════════════════════════════════════════════════════
// DOCUMENT PRIMITIVES — Content composites for DocumentPage
// ═══════════════════════════════════════════════════════════════════════════

export 'document/app_document_section.dart';

// ═══════════════════════════════════════════════════════════════════════════
// TOKENS — Design tokens for layout, typography, shape, motion
// ═══════════════════════════════════════════════════════════════════════════

export 'tokens/spacing.dart' show Spacing;
export 'tokens/typography.dart' show AppTextStyles;
export 'tokens/shape.dart' show AppShape, AppShapeTokens;
export 'tokens/motion.dart' show AppMotion;
export 'tokens/opacity.dart' show AppOpacity;
export 'tokens/elevation.dart' show AppElevation;
export 'tokens/icon_ids.dart' show AppIconId;
export 'tokens/icons.dart' show AppIcons;

// ═══════════════════════════════════════════════════════════════════════════
// ILLUSTRATIONS — Semantic illustration palettes
// ═══════════════════════════════════════════════════════════════════════════

export 'tokens/illustration/flux_mascot_palette.dart' show FluxMascotPalettes;

// ═══════════════════════════════════════════════════════════════════════════
// ERROR FEEDBACK — Platform-adaptive feedback utilities
// ═══════════════════════════════════════════════════════════════════════════

export 'adaptive/error_feedback.dart';
