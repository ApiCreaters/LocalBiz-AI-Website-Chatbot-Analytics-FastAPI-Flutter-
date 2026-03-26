// lib/theme/app_colors.dart
// ─────────────────────────────────────────────────────────
// Exact colors from the LocalBiz website CSS variables
// --navy:  #091413   --navy2: #285A48
// --gold:  #408A71   --gold2: #B0E4CC

import 'package:flutter/material.dart';

class AppColors {
  // ── Primary Palette ──────────────────────────────────
  static const Color bg        = Color(0xFF091413); // --navy   (body bg)
  static const Color bg2       = Color(0xFF285A48); // --navy2  (cards, nav)
  static const Color bg3       = Color(0xFF0f2420); // section--light
  static const Color bgDeep    = Color(0xFF060f0e); // demo section

  // ── Accent ───────────────────────────────────────────
  static const Color green     = Color(0xFF408A71); // --gold   (buttons, icons)
  static const Color mint      = Color(0xFFB0E4CC); // --gold2  (highlights)

  // ── Text ─────────────────────────────────────────────
  static const Color textLight = Color(0xFFe8f7f0);
  static const Color textMuted = Color(0xFF7aaa96);
  static const Color textDim   = Color(0xFF5a9a80);

  // ── Border ───────────────────────────────────────────
  static const Color border    = Color(0xFF285A48);
  static const Color borderSoft = Color(0xFF1a3d2e);

  // ── Others ───────────────────────────────────────────
  static const Color whatsapp  = Color(0xFF25D366);
  static const Color white     = Color(0xFFFFFFFF);
  static const Color error     = Color(0xFFe05555);
  static const Color success   = Color(0xFF25D366);
}
