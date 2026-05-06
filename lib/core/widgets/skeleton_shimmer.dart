import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
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
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
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

class CardSkeleton extends StatelessWidget {
  final double height;
  final double borderRadius;
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

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Row Skeleton
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
        // Content Skeletons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonShimmer(width: 150, height: 24, borderRadius: 8),
              const SizedBox(height: 16),
              const CardSkeleton(height: 80),
              const CardSkeleton(height: 80),
              const SizedBox(height: 32),
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
