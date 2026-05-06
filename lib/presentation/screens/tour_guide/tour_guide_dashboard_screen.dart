import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/base/base_providers.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:flutter_tourism_app_26/presentation/screens/chat/chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tourism_app_26/core/widgets/skeleton_shimmer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_tourism_app_26/data/models/booking_model.dart';

class TourGuideDashboardScreen extends ConsumerWidget {
  const TourGuideDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final bookingsState = ref.watch(allBookingsProvider);

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guide Panel',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.5,
                              ),
                        ),
                        Text(
                          'Welcome back, ${user?.name ?? 'Guide'}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildHeaderAction(
                      LucideIcons.rotateCcw,
                      onPressed: () => ref.invalidate(allBookingsProvider),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Stats Summary ──────────────────────────────────────────
              _buildStatsRow(bookingsState, user?.id),

              const SizedBox(height: 32),

              // ── Content Sections ───────────────────────────────────────
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Active Assignments'),
                        const SizedBox(height: 16),
                        _buildAssignmentList(bookingsState, user?.id),

                        const SizedBox(height: 32),

                        _buildSectionHeader('Traveler Chats'),
                        const SizedBox(height: 16),
                        _buildTravelerChats(bookingsState, user?.id, ref),

                        const SizedBox(height: 32),

                        _buildSupportCard(context),

                        const SizedBox(height: 120), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, {VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildStatsRow(AsyncValue bookingsState, String? guideId) {
    return bookingsState.when(
      data: (bookings) {
        final assigned = (bookings as List)
            .where((b) => b.tourGuide?.id == guideId)
            .toList();
        final activeCount = assigned
            .where((b) => b.status == 'confirmed')
            .length;
        final pendingCount = assigned
            .where((b) => b.status == 'pending')
            .length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _buildStatCard(
                'Assigned',
                activeCount.toString(),
                LucideIcons.calendarCheck,
                AppColors.primary,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Pending',
                pendingCount.toString(),
                LucideIcons.clock,
                Colors.orangeAccent,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Clients',
                assigned.length.toString(),
                LucideIcons.users,
                AppColors.secondary,
              ),
            ],
          ),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index == 2 ? 0 : 12),
                child: const SkeletonShimmer(height: 80, borderRadius: 20),
              ),
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAssignmentList(AsyncValue bookingsState, String? guideId) {
    return bookingsState.when(
      data: (bookings) {
        final assigned = (bookings as List)
            .where((b) => b.tourGuide?.id == guideId)
            .toList();
        if (assigned.isEmpty) return _buildEmptyTile('No assigned bookings');

        return Column(
          children: assigned.map((b) => _AssignmentCard(booking: b)).toList(),
        );
      },
      loading: () => Column(
        children: List.generate(2, (index) => const CardSkeleton(height: 90)),
      ),
      error: (_, __) => const Text(
        'Error loading assignments',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildTravelerChats(
    AsyncValue bookingsState,
    String? guideId,
    WidgetRef ref,
  ) {
    return bookingsState.when(
      data: (bookings) {
        final assigned =
            (bookings as List).where((b) => b.tourGuide?.id == guideId).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (assigned.isEmpty) return _buildEmptyTile('No active chats');

        // Only show the MOST RECENT chat on the dashboard
        final recentChat = assigned.first;

        return Column(
          children: [
            _TravelerChatTile(booking: recentChat),
            if (assigned.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () =>
                        ref.read(mainNavNotifierProvider.notifier).setIndex(2),
                    icon: const Icon(
                      LucideIcons.messageSquare,
                      size: 14,
                      color: AppColors.secondary,
                    ),
                    label: Text(
                      'View ${assigned.length - 1} more conversations',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const CardSkeleton(height: 70, borderRadius: 24),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.headset, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          const Text(
            'Company Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Need to speak with the service provider? Chat directly with the company manager.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logic to find company owner and chat
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Chat with Company',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTile(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final Booking booking;
  const _AssignmentCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM dd').format(booking.dates.startDate);
    final travelerName = booking.user?.name ?? 'Traveler';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      date.split(' ')[1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        height: 1,
                      ),
                    ),
                    Text(
                      date.split(' ')[0].toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.tourismService.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.user,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Traveler: $travelerName',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.building2,
                          size: 12,
                          color: AppColors.secondary.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking.tourismService.companyName,
                          style: TextStyle(
                            color: AppColors.secondary.withValues(alpha: 0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  ),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: LucideIcons.messageCircle,
              label: 'Chat Traveler',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(booking: booking),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: LucideIcons.building2,
              label: 'Chat Company',
              onPressed: () {
                final managerId = booking.tourismService.managerId;
                if (managerId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        booking: booking,
                        conversationId: managerId,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelerChatTile extends StatelessWidget {
  final Booking booking;
  const _TravelerChatTile({required this.booking});

  @override
  Widget build(BuildContext context) {
    final traveler = booking.user;
    final travelerName = traveler?.name ?? 'Traveler';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.3),
                      AppColors.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child:
                      (traveler?.avatar != null && traveler!.avatar!.isNotEmpty)
                      ? ClipOval(
                          child: Image.network(
                            traveler.avatar!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          travelerName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              title: Text(
                travelerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.messageCircle,
                      size: 12,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${booking.tourismService.companyName} • ${booking.tourismService.title}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.chevronRight,
                  color: Colors.white24,
                  size: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(booking: booking),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
