import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tourism_app_26/core/widgets/skeleton_shimmer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_tourism_app_26/data/models/booking_model.dart';
import 'package:flutter_tourism_app_26/presentation/screens/chat/chat_screen.dart';

class TourGuideScheduleScreen extends ConsumerStatefulWidget {
  const TourGuideScheduleScreen({super.key});

  @override
  ConsumerState<TourGuideScheduleScreen> createState() => _TourGuideScheduleScreenState();
}

class _TourGuideScheduleScreenState extends ConsumerState<TourGuideScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          'Schedule',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.5,
                              ),
                        ),
                        Text(
                          'Manage your tour assignments',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildHeaderAction(LucideIcons.rotateCcw, onPressed: () => ref.invalidate(allBookingsProvider)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Tab Bar ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withOpacity(0.4),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Tab Content ───────────────────────────────────────────
              Expanded(
                child: bookingsState.when(
                  data: (bookings) {
                    final myAssignments = (bookings as List)
                        .where((b) => b.tourGuide?.id == user?.id)
                        .toList();

                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);

                    final upcoming = myAssignments.where((b) {
                      final isCancelled = b.status.toLowerCase() == 'cancelled';
                      final isPastDate = b.dates.endDate.isBefore(today);
                      return !isCancelled && !isPastDate;
                    }).toList();

                    final past = myAssignments.where((b) {
                      final isCompleted = b.status.toLowerCase() == 'completed';
                      final isPastDate = b.dates.endDate.isBefore(today);
                      final isCancelled = b.status.toLowerCase() == 'cancelled';
                      return (isCompleted || isPastDate) && !isCancelled;
                    }).toList();

                    final cancelled =
                        myAssignments.where((b) => b.status.toLowerCase() == 'cancelled').toList();

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _AssignmentList(
                          bookings: upcoming,
                          emptyMessage: 'No upcoming assignments',
                        ),
                        _AssignmentList(
                          bookings: past,
                          emptyMessage: 'No past assignments',
                        ),
                        _AssignmentList(
                          bookings: cancelled,
                          emptyMessage: 'No cancelled assignments',
                        ),
                      ],
                    );
                  },
                  loading: () => ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: 3,
                    itemBuilder: (_, __) => const CardSkeleton(height: 160, margin: EdgeInsets.only(bottom: 16)),
                  ),
                  error: (_, __) => const Center(
                    child: Text('Error loading schedule', style: TextStyle(color: Colors.white)),
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
}

class _AssignmentList extends StatelessWidget {
  final List<dynamic> bookings;
  final String emptyMessage;

  const _AssignmentList({
    required this.bookings,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = List<dynamic>.from(bookings)
      ..sort((a, b) => b.dates.startDate.compareTo(a.dates.startDate));

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.calendarX, size: 64, color: Colors.white.withOpacity(0.1)),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _ScheduleCard(booking: filtered[index]),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Booking booking;
  const _ScheduleCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM dd');
    final traveler = booking.user;
    final travelerName = traveler?.name ?? 'Traveler';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _getStatusColor(booking.status).withOpacity(0.2)),
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(booking.status),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      dateFormat.format(booking.dates.startDate),
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  booking.tourismService.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 14, color: AppColors.primary.withOpacity(0.6)),
                    const SizedBox(width: 6),
                    Text(
                      booking.tourismService.location,
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white10),
                ),
                Row(
                  children: [
                    _buildUserAvatar(traveler),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            travelerName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            'Primary Traveler',
                            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen(booking: booking)),
                        );
                      },
                      icon: const Icon(LucideIcons.messageCircle, color: AppColors.secondary, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.secondary.withOpacity(0.1),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(dynamic user) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.05)],
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Center(
        child: (user?.avatar != null && user!.avatar!.isNotEmpty)
            ? ClipOval(child: Image.network(user.avatar!, fit: BoxFit.cover))
            : Text(
                (user?.name ?? 'T').substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'pending':
        return Colors.orangeAccent;
      case 'cancelled':
        return Colors.redAccent;
      case 'completed':
        return AppColors.secondary;
      default:
        return Colors.grey;
    }
  }
}
