import 'package:flutter/material.dart';

/// A responsive breakpoint system for adapting layouts across mobile, tablet,
/// and desktop/web viewports.
///
/// ## Breakpoints
/// | Name    | Width range          | Examples                    |
/// |---------|----------------------|-----------------------------|
/// | mobile  | < 600 px             | phones in portrait mode     |
/// | tablet  | 600 px – 1023 px     | tablets, landscape phones   |
/// | desktop | ≥ 1024 px            | laptops, desktops, web      |
///
/// ## Design philosophy
/// The app uses a **mobile-first** approach: mobile layouts are the default
/// and larger layouts add complexity (more columns, side navigation rails, etc.).
///
/// ## Usage
/// ```dart
/// // Check the current breakpoint:
/// if (Responsive.isMobile(context)) { ... }
///
/// // Return a layout-specific value:
/// final padding = Responsive.value(context,
///   mobile:  16.0,
///   tablet:  24.0,
///   desktop: 40.0,
/// );
///
/// // Number of grid columns for destination cards:
/// GridView.count(crossAxisCount: Responsive.cardGridColumns(context))
/// ```
class Responsive {
  /// Maximum width (exclusive) classified as mobile.
  /// At exactly 600 px the device is considered a tablet.
  static const double mobileMax = 600;

  /// Maximum width (exclusive) classified as tablet.
  /// At exactly 1024 px the device is considered desktop.
  static const double tabletMax = 1024;

  // ── Breakpoint Helpers ────────────────────────────────────────────────────

  /// Returns `true` when the available width is less than [mobileMax] (600 px).
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  /// Returns `true` when the available width is between [mobileMax] and
  /// [tabletMax] (600–1023 px inclusive).
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileMax && w < tabletMax;
  }

  /// Returns `true` when the available width is at least [tabletMax] (1024 px).
  /// This is also the breakpoint at which the app switches from a bottom
  /// navigation bar to a [NavigationRail].
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  // ── Generic Value Selector ─────────────────────────────────────────────────

  /// Returns one of the three provided values based on the current breakpoint.
  ///
  /// The [tablet] parameter is optional — if omitted, it falls back to [desktop].
  /// This mirrors the mobile-first pattern: only define a [tablet] override if
  /// the tablet layout genuinely differs from desktop.
  ///
  /// ```dart
  /// final columns = Responsive.value<int>(context,
  ///   mobile: 1, tablet: 2, desktop: 3,
  /// );
  /// ```
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }

  // ── Layout Helpers ─────────────────────────────────────────────────────────

  /// Returns the maximum content width for the current viewport.
  ///
  /// On viewports ≥ 1100 px the content is capped at 1100 px (centred via
  /// horizontal padding) to prevent overly wide text lines and maintain a
  /// comfortable reading / scanning experience.
  static double contentMaxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1100) return 1100;
    if (w >= mobileMax) return w; // On smaller screens, use full width or constrained by padding
    return w;
  }

  /// Returns the horizontal padding to apply so that content is centred within
  /// the maximum content width.
  ///
  /// - Desktop (≥ 1100 px): `(screenWidth - 1100) / 2`
  /// - Tablet: 32 px fixed padding
  /// - Mobile: 20 px fixed padding
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1100) return (w - 1100) / 2;
    if (w >= mobileMax) return 32;
    return 20;
  }

  /// Returns the number of grid columns for destination / service cards.
  ///
  /// | Breakpoint | Columns |
  /// |------------|---------|
  /// | desktop    | 3       |
  /// | tablet     | 2       |
  /// | mobile     | 1       |
  ///
  /// Used in [ExploreScreen] and similar grid layouts.
  static int cardGridColumns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= tabletMax) return 3;
    if (w >= mobileMax) return 2;
    return 1;
  }
}
