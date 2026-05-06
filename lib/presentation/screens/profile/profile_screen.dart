import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/theme/theme_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/interaction/interaction_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/theme/locale_provider.dart';
import 'package:flutter_tourism_app_26/presentation/screens/profile/edit_profile_screen.dart';
import 'package:flutter_tourism_app_26/core/utils/responsive.dart';
import 'package:flutter_tourism_app_26/core/extensions/l10n_extension.dart'; // Import l10n extension
import '../chat/conversations_screen.dart';
import '../chat/ai_chat_screen.dart';
import 'favorites_list_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final bookingsState = ref.watch(bookingNotifierProvider);
    final favState = ref.watch(favoriteNotifierProvider);

    final user = authState.user;
    final isManager =
        user?.role.toLowerCase() == 'manager' ||
        user?.role.toLowerCase() == 'company';

    final maxW = Responsive.contentMaxWidth(context);
    final hp = Responsive.horizontalPadding(context);

    final tripsCount = bookingsState.valueOrNull?.length ?? 0;
    final favCount = favState.valueOrNull?.length ?? 0;

    // For manager, we can show service count
    final servicesCount = isManager ? 12 : 0;
    final isArabic = ref.watch(localeNotifierProvider).languageCode == 'ar';

    final List<_MenuItemData> menuItems = [
      _MenuItemData(
        icon: Icons.person_outline,
        label: l10n.editProfile,
        color: AppColors.primary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          );
        },
      ),
      _MenuItemData(
        icon: Icons.auto_awesome_outlined,
        label: context.l10n.askAiGuide, // Localized AI Guide label
        color: const Color(0xFF8B5CF6),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIChatScreen()),
          );
        },
      ),
      if (user?.role.toLowerCase() != 'tourguide')
        _MenuItemData(
          icon: Icons.favorite_outline,
          label: l10n.myFavorites,
          color: Colors.pinkAccent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritesListScreen(),
              ),
            );
          },
        ),
      _MenuItemData(
        icon: Icons.settings_outlined,
        label: l10n.settings,
        color: AppColors.secondary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      ),
      _MenuItemData(
        icon: Icons.language_outlined,
        label: isArabic ? 'English' : 'العربية',
        color: Colors.blueAccent,
        onTap: () => ref.read(localeNotifierProvider.notifier).toggleLocale(),
      ),
      _MenuItemData(
        icon: Icons.help_outline,
        label: l10n.helpSupport,
        color: AppColors.textMuted,
        onTap: () {},
      ),
      _MenuItemData(
        icon: Icons.info_outline,
        label: l10n.aboutApp,
        color: AppColors.textMuted,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          );
        },
      ),
    ];

    return Scaffold(
      body: AuroraBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Profile Header ──────────────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hp),
                  sliver: SliverToBoxAdapter(
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
                                  backgroundColor: Colors.white.withOpacity(0.3),
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
                              user?.name ?? context.l10n.guestExplorer, // Localized guest name
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? context.l10n.signInFullAccess, // Localized guest email
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Role badge
                            _RoleBadge(role: user?.role),

                            const SizedBox(height: 28),

                            // Stats row
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _StatItem(
                                    value: isManager ? servicesCount.toString() : tripsCount.toString(),
                                    label: isManager ? context.l10n.services : l10n.trips, // Localized stat labels
                                    icon: isManager ? Icons.map_outlined : Icons.flight_takeoff,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  _StatItem(
                                    value: isManager ? '158' : favCount.toString(),
                                    label: isManager ? context.l10n.bookings : l10n.favorites, // Localized stat labels
                                    icon: isManager ? Icons.book_online_outlined : Icons.favorite_outline,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  _StatItem(
                                    value: isManager ? '\$42k' : '0',
                                    label: isManager ? context.l10n.revenue : l10n.reviews, // Localized stat labels
                                    icon: isManager ? Icons.account_balance_wallet_outlined : Icons.star_outline,
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

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // ── Menu Items ──────────────────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hp + 24),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: menuItems.asMap().entries.map((entry) {
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
                                  child: Icon(item.icon, color: item.color, size: 20),
                                ),
                                title: Text(
                                  item.label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                              ),
                              if (i < menuItems.length - 1)
                                Divider(
                                  height: 1,
                                  indent: 72,
                                  endIndent: 20,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // ── Logout Button ───────────────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hp + 24),
                  sliver: SliverToBoxAdapter(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error, width: 1.5),
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text(
                        l10n.logOut,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String? role;
  const _RoleBadge({this.role});

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (role) {
      'Admin' => (
          Icons.shield_outlined,
          context.l10n.administrator, // Localized role
          const Color(0xFFF59E0B),
        ),
      'Manager' => (
          Icons.business_center_outlined,
          context.l10n.manager, // Localized role
          const Color(0xFF8B5CF6),
        ),
      'TourGuide' => (
          Icons.map_outlined,
          context.l10n.tourGuideLabel, // Localized role
          const Color(0xFF10B981),
        ),
      String() => (Icons.person_outline, context.l10n.travellerLabel, const Color(0xFF6366F1)), // Localized role
      null => (Icons.visibility_outlined, context.l10n.guestLabel, Colors.white54), // Localized role
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
