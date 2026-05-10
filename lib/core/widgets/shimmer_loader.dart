import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

/// A collection of **shimmer skeleton** widgets used as loading placeholders
/// while asynchronous data is being fetched.
///
/// ## Why Shimmer?
/// Blank screens or spinner-only states feel abrupt and give the user no
/// sense of what is about to appear.  Shimmer skeletons:
/// 1. Give immediate visual feedback that content is on its way.
/// 2. Preserve the page layout so there is no jarring layout shift on load.
/// 3. Feel more polished and modern than a centred `CircularProgressIndicator`.
///
/// ## How the animation works
/// The `shimmer` package renders a sliding highlight gradient over the base
/// colour.  [AppColors.shimmerBase] is the dark, resting colour and
/// [AppColors.shimmerHighlight] is the brighter highlight that sweeps across.
///
/// ## Widget catalogue
/// | Widget              | Use case                                   |
/// |---------------------|--------------------------------------------|
/// | [ShimmerCardList]   | Horizontal scrolling card rows             |
/// | [ShimmerServiceList]| Vertical full-width service/post cards     |
/// | [ShimmerBanner]     | Large promotional banner placeholders      |
/// | [ShimmerListTile]   | Avatar + two-line text list items          |

// ── Horizontal Card Row Shimmer ───────────────────────────────────────────────

/// A horizontally-scrolling row of shimmer skeleton cards.
///
/// Mirrors the "Trending" or "Featured" horizontal card list on the home screen.
/// When the provider resolves, this widget is replaced by the real list.
///
/// ```dart
/// // Show while loading:
/// if (servicesAsync.isLoading) return const ShimmerCardList();
/// ```
class ShimmerCardList extends StatelessWidget {
  /// Number of placeholder cards to render.
  final int count;

  /// Width of each placeholder card in logical pixels.
  final double cardWidth;

  /// Height of the list (and each card) in logical pixels.
  final double cardHeight;

  const ShimmerCardList({
    super.key,
    this.count = 3,
    this.cardWidth = 200,
    this.cardHeight = 280,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: count,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Vertical Service List Shimmer ─────────────────────────────────────────────

/// A vertically-stacked shimmer list of full-width service card placeholders.
///
/// Used in [ExploreScreen] and [ServiceListScreen] while the services API
/// request is in flight.
///
/// Uses `shrinkWrap: true` and [NeverScrollableScrollPhysics] because it is
/// typically embedded inside an outer [SingleChildScrollView] or [ListView].
class ShimmerServiceList extends StatelessWidget {
  /// Number of placeholder cards.
  final int count;

  const ShimmerServiceList({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      // Disable internal scrolling — the parent scroll view handles this.
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          height: 340, // Matches the height of the real ServiceCard
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

// ── Banner Shimmer ─────────────────────────────────────────────────────────────

/// A single large rectangular shimmer placeholder for banner or hero images.
///
/// Used at the top of screens that show a promotional banner while it loads.
class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }
}

// ── List Tile Shimmer ─────────────────────────────────────────────────────────

/// A shimmer placeholder for a single avatar + two-line-text list tile.
///
/// Renders a square avatar placeholder on the left and two shimmer bars
/// on the right — mirroring the structure of a real booking or notification
/// list item.
///
/// Use [ListView.builder] with a `count` to show multiple tiles:
/// ```dart
/// ListView.builder(
///   itemCount: 4,
///   itemBuilder: (_, __) => const ShimmerListTile(),
/// )
/// ```
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          children: [
            // Avatar placeholder — 64×64 rounded square
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(width: 16),
            // Text placeholder — two bars of different widths
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primary text bar — full width
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: AppColors.shimmerBase,
                  ),
                  const SizedBox(height: 8),
                  // Secondary text bar — shorter, simulating a subtitle
                  Container(
                    height: 12,
                    width: 120,
                    color: AppColors.shimmerBase,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
