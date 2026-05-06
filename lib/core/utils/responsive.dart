import 'package:flutter/material.dart';

/// Responsive breakpoint system for mobile, tablet, and desktop/web.
class Responsive {
  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  /// Returns a value based on the current screen size.
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

  /// Returns the constrained content max width for the current layout.
  static double contentMaxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1100) return 1100;
    if (w >= mobileMax) return w; // On smaller screens, use full width or constrained by padding
    return w;
  }

  /// Returns horizontal padding based on screen width.
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1100) return (w - 1100) / 2;
    if (w >= mobileMax) return 32;
    return 20;
  }

  /// Number of grid columns for destination cards.
  static int cardGridColumns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= tabletMax) return 3;
    if (w >= mobileMax) return 2;
    return 1;
  }
}
