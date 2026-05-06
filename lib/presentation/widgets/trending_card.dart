import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/service_model.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/interaction/interaction_provider.dart';

class TrendingCard extends ConsumerWidget {
  final TourismService service;
  final VoidCallback onTap;

  const TrendingCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  String get _imageUrl =>
      service.images.isNotEmpty ? service.images.first : '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorited = ref.watch(favoriteNotifierProvider).maybeWhen(
          data: (favs) => favs.any((f) => f.service.id == service.id),
          orElse: () => false,
        );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Hero(
                tag: 'trending-${service.id}',
                child: _imageUrl.isEmpty
                    ? Image.asset('assets/images/bali.png', fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: _imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                        errorWidget: (_, __, ___) =>
                            Image.asset('assets/images/bali.png', fit: BoxFit.cover),
                      ),
              ),

              // Full overlay gradient
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.cardOverlayGradient,
                ),
              ),

              // Favorite button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    ref.read(favoriteNotifierProvider.notifier).toggleFavorite(service.id);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.redAccent : Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Category badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _categoryColor(service.category),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    service.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

              // Bottom glass info panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            service.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 11, color: Colors.white70),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  service.location,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${service.price.toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 13, color: Colors.amber),
                                  const SizedBox(width: 3),
                                  Text(
                                    service.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    return AppColors.categoryColors[category] ?? AppColors.primary;
  }
}
