import 'package:flutter/material.dart';

/// Vitalo App Colors - Solar Theme
/// Warm orange palette for light and dark modes
class AppColors {
  // ───── LIGHT THEME — Solar Mode ─────
  static const primary = Color(0xFFF97316); // Orange 500
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFDBA74); // Orange 300
  static const onPrimaryContainer = Color(0xFF7C2D12);

  static const secondary = Color(0xFFEA580C); // Orange 600
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFED7AA); // Orange 200
  static const onSecondaryContainer = Color(0xFF7C2D12);

  static const background = Color(0xFFF5F5F4); // Stone 100
  static const onBackground = Color(0xFF1C1917); // Stone 900
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1C1917);
  static const surfaceVariant = Color(0xFFE7E5E4); // Stone 200
  static const onSurfaceVariant = Color(0xFF78716C); // Stone 500

  static const outline = Color(0xFFD6D3D1); // Stone 300
  static const shadow = Color(0x33F97316);

  // ───── DARK THEME — Solar Night ─────
  static const darkPrimary = Color(0xFFFB923C); // Orange 400
  static const darkOnPrimary = Color(0xFF431407);
  static const darkPrimaryContainer = Color(0xFF7C2D12);
  static const darkOnPrimaryContainer = Color(0xFFFED7AA);

  static const darkSecondary = Color(0xFFC2410C); // Orange 700
  static const darkOnSecondary = Color(0xFFFED7AA);
  static const darkSecondaryContainer = Color(0xFF431407);
  static const darkOnSecondaryContainer = Color(0xFFFDBA74);

  static const darkBackground = Color(0xFF1C1917); // Stone 900
  static const darkSurface = Color(0xFF292524); // Stone 800
  static const darkSurfaceVariant = Color(0xFF44403C); // Stone 700
  static const darkOnSurface = Color(0xFFF5F5F4); // Stone 100
  static const darkOnSurfaceVariant = Color(0xFFA8A29E); // Stone 400

  static const darkOutline = Color(0xFF57534E); // Stone 600
  static const darkShadow = Color(0x33FB923C);

  // ───── Semantic / Status ─────
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFE11D48);
  static const darkError = Color(0xFFFDA4AF);
  static const info = Color(0xFF4F46E5);
}
