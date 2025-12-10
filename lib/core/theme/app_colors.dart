import 'package:flutter/material.dart';

class AppColors {
  // ───── Brand Seeds ─────
  // Use the light/dark primary as seeds for Material color generation.
  static const primarySeedLight = Color(0xFF00B894); // Vitalo Mint (light seed)
  static const primarySeedDark = Color(0xFF00D8A0); // Brighter Mint (dark seed)

  // ───── LIGHT THEME — Solar Mode (Warm Stone) ─────
  static const primary = Color(0xFFF97316); // Solar Orange
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFED7AA); // Orange tint
  static const onPrimaryContainer = Color(0xFF7C2D12);

  static const secondary = Color(0xFFF59E0B); // Gold
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFDE68A);
  static const onSecondaryContainer = Color(0xFF78350F);

  static const background = Color(0xFFF5F5F4); // Stone 100
  static const onBackground = Color(0xFF1C1917); // Stone 900
  static const surface = Color(0xFFFFFFFF); // Card White
  static const onSurface = Color(0xFF1C1917); // Stone 900
  static const surfaceVariant = Color(0xFFE7E5E4); // Stone 200
  static const onSurfaceVariant = Color(0xFF78716C); // Stone 500

  static const outline = Color(0xFFD6D3D1); // Stone 300
  static const disabled = Color(0xFFF5F5F4);
  static const shadow = Color(0x33F97316); // orange shadow (alpha)
  static const highlight = Color(0xFFF59E0B); // Gold accent

  // ───── Semantic / Status ─────
  static const success = Color(0xFF10B981); // Emerald
  static const warning = Color(0xFFF59E0B); // Gold
  static const error = Color(0xFFE11D48); // Rose
  static const info = Color(0xFF4F46E5); // Indigo

  // ───── DARK THEME — Lunar Mode (Deep Slate) ─────
  static const darkBackground = Color(0xFF0F172A); // Slate 900
  static const darkSurface = Color(0xFF1E293B); // Slate 800
  static const darkSurfaceVariant = Color(0xFF334155); // Slate 700

  static const darkPrimary = Color(0xFF818CF8); // Indigo 400
  static const darkOnPrimary = Color(0xFF1E1B4B);
  static const darkSecondary = Color(0xFFA78BFA); // Violet 400

  static const darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const darkOutline = Color(0xFF475569); // Slate 600
  static const darkShadow = Color(0x33818CF8); // indigo aura (alpha)
}

/// Brand gradients & backgrounds shared across the app.
class AppGradients {
  // Primary action (CTA) gradient — mint → gold (growth).
  static const lightPrimary = [
    Color(0xFF00B894), // Vitalo Mint
    Color(0xFFFFD166), // Vitalo Gold
  ];
  static const darkPrimary = [
    Color(0xFF00D8A0), // Bright Mint
    Color(0xFFFF9E57), // Warm Orange (dark accent)
  ];

  // Subtle atmospheric background sweeps (light).
  static const lightBackground = [
    Color(0xFFF6F5F2), // Porcelain Mist
    Color(0xFFFFFFFF),
    Color(0xFFF6F5F2),
  ];

  // Subtle atmospheric background sweeps (dark).
  static const darkBackground = [
    Color(0xFF121212),
    Color(0xFF1A1A1A),
    Color(0xFF1E1E1E),
  ];

  // Landing hero gradients.
  static const landingLight = [
    Color(0xFFF6F5F2), // porcelain
    Color(0xFFBDF3E6), // mint tint
    Color(0xFFFFF1CC), // soft gold haze
    Color(0xFFFDE7DA), // warm neutral mist
  ];
  static const landingDark = [
    Color(0xFF0F0F10),
    Color(0xFF121212),
    Color(0xFF1E1E1E),
    Color(0xFF263238), // deep teal-black
  ];

  // Accent sweeps for components and illustrations.
  static const prismAura = [
    Color(0xFF00B894), // mint
    Color(0xFF006D77), // deep teal
    Color(0xFFFF8C42), // warm accent
  ];

  // Glass overlay for cards/images.
  static const auroraGlass = [Color(0xCCFFFFFF), Color(0x66FFFFFF)];

  // Legacy-friendly gradients refreshed for the new palette.
  static const vitalAura = [
    Color(0xFF00B894), // mint
    Color(0xFFFF8C42), // peach/orange
    Color(0xFFFFD166), // gold
  ];

  static const consciousnessRise = [
    Color(0xFF006D77), // deep teal
    Color(0xFF00B894), // mint ascent
    Color(0xFFFFD166), // hopeful gold
  ];

  // Calm hero sweep (mint → teal → porcelain).
  static const serenityBloom = [
    Color(0xFFBDF3E6),
    Color(0xFF00B894),
    Color(0xFFF6F5F2),
  ];

  // Dark energize (mint → warm accent).
  static const livingEnergy = [
    Color(0xFF0D0D0D),
    Color(0xFF00D8A0),
    Color(0xFFFF9E57),
  ];

  // Deep, subtle backgrounds for dark pages.
  static const stellarWellness = [
    Color(0xFF121212),
    Color(0xFF1A1A1A),
    Color(0xFF222222),
  ];

  // Light marketing sweep (mint → gold → porcelain).
  static const dawnAwakening = [
    Color(0xFF00B894),
    Color(0xFFFFD166),
    Color(0xFFF6F5F2),
  ];

  static const nirvanaGate = [
    Color(0xFFFFFFFF), // clean light
    Color(0xFFF6F5F2), // porcelain mist
    Color(0xFFBDF3E6), // mint veil
  ];
}
