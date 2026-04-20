import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/utils/responsive.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/core/widgets/section_header.dart';
import 'package:flutter_tourism_app_26/core/widgets/shimmer_loader.dart';
import 'package:flutter_tourism_app_26/presentation/providers/service/service_provider.dart';
import 'package:flutter_tourism_app_26/presentation/widgets/service_card.dart';
import 'package:flutter_tourism_app_26/presentation/screens/service/service_details_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  bool _searchFocused = false;
  String _searchQuery = '';

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'Beach', 'icon': Icons.beach_access, 'emoji': '🏖️'},
    {'label': 'Mountain', 'icon': Icons.terrain, 'emoji': '🏔️'},
    {'label': 'Culture', 'icon': Icons.account_balance, 'emoji': '🏛️'},
    {'label': 'Adventure', 'icon': Icons.hiking, 'emoji': '🧗'},
    {'label': 'City', 'icon': Icons.location_city, 'emoji': '🌆'},
    {'label': 'Food', 'icon': Icons.restaurant, 'emoji': '🍜'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(serviceNotifierProvider);
    final hp = Responsive.horizontalPadding(context);
    final maxW = Responsive.contentMaxWidth(context);
    final isDesktop = Responsive.isDesktop(context);
    final gridColumns = isDesktop ? 3 : (Responsive.isTablet(context) ? 2 : 3);

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator.adaptive(
            onRefresh: () =>
                ref.read(serviceNotifierProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                // ── Header ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxW),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(hp, 20, hp, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Find your next unforgettable experience',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Search bar
                            Focus(
                              onFocusChange: (focused) =>
                                  setState(() => _searchFocused = focused),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _searchFocused
                                          ? AppColors.primary
                                              .withValues(alpha: 0.25)
                                          : Colors.black
                                              .withValues(alpha: 0.08),
                                      blurRadius: _searchFocused ? 20 : 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: _searchFocused
                                        ? AppColors.primary
                                            .withValues(alpha: 0.5)
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (v) {
                                          setState(() => _searchQuery = v);
                                          if (v.isEmpty) {
                                            ref
                                                .read(serviceNotifierProvider
                                                    .notifier)
                                                .refresh();
                                          }
                                        },
                                        onSubmitted: (v) => ref
                                            .read(serviceNotifierProvider
                                                .notifier)
                                            .searchServices(v),
                                        decoration: const InputDecoration(
                                          hintText: 'Search destinations…',
                                          prefixIcon: Icon(Icons.search,
                                              color: AppColors.primary),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          fillColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    if (_searchQuery.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            color: AppColors.textMuted),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _searchQuery = '');
                                          ref
                                              .read(serviceNotifierProvider
                                                  .notifier)
                                              .refresh();
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                // ── Category Grid ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxW),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: hp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(
                              title: 'Browse by Category',
                              titleColor: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridColumns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final cat = _categories[index];
                                final color = AppColors.categoryColors[
                                        cat['label'] as String] ??
                                    AppColors.primary;
                                return GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(serviceNotifierProvider.notifier)
                                        .searchServices(cat['label'] as String);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          color,
                                          color.withValues(alpha: 0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cat['emoji'] as String,
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          cat['label'] as String,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),


                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // ── Popular This Week ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SectionHeader(
                      title: 'Popular This Week',
                      titleColor: Colors.white,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                servicesAsync.when(
                  data: (services) => SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ServiceCard(
                          service: services[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServiceDetailsScreen(
                                    service: services[index]),
                              ),
                            );
                          },
                        ),
                        childCount: services.length,
                      ),
                    ),
                  ),
                  loading: () => SliverToBoxAdapter(
                    child: const ShimmerServiceList(count: 3),
                  ),
                  error: (err, _) => SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off,
                              size: 48, color: Colors.white54),
                          const SizedBox(height: 12),
                          Text(
                            'Could not load services',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => ref
                                .read(serviceNotifierProvider.notifier)
                                .refresh(),
                            child: const Text('Retry',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
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
