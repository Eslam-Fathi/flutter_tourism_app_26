import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/service_model.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user/user_provider.dart';
import 'payment_screen.dart';

/// Screen for creating a new booking for a specific service.
/// Uses the AuroraBackground for a premium look and feel.
class BookingFormScreen extends ConsumerStatefulWidget {
  final TourismService service;
  final DateTimeRange? initialDates;
  final String? initialGuideId;

  const BookingFormScreen({
    super.key,
    required this.service,
    this.initialDates,
    this.initialGuideId,
  });

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  // Local state for the booking form
  late DateTimeRange _selectedDates;
  int _adultsCount = 2;
  int _childrenCount = 0;
  final _specialRequestsController = TextEditingController();
  final bool _isSubmitting = false;
  String? _selectedGuideId;

  @override
  void initState() {
    super.initState();
    // Initialize dates to next week if not provided
    _selectedDates = widget.initialDates ??
        DateTimeRange(
          start: DateTime.now().add(const Duration(days: 7)),
          end: DateTime.now().add(const Duration(days: 10)),
        );
    _selectedGuideId = widget.initialGuideId;
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  /// Calculates the total price based on service price, nights, and guests.
  double get _totalPrice {
    final nights = _selectedDates.end.difference(_selectedDates.start).inDays;
    final basePrice = widget.service.price;
    final totalGuests = _adultsCount + (_childrenCount * 0.5); // Children are half price
    return basePrice * nights * totalGuests;
  }

  /// Opens the material date range picker
  Future<void> _pickDates() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDates,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDates = picked);
    }
  }

  /// Handles the booking submission by navigating to the Payment screen
  void _submitBooking() {
    // Prepare the booking data structure
    final bookingData = {
      'service': widget.service.id,
      'dates': {
        'startDate': _selectedDates.start.toIso8601String(),
        'endDate': _selectedDates.end.toIso8601String(),
      },
      'guests': {
        'adults': _adultsCount,
        'children': _childrenCount,
      },
      'notes': _specialRequestsController.text,
      'totalPrice': _totalPrice,
      if (_selectedGuideId != null) 'tourGuide': _selectedGuideId,
    };

    // Navigate to the payment screen instead of creating the booking immediately
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          service: widget.service,
          bookingData: bookingData,
          totalPrice: _totalPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Complete Booking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primary.withOpacity(0.2),
                          image: widget.service.images.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(widget.service.images.first),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.service.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${widget.service.price} / night',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Dates Selection
                const Text(
                  'Select Dates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickDates,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: AppColors.primary),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateFormat('MMM dd').format(_selectedDates.start)} - ${DateFormat('MMM dd, yyyy').format(_selectedDates.end)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${_selectedDates.end.difference(_selectedDates.start).inDays} Nights',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Guests Selection
                const Text(
                  'Guests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Adults Counter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Adults', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: _adultsCount > 1 ? () => setState(() => _adultsCount--) : null,
                              ),
                              Text('$_adultsCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => setState(() => _adultsCount++),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      // Children Counter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Children', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: _childrenCount > 0 ? () => setState(() => _childrenCount--) : null,
                              ),
                              Text('$_childrenCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => setState(() => _childrenCount++),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Special Requests
                const Text(
                  'Special Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _specialRequestsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Any dietary requirements, accessibility needs, etc.',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Tour Guide Selection
                const Text(
                  'Choose Your Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGuideSelection(),
                const SizedBox(height: 40),

                // Payment Summary and Submit
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Payment', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                          Text(
                            '\$${_totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _isSubmitting ? null : _submitBooking,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Confirm & Pay',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideSelection() {
    final guidesAsync = ref.watch(tourGuidesProvider);

    return guidesAsync.when(
      data: (guides) {
        if (guides.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'No guides available at the moment. One will be assigned for you.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              final isSelected = _selectedGuideId == guide.id;

              return GestureDetector(
                onTap: () => setState(() => _selectedGuideId = isSelected ? null : guide.id),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.1),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        backgroundImage: (guide.avatar != null && guide.avatar!.isNotEmpty)
                            ? NetworkImage(guide.avatar!)
                            : null,
                        child: (guide.avatar == null || guide.avatar!.isEmpty)
                            ? Text(
                                guide.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        guide.name.split(' ').first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
      error: (err, stack) => const Text('Error loading guides', style: TextStyle(color: Colors.white)),
    );
  }
}
