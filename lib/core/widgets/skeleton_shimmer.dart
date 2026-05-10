import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A primitive shimmer loading block with configurable dimensions.
///
/// Unlike the higher-level shimmer composites in `shimmer_loader.dart`
/// (which have fixed layouts matching specific screens), [SkeletonShimmer]
/// is a **low-level building block** — a single shimmer rectangle that can be
/// combined freely to build any skeleton layout.
///
/// The shimmer colours use translucent white (`Colors.white.withOpacity(...)`)
/// rather than the opaque greys in [ShimmerCardList].  This makes
/// [SkeletonShimmer] suitable for placement **on dark backgrounds** (e.g. the
/// admin dashboard's dark surface) where grey would be invisible.
///
/// ## Usage
/// ```dart
/// // A single loading bar:
/// const SkeletonShimmer(width: 200, height: 16)
///
/// // A loading block (card-sized):
/// SkeletonShimmer(
///   width: double.infinity,
///   height: 100,
///   borderRadius: 24,
///   margin: const EdgeInsets.only(bottom: 12),
/// )
/// ```
class SkeletonShimmer extends StatelessWidget {
  /// Width of the shimmer block.  Defaults to `double.infinity` (full width).
  final double width;

  /// Height of the shimmer block in logical pixels.  Defaults to 20.
  final double height;

  /// Corner radius of the shimmer block.  Defaults to 8.
  final double borderRadius;

  /// Optional outer margin, useful when stacking multiple blocks vertically.
  final EdgeInsetsGeometry? margin;

  const SkeletonShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        // White-tinted colours work well on both light and dark surfaces.
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
        // 1500 ms period feels gentle and non-distracting.
        period: const Duration(milliseconds: 1500),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

/// A pre-configured [SkeletonShimmer] sized to match a content card.
///
/// Used when you need a quick card-height loading placeholder without
/// specifying dimensions each time.
///
/// Default values (`height: 100`, `borderRadius: 24`) match the rounded card
/// shape used throughout the app.
class CardSkeleton extends StatelessWidget {
  /// Height of the card placeholder.
  final double height;

  /// Corner radius of the card placeholder.
  final double borderRadius;

  /// Bottom margin separating stacked cards.
  final EdgeInsetsGeometry margin;

  const CardSkeleton({
    super.key,
    this.height = 100,
    this.borderRadius = 24,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      height: height,
      borderRadius: borderRadius,
      margin: margin,
    );
  }
}

/// A full-page shimmer layout mimicking the admin dashboard's data sections.
///
/// Renders a row of three stat-card placeholders followed by two section
/// headers and their corresponding card skeletons.  This prevents a jarring
/// layout shift when the real dashboard data loads.
///
/// Used in [AdminDashboardScreen] and [CompanyDashboardScreen] while the
/// stats and recent-activity providers are loading.
///
/// ### Layout structure
/// ```
/// ┌─────┐  ┌─────┐  ┌─────┐   ← stats row (3 cards)
/// └─────┘  └─────┘  └─────┘
///
/// Section Title ─────────────
/// ┌──────────────────────────┐
/// └──────────────────────────┘
/// ┌──────────────────────────┐
/// └──────────────────────────┘
///
/// Section Title ─────────────
/// ┌──────────────────────────┐
/// └──────────────────────────┘
/// ```
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Stats Row Skeleton ─────────────────────────────────────────────
        // Three equally-wide boxes side by side mirror the real stat card row.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: List.generate(3, (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index == 2 ? 0 : 12),
                child: const SkeletonShimmer(height: 80, borderRadius: 20),
              ),
            )),
          ),
        ),
        const SizedBox(height: 32),

        // ── Content Skeletons ───────────────────────────────────────────────
        // A section heading shimmer + two card skeletons, repeated once more.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1 title placeholder
              const SkeletonShimmer(width: 150, height: 24, borderRadius: 8),
              const SizedBox(height: 16),
              const CardSkeleton(height: 80),
              const CardSkeleton(height: 80),
              const SizedBox(height: 32),
              // Section 2 title placeholder
              const SkeletonShimmer(width: 120, height: 24, borderRadius: 8),
              const SizedBox(height: 16),
              const CardSkeleton(height: 70, borderRadius: 24),
            ],
          ),
        ),
      ],
    );
  }
}
