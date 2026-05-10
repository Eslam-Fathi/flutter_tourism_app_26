import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A reusable, consistent section header with a title and an optional action
/// button (typically labelled "See All").
///
/// ## Design purpose
/// Every list section on the home screen and explore screen uses the same
/// visual rhythm: a **bold left-aligned title** + a **pill-shaped action link**
/// on the right.  [SectionHeader] encapsulates this pattern so that:
/// - Every section looks identical without copy-pasting code.
/// - Changing the header style (font size, colour, pill shape) only requires
///   editing this one widget.
///
/// ## Layout
/// ```
/// ┌──────────────────────────────────────────┐
/// │ Trending Now            [  See All  ]    │
/// └──────────────────────────────────────────┘
/// ```
/// A [Row] with [MainAxisAlignment.spaceBetween] keeps the title and action
/// at opposite edges regardless of screen width.
///
/// ## Usage
/// ```dart
/// // With an action button:
/// SectionHeader(
///   title: 'Trending Now',
///   actionLabel: 'See All',
///   onAction: () => Navigator.push(context, ...),
/// )
///
/// // Title only (no action):
/// SectionHeader(title: 'Featured Services')
///
/// // Custom title colour (e.g. on a dark background):
/// SectionHeader(
///   title: 'My Bookings',
///   titleColor: Colors.white,
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// The bold section title displayed on the left.
  final String title;

  /// Optional label for the right-side action button (e.g. `'See All'`).
  /// When `null`, no action button is rendered.
  final String? actionLabel;

  /// Callback invoked when the action button is tapped.
  /// Should typically navigate to the full list screen.
  final VoidCallback? onAction;

  /// Overrides the default [AppColors.textBody] colour for the title text.
  /// Useful when the header is placed on a dark or coloured background.
  final Color? titleColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Title ─────────────────────────────────────────────────────────
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,  // Extra-bold for strong visual hierarchy
                color: titleColor ?? AppColors.textBody,
                letterSpacing: -0.5,          // Slight negative tracking for headlines
              ),
        ),

        // ── Action Button (conditional) ────────────────────────────────────
        // Only rendered when [actionLabel] is provided.
        // Uses [GestureDetector] rather than [TextButton] because we need a
        // custom pill-shaped container, not a standard Material button.
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                // 10% primary tint — visible without being distracting
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20), // Pill shape
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
