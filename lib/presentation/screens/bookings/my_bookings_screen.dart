import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/core/widgets/shimmer_loader.dart';
import 'package:flutter_tourism_app_26/data/models/booking_model.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen>
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
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Bookings',
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
                            'Track and manage your trips',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.sort,
                            color: Colors.white, size: 22),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Tab Bar ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    padding: const EdgeInsets.all(4),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: Colors.white70,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Tab content ───────────────────────────────────────────
              Expanded(
                child: ref.watch(bookingNotifierProvider).when(
                  data: (bookings) => TabBarView(
                    controller: _tabController,
                    children: [
                      _BookingList(
                          bookings: bookings,
                          status: 'confirmed',
                          emptyMessage: 'No upcoming trips yet'),
                      _BookingList(
                          bookings: bookings,
                          status: 'completed',
                          emptyMessage: 'No past trips'),
                      _BookingList(
                          bookings: bookings,
                          status: 'cancelled',
                          emptyMessage: 'No cancelled bookings'),
                    ],
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (err, _) => const Center(
                    child: Text('Failed to load bookings', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final String status;
  final String emptyMessage;

  const _BookingList({
    required this.bookings,
    required this.status,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = bookings
        .where((b) {
          final bStatus = b.status.toLowerCase();
          if (status == 'confirmed') {
            return bStatus == 'confirmed' || bStatus == 'pending';
          }
          return bStatus == status;
        })
        .toList();

    if (filtered.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) =>
          _BookingCard(booking: filtered[index]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.luggage_outlined,
              size: 48,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a service to see it here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status.toLowerCase()) {
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'pending':
        return AppColors.statusPending;
      case 'cancelled':
        return AppColors.statusCancelled;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image + overlay
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (booking.tourismService.images.isNotEmpty)
                    Image.network(
                      booking.tourismService.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) => Container(color: AppColors.primary.withOpacity(0.2)),
                    )
                  else
                    Container(color: AppColors.primary.withOpacity(0.2)),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.tourismService.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${dateFormat.format(booking.dates.startDate)} → ${dateFormat.format(booking.dates.endDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note_outlined,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            booking.notes!,
                            style: const TextStyle(
                              color: AppColors.textBody,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          booking.tourismService.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${booking.totalPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
