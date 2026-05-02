import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/aurora_background.dart';

class CompanyBookingsScreen extends ConsumerWidget {
  const CompanyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(companyBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AuroraBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Manage Bookings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
                floating: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: bookingsAsync.when(
                  data: (bookings) {
                    if (bookings.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'There are no bookings yet.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final booking = bookings[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Booking #${booking.id.substring(0, 8)}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: booking.status == 'confirmed'
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      booking.status.toUpperCase(),
                                      style: TextStyle(
                                        color: booking.status == 'confirmed'
                                            ? Colors.greenAccent
                                            : Colors.orangeAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                booking.tourismService.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.blueAccent,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${DateFormat('MMM dd').format(booking.dates.startDate)} - ${DateFormat('MMM dd, yyyy').format(booking.dates.endDate)}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.note_outlined,
                                          size: 14, color: Colors.amberAccent),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          booking.notes!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${booking.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (booking.status != 'confirmed')
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.greenAccent,
                                        foregroundColor: Colors.black,
                                        minimumSize: const Size(0, 32),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                      onPressed: () async {
                                        try {
                                          await ref
                                              .read(bookingNotifierProvider
                                                  .notifier)
                                              .confirmBooking(booking.id);
                                          ref.invalidate(companyBookingsProvider);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Booking confirmed!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('Error: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }, childCount: bookings.length),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  error: (error, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error loading bookings: $error',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
