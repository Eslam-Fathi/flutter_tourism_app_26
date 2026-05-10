import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Central theme definitions for the SeYaha Tourism application.
///
/// ## Material 3
/// Both themes use `useMaterial3: true`, which enables the new Material Design 3
/// visual style — dynamic colour roles, updated component shapes, and expressive
/// motion.  All colour values come from [AppColors] via a [ColorScheme.fromSeed]
/// factory which generates a harmonious tonal palette from the seed colour.
///
/// ## Typography — DM Sans
/// The app uses **DM Sans** (via `google_fonts`) for all text:
/// - A geometric, humanist sans-serif that feels modern but approachable.
/// - Excellent legibility at small sizes for body copy.
/// - The `-1` letter-spacing on `displayLarge` gives headlines a premium,
///   editorial feel — common in travel/lifestyle branding.
///
/// ## Design Tokens
/// [expressiveDuration] and [expressiveCurve] define the standard animation
/// contract for page transitions and state changes.  Use them in `AnimatedContainer`,
/// `AnimatedOpacity`, etc., to keep motion consistent across the app.
///
/// ## Usage
/// ```dart
/// // In MaterialApp:
/// theme: AppTheme.lightTheme,
/// darkTheme: AppTheme.darkTheme,
/// themeMode: themeMode, // from ThemeNotifier
///
/// // Reading theme tokens in widgets:
/// Theme.of(context).textTheme.headlineLarge
/// Theme.of(context).colorScheme.primary
/// ```
class AppTheme {
  /// Standard animation duration for state-change animations.
  ///
  /// 450 ms is long enough to be perceptible but short enough to feel snappy.
  /// Used with [expressiveCurve] for a cohesive feel.
  static const Duration expressiveDuration = Duration(milliseconds: 450);

  /// Standard animation easing curve — fast start, slow end.
  ///
  /// [Curves.fastOutSlowIn] mimics physics-based deceleration, making
  /// transitions feel natural and premium.
  static const Curve expressiveCurve = Curves.fastOutSlowIn;

  // ── Light Theme ───────────────────────────────────────────────────────────

  /// The primary theme for the app when [ThemeMode.light] is active.
  ///
  /// Colour roles:
  /// - `primary` → indigo dusk (nav, FAB, selected states)
  /// - `secondary` → cornflower blue (highlights, chips)
  /// - `tertiary` → adventure orange (CTA buttons)
  /// - `background` → pale azure (page backgrounds)
  /// - `surface` → white (cards, sheets)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        // `fromSeed` generates a full M3 tonal palette from this seed colour.
        // The explicit overrides below replace the auto-generated values with
        // our curated [AppColors] so the palette stays on-brand.
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,    // Text/icons drawn on top of primary colour
        onSecondary: Colors.white,  // Text/icons drawn on top of secondary
        onBackground: AppColors.textBody,
        onSurface: AppColors.textBody,
      ),
      // ── Typography ────────────────────────────────────────────────────────
      // Using DM Sans for a premium, storytelling feel.
      // `copyWith` lets us override only specific roles while inheriting the
      // rest from the base DM Sans text theme.
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        displayLarge: GoogleFonts.dmSans(
          color: AppColors.textBody,
          fontWeight: FontWeight.bold,
          letterSpacing: -1, // Tight tracking on large headlines for editorial look
        ),
        headlineLarge: GoogleFonts.dmSans(
          color: AppColors.textBody,
          fontWeight: FontWeight.bold,
          height: 1.1, // Tighter line height for compact hero titles
        ),
        titleLarge: GoogleFonts.dmSans(
          color: AppColors.textBody,
          fontWeight: FontWeight.w600, // Semi-bold for section titles
        ),
        bodyLarge: GoogleFonts.dmSans(color: AppColors.textBody),
        labelLarge: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
      ),
      // ── AppBar ────────────────────────────────────────────────────────────
      // Transparent + no elevation so page-level backgrounds bleed through
      // (e.g. the aurora gradient on auth screens).
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false, // Left-aligned titles feel more editorial
        iconTheme: IconThemeData(color: AppColors.textBody),
      ),
      // ── Elevated Button ───────────────────────────────────────────────────
      // Full-width, rounded, adventure-orange — the primary CTA style.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0, // Flat style — depth comes from rounded corners, not shadow
          minimumSize: const Size(double.infinity, 60), // Full-width, tall touch target
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Stadium-pill shape
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // ── Input Decoration ──────────────────────────────────────────────────
      // Filled, borderless fields with a focused highlight border.
      // The semi-transparent white fill gives a frosted-glass look when
      // placed over the aurora background.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none, // No border in resting state
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          // 2px primary border indicates keyboard focus — important for accessibility
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      // ── Card ──────────────────────────────────────────────────────────────
      // Zero-elevation cards with very rounded corners (30px) give a
      // soft, friendly aesthetic in line with modern travel apps.
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent, // Suppress M3 tonal tinting on cards
      ),
    );
  }

  // ── Dark Theme ────────────────────────────────────────────────────────────

  /// The dark-mode theme activated when [ThemeMode.dark] is selected.
  ///
  /// Currently minimal — inherits M3 defaults for most component themes and
  /// only overrides the colour scheme and typography.  Future iterations should
  /// add the same component-level overrides as [lightTheme].
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark, // Signals M3 to use dark-mode tonal roles
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
      ),
      // Apply DM Sans on top of Flutter's dark base text theme so that
      // dark-mode text colours (white on dark) are preserved.
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
    );
  }
}
