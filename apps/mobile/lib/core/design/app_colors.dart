import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary
  static const Color forestGreen = Color(0xFF1B4332);
  static const Color forestGreenLight = Color(0xFF2D6A4F);
  static const Color forestGreenDark = Color(0xFF0D2B1E);

  // Secondary
  static const Color warmIvory = Color(0xFFF5F0E8);
  static const Color warmIvoryDark = Color(0xFFE8E0D0);

  // Accent
  static const Color softGold = Color(0xFFC9A94E);
  static const Color softGoldLight = Color(0xFFD4BC6A);
  static const Color softGoldDark = Color(0xFFA88D3D);

  // Support
  static const Color sage = Color(0xFF7A9E7E);
  static const Color charcoal = Color(0xFF2D2D2D);
  static const Color slate = Color(0xFF6B7280);
  static const Color mistWhite = Color(0xFFF9FAFB);

  // Semantic
  static const Color success = Color(0xFF2D6A4F);
  static const Color warning = Color(0xFFE6A817);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // Health data visualization (semantic, not decorative brand colors)
  static const Color period = Color(0xFFE86B6B);
  static const Color periodLight = Color(0xFFFFB3BA);
  static const Color periodMedium = Color(0xFFFF6B6B);
  static const Color periodHeavy = Color(0xFFE04848);
  static const Color periodVeryHeavy = Color(0xFFB71C1C);
  static const Color symptomGreen = Color(0xFF81C784);
  static const Color symptomPurple = Color(0xFF9575CD);
  static const Color symptomRed = Color(0xFFE57373);
  static const Color symptomBlue = Color(0xFF64B5F6);
  static const Color symptomOrange = Color(0xFFFF8A65);
  static const Color symptomCyan = Color(0xFF4DD0E1);
  static const Color symptomSky = Color(0xFF4FC3F7);
  static const Color symptomCritical = Color(0xFFE53935);
  static const Color symptomUrgent = Color(0xFFFF5252);
  static const Color phasePurple = Color(0xFF7C5CBF);
  static const Color phaseBlue = Color(0xFF5B8DEF);
  static const Color hormoneBlue = Color(0xFF5B6ABF);
  static const Color timelineJournal = Color(0xFFE91E90);

  // External integration identity colors
  static const Color deviceGeneric = Color(0xFF7B61FF);
  static const Color deviceApple = Color(0xFF000000);
  static const Color deviceFitbit = Color(0xFF00B0B9);
  static const Color deviceGarmin = Color(0xFF1976D2);
  static const Color deviceOura = Color(0xFF607D8B);
  static const Color deviceSamsung = Color(0xFFEB0029);
  static const Color deviceGoogle = Color(0xFF0D7A3F);
  static const Color deviceXiaomi = Color(0xFFFF6B00);

  // Fixed contrast colors used on known solid backgrounds
  static const Color onBrand = Color(0xFFFFFFFF);
  static const Color shadow = Color(0xFF000000);
  static const Color decoyInk = Color(0xFF333333);
  static const Color decoySurface = Color(0xFFF5F5F5);
  static const Color decoyKey = Color(0xFFE8E8E8);

  // Light theme
  static const Color backgroundLight = Color(0xFFFAFAF8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Dark theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF374151);
}
