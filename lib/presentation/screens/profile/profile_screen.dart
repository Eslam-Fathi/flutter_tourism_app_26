import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/theme/theme_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/interaction/interaction_provider.dart';
import '../chat/conversations_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final bookingsState = ref.watch(bookingNotifierProvider);
    final favState = ref.watch(favoriteNotifierProvider);
    
    final user = authState.user;
    final tripsCount = bookingsState.valueOrNull?.length ?? 0;
    final favCount = favState.valueOrNull?.length ?? 0;

    final List<_MenuItem> menuItems = [
      _MenuItem(
          icon: Icons.person_outline,
          label: 'Edit Profile',
          color: AppColors.primary,
          onTap: () {}),
      _MenuItem(
          icon: Icons.chat_bubble_outline,
          label: 'Messages',
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConversationsScreen(),
              ),
            );
          }),
      _MenuItem(
          icon: Icons.favorite_outline,
          label: 'My Favorites',
          color: Colors.pinkAccent,
          onTap: () {}),
      _MenuItem(
          icon: Icons.credit_card_outlined,
          label: 'Payment Methods',
          color: AppColors.success,
          onTap: () {}),
      _MenuItem(
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          color: AppColors.warning,
          onTap: () {}),
      _MenuItem(
          icon: themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          label: 'Dark Mode',
          color: AppColors.primary,
          trailing: Switch.adaptive(
            value: themeMode == ThemeMode.dark,
            onChanged: (val) {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
          onTap: () {
            ref.read(themeNotifierProvider.notifier).toggleTheme();
          }),
      _MenuItem(
          icon: Icons.settings_outlined,
          label: 'Settings',
          color: AppColors.secondary,
          onTap: () {}),
      _MenuItem(
          icon: Icons.help_outline,
          label: 'Help & Support',
          color: AppColors.textMuted,
          onTap: () {}),
      _MenuItem(
          icon: Icons.info_outline,
          label: 'About SeYaha',
          color: AppColors.textMuted,
          onTap: () {}),
    ];

    return Scaffold(
      body: AuroraBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Profile Header ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor:
                                Colors.white.withOpacity(0.3),
                            child: user?.avatar != null && user!.avatar!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      user.avatar!,
                                      width: 104,
                                      height: 104,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
                                    (user?.name ?? 'G')
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name & email
                      Text(
                        user?.name ?? 'Guest Explorer',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'Sign in for full access',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          user?.role == 'Admin'
                              ? '👑 Administrator'
                              : user != null
                                  ? '✈️ Traveller'
                                  : '👀 Guest',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Stats row
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                                value: tripsCount.toString(),
                                label: 'Trips',
                                icon: Icons.flight_takeoff),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withOpacity(0.2)),
                            _StatItem(
                                value: favCount.toString(),
                                label: 'Favorites',
                                icon: Icons.favorite_outline),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withOpacity(0.2)),
                            _StatItem(
                                value: '0',
                                label: 'Reviews',
                                icon: Icons.star_outline),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Menu Items ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: menuItems
                      .asMap()
                      .entries
                      .map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        ListTile(
                          onTap: item.onTap,
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.icon,
                                color: item.color, size: 20),
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: item.trailing ?? const Icon(
                            Icons.chevron_right,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        if (i < menuItems.length - 1)
                          Divider(
                            height: 1,
                            indent: 72,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Logout ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(
                        color: AppColors.error, width: 1.5),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  onPressed: () =>
                      ref.read(authNotifierProvider.notifier).logout(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.trailing,
  });
}
