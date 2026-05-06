import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../providers/auth/auth_provider.dart';
import '../profile/profile_screen.dart';
import 'company_dashboard_overview.dart';
import 'company_services_screen.dart';
import 'company_bookings_screen.dart';
import 'company_guides_screen.dart';
import '../../../l10n/app_localizations.dart';


// ── Nav destination model ─────────────────────────────────────────────────
class _CompanyNavDest {
  final IconData icon;
  final IconData activeIcon;
  final String Function(AppLocalizations) label;
  const _CompanyNavDest({required this.icon, required this.activeIcon, required this.label});
}

final List<_CompanyNavDest> _destinations = [
  _CompanyNavDest(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: (l) => l.overview),
  _CompanyNavDest(icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: (l) => l.tripPlans),
  _CompanyNavDest(icon: Icons.people_outline, activeIcon: Icons.people_rounded, label: (l) => l.guides),
  _CompanyNavDest(icon: Icons.book_online_outlined, activeIcon: Icons.book_online_rounded, label: (l) => l.bookings),
  _CompanyNavDest(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: (l) => l.profile),
];


// ── Main Wrapper ──────────────────────────────────────────────────────────
class CompanyMainWrapper extends ConsumerStatefulWidget {
  const CompanyMainWrapper({super.key});

  @override
  ConsumerState<CompanyMainWrapper> createState() => _CompanyMainWrapperState();
}

class _CompanyMainWrapperState extends ConsumerState<CompanyMainWrapper> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    final List<Widget> screens = [
      const CompanyDashboardOverview(),
      const CompanyServicesScreen(),
      const CompanyGuidesScreen(),
      const CompanyBookingsScreen(),
      const ProfileScreen(), // Reuse profile for settings
    ];

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Row(
          children: [
            _DesktopCompanyNavRail(currentIndex: _currentIndex, onTap: _onNavTap),
            const VerticalDivider(width: 1, thickness: 1, color: Colors.white12),
            Expanded(child: IndexedStack(index: _currentIndex, children: [
              const CompanyDashboardOverview(key: ValueKey('dashboard')),
              const CompanyServicesScreen(key: ValueKey('services')),
              const CompanyGuidesScreen(key: ValueKey('guides')),
              const CompanyBookingsScreen(key: ValueKey('bookings')),
              const ProfileScreen(key: ValueKey('profile')),
            ])),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(index: _currentIndex, children: [
        const CompanyDashboardOverview(key: ValueKey('dashboard')),
        const CompanyServicesScreen(key: ValueKey('services')),
        const CompanyGuidesScreen(key: ValueKey('guides')),
        const CompanyBookingsScreen(key: ValueKey('bookings')),
        const ProfileScreen(key: ValueKey('profile')),
      ]),
      bottomNavigationBar: _BottomCompanyNavBar(currentIndex: _currentIndex, onTap: _onNavTap),
    );
  }
}

// ── Desktop NavigationRail ────────────────────────────────────────────────
class _DesktopCompanyNavRail extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DesktopCompanyNavRail({required this.currentIndex, required this.onTap});

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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.blueAccent, AppColors.primary]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.business_center, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.companyLabel, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                children: _destinations.asMap().entries.map((entry) {
                  final i = entry.key;
                  final dest = entry.value;
                  final isSelected = i == currentIndex;
                  return GestureDetector(
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected ? Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)) : null,
                      ),
                      child: Row(
                        children: [
                          Icon(isSelected ? dest.activeIcon : dest.icon, color: isSelected ? Colors.blueAccent : Colors.white54, size: 22),
                          const SizedBox(width: 14),
                          Text(dest.label(AppLocalizations.of(context)!), style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 15)),

                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
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
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          (user?.name ?? 'C').substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? AppLocalizations.of(context)!.guestLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(user?.role ?? '', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.blueAccent, size: 18),
                        onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                        tooltip: AppLocalizations.of(context)!.logOut,
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
class _BottomCompanyNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomCompanyNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: bottomPad > 0 ? bottomPad : 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xE61B065E),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_destinations.length, (index) {
                final dest = _destinations[index];
                final isSelected = index == currentIndex;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? dest.activeIcon : dest.icon,
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.white.withValues(alpha: 0.4),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                          ),
                          child: Text(dest.label(l10n)),
                        ),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isSelected ? 4 : 0,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
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

