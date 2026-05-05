import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Palette — Aurora / Indigo Dusk
  static const Color primary = Color(0xFF6809CE); // Indigo Dusk
  static const Color secondary = Color(0xFF6495ED); // Cornflower Blue
  static const Color accent = Color(0xFFF97316); // Adventure Orange (CTA)

  // Background & Surface
  static const Color background = Color(0xFFF0FFFF); // Azure
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textBody = Color(0xFF00008B); // Deep Blue
  static const Color textMuted = Color(0xFF475569); // Slate

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Status badge colors
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusConfirmed = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFFEF4444);

  // Glassmorphism
  static const Color glassWhite = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white border
  static const Color glassCardDark = Color(0x26000000); // 15% black tint

  // Shimmer
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // Aurora Gradients
  static const List<Color> auroraGradient = [
    Color(0xFF6809CE),
    Color(0xFF6495ED),
    Color(0xFF00008B),
  ];

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6809CE), Color(0xFF1E3A8A)],
  );

  static const LinearGradient cardOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );

  // Dark Mode
  static const Color backgroundDark = Color(0xFF0D0221);
  static const Color surfaceDark = Color(0xFF1B065E);
  static const Color surfaceDark2 = Color(0xFF150447);

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Hotel': Color(0xFF14B8A6),
    'RealEstate': Color(0xFF06B6D4),
    'Tours': Color(0xFF6809CE),
    'All': Color(0xFFF97316),
    'Cars': Color(0xFFFB923C),
  };
}
