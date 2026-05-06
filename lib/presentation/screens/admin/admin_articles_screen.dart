import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import '../../providers/admin/article_management_provider.dart';
import 'widgets/create_article_dialog.dart';

class AdminArticlesScreen extends ConsumerWidget {
  const AdminArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articleNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AuroraBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  AppLocalizations.of(context)!.historicalArticles,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
                floating: true,
                actions: [
                  IconButton(
                    onPressed: () =>
                        ref.read(articleNotifierProvider.notifier).refresh(),
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: articlesAsync.when(
                  data: (articles) {
                    if (articles.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(64),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.history_edu,
                                  color: Colors.white24,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!.noArticlesYet,
                                  style: const TextStyle(color: Colors.white38),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final article = articles[index];
                        return _ArticleCard(article: article);
                      }, childCount: articles.length),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (err, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.error}: $err',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateArticleDialog(),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.addArticle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _ArticleCard extends ConsumerWidget {
  final dynamic article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.white10),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            article.location,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
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
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                _showDeleteConfirm(context, ref);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          AppLocalizations.of(context)!.deleteArticle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(AppLocalizations.of(context)!.deleteArticleConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(articleNotifierProvider.notifier)
                  .deleteArticle(article.id);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
