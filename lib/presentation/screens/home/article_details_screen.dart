import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../data/models/article_model.dart';
import '../../../core/theme/app_colors.dart';

/// Screen to display the full content of an ancient history article.
/// Features a stunning hero image header and reading-optimized typography.
class ArticleDetailsScreen extends StatelessWidget {
  final HistoricalArticle article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'article-${article.id}',
                    child: CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) => const Icon(Icons.error, color: Colors.white),
                    ),
                  ),
                  // Gradient Overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xAA000000),
                        ],
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                  // Title overlay at the bottom of the image
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Ancient History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          article.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Article Content ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author & Date Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: Text(
                            article.author.isNotEmpty ? article.author[0].toUpperCase() : 'A',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textBody,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM d, yyyy').format(article.createdAt),
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.share_outlined, color: AppColors.textMuted),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border, color: AppColors.textMuted),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Location Info
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          article.location,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBody,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.shimmerBase),
                    const SizedBox(height: 24),

                    // Main Article Body
                    Text(
                      article.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textBody,
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
