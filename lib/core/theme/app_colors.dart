import 'package:flutter/material.dart';

/// The complete colour palette for the SeYaha Tourism application.
///
/// ## Design Concept — "Aurora / Indigo Dusk"
/// The palette evokes the feeling of a clear night sky over the Egyptian desert:
/// deep indigo and cornflower blue convey trustworthiness and exploration, while
/// adventure orange provides high-contrast call-to-action pops.
///
/// ## How to use
/// Always reference these constants directly instead of defining ad-hoc colours
/// in individual widgets.  This ensures visual consistency and makes global
/// rebrand changes trivially easy.
///
/// ```dart
/// Container(color: AppColors.primary)          // primary brand colour
/// Text('...', style: TextStyle(color: AppColors.textBody))
/// ```
///
/// ## Glassmorphism colours
/// The `glass*` constants are pre-computed semi-transparent colours for the
/// frosted-glass effect used by [GlassCard].  Using named constants instead of
/// inline `withOpacity()` calls ensures every glass surface looks identical.
///
/// ## Dark Mode
/// Dark-mode surfaces are a very deep indigo family (`backgroundDark`,
/// `surfaceDark`, `surfaceDark2`) to match the aurora night-sky theme.
class AppColors {
  // ── Primary Brand Palette — Aurora / Indigo Dusk ──────────────────────────

  /// The dominant brand colour — a vivid indigo inspired by twilight skies.
  /// Used on primary buttons, active nav items, and section headers.
  static const Color primary = Color(0xFF6809CE); // Indigo Dusk

  /// The secondary accent — cornflower blue, paired with [primary] in gradients
  /// and used for icons, hyperlinks, and subtle highlights.
  static const Color secondary = Color(0xFF6495ED); // Cornflower Blue

  /// The call-to-action (CTA) colour — adventure orange.
  /// Draws attention to the most important interactive elements (e.g. "Book Now").
  /// High contrast against both [primary] and white backgrounds.
  static const Color accent = Color(0xFFF97316); // Adventure Orange (CTA)

  // ── Background & Surface ──────────────────────────────────────────────────

  /// The light-mode page background — a very pale azure.
  /// Gives the app a bright, airy travel-magazine feel in light mode.
  static const Color background = Color(0xFFF0FFFF); // Azure

  /// The default surface colour (cards, sheets) in light mode.
  static const Color surface = Color(0xFFFFFFFF);

  // ── Text ──────────────────────────────────────────────────────────────────

  /// Primary body text in light mode — a deep, rich blue that pairs with
  /// the azure background for strong contrast (WCAG AA compliant).
  static const Color textBody = Color(0xFF00008B); // Deep Blue

  /// Muted / secondary text — a neutral slate for subtitles, hints, and
  /// metadata that should recede behind primary content.
  static const Color textMuted = Color(0xFF475569); // Slate

  // ── Semantic Colours ──────────────────────────────────────────────────────

  /// Standard error/danger colour.  Applied to form validation messages,
  /// destructive action buttons, and error snack bars.
  static const Color error = Color(0xFFEF4444);

  /// Success / confirmation colour.  Used for confirmed booking badges and
  /// success toasts.
  static const Color success = Color(0xFF10B981);

  /// Warning / attention colour.  Used for pending states and advisory messages.
  static const Color warning = Color(0xFFF59E0B);

  // ── Booking Status Badge Colours ──────────────────────────────────────────
  // These mirror the backend's BookingStatus enum values for visual consistency.

  /// Amber badge for bookings awaiting review.
  static const Color statusPending = Color(0xFFF59E0B);

  /// Green badge for confirmed bookings.
  static const Color statusConfirmed = Color(0xFF10B981);

  /// Red badge for cancelled or rejected bookings.
  static const Color statusCancelled = Color(0xFFEF4444);

  // ── Glassmorphism ──────────────────────────────────────────────────────────
  // Pre-computed alpha values for the frosted-glass design pattern.
  // Used by [GlassCard] and [GlassDarkCard].

  /// 10% white fill — used as the default glass card background.
  static const Color glassWhite = Color(0x1AFFFFFF); // 10% white

  /// 20% white border — subtle border that defines glass edges without
  /// breaking the illusion of transparency.
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white border

  /// 15% black tint — darker glass for cards that overlay images or
  /// saturated backgrounds (see [GlassDarkCard]).
  static const Color glassCardDark = Color(0x26000000); // 15% black tint

  // ── Shimmer Animation ─────────────────────────────────────────────────────
  // Loading-skeleton colours.  The base/highlight pair creates the sweeping
  // animation effect in [ShimmerCardList] and related widgets.

  /// The base (resting) colour of the shimmer skeleton.
  static const Color shimmerBase = Color(0xFFE2E8F0);

  /// The bright highlight that sweeps across the skeleton to simulate loading.
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // ── Aurora Gradients ──────────────────────────────────────────────────────

  /// A three-stop gradient that mimics the aurora borealis visual — used as
  /// the glow cloud colours in [AuroraBackground].
  static const List<Color> auroraGradient = [
    Color(0xFF6809CE),
    Color(0xFF6495ED),
    Color(0xFF00008B),
  ];

  /// Linear gradient for hero banners and full-page splash backgrounds.
  /// Sweeps from deep indigo (top-left) to midnight navy (bottom-right).
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6809CE), Color(0xFF1E3A8A)],
  );

  /// Semi-transparent black gradient overlaid on image cards to ensure
  /// white text remains legible against any photo.
  /// Runs from transparent (top) to ~80% black (bottom).
  static const LinearGradient cardOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );

  // ── Dark Mode ─────────────────────────────────────────────────────────────

  /// Darkest page background for dark mode — a near-black deep indigo.
  static const Color backgroundDark = Color(0xFF0D0221);

  /// Primary card surface in dark mode.
  static const Color surfaceDark = Color(0xFF1B065E);

  /// Secondary card surface in dark mode — slightly lighter than [surfaceDark]
  /// for layered depth (e.g. cards inside a drawer panel).
  static const Color surfaceDark2 = Color(0xFF150447);

  // ── Category Colours ──────────────────────────────────────────────────────
  // Each service category in the app has a dedicated accent colour used in
  // filter chips, category tags, and icon backgrounds.

  /// Colour map keyed by the backend `category` string value.
  /// Must stay in sync with [CompanyCategory] / [ServiceCategory] enums.
  static const Map<String, Color> categoryColors = {
    'Hotel': Color(0xFF14B8A6),       // Teal — calm, hospitality feel
    'RealEstate': Color(0xFF06B6D4),  // Cyan — clean, modern
    'Tours': Color(0xFF6809CE),       // Brand indigo — adventure
    'All': Color(0xFFF97316),         // Orange — energetic catch-all
    'Cars': Color(0xFFFB923C),        // Light orange — speed / mobility
  };
}
