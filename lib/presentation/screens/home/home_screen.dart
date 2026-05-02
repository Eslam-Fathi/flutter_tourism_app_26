import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/utils/responsive.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/core/widgets/section_header.dart';
import 'package:flutter_tourism_app_26/core/widgets/shimmer_loader.dart';

import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/service/service_provider.dart';
import 'package:flutter_tourism_app_26/presentation/screens/service/service_details_screen.dart';
import 'package:flutter_tourism_app_26/presentation/widgets/article_card.dart';
import 'package:flutter_tourism_app_26/presentation/screens/home/article_details_screen.dart';

import 'package:flutter_tourism_app_26/presentation/providers/admin/article_management_provider.dart';
import 'package:flutter_tourism_app_26/presentation/widgets/trending_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _showGuestPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text(
          'You need to create an account or sign in to perform this action.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(120, 44)),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final servicesAsync = ref.watch(serviceNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final isGuest = authState.status == AuthStatus.guest;

    final List<Map<String, dynamic>> categories = [
      {'label': l10n.categoryAll, 'icon': Icons.apps_rounded, 'key': 'All'},
      {'label': l10n.categoryBeach, 'icon': Icons.beach_access, 'key': 'Beach'},
      {'label': l10n.categoryMountain, 'icon': Icons.terrain, 'key': 'Mountain'},
      {'label': l10n.categoryCulture, 'icon': Icons.account_balance, 'key': 'Culture'},
      {'label': l10n.categoryAdventure, 'icon': Icons.hiking, 'key': 'Adventure'},
      {'label': l10n.categoryFood, 'icon': Icons.restaurant, 'key': 'Food'},
    ];



    final hp = Responsive.horizontalPadding(context);
    final maxW = Responsive.contentMaxWidth(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Hero height: smaller on web/desktop so it doesn't dominate
    final heroHeight = isDesktop ? 380.0 : (isTablet ? 420.0 : 460.0);
    // Card height for trending section
    final trendingCardWidth = isDesktop ? 260.0 : 220.0;
    final trendingHeight = isDesktop ? 340.0 : 310.0;

    return Scaffold(
      body: AuroraBackground(
        child: RefreshIndicator.adaptive(
          onRefresh: () => ref.read(serviceNotifierProvider.notifier).refresh(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ══════════════════════════════════════════════════
              // HERO SLIVER APP BAR
              // Search bar is placed as bottom: of the AppBar so it
              // always appears below the image — never hidden behind it.
              // ══════════════════════════════════════════════════
              SliverAppBar(
                expandedHeight: heroHeight,
                collapsedHeight: 64,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                // Search bar embedded in the AppBar's bottom slot —
                // this guarantees it never overlaps the hero image.
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(72),
                  child: _SearchBar(
                    maxWidth: maxW,
                    hp: hp,
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    onFilterTap: () => _showFilterSheet(context),
                  ),

                ),

                // leading removed to unify navigation
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: _CircleIconBtn(
                      icon: Icons.notifications_outlined,
                      onTap: () {},
                    ),
                  ),
                ],
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                    child: Container(
                      color: AppColors.backgroundDark.withValues(alpha: 0.4),
                      child: FlexibleSpaceBar(
                        stretchModes: const [
                          StretchMode.zoomBackground,
                          StretchMode.blurBackground,
                        ],
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/hero.png',
                              fit: BoxFit.cover,
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.5),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.6),
                                  ],
                                  stops: const [0.0, 0.45, 1.0],
                                ),
                              ),
                            ),
                            Positioned(
                              left: hp,
                              right: hp,
                              bottom: 96,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.discoverYour,
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    l10n.dreamGetaway,
                                    style: TextStyle(
                                      fontSize: isDesktop ? 26 : 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ══════════════════════════════════════════════════
              // CATEGORY FILTER CHIPS
              // ══════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _centeredContent(
                  maxWidth: maxW,
                  hp: hp,
                  child: SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = index == _selectedCategoryIndex;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategoryIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Theme.of(context).colorScheme.surface
                                        .withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.3)
                                      : Colors.black.withValues(alpha: 0.05),
                                  blurRadius: isSelected ? 10 : 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat['icon'] as IconData,
                                  size: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cat['label'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textMuted,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 36)),

              // ══════════════════════════════════════════════════
              // TRENDING NOW
              // Horizontal scroll on mobile/tablet
              // Wrap-around grid on desktop
              // ══════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _centeredContent(
                  maxWidth: maxW,
                  hp: hp,
                  child: SectionHeader(
                    title: l10n.trendingServices,
                    actionLabel: l10n.seeAll,
                    onAction: () {},
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverToBoxAdapter(
                child: _centeredContent(
                  maxWidth: maxW,
                  hp: hp,
                  child: servicesAsync.when(
                    data: (services) {
                      // Filter logic
                      final filteredServices = services.where((s) {
                        final matchesCategory = _selectedCategoryIndex == 0 ||
                            s.category.toLowerCase() == categories[_selectedCategoryIndex]['key'].toString().toLowerCase();
                        final matchesSearch = _searchQuery.isEmpty ||

                            s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            s.location.toLowerCase().contains(_searchQuery.toLowerCase());
                        return matchesCategory && matchesSearch;
                      }).toList();

                      if (filteredServices.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 40),
                              Icon(Icons.search_off, size: 48, color: Colors.white24),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noResults,
                                style: const TextStyle(color: Colors.white54, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      if (isDesktop) {
                        return Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: filteredServices.map((s) {
                            return SizedBox(
                              width: trendingCardWidth,
                              height: trendingHeight,
                              child: TrendingCard(
                                service: s,
                                onTap: () => _handleServiceTap(context, s, isGuest),
                              ),

                            );
                          }).toList(),
                        );
                      } else {
                        return SizedBox(
                          height: trendingHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            padding: EdgeInsets.symmetric(horizontal: hp),
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              final s = filteredServices[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == filteredServices.length - 1 ? 0 : 20,
                                ),
                                child: SizedBox(
                                  width: trendingCardWidth,
                                  child: TrendingCard(
                                    service: s,
                                    onTap: () => _handleServiceTap(context, s, isGuest),
                                  ),

                                ),
                              );
                            },
                          ),
                        );
                      }
                    },

                    loading: () => ShimmerCardList(
                      count: 4,
                      cardWidth: trendingCardWidth,
                      cardHeight: trendingHeight,
                    ),
                    error: (err, _) => _ErrorState(
                      onRetry: () =>
                          ref.read(serviceNotifierProvider.notifier).refresh(),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // ══════════════════════════════════════════════════
              // FEATURED DESTINATION BANNER
              // ══════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _centeredContent(
                  maxWidth: maxW,
                  hp: hp,
                  child: _FeaturedBanner(isDesktop: isDesktop),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // ══════════════════════════════════════════════════
              // ANCIENT STORIES (HISTORICAL ARTICLES)
              // ══════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _centeredContent(
                  maxWidth: maxW,
                  hp: hp,
                  child: SectionHeader(
                    title: l10n.ancientHistory,
                    actionLabel: l10n.seeAll,
                    onAction: () {},
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverToBoxAdapter(
                child: ref
                    .watch(articleNotifierProvider)
                    .when(
                      data: (articles) {
                        if (articles.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        if (isDesktop) {
                          return _centeredContent(
                            maxWidth: maxW,
                            hp: hp,
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: articles
                                  .map(
                                    (a) => SizedBox(
                                      width: 300,
                                      height: 380,
                                      child: ArticleCard(
                                        article: a,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ArticleDetailsScreen(
                                                    article: a,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 380,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.symmetric(horizontal: hp),
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final a = articles[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == articles.length - 1
                                        ? 0
                                        : 20,
                                  ),
                                  child: SizedBox(
                                    width: 280,
                                    child: ArticleCard(
                                      article: a,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ArticleDetailsScreen(
                                                  article: a,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                      loading: () => ShimmerCardList(
                        count: 3,
                        cardWidth: 280,
                        cardHeight: 380,
                      ),
                      error: (err, _) => const SizedBox.shrink(),
                    ),
              ),

              // Bottom padding (accounts for bottom nav)
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
        ),
      ),
    );
  }

  void _handleServiceTap(BuildContext context, service, bool isGuest) {
    if (isGuest) {
      _showGuestPopup(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceDetailsScreen(service: service),
        ),
      );
    }
  }

  void _showFilterSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.filter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.priceRange,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            RangeSlider(
              values: const RangeValues(100, 800),
              min: 0,
              max: 1000,
              divisions: 20,
              activeColor: AppColors.primary,
              inactiveColor: Colors.white10,
              labels: const RangeLabels('\$100', '\$800'),
              onChanged: (values) {},
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.applyFilters),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


// ── Helpers ───────────────────────────────────────────────────────────────

/// Centers content with max width and symmetric horizontal padding.
Widget _centeredContent({
  required Widget child,
  required double maxWidth,
  required double hp,
}) {
  return Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hp),
        child: child,
      ),
    ),
  );
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final double maxWidth;
  final double hp;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const _SearchBar({
    required this.maxWidth,
    required this.hp,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      // Vertical padding sits BELOW the hero image, inside the AppBar bottom slot
      padding: EdgeInsets.only(left: hp, right: hp, bottom: 12, top: 8),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: l10n.searchDestinations,
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: onFilterTap,
                      tooltip: l10n.filter,


                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _FeaturedBanner extends StatelessWidget {
  final bool isDesktop;

  const _FeaturedBanner({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isDesktop ? 200 : 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6809CE), Color(0xFF1E3A8A)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Opacity(
                opacity: 0.08,
                child: Image.asset('assets/images/hero.png', fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Text(
                              '🔥 SPECIAL OFFER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Egypt Adventure\nPackage 2026',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Explore Now'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '\$299',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'per person',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 40, color: AppColors.textMuted),
          const SizedBox(height: 8),
          const Text(
            'Could not load destinations',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
