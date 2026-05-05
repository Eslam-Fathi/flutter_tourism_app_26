import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/data/models/user_model.dart';
import 'package:flutter_tourism_app_26/presentation/providers/base/base_providers.dart';
import 'widgets/guide_selection_dialog.dart';

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
                            color: AppColors.surfaceDark.withValues(alpha: 0.6),
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
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : booking.status == 'cancelled'
                                          ? Colors.red.withValues(alpha: 0.2)
                                          : Colors.orange.withValues(
                                              alpha: 0.2,
                                            ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      booking.status.toUpperCase(),
                                      style: TextStyle(
                                        color: booking.status == 'confirmed'
                                            ? Colors.greenAccent
                                            : booking.status == 'cancelled'
                                            ? Colors.redAccent
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
                              if (booking.notes != null &&
                                  booking.notes!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.note_outlined,
                                        size: 14,
                                        color: Colors.amberAccent,
                                      ),
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
                                  if (booking.tourGuide != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.blue.withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            LucideIcons.userCheck,
                                            size: 14,
                                            color: Colors.blueAccent,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            booking.tourGuide!.name,
                                            style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (booking.status == 'pending')
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () => _handleStatusUpdate(
                                            context,
                                            ref,
                                            booking.id,
                                            'cancelled',
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.redAccent,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                          ),
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.greenAccent,
                                            foregroundColor: Colors.black,
                                            minimumSize: const Size(0, 32),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () => _handleStatusUpdate(
                                            context,
                                            ref,
                                            booking.id,
                                            'confirmed',
                                          ),
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
                                  if (booking.status == 'confirmed' &&
                                      booking.tourGuide == null)
                                    ElevatedButton.icon(
                                      onPressed: () => _showGuideSelection(
                                        context,
                                        ref,
                                        booking.id,
                                      ),
                                      icon: const Icon(
                                        LucideIcons.userPlus,
                                        size: 14,
                                      ),
                                      label: const Text(
                                        'Assign Guide',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(0, 32),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (booking.status == 'confirmed' &&
                                      booking.tourGuide != null)
                                    IconButton(
                                      onPressed: () => _showGuideSelection(
                                        context,
                                        ref,
                                        booking.id,
                                        booking.tourGuide?.id,
                                      ),
                                      icon: const Icon(
                                        LucideIcons.userCheck,
                                        size: 16,
                                        color: Colors.white70,
                                      ),
                                      tooltip: 'Change Guide',
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

  Future<void> _handleStatusUpdate(
    BuildContext context,
    WidgetRef ref,
    String bookingId,
    String status,
  ) async {
    try {
      await ref
          .read(bookingNotifierProvider.notifier)
          .updateStatus(bookingId, status);
      // Explicitly invalidate company bookings to ensure UI refresh
      ref.invalidate(companyBookingsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking ${status == 'confirmed' ? 'confirmed' : 'rejected'} successfully',
            ),
            backgroundColor: status == 'confirmed'
                ? Colors.green
                : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
  Future<void> _showGuideSelection(
    BuildContext context,
    WidgetRef ref,
    String bookingId, [
    String? currentGuideId,
  ]) async {


    final guide = await showDialog<User>(
      context: context,
      builder: (context) => const GuideSelectionDialog(),
    );

    if (guide != null && context.mounted) {
      try {
        await ref.read(bookingRepositoryProvider).assignGuide(bookingId, guide.id);
        // Explicitly invalidate company bookings to ensure UI refresh
        ref.invalidate(companyBookingsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tour guide assigned successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'), 
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
