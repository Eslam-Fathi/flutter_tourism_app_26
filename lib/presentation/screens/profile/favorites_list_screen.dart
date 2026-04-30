import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../widgets/service_card.dart';
import '../../providers/interaction/interaction_provider.dart';
import '../service/service_details_screen.dart';

/// Screen displaying the user's favorite tourism services.
/// Uses a sliver list to display the items.
class FavoritesListScreen extends ConsumerWidget {
  const FavoritesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Watch the favorite services provider
    final favState = ref.watch(favoriteNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.myFavorites),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: favState.when(
            data: (services) {
              if (services.isEmpty) {
                // Display a friendly message if no favorites are found
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noFavoritesYet,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.startExploringFavorites,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Display the list of favorite services using ServiceCard
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        // The 'services' list is actually a list of 'Favorite' objects
                        final favorite = services[index];
                        final service = favorite.service;

                        return ServiceCard(
                          service: service,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ServiceDetailsScreen(service: service),
                              ),
                            );
                          },
                        );
                      }, childCount: services.length),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (err, stack) => Center(
              child: Text(
                'Failed to load favorites',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
