import 'dart:ui';

import 'package:flutter/cupertino.dart';

// ═══════════════════════════════════════════════════════════════════════════
// VITALO THEME - iOS 26 Liquid Glass Design System
// Pure Cupertino implementation following Apple Human Interface Guidelines
//
// Philosophy:
// • Clarity — Content is paramount, negative space guides focus
// • Deference — Fluid motion and crisp interface serve content
// • Depth — Visual layers and realistic motion convey hierarchy
// • Vibrancy — Bright, energetic colors that pop on glass surfaces
//
// Design Language:
// • Liquid Glass — Translucent surfaces with blur and vibrancy
// • Dynamic Colors — CupertinoDynamicColor for automatic light/dark
// • SF Pro Typography — Apple's native typeface with precise metrics
// • 4pt/8pt Grid — iOS standard spacing system
// ═══════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════
// VITALO COLORS - Apple HIG Dynamic Color System
// ═══════════════════════════════════════════════════════════════════════════
//
// Apple HIG Color Categories:
// • Label Colors — For text (label, secondaryLabel, tertiaryLabel, quaternaryLabel)
// • Fill Colors — For UI elements (systemFill, secondarySystemFill, etc.)
// • Background Colors — For layered surfaces (systemBackground, secondarySystemBackground)
// • Separator Colors — For dividers (separator, opaqueSeparator)
// • Tint Colors — Brand/accent colors (systemBlue, systemOrange, etc.)
//
// Usage:
//   VitaloColors.accent.resolveFrom(context)
//   VitaloColors.success.resolveFrom(context)
// ═══════════════════════════════════════════════════════════════════════════

/// Vitalo's brand colors following Apple HIG dynamic color pattern.
/// All colors automatically adapt to light/dark mode and accessibility settings.
abstract class VitaloColors {
  VitaloColors._();

  // ─────────────────────────────────────────────────────────────────────────
  // BRAND TINT COLORS (Primary UI Accent)
  // ─────────────────────────────────────────────────────────────────────────

  /// Primary accent color — Vibrant Orange (Energy & Vitality)
  /// Use for: Primary buttons, links, active states, brand identity
  static const CupertinoDynamicColor accent =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFF97316), // Orange 500 - Bright brand
        darkColor: Color(0xFFFB923C), // Orange 400 - Pops on dark
      );

  /// Secondary accent — Vibrant Pink (Fresh & Modern)
  /// Use for: Secondary actions, highlights, decorative elements
  static const CupertinoDynamicColor accentSecondary =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFEC4899), // Pink 500
        darkColor: Color(0xFFF472B6), // Pink 400
      );

  /// Tertiary accent — Cyan (Cool Balance)
  /// Use for: Success states, positive feedback, health indicators
  static const CupertinoDynamicColor accentTertiary =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFF06B6D4), // Cyan 500
        darkColor: Color(0xFF22D3EE), // Cyan 400
      );

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC COLORS (System Feedback)
  // ─────────────────────────────────────────────────────────────────────────

  /// Success — Positive outcomes, completed actions
  static const CupertinoDynamicColor success =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFF22C55E), // Green 500
        darkColor: Color(0xFF4ADE80), // Green 400
      );

  /// Warning — Caution, attention needed
  static const CupertinoDynamicColor warning =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFF59E0B), // Amber 500
        darkColor: Color(0xFFFBBF24), // Amber 400
      );

  /// Destructive — Errors, delete actions, critical alerts
  static const CupertinoDynamicColor destructive =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFEF4444), // Red 500
        darkColor: Color(0xFFF87171), // Red 400
      );

  // ─────────────────────────────────────────────────────────────────────────
  // BACKGROUND COLORS (Layered Surfaces - Apple HIG)
  // ─────────────────────────────────────────────────────────────────────────

  /// Primary background — Base canvas (fullscreen views)
  static const CupertinoDynamicColor background =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFFFFFF), // Pure white
        darkColor: Color(0xFF000000), // Pure black (OLED friendly)
      );

  /// Secondary background — Grouped content (cards, sections)
  static const CupertinoDynamicColor backgroundSecondary =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFF2F2F7), // iOS system gray 6
        darkColor: Color(0xFF1C1C1E), // iOS elevated dark
      );

  /// Tertiary background — Nested content within groups
  static const CupertinoDynamicColor backgroundTertiary =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFFFFFF), // White on gray
        darkColor: Color(0xFF2C2C2E), // Elevated dark
      );

  /// Elevated background — Modals, sheets, popovers
  static const CupertinoDynamicColor backgroundElevated =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFFFFFF), // Pure white
        darkColor: Color(0xFF1C1C1E), // Elevated dark surface
      );

  // ─────────────────────────────────────────────────────────────────────────
  // FILL COLORS (Interactive Elements - Apple HIG)
  // ─────────────────────────────────────────────────────────────────────────

  /// System fill — For thin/small elements (switches, sliders)
  static const CupertinoDynamicColor fill =
      CupertinoDynamicColor.withBrightness(
        color: Color(0x33787880), // 20% gray
        darkColor: Color(0x5C787880), // 36% gray
      );

  /// Secondary fill — For medium elements (text fields, buttons)
  static const CupertinoDynamicColor fillSecondary =
      CupertinoDynamicColor.withBrightness(
        color: Color(0x29787880), // 16% gray
        darkColor: Color(0x52787880), // 32% gray
      );

  /// Tertiary fill — For large elements (cards, wells)
  static const CupertinoDynamicColor fillTertiary =
      CupertinoDynamicColor.withBrightness(
        color: Color(0x1F787880), // 12% gray
        darkColor: Color(0x3D787880), // 24% gray
      );

  /// Quaternary fill — For extra large elements
  static const CupertinoDynamicColor fillQuaternary =
      CupertinoDynamicColor.withBrightness(
        color: Color(0x14787880), // 8% gray
        darkColor: Color(0x2E787880), // 18% gray
      );

  // ─────────────────────────────────────────────────────────────────────────
  // SEPARATOR & BORDER COLORS
  // ─────────────────────────────────────────────────────────────────────────

  /// Separator — For lines between content (translucent)
  static const CupertinoDynamicColor separator =
      CupertinoDynamicColor.withBrightness(
        color: Color(0x4D3C3C43), // 30% opacity
        darkColor: Color(0x99545458), // 60% opacity
      );

  /// Opaque separator — For lines that don't show content beneath
  static const CupertinoDynamicColor separatorOpaque =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFC6C6C8),
        darkColor: Color(0xFF38383A),
      );

  /// Glass border — Subtle edge for Liquid Glass surfaces
  static const CupertinoDynamicColor glassBorder =
      CupertinoDynamicColor.withBrightness(
        color: Color(0x33FFFFFF), // 20% white
        darkColor: Color(0x33FFFFFF), // 20% white (edge glow)
      );

  // ─────────────────────────────────────────────────────────────────────────
  // ACCENT CONTAINERS (Soft backgrounds for accent colors)
  // ─────────────────────────────────────────────────────────────────────────

  /// Accent container — Soft orange background for accent content
  static const CupertinoDynamicColor accentContainer =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFFF7ED), // Orange 50
        darkColor: Color(0xFF7C2D12), // Orange 900
      );

  /// Secondary container — Soft pink background
  static const CupertinoDynamicColor secondaryContainer =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFDF2F8), // Pink 50
        darkColor: Color(0xFF9D174D), // Pink 800
      );

  /// Tertiary container — Soft cyan background
  static const CupertinoDynamicColor tertiaryContainer =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFECFEFF), // Cyan 50
        darkColor: Color(0xFF0E7490), // Cyan 700
      );

  /// Success container — Soft green background
  static const CupertinoDynamicColor successContainer =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFF0FDF4), // Green 50
        darkColor: Color(0xFF166534), // Green 800
      );

  /// Warning container — Soft amber background
  static const CupertinoDynamicColor warningContainer =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFFFBEB), // Amber 50
        darkColor: Color(0xFF92400E), // Amber 800
      );

  /// Destructive container — Soft red background
  static const CupertinoDynamicColor destructiveContainer =
      CupertinoDynamicColor.withBrightness(
        color: Color(0xFFFEF2F2), // Red 50
        darkColor: Color(0xFF991B1B), // Red 800
      );

  // ─────────────────────────────────────────────────────────────────────────
  // LABEL COLORS (Text - Apple HIG)
  // ─────────────────────────────────────────────────────────────────────────

  /// Primary label — Main text content
  static const CupertinoDynamicColor label = CupertinoColors.label;

  /// Secondary label — Subtitles, descriptions
  static const CupertinoDynamicColor labelSecondary =
      CupertinoColors.secondaryLabel;

  /// Tertiary label — Placeholder text, disabled text
  static const CupertinoDynamicColor labelTertiary =
      CupertinoColors.tertiaryLabel;

  /// Quaternary label — Watermarks, very subtle text
  static const CupertinoDynamicColor labelQuaternary =
      CupertinoColors.quaternaryLabel;
}

// ═══════════════════════════════════════════════════════════════════════════
// VITALO TEXT STYLES - Apple HIG Typography (SF Pro)
// ═══════════════════════════════════════════════════════════════════════════
//
// Apple Typography Scale (SF Pro):
// ┌──────────────┬──────────┬────────────┬──────────────┐
// │ Style        │ Size(pt) │ Weight     │ Letter Space │
// ├──────────────┼──────────┼────────────┼──────────────┤
// │ Large Title  │ 34       │ Bold       │ 0.37         │
// │ Title 1      │ 28       │ Bold       │ 0.36         │
// │ Title 2      │ 22       │ Bold       │ 0.35         │
// │ Title 3      │ 20       │ Semibold   │ 0.38         │
// │ Headline     │ 17       │ Semibold   │ -0.41        │
// │ Body         │ 17       │ Regular    │ -0.41        │
// │ Callout      │ 16       │ Regular    │ -0.32        │
// │ Subhead      │ 15       │ Regular    │ -0.24        │
// │ Footnote     │ 13       │ Regular    │ -0.08        │
// │ Caption 1    │ 12       │ Regular    │ 0            │
// │ Caption 2    │ 11       │ Regular    │ 0.07         │
// └──────────────┴──────────┴────────────┴──────────────┘
//
// Usage:
//   Text('Title', style: VitaloTextStyles.largeTitle(context))
//   Text('Body', style: VitaloTextStyles.body(context))
//   Text('Muted', style: VitaloTextStyles.bodySecondary(context))
// ═══════════════════════════════════════════════════════════════════════════

/// Apple HIG Typography styles using SF Pro (system font on iOS).
/// All methods accept BuildContext for dynamic color resolution.
abstract class VitaloTextStyles {
  VitaloTextStyles._();

  // ─────────────────────────────────────────────────────────────────────────
  // DISPLAY & TITLE STYLES (CupertinoColors.label)
  // ─────────────────────────────────────────────────────────────────────────

  /// Large Title — 34pt Bold
  /// Use for: Main screen titles, hero text
  static TextStyle largeTitle(BuildContext context) => TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.37,
    height: 1.2,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Title 1 — 28pt Bold
  /// Use for: Section headers, important headings
  static TextStyle title1(BuildContext context) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.36,
    height: 1.2,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Title 2 — 22pt Bold
  /// Use for: Subsection headers, card titles
  static TextStyle title2(BuildContext context) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.35,
    height: 1.25,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Title 3 — 20pt Semibold
  /// Use for: Smaller headers, group titles
  static TextStyle title3(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    height: 1.25,
    color: CupertinoColors.label.resolveFrom(context),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // BODY STYLES (CupertinoColors.label)
  // ─────────────────────────────────────────────────────────────────────────

  /// Headline — 17pt Semibold
  /// Use for: Emphasized body text, list item titles
  static TextStyle headline(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.3,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Body — 17pt Regular
  /// Use for: Primary reading content, paragraphs
  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Callout — 16pt Regular
  /// Use for: Secondary content, supporting text
  static TextStyle callout(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.35,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Subhead — 15pt Regular
  /// Use for: Tertiary content, metadata
  static TextStyle subhead(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.35,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Footnote — 13pt Regular
  /// Use for: Supplementary info, timestamps
  static TextStyle footnote(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.4,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Caption 1 — 12pt Regular
  /// Use for: Labels, tags, badges
  static TextStyle caption1(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: CupertinoColors.label.resolveFrom(context),
  );

  /// Caption 2 — 11pt Regular
  /// Use for: Micro text, legal, fine print
  static TextStyle caption2(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    height: 1.4,
    color: CupertinoColors.label.resolveFrom(context),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // SECONDARY LABEL STYLES (CupertinoColors.secondaryLabel)
  // ─────────────────────────────────────────────────────────────────────────

  /// Headline Secondary — 17pt Semibold (muted)
  static TextStyle headlineSecondary(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.3,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  /// Body Secondary — 17pt Regular (muted)
  static TextStyle bodySecondary(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  /// Callout Secondary — 16pt Regular (muted)
  static TextStyle calloutSecondary(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.35,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  /// Subhead Secondary — 15pt Regular (muted)
  static TextStyle subheadSecondary(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.35,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  /// Footnote Secondary — 13pt Regular (muted)
  static TextStyle footnoteSecondary(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.4,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  /// Caption Secondary — 12pt Regular (muted)
  static TextStyle captionSecondary(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // TERTIARY LABEL STYLES (CupertinoColors.tertiaryLabel)
  // ─────────────────────────────────────────────────────────────────────────

  /// Body Tertiary — 17pt Regular (very muted)
  static TextStyle bodyTertiary(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
  );

  /// Footnote Tertiary — 13pt Regular (very muted)
  static TextStyle footnoteTertiary(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.4,
    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // ACCENT COLORED STYLES (VitaloColors.accent)
  // ─────────────────────────────────────────────────────────────────────────

  /// Body Accent — 17pt Regular in accent color
  static TextStyle bodyAccent(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
    color: VitaloColors.accent.resolveFrom(context),
  );

  /// Headline Accent — 17pt Semibold in accent color
  static TextStyle headlineAccent(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.3,
    color: VitaloColors.accent.resolveFrom(context),
  );

  /// Footnote Accent — 13pt Regular in accent color
  static TextStyle footnoteAccent(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.4,
    color: VitaloColors.accent.resolveFrom(context),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // DESTRUCTIVE COLORED STYLES (VitaloColors.destructive)
  // ─────────────────────────────────────────────────────────────────────────

  /// Body Destructive — 17pt Regular in error color
  static TextStyle bodyDestructive(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.3,
    color: VitaloColors.destructive.resolveFrom(context),
  );

  /// Headline Destructive — 17pt Semibold in error color
  static TextStyle headlineDestructive(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.3,
    color: VitaloColors.destructive.resolveFrom(context),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// LEGACY ALIASES - For backward compatibility during migration
// ═══════════════════════════════════════════════════════════════════════════

/// @deprecated Use VitaloTextStyles instead
typedef AppleTextStyles = VitaloTextStyles;

// ═══════════════════════════════════════════════════════════════════════════
// APP SPACING - iOS HIG 4pt/8pt Grid System
// ═══════════════════════════════════════════════════════════════════════════
//
// iOS Layout Guidelines:
// • Base unit: 4pt (minimum)
// • Standard margin: 16pt (default horizontal padding)
// • Safe area: 20pt (edge insets on full-width content)
// • Section gap: 35pt (between grouped sections)
// • Touch target: 44pt minimum (accessibility requirement)
//
// Usage:
//   SizedBox(height: AppSpacing.md)
//   EdgeInsets.all(AppSpacing.lg)
//   BorderRadius.circular(AppSpacing.radiusMd)
// ═══════════════════════════════════════════════════════════════════════════

/// iOS Human Interface Guidelines spacing constants.
/// All values follow Apple's 4pt/8pt grid system.
abstract class AppSpacing {
  AppSpacing._();

  // ─────────────────────────────────────────────────────────────────────────
  // BASE SPACING SCALE (4pt increments)
  // ─────────────────────────────────────────────────────────────────────────

  /// 4pt — Minimum unit, tight spacing
  static const double xxs = 4.0;

  /// 8pt — Compact spacing, icon gaps
  static const double xs = 8.0;

  /// 12pt — Small spacing, inline elements
  static const double sm = 12.0;

  /// 16pt — Standard spacing (iOS default margin)
  static const double md = 16.0;

  /// 20pt — Comfortable spacing, section padding
  static const double lg = 20.0;

  /// 24pt — Generous spacing, card gaps
  static const double xl = 24.0;

  /// 32pt — Large spacing, section breaks
  static const double xxl = 32.0;

  /// 40pt — Extra large, major separators
  static const double xxxl = 40.0;

  /// 48pt — Hero spacing
  static const double xxxxl = 48.0;

  // ─────────────────────────────────────────────────────────────────────────
  // PAGE LAYOUT (iOS Safe Area Standards)
  // ─────────────────────────────────────────────────────────────────────────

  /// Horizontal page margin (iOS standard: 20pt)
  static const double pageHorizontal = 20.0;

  /// @deprecated Use pageHorizontal instead
  static const double pageHorizontalPadding = 20.0;

  /// Vertical page margin (iOS standard: 20pt)
  static const double pageVertical = 20.0;

  /// @deprecated Use pageVertical instead
  static const double pageVerticalPadding = 20.0;

  /// Section gap (iOS grouped list: 35pt)
  static const double sectionGap = 35.0;

  /// @deprecated Use sectionGap instead
  static const double sectionSpacing = 35.0;

  /// Card gap (between cards: 16pt)
  static const double cardGap = 16.0;

  // ─────────────────────────────────────────────────────────────────────────
  // COMPONENT DIMENSIONS (iOS HIG Standards)
  // ─────────────────────────────────────────────────────────────────────────

  /// Standard button height (iOS: 50pt)
  static const double buttonHeight = 50.0;

  /// Compact button height (iOS: 36pt)
  static const double buttonHeightCompact = 36.0;

  /// @deprecated Use buttonHeightCompact instead
  static const double buttonHeightSmall = 36.0;

  /// Input/row height (iOS standard: 44pt)
  static const double rowHeight = 44.0;

  /// @deprecated Use rowHeight instead
  static const double inputHeight = 44.0;

  /// Minimum touch target (iOS accessibility: 44pt)
  static const double touchTarget = 44.0;

  /// @deprecated Use touchTarget instead
  static const double touchTargetMin = 44.0;

  /// Navigation bar height (iOS: 44pt)
  static const double navBarHeight = 44.0;

  /// Tab bar height (iOS: 49pt)
  static const double tabBarHeight = 49.0;

  /// Large title bar height (iOS: 96pt)
  static const double largeTitleHeight = 96.0;

  // ─────────────────────────────────────────────────────────────────────────
  // BORDER RADIUS (iOS Rounded Rectangle Style)
  // ─────────────────────────────────────────────────────────────────────────

  /// Extra small radius — Chips, tags (6pt)
  static const double radiusXs = 6.0;

  /// Small radius — Buttons, inputs (10pt)
  static const double radiusSm = 10.0;

  /// Medium radius — Cards, tiles (14pt)
  static const double radiusMd = 14.0;

  /// Large radius — Modals, sheets (20pt)
  static const double radiusLg = 20.0;

  /// Extra large radius — Bottom sheets (28pt)
  static const double radiusXl = 28.0;

  /// Pill radius — Fully rounded (50pt)
  static const double radiusPill = 50.0;

  // Legacy aliases for backward compatibility
  /// @deprecated Use radiusMd instead
  static const double cardRadius = 14.0;

  /// @deprecated Use radiusLg instead
  static const double cardRadiusLarge = 20.0;

  /// @deprecated Use radiusXs instead
  static const double cardRadiusSmall = 10.0;

  /// @deprecated Use radiusMd instead
  static const double buttonRadius = 14.0;

  /// @deprecated Use radiusPill instead
  static const double buttonRadiusPill = 25.0;

  /// @deprecated Use radiusSm instead
  static const double inputRadius = 10.0;

  // ─────────────────────────────────────────────────────────────────────────
  // ICON SIZES (SF Symbol Scale)
  // ─────────────────────────────────────────────────────────────────────────

  /// Extra small icon (13pt)
  static const double iconXs = 13.0;

  /// Small icon (17pt) — Inline with body text
  static const double iconSm = 17.0;

  /// @deprecated Use iconSm instead
  static const double iconSizeSmall = 17.0;

  /// Medium icon (22pt) — Standard UI icon
  static const double iconMd = 22.0;

  /// @deprecated Use iconMd instead
  static const double iconSize = 22.0;

  /// Large icon (28pt) — Navigation, emphasis
  static const double iconLg = 28.0;

  /// @deprecated Use iconLg instead
  static const double iconSizeLarge = 28.0;

  /// Extra large icon (34pt) — Headers, features
  static const double iconXl = 34.0;

  /// Hero icon (44pt) — Touch targets, app icons
  static const double iconHero = 44.0;

  /// @deprecated Use iconHero instead
  static const double iconSizeHero = 44.0;

  // ─────────────────────────────────────────────────────────────────────────
  // AVATAR SIZES
  // ─────────────────────────────────────────────────────────────────────────

  /// Small avatar (32pt)
  static const double avatarSm = 32.0;

  /// @deprecated Use avatarSm instead
  static const double avatarSizeSmall = 32.0;

  /// Medium avatar (48pt)
  static const double avatarMd = 48.0;

  /// @deprecated Use avatarMd instead
  static const double avatarSize = 48.0;

  /// Large avatar (72pt)
  static const double avatarLg = 72.0;

  /// @deprecated Use avatarLg instead
  static const double avatarSizeLarge = 72.0;

  /// Hero avatar (96pt)
  static const double avatarXl = 96.0;

  // ─────────────────────────────────────────────────────────────────────────
  // CARD DIMENSIONS
  // ─────────────────────────────────────────────────────────────────────────

  /// Small card height (120pt)
  static const double cardHeightSm = 120.0;

  /// @deprecated Use cardHeightSm instead
  static const double cardHeightSmall = 140.0;

  /// Medium card height (160pt)
  static const double cardHeightMd = 160.0;

  /// @deprecated Use cardHeightMd instead
  static const double cardHeightMedium = 160.0;

  /// Large card height (200pt)
  static const double cardHeightLg = 200.0;

  // ─────────────────────────────────────────────────────────────────────────
  // EDGE INSETS HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  /// Standard page padding (horizontal: 20, vertical: 20)
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: pageHorizontal,
    vertical: pageVertical,
  );

  /// Horizontal page padding only
  static const EdgeInsets pageHorizontalPad = EdgeInsets.symmetric(
    horizontal: pageHorizontal,
  );

  /// Card internal padding (16pt all around)
  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  /// List tile padding (horizontal: 16, vertical: 12)
  static const EdgeInsets tilePadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // ANIMATION DURATIONS (iOS Standard)
  // ─────────────────────────────────────────────────────────────────────────

  /// Instant feedback (100ms)
  static const Duration durationFast = Duration(milliseconds: 100);

  /// Standard transition (200ms)
  static const Duration durationMedium = Duration(milliseconds: 200);

  /// Deliberate motion (300ms)
  static const Duration durationSlow = Duration(milliseconds: 300);

  /// Modal/sheet animation (400ms)
  static const Duration durationSheet = Duration(milliseconds: 400);

  /// Spring animation (500ms)
  static const Duration durationSpring = Duration(milliseconds: 500);
}

// ═══════════════════════════════════════════════════════════════════════════
// LIQUID GLASS - iOS 26 Material Constants
// ═══════════════════════════════════════════════════════════════════════════
//
// Liquid Glass Design Principles:
// • Translucent surfaces with backdrop blur
// • Subtle border for glass edge refraction
// • Soft shadows for floating effect
// • Content vibrancy (colors show through)
//
// Usage:
//   ClipRRect(
//     borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
//     child: BackdropFilter(
//       filter: LiquidGlass.blur(),
//       child: Container(
//         decoration: BoxDecoration(
//           color: VitaloColors.background.resolveFrom(context)
//               .withOpacity(LiquidGlass.opacityLight),
//           border: Border.all(
//             color: VitaloColors.glassBorder.resolveFrom(context),
//             width: LiquidGlass.borderThin,
//           ),
//         ),
//         child: content,
//       ),
//     ),
//   )
// ═══════════════════════════════════════════════════════════════════════════

/// Constants for iOS 26 Liquid Glass material implementation.
abstract class LiquidGlass {
  LiquidGlass._();

  // ─────────────────────────────────────────────────────────────────────────
  // BLUR VALUES (BackdropFilter sigma)
  // ─────────────────────────────────────────────────────────────────────────

  /// Light blur (10pt) — Subtle frosted effect
  static const double blurLight = 10.0;

  /// Medium blur (20pt) — Standard glass effect
  static const double blurMedium = 20.0;

  /// Heavy blur (30pt) — Modal/sheet glass
  static const double blurHeavy = 30.0;

  /// Ultra blur (40pt) — Maximum frosting
  static const double blurUltra = 40.0;

  // ─────────────────────────────────────────────────────────────────────────
  // OPACITY VALUES (Surface transparency)
  // ─────────────────────────────────────────────────────────────────────────

  /// Light mode glass tint (70%)
  static const double opacityLight = 0.7;

  /// Dark mode glass tint (50%)
  static const double opacityDark = 0.5;

  /// Sheet/modal glass (85%)
  static const double opacitySheet = 0.85;

  /// Navigation bar glass (80%)
  static const double opacityNavBar = 0.8;

  /// Tab bar glass (90%)
  static const double opacityTabBar = 0.9;

  // ─────────────────────────────────────────────────────────────────────────
  // BORDER VALUES (Glass edge)
  // ─────────────────────────────────────────────────────────────────────────

  /// Thin border (0.5pt) — Subtle edge refraction
  static const double borderThin = 0.5;

  /// @deprecated Use borderThin instead
  static const double borderWidth = 0.5;

  /// Standard border (1pt) — Visible edge
  static const double borderStandard = 1.0;

  /// @deprecated Use borderStandard instead
  static const double borderWidthThick = 1.0;

  // ─────────────────────────────────────────────────────────────────────────
  // SHADOW VALUES (Floating effect)
  // ─────────────────────────────────────────────────────────────────────────

  /// Shadow blur radius (20pt)
  static const double shadowBlur = 20.0;

  /// Shadow opacity (8%)
  static const double shadowOpacity = 0.08;

  /// Shadow offset
  static const Offset shadowOffset = Offset(0, 8);

  /// Shadow color
  static const Color shadowColor = Color(0x14000000);

  // ─────────────────────────────────────────────────────────────────────────
  // HELPER METHODS
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates a standard blur filter for glass effect
  static ImageFilter blur([double sigma = blurMedium]) {
    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }

  /// Creates glass shadow decoration
  static List<BoxShadow> get shadows => [
    const BoxShadow(
      color: shadowColor,
      blurRadius: shadowBlur,
      offset: shadowOffset,
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════════════════
// SEMANTIC COLOR PALETTES - Feature-Specific Colors
// ═══════════════════════════════════════════════════════════════════════════

/// Flux mascot brand colors (vibrant orange gradient)
abstract class FluxColors {
  FluxColors._();

  /// Light theme - outer aura
  static const Color lightBack = Color(0xFFFDBA74); // Orange 300

  /// Light theme - middle flow
  static const Color lightMid = Color(0xFFF97316); // Orange 500

  /// Light theme - core center
  static const Color lightFront = Color(0xFFEA580C); // Orange 600

  /// Dark theme - outer aura
  static const Color darkBack = Color(0xFF7C2D12); // Orange 900

  /// Dark theme - middle flow
  static const Color darkMid = Color(0xFFFB923C); // Orange 400

  /// Dark theme - core center
  static const Color darkFront = Color(0xFFC2410C); // Orange 700

  /// Light theme shine
  static const Color lightShine = Color(0xFFFFFFFF);

  /// Dark theme shine
  static const Color darkShine = Color(0xFFFDBA74);
}

/// Health goal semantic colors
abstract class GoalColors {
  GoalColors._();

  /// Lose Weight - Blue
  static const Color loseWeight = Color(0xFF42A5F5);

  /// Build Muscle - Red
  static const Color buildMuscle = Color(0xFFEF5350);

  /// Improve Sleep - Indigo
  static const Color improveSleep = Color(0xFF5C6BC0);

  /// Manage Stress - Teal
  static const Color manageStress = Color(0xFF26A69A);

  /// Boost Stamina - Orange
  static const Color boostStamina = Color(0xFFFF9800);

  /// Maintain Weight - Green
  static const Color maintainWeight = Color(0xFF66BB6A);

  /// Gain Weight - Purple
  static const Color gainWeight = Color(0xFFAB47BC);
}

/// AI coach personality semantic colors
abstract class CoachColors {
  CoachColors._();

  /// Supportive Friend - Warm Pink
  static const Color supportiveFriend = Color(0xFFEC407A);

  /// Tough Coach - Deep Red
  static const Color toughCoach = Color(0xFFD32F2F);

  /// Calm Mentor - Sage Green
  static const Color calmMentor = Color(0xFF66BB6A);

  /// Energetic Hype - Bright Orange
  static const Color energeticHype = Color(0xFFFF9800);

  /// Data Analyst - Cool Blue
  static const Color dataAnalyst = Color(0xFF42A5F5);

  /// Mindful Guide - Soft Purple
  static const Color mindfulGuide = Color(0xFF9575CD);
}

/// Third-party brand colors
abstract class BrandColors {
  BrandColors._();

  /// Apple Health pink/red
  static const Color appleHealth = Color(0xFFFF2D55);

  /// Google Health Connect blue
  static const Color healthConnect = Color(0xFF4285F4);

  /// Google Blue
  static const Color googleBlue = Color(0xFF4285F4);

  /// Google Red
  static const Color googleRed = Color(0xFFEA4335);

  /// Google Yellow
  static const Color googleYellow = Color(0xFFFBBC05);

  /// Google Green
  static const Color googleGreen = Color(0xFF34A853);
}
