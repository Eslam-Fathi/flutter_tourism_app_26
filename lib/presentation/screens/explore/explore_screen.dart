import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/utils/responsive.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/core/widgets/section_header.dart';
import 'package:flutter_tourism_app_26/core/widgets/shimmer_loader.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'package:flutter_tourism_app_26/presentation/providers/service/service_provider.dart';
import 'package:flutter_tourism_app_26/presentation/widgets/service_card.dart';
import 'package:flutter_tourism_app_26/presentation/screens/service/service_details_screen.dart';
import '../../providers/notification_provider.dart';
import '../profile/notifications_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  bool _searchFocused = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterPanel() {
    // For web/desktop, we could show a side sheet or dialog.
    // For mobile, a bottom sheet is best.
    if (Responsive.isDesktop(context)) {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(content: Text('Desktop filters coming soon')),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const _FilterBottomSheet(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final servicesAsync = ref.watch(serviceNotifierProvider);
    final hp = Responsive.horizontalPadding(context);
    final maxW = Responsive.contentMaxWidth(context);
    final isDesktop = Responsive.isDesktop(context);

    final List<Map<String, dynamic>> categoriesList = [
      {
        'label': l10n.categoryHotels,
        'value': 'Hotel',
        'icon': LucideIcons.hotel,
      },
      {
        'label': l10n.categoryApartments,
        'value': 'RealEstate',
        'icon': LucideIcons.building2,
      },
      {'label': l10n.categoryTours, 'value': 'Tours', 'icon': LucideIcons.map},
      {'label': l10n.categoryCars, 'value': 'Cars', 'icon': LucideIcons.car},
      {
        'label': l10n.categoryAll,
        'value': 'All',
        'icon': LucideIcons.layoutGrid,
      },
    ];

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator.adaptive(
            onRefresh: () =>
                ref.read(serviceNotifierProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.explore,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                      ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _CircleIconBtn(
                                      icon: Icons.notifications_outlined,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const NotificationsScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    if (ref
                                            .watch(
                                              notificationNotifierProvider
                                                  .notifier,
                                            )
                                            .unreadCount >
                                        0)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            '${ref.watch(notificationNotifierProvider.notifier).unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
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
                            Row(
                              children: [
                                Expanded(
                                  child: Focus(
                                    onFocusChange: (focused) => setState(
                                      () => _searchFocused = focused,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 12,
                                          sigmaY: 12,
                                        ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: _searchFocused
                                                  ? 0.25
                                                  : 0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: _searchFocused
                                                  ? AppColors.primary
                                                        .withValues(alpha: 0.5)
                                                  : Colors.white.withValues(
                                                      alpha: 0.15,
                                                    ),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              if (_searchFocused)
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 4),
                                                ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _searchController,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  onChanged: (v) {
                                                    setState(
                                                      () => _searchQuery = v,
                                                    );
                                                    if (v.isEmpty) {
                                                      ref
                                                          .read(
                                                            serviceNotifierProvider
                                                                .notifier,
                                                          )
                                                          .refresh();
                                                    }
                                                  },
                                                  onSubmitted: (v) => ref
                                                      .read(
                                                        serviceNotifierProvider
                                                            .notifier,
                                                      )
                                                      .searchServices(v),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        l10n.searchDestinations,
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                                    prefixIcon: const Icon(
                                                      LucideIcons.search,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    border: InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    fillColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                              if (_searchQuery.isNotEmpty)
                                                IconButton(
                                                  icon: const Icon(
                                                    LucideIcons.x,
                                                    color: Colors.white70,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {
                                                    _searchController.clear();
                                                    setState(
                                                      () => _searchQuery = '',
                                                    );
                                                    ref
                                                        .read(
                                                          serviceNotifierProvider
                                                              .notifier,
                                                        )
                                                        .refresh();
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 12,
                                      sigmaY: 12,
                                    ),
                                    child: InkWell(
                                      onTap: _showFilterPanel,
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.15,
                                            ),
                                          ),
                                        ),
                                        child: const Icon(
                                          LucideIcons.slidersHorizontal,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                              title: l10n.browseByCategory,
                              titleColor: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: categoriesList.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final cat = categoriesList[index];
                                  final color =
                                      AppColors.categoryColors[cat['value']
                                          as String] ??
                                      AppColors.primary;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8,
                                        sigmaY: 8,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(
                                                serviceNotifierProvider
                                                    .notifier,
                                              )
                                              .applyFilters(
                                                category:
                                                    cat['value'] as String,
                                              );
                                        },
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.2),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                color.withValues(alpha: 0.4),
                                                color.withValues(alpha: 0.1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: color.withValues(
                                                alpha: 0.3,
                                              ),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                cat['icon'] as IconData,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                cat['label'] as String,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                      title: l10n.popularThisWeek,
                      titleColor: Colors.white,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                servicesAsync.when(
                  data: (services) {
                    final columns = isDesktop
                        ? 2
                        : (Responsive.isTablet(context) ? 2 : 1);
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                      sliver: columns > 1
                          ? SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: 380,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => ServiceCard(
                                  service: services[index],
                                  onTap: () => ServiceDetailsScreen.show(
                                    context,
                                    services[index],
                                  ),
                                ),
                                childCount: services.length,
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => ServiceCard(
                                  service: services[index],
                                  onTap: () => ServiceDetailsScreen.show(
                                    context,
                                    services[index],
                                  ),
                                ),
                                childCount: services.length,
                              ),
                            ),
                    );
                  },
                  loading: () => SliverToBoxAdapter(
                    child: const ShimmerServiceList(count: 3),
                  ),
                  error: (err, _) => SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 48,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Could not load services',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => ref
                                .read(serviceNotifierProvider.notifier)
                                .refresh(),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.white),
                            ),
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

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  double _priceRange = 1000;
  String _selectedCategory = 'All';

  final List<Map<String, String>> _categories = [
    {'label': 'All', 'value': 'All'},
    {'label': 'Hotels', 'value': 'Hotel'},
    {'label': 'Apartments', 'value': 'RealEstate'},
    {'label': 'Tours', 'value': 'Tours'},
    {'label': 'Cars', 'value': 'Cars'},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.filter,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['value'];
                return ChoiceChip(
                  label: Text(cat['label']!),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = cat['value']!);
                  },
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.priceRange,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Slider(
            value: _priceRange,
            min: 0,
            max: 2000,
            divisions: 20,
            activeColor: AppColors.primary,
            inactiveColor: Colors.white.withValues(alpha: 0.1),
            label: '\$${_priceRange.round()}',
            onChanged: (val) => setState(() => _priceRange = val),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ref
                    .read(serviceNotifierProvider.notifier)
                    .applyFilters(
                      category: _selectedCategory,
                      maxPrice: _priceRange,
                    );
              },
              child: Text(
                l10n.applyFilters,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
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
