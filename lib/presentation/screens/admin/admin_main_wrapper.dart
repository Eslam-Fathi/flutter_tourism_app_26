import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../providers/auth/auth_provider.dart';
import 'admin_dashboard_overview.dart';
import 'admin_users_screen.dart';
import 'admin_companies_screen.dart';
import '../profile/profile_screen.dart';

// ── Nav destination model ─────────────────────────────────────────────────
class _AdminNavDest {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _AdminNavDest({required this.icon, required this.activeIcon, required this.label});
}

const List<_AdminNavDest> _destinations = [
  _AdminNavDest(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Overview'),
  _AdminNavDest(icon: Icons.people_outline, activeIcon: Icons.people_rounded, label: 'Users'),
  _AdminNavDest(icon: Icons.business_outlined, activeIcon: Icons.business_rounded, label: 'Companies'),
  _AdminNavDest(icon: Icons.admin_panel_settings_outlined, activeIcon: Icons.admin_panel_settings_rounded, label: 'Admin'),
];

// ── Main Wrapper ──────────────────────────────────────────────────────────
class AdminMainWrapper extends ConsumerStatefulWidget {
  const AdminMainWrapper({super.key});

  @override
  ConsumerState<AdminMainWrapper> createState() => _AdminMainWrapperState();
}

class _AdminMainWrapperState extends ConsumerState<AdminMainWrapper> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    final List<Widget> screens = [
      const AdminDashboardOverview(),
      const AdminUsersScreen(),
      const AdminCompaniesScreen(),
      const ProfileScreen(), // Reuse profile for settings
    ];

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Row(
          children: [
            _DesktopAdminNavRail(currentIndex: _currentIndex, onTap: _onNavTap),
            const VerticalDivider(width: 1, thickness: 1, color: Colors.white12),
            Expanded(child: IndexedStack(index: _currentIndex, children: screens)),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: _BottomAdminNavBar(currentIndex: _currentIndex, onTap: _onNavTap),
    );
  }
}

// ── Desktop NavigationRail ────────────────────────────────────────────────
class _DesktopAdminNavRail extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DesktopAdminNavRail({required this.currentIndex, required this.onTap});

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
                      gradient: const LinearGradient(colors: [Colors.redAccent, AppColors.primary]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text('Admin', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
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
                        color: isSelected ? Colors.redAccent.withValues(alpha: 0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected ? Border.all(color: Colors.redAccent.withValues(alpha: 0.3)) : null,
                      ),
                      child: Row(
                        children: [
                          Icon(isSelected ? dest.activeIcon : dest.icon, color: isSelected ? Colors.redAccent : Colors.white54, size: 22),
                          const SizedBox(width: 14),
                          Text(dest.label, style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 15)),
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
                        backgroundColor: Colors.redAccent,
                        child: Text(
                          (user?.name ?? 'A').substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'Admin', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(user?.role ?? 'Role', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                        onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                        tooltip: 'Log out',
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
class _BottomAdminNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomAdminNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10 + bottomPad),
          decoration: const BoxDecoration(
            color: Color(0xF21B065E),
            border: Border(top: BorderSide(color: Colors.white12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.redAccent.withValues(alpha: 0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isSelected ? dest.activeIcon : dest.icon,
                          color: isSelected ? Colors.redAccent : Colors.white54,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.redAccent : Colors.white54,
                        ),
                        child: Text(dest.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
