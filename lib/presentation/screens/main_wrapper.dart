import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home/home_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../providers/auth/auth_provider.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/bookings/my_bookings_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/chat/conversations_screen.dart';
import '../screens/tour_guide/tour_guide_dashboard_screen.dart';
import '../screens/tour_guide/tour_guide_schedule_screen.dart';
import '../../core/network/socket_service.dart';
import '../providers/base/base_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../core/extensions/l10n_extension.dart'; // Import l10n extension


// ── Nav destination model ─────────────────────────────────────────────────
class _NavDest {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavDest({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ── Main Wrapper ──────────────────────────────────────────────────────────
class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainNavNotifierProvider);
    final user = ref.watch(authNotifierProvider).user;
    final role = user?.role ?? 'User';
    final destinations = _getDestinations(context, role);
    final screens = _getScreens(role);
    
    // ── Global Socket Connection Logic ──────────────────────────────
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.user != null) {
        ref.read(tokenStorageProvider).getToken().then((token) {
          if (token != null) {
            ref.read(socketServiceProvider.notifier).connect(token, 'https://se-yaha.vercel.app');
          }
        });
      }
    });

    final isDesktop = Responsive.isDesktop(context);

    // ── Desktop / Web layout ──────────────────────────────────────────
    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            _DesktopNavRail(
              currentIndex: currentIndex,
              onTap: (index) => ref.read(mainNavNotifierProvider.notifier).setIndex(index),
              destinations: destinations,
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: screens,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(mainNavNotifierProvider.notifier).setIndex(index),
        destinations: destinations,
      ),
    );
  }

  List<_NavDest> _getDestinations(BuildContext context, String role) {
    final l10n = AppLocalizations.of(context)!;
    if (role == 'TourGuide') {
      return [
        _NavDest(
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard_rounded,
          label: context.l10n.dashboard, // Localized dashboard
        ),
        _NavDest(
          icon: Icons.calendar_month_outlined,
          activeIcon: Icons.calendar_month_rounded,
          label: context.l10n.schedule, // Localized schedule
        ),
        _NavDest(
          icon: Icons.chat_bubble_outline,
          activeIcon: Icons.chat_bubble,
          label: l10n.messages,
        ),
        _NavDest(
          icon: Icons.person_outline,
          activeIcon: Icons.person_rounded,
          label: l10n.profile,
        ),
      ];
    }

    return [
      _NavDest(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: l10n.home),
      _NavDest(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: l10n.explore),
      _NavDest(icon: Icons.luggage_outlined, activeIcon: Icons.luggage, label: l10n.bookings),
      _NavDest(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: l10n.messages),
      _NavDest(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: l10n.profile),
    ];
  }

  List<Widget> _getScreens(String role) {
    if (role == 'TourGuide') {
      return [
        const TourGuideDashboardScreen(),
        const TourGuideScheduleScreen(),
        const ConversationsScreen(),
        const ProfileScreen(),
      ];
    }

    return [
      const HomeScreen(),
      const ExploreScreen(),
      const MyBookingsScreen(),
      const ConversationsScreen(),
      const ProfileScreen(),
    ];
  }
}

// ── Desktop NavigationRail ────────────────────────────────────────────────
class _DesktopNavRail extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavDest> destinations;

  const _DesktopNavRail({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Container(
      width: 220,
      color: AppColors.backgroundDark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo / Brand
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.travel_explore,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'SeYaha',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Nav items
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                children: destinations.asMap().entries.map((entry) {
                  final i = entry.key;
                  final dest = entry.value;
                  final isSelected = i == currentIndex;
                  return GestureDetector(
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primary
                                    .withValues(alpha: 0.3))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? dest.activeIcon : dest.icon,
                            color: isSelected
                                ? AppColors.secondary
                                : Colors.white54,
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            dest.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white54,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // User + logout at the bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          (user?.name ?? 'G')
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? context.l10n.guest, // Localized guest fallback
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user?.role ?? context.l10n.guest, // Localized role fallback
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: Colors.redAccent, size: 18),
                        onPressed: () => ref
                            .read(authNotifierProvider.notifier)
                            .logout(),
                        tooltip: context.l10n.logOut, // Localized tooltip
                      ),
                    ],
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

// ── Mobile Bottom Navigation Bar ─────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavDest> destinations;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    
    return Container(
      margin: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: bottomPad > 0 ? bottomPad : 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (index) {
                final dest = destinations[index];
                final isSelected = index == currentIndex;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.translucent,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? dest.activeIcon : dest.icon,
                            color: isSelected
                                ? AppColors.secondary
                                : Colors.white.withValues(alpha: 0.5),
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                            child: Text(dest.label),
                          ),
                          const SizedBox(height: 2),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isSelected ? 4 : 0,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}


