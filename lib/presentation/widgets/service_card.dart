import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/models/service_model.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/interaction/interaction_provider.dart';

class ServiceCard extends ConsumerStatefulWidget {
  final TourismService service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  ConsumerState<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends ConsumerState<ServiceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnim;

  String get _imageUrl =>
      widget.service.images.isNotEmpty ? widget.service.images.first : '';

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorited = ref.watch(favoriteNotifierProvider).maybeWhen(
          data: (favs) => favs.any((f) => f.service.id == widget.service.id),
          orElse: () => false,
        );

    return GestureDetector(
      onTapDown: (_) => _scaleController.reverse(),
      onTapUp: (_) {
        _scaleController.forward();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.forward(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Stack
              Stack(
                children: [
                  Hero(
                    tag: 'service-${widget.service.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30)),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: _imageUrl.isEmpty
                            ? Image.asset('assets/images/bali.png',
                                fit: BoxFit.cover)
                            : CachedNetworkImage(
                                imageUrl: _imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                    color: AppColors.shimmerBase),
                                errorWidget: (_, __, ___) => Image.asset(
                                    'assets/images/bali.png',
                                    fit: BoxFit.cover),
                              ),
                      ),
                    ),
                  ),

                  // Gradient overlay on image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30)),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Favorite button
                  Positioned(
                    top: 14,
                    right: 14,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(favoriteNotifierProvider.notifier).toggleFavorite(widget.service.id);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorited
                                  ? Colors.redAccent
                                  : AppColors.textBody,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Category pill
                  Positioned(
                    bottom: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _categoryColor(widget.service.category),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                                color:
                                    _categoryColor(widget.service.category)
                                        .withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        widget.service.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Info panel
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.service.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w900, 
                                    fontSize: 19,
                                    letterSpacing: -0.5,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${widget.service.price.toInt()}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.accent,
                              ),
                            ),
                            const Text(
                              'per person',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.service.rating.toStringAsFixed(1)} (${widget.service.reviewsCount} reviews)',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        const Icon(LucideIcons.mapPin,
                            color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.service.location,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
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
