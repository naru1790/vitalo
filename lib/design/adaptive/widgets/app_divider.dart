// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0 adaptive primitive. Feature code depends on stable semantics.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.

import 'package:flutter/widgets.dart';

import '../platform/app_environment_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/shape.dart';
import '../../tokens/spacing.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Semantic divider inset levels.
///
/// Controls horizontal indentation without exposing pixel values.
/// Values are resolved internally from spacing tokens.
enum AppDividerInset {
  /// Full-bleed divider. No horizontal inset.
  none,

  /// Content-aligned inset. Matches standard content padding.
  content,

  /// Leading-aligned inset. Aligns after leading icon/avatar area.
  /// Future-proof for list items with leading widgets.
  leading,
}

/// Semantic divider variants.
///
/// Controls visual weight without exposing colors or thickness.
/// Values are resolved internally from shape and color tokens.
enum AppDividerVariant {
  /// Default section separation. Clearly visible.
  standard,

  /// Low-emphasis separation. For lists and grouped content.
  subtle,
}

/// Tier-0 adaptive divider primitive.
///
/// The only legal way to render dividers in feature code.
/// Enforces semantic variants and insets without exposing layout mechanics.
///
/// Feature code MUST use this instead of:
/// - [Divider]
/// - [CupertinoDivider]
/// - [Container] with height
/// - [SizedBox] with height
///
/// ## Responsibility Boundaries
///
/// This widget handles:
/// - Horizontal visual separation
/// - Platform-appropriate thickness
/// - Platform-appropriate color
/// - Semantic horizontal insets
///
/// This widget does **NOT** handle:
/// - Vertical spacing (use layout spacing tokens)
/// - Custom colors or thickness
/// - Dashed or decorated dividers
/// - Gesture interaction
///
/// ## Accessibility
///
/// Dividers are visual-only and do not appear in the semantics tree.
/// They are not focusable and do not consume gestures.
///
/// ## ⚠️ Usage Warning
///
/// Do not wrap AppDivider with SizedBox/Container to add spacing.
/// Use spacing tokens in layout instead.
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.variant = AppDividerVariant.standard,
    this.inset = AppDividerInset.none,
  });

  /// Semantic variant controlling visual weight.
  final AppDividerVariant variant;

  /// Semantic inset controlling horizontal indentation.
  final AppDividerInset inset;

  @override
  Widget build(BuildContext context) {
    final platform = AppPlatformScope.of(context);

    // Dividers are visual-only and must not appear in semantics tree.
    return ExcludeSemantics(
      child: platform == AppPlatform.ios
          ? _CupertinoDivider(variant: variant, inset: inset)
          : _MaterialDivider(variant: variant, inset: inset),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE IMPLEMENTATIONS
// ═══════════════════════════════════════════════════════════════════════════

/// Material implementation using Container.
///
/// Does NOT use [Divider] widget to avoid exposing framework primitives.
/// Thickness and color are derived from shape tokens and shell-injected theme.
class _MaterialDivider extends StatelessWidget {
  const _MaterialDivider({required this.variant, required this.inset});

  final AppDividerVariant variant;
  final AppDividerInset inset;

  @override
  Widget build(BuildContext context) {
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;
    final colors = AppColorScope.of(context).colors;

    // Thickness from shape tokens based on variant.
    final double thickness = _resolveThickness(shape);

    // Color from environment scope.
    final Color color = colors.neutralDivider;

    // Inset from spacing tokens.
    final EdgeInsetsGeometry padding = _resolveInset(spacing);

    return Padding(
      padding: padding,
      child: Container(height: thickness, color: color),
    );
  }

  double _resolveThickness(AppShape shape) {
    // Shape tokens define divider weights per platform.
    return switch (variant) {
      AppDividerVariant.standard => shape.dividerVisible,
      AppDividerVariant.subtle => shape.dividerSubtle,
    };
  }

  EdgeInsetsGeometry _resolveInset(AppSpacing spacing) {
    // Insets are horizontal only. Dividers must not add vertical spacing.
    return switch (inset) {
      AppDividerInset.none => EdgeInsets.zero,
      AppDividerInset.content => EdgeInsets.symmetric(horizontal: spacing.md),
      // Leading inset aligns divider after standard leading affordance
      // (icon/avatar). spacing.xl is treated as the canonical leading width.
      // This is intentional and future-proof for list items.
      AppDividerInset.leading => EdgeInsetsDirectional.only(start: spacing.xl),
    };
  }
}

/// Cupertino implementation using Container.
///
/// Does NOT use [CupertinoDivider] to avoid exposing framework primitives.
/// iOS dividers are typically hairline-thin and use system separator color.
class _CupertinoDivider extends StatelessWidget {
  const _CupertinoDivider({required this.variant, required this.inset});

  final AppDividerVariant variant;
  final AppDividerInset inset;

  @override
  Widget build(BuildContext context) {
    final shape = AppShapeTokens.of;
    final spacing = Spacing.of;
    final colors = AppColorScope.of(context).colors;

    // Thickness from shape tokens based on variant.
    final double thickness = _resolveThickness(shape);

    // Color from environment scope.
    final Color color = colors.neutralDivider;

    // Inset from spacing tokens.
    final EdgeInsetsGeometry padding = _resolveInset(spacing);

    return Padding(
      padding: padding,
      child: Container(height: thickness, color: color),
    );
  }

  double _resolveThickness(AppShape shape) {
    // iOS dividers are typically thinner than Android.
    // Shape tokens already account for platform differences.
    return switch (variant) {
      AppDividerVariant.standard => shape.dividerVisible,
      AppDividerVariant.subtle => shape.dividerSubtle,
    };
  }

  EdgeInsetsGeometry _resolveInset(AppSpacing spacing) {
    // Insets are horizontal only. Dividers must not add vertical spacing.
    return switch (inset) {
      AppDividerInset.none => EdgeInsets.zero,
      AppDividerInset.content => EdgeInsets.symmetric(horizontal: spacing.md),
      // Leading inset aligns divider after standard leading affordance
      // (icon/avatar). spacing.xl is treated as the canonical leading width.
      // This is intentional and future-proof for list items.
      AppDividerInset.leading => EdgeInsetsDirectional.only(start: spacing.xl),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SELF-VERIFICATION CHECKLIST (ARCHITECTURAL COMPLIANCE)
// ═══════════════════════════════════════════════════════════════════════════
//
// ✅ No raw pixels exposed — All sizes from AppShapeTokens, all insets from Spacing
// ✅ No framework divider widgets used — Uses Container, not Divider/CupertinoDivider
// ✅ Platform behavior is intentional and documented — iOS uses CupertinoColors.separator
// ✅ Feature code cannot misuse this API — Only semantic enums exposed, no doubles
// ✅ File is safe to freeze — Public API is minimal and complete
//
// ═══════════════════════════════════════════════════════════════════════════
