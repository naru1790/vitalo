import 'package:flutter/material.dart';

class AppColors {
  // ───── Brand Seeds ─────
  // Use the light/dark primary as seeds for Material color generation.
  static const primarySeedLight = Color(0xFF00B894); // Vitalo Mint (light seed)
  static const primarySeedDark  = Color(0xFF00D8A0); // Brighter Mint (dark seed)

  // ───── LIGHT THEME — Vitalo (Calm & Fresh) ─────
  static const primary            = Color(0xFF00B894); // Vitalo Mint
  static const onPrimary          = Color(0xFFFFFFFF);
  static const primaryContainer   = Color(0xFFBDF3E6); // Mint tint container
  static const onPrimaryContainer = Color(0xFF00382D);

  static const secondary            = Color(0xFF006D77); // Deep Teal
  static const onSecondary          = Color(0xFFFFFFFF);
  static const secondaryContainer   = Color(0xFFB2EBF2); // Teal tint container
  static const onSecondaryContainer = Color(0xFF002C30);

  static const background   = Color(0xFFF6F5F2); // Porcelain Mist (eye-soothing)
  static const onBackground = Color(0xFF212121); // Graphite
  static const surface      = Color(0xFFFFFFFF);
  static const onSurface    = Color(0xFF2B2B2B);
  static const surfaceVariant   = Color(0xFFE0E0E0); // Misty Gray
  static const onSurfaceVariant = Color(0xFF616161);

  static const outline  = Color(0xFFDADADA);
  static const disabled = Color(0xFFEDEDED);
  static const shadow   = Color(0x3300B894); // mint shadow (alpha)
  static const highlight= Color(0xFFFFD166); // Vitalo Gold (reward/shine)

  // ───── Semantic / Status ─────
  static const success = Color(0xFF48C78E); // Seafoam Green
  static const warning = Color(0xFFFF8C42); // Solar Peach (muted orange)
  static const error   = Color(0xFFFF6B6B); // Coral Red
  static const info    = Color(0xFF5A8CFF); // Info Blue

  // ───── DARK THEME — Vitalo (Calm & Focused) ─────
  static const darkBackground      = Color(0xFF121212); // Deep Charcoal
  static const darkSurface         = Color(0xFF1E1E1E);
  static const darkSurfaceVariant  = Color(0xFF2A2A2A);

  static const darkPrimary     = Color(0xFF00D8A0); // Brighter Mint for dark
  static const darkOnPrimary   = Color(0xFF00221B);
  static const darkSecondary   = Color(0xFFFF9E57); // Warm accent on dark

  static const darkTextPrimary   = Color(0xFFEDEDED);
  static const darkTextSecondary = Color(0xFFB0B0B0);
  static const darkOutline       = Color(0xFF3A3A3A);
  static const darkShadow        = Color(0x3300D8A0); // mint aura (alpha)
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
  static const auroraGlass = [
    Color(0xCCFFFFFF),
    Color(0x66FFFFFF),
  ];

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
