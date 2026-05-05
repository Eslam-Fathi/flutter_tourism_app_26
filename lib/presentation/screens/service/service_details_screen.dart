import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../data/models/service_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../bookings/booking_form_screen.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/booking/booking_provider.dart';
import 'package:flutter_tourism_app_26/core/utils/responsive.dart';
import 'widgets/review_widgets.dart';
import '../../providers/user/user_provider.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  final TourismService service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  ConsumerState<ServiceDetailsScreen> createState() =>
      _ServiceDetailsScreenState();

  static void show(BuildContext context, TourismService service) {
    if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 850),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: ServiceDetailsScreen(service: service),
            ),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceDetailsScreen(service: service),
        ),
      );
    }
  }
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isFavorited = false;
  DateTimeRange? _selectedDates;
  String? _selectedGuideId;
  late TabController _infoTabController;

  String get _imageUrl =>
      widget.service.images.isNotEmpty ? widget.service.images.first : '';

  @override
  void initState() {
    super.initState();
    _infoTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _infoTabController.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final picked = await showDateRangePicker(
      context: context,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Sticky image header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: Hero(
              tag: 'service-${widget.service.id}',
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _imageUrl.isEmpty
                      ? Image.asset('assets/images/bali.png', fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: _imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: AppColors.shimmerBase),
                          errorWidget: (_, __, ___) => Image.asset(
                            'assets/images/bali.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                  // Gradient scrim
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x99000000),
                          Colors.transparent,
                          Color(0xBB000000),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Spacer to show image
              const SliverToBoxAdapter(child: SizedBox(height: 340)),

              // Content card
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Category + Rating
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (AppColors.categoryColors[widget
                                                .service
                                                .category] ??
                                            AppColors.primary)
                                        .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                widget.service.category,
                                style: TextStyle(
                                  color:
                                      AppColors.categoryColors[widget
                                          .service
                                          .category] ??
                                      AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.service.rating.toStringAsFixed(1)} (${widget.service.reviewsCount})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBody,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          widget.service.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 10),

                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.service.location,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Info pills
                        Row(
                          children: [
                            _InfoPill(
                              icon: Icons.schedule_outlined,
                              label: '7 Days',
                              color: AppColors.primary,
                            ),
                            _InfoPill(
                              icon: Icons.people_outline,
                              label: 'Max 12',
                              color: AppColors.success,
                            ),
                            _InfoPill(
                              icon: Icons.language,
                              label: 'English',
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Tab bar
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TabBar(
                            controller: _infoTabController,
                            padding: const EdgeInsets.all(4),
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textMuted,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            tabs: [
                              Tab(text: l10n.about),
                              const Tab(text: 'Itinerary'),
                              Tab(text: l10n.reviews),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tab views
                        SizedBox(
                          height: 220,
                          child: TabBarView(
                            controller: _infoTabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              // Overview tab
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.service.cleanDescription.isEmpty
                                          ? 'Experience the breathtaking beauty of ${widget.service.location}. Immerse yourself in the local culture, enjoy stunning views, and create memories that will last a lifetime. Our expert guides ensure you have a safe and unforgettable journey through this magnificent destination.'
                                          : widget.service.cleanDescription,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: AppColors.textBody,
                                        height: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Choose Your Preferred Guide',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.textBody,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildGuideSelector(),
                                  ],
                                ),
                              ),
                              // Itinerary tab
                              ListView(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                children: const [
                                  _ItineraryItem(
                                    day: 1,
                                    title: 'Arrival & Welcome Tour',
                                  ),
                                  _ItineraryItem(
                                    day: 2,
                                    title: 'Main Attractions Visit',
                                  ),
                                  _ItineraryItem(
                                    day: 3,
                                    title: 'Cultural Immersion Day',
                                  ),
                                ],
                              ),
                              // Reviews tab
                              Column(
                                children: [
                                  Expanded(
                                    child: ReviewList(serviceId: widget.service.id),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildAddReviewButton(context, ref),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Date selector
                        GestureDetector(
                          onTap: _pickDates,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Select Dates',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textBody,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _selectedDates == null
                                          ? 'Tap to choose dates'
                                          : '${DateFormat('MMM dd').format(_selectedDates!.start)} → ${DateFormat('MMM dd, yyyy').format(_selectedDates!.end)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _selectedDates == null
                                            ? AppColors.textMuted
                                            : AppColors.primary,
                                        fontWeight: _selectedDates == null
                                            ? FontWeight.normal
                                            : FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Extra space for bottom sheet
                        SizedBox(height: 120 + bottomPad),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Floating app bar ─────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _CircleNavBtn(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    _CircleNavBtn(icon: Icons.share_outlined, onTap: () {}),
                    const SizedBox(width: 10),
                    _CircleNavBtn(
                      icon: _isFavorited
                          ? Icons.favorite
                          : Icons.favorite_border,
                      iconColor: _isFavorited ? Colors.redAccent : Colors.white,
                      onTap: () => setState(() => _isFavorited = !_isFavorited),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom CTA Glass Sheet ───────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + bottomPad),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Price',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '\$${widget.service.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.accent,
                            ),
                          ),
                          Text(
                            l10n.perPerson,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, Color(0xFF4338CA)],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingFormScreen(
                                      service: widget.service,
                                      initialDates: _selectedDates,
                                      initialGuideId: _selectedGuideId,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                l10n.bookNow,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddReviewButton(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final bookingsAsync = ref.watch(bookingNotifierProvider);
    
    final user = authState.user;
    if (user == null) return const SizedBox.shrink();

    return bookingsAsync.when(
      data: (bookings) {
        final hasConfirmedBooking = bookings.any((b) => 
          b.tourismService.id == widget.service.id && b.status == 'confirmed'
        );
        final isAdmin = user.role == 'Admin';

        if (!hasConfirmedBooking && !isAdmin) return const SizedBox.shrink();

        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddReviewSheet(serviceId: widget.service.id),
              );
            },
            icon: const Icon(Icons.add_comment_rounded, size: 18),
            label: const Text('Write a Review'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildGuideSelector() {
    final guidesAsync = ref.watch(tourGuidesProvider);

    return guidesAsync.when(
      data: (guides) {
        if (guides.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              final isSelected = _selectedGuideId == guide.id;

              return GestureDetector(
                onTap: () => setState(() => _selectedGuideId = isSelected ? null : guide.id),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.black.withValues(alpha: 0.05),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        backgroundImage: (guide.avatar != null && guide.avatar!.isNotEmpty)
                            ? NetworkImage(guide.avatar!)
                            : null,
                        child: (guide.avatar == null || guide.avatar!.isEmpty)
                            ? Text(
                                guide.name[0].toUpperCase(),
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        guide.name.split(' ').first,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textBody,
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildGuideInfo(dynamic guideOrId) {
    if (guideOrId == null) return const SizedBox.shrink();
    
    if (guideOrId is User) {
      return _buildGuideUI(guideOrId);
    }
    
    final userRole = ref.watch(authNotifierProvider).user?.role;
    final guideAsync = ref.watch(userByIdProvider(guideOrId.toString()));

    return guideAsync.when(
      data: (guide) {
        if (guide != null) return _buildGuideUI(guide);
        
        // Fallback for travelers if guide fetch returned null (e.g. due to 403)
        if (userRole?.toLowerCase() == 'user') {
          return _buildGuideUI(User(
            id: guideOrId.toString(),
            name: 'Professional Guide',
            email: '',
            role: 'guide',
          ));
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (error, stack) {
        // If forbidden (403), it means the user is a traveler and cannot fetch user details directly.
        // We show a skeleton "Assigned Guide" instead of an error or empty space.
        if (error.toString().contains('403') || userRole?.toLowerCase() == 'user') {
          return _buildGuideUI(User(
            id: guideOrId.toString(),
            name: 'Professional Guide',
            email: '',
            role: 'guide',
          ));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGuideUI(User guide) {
    return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: (guide.avatar != null && guide.avatar!.isNotEmpty)
                    ? NetworkImage(guide.avatar!)
                    : null,
                child: (guide.avatar == null || guide.avatar!.isEmpty)
                    ? Text(guide.name[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Text(
                      'Certified Tour Guide',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You can start a chat with your guide as soon as you book this service!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        );
  }
}

class _CircleNavBtn extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleNavBtn({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: iconColor ?? Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItineraryItem extends StatelessWidget {
  final int day;
  final String title;

  const _ItineraryItem({required this.day, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textBody,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
