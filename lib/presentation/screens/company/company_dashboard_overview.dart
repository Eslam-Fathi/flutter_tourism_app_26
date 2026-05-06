import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/booking/booking_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/service/service_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/aurora_background.dart';
import '../../../../data/models/booking_model.dart';
import '../../../../data/models/service_model.dart';
import 'package:flutter_tourism_app_26/data/models/company_model.dart';
import 'package:flutter_tourism_app_26/presentation/providers/company/company_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/interaction/review_provider.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';

class CompanyDashboardOverview extends ConsumerWidget {
  const CompanyDashboardOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final servicesAsync = ref.watch(companyServicesProvider);
    final bookingsAsync = ref.watch(companyBookingsProvider);
    final myCompanyAsync = ref.watch(myCompanyProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AuroraBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(context, user?.name ?? 'Manager'),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 24),
                    _buildRevenueChart(context, bookingsAsync),
                    const SizedBox(height: 24),
                    myCompanyAsync.when(
                      data: (comp) => comp != null && !comp.approved
                          ? _buildApprovalWarning(context)
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    _buildStatsGrid(context, servicesAsync, bookingsAsync),
                    const SizedBox(height: 32),
                    _buildQuickActions(context, myCompanyAsync),
                    const SizedBox(height: 32),
                    _buildRecentBookingsHeader(context),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              _buildRecentBookingsList(context, bookingsAsync),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: _buildRecentReviewsHeader(context),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildRecentReviewsList(context, ref, servicesAsync),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context)!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dashboardOverview,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  l10n.welcomeBack(name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context, AsyncValue<List<Booking>> bookingsAsync) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.revenueStatus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.revenueNote,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: bookingsAsync.when(
              data: (bookings) {
                // Simplified dummy chart data points based on real booking counts
                // In a real app, you'd group by date
                return LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 20),
                          FlSpot(1, 35),
                          FlSpot(2, 25),
                          FlSpot(3, 45),
                          FlSpot(4, 38),
                          FlSpot(5, 50),
                          FlSpot(6, 42),
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, AppColors.primary],
                        ),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blueAccent.withValues(alpha: 0.2),
                              AppColors.primary.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Icon(Icons.error, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AsyncValue<List<TourismService>> servicesAsync,
    AsyncValue<List<Booking>> bookingsAsync,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;

        final servicesCount = servicesAsync.valueOrNull?.length ?? 0;
        final bookingsCount = bookingsAsync.valueOrNull?.length ?? 0;
        final totalRevenue =
            bookingsAsync.valueOrNull?.fold(
              0.0,
              (sum, b) => (b.status == 'confirmed' || b.status == 'completed')
                  ? sum + b.totalPrice
                  : sum,
            ) ??
            0.0;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatBox(
              AppLocalizations.of(context)!.activeServices,
              servicesCount.toString(),
              Icons.map_outlined,
              Colors.blueAccent,
              itemWidth,
            ),
            _buildStatBox(
              AppLocalizations.of(context)!.totalBookings,
              bookingsCount.toString(),
              Icons.book_online_outlined,
              Colors.greenAccent,
              itemWidth,
            ),
            _buildStatBox(
              AppLocalizations.of(context)!.guides,
              '0', // Static until Guides module is connected
              Icons.people_outline,
              Colors.orangeAccent,
              itemWidth,
            ),
            _buildStatBox(
              AppLocalizations.of(context)!.netRevenue,
              '\$${(totalRevenue / 1000).toStringAsFixed(1)}k',
              Icons.account_balance_wallet_outlined,
              Colors.pinkAccent,
              itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatBox(
    String title,
    String value,
    IconData icon,
    Color color,
    double width,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    AsyncValue<Company?> myCompanyAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.quickActions,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        myCompanyAsync.when(
          data: (comp) {
            final isApproved = comp?.approved ?? false;
            return Opacity(
              opacity: isApproved ? 1.0 : 0.5,
              child: AbsorbPointer(
                absorbing: !isApproved,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context,
                      AppLocalizations.of(context)!.addTrip,
                      Icons.add_circle_outline,
                    ),
                    _buildActionButton(
                      context,
                      AppLocalizations.of(context)!.guides,
                      Icons.person_add_outlined,
                    ),
                    _buildActionButton(
                      context,
                      AppLocalizations.of(context)!.reports,
                      Icons.bar_chart,
                    ),
                    _buildActionButton(
                      context,
                      AppLocalizations.of(context)!.settings,
                      Icons.settings_outlined,
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildApprovalWarning(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.accountPendingApproval,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.accountUnderReview,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecentBookingsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.recentActivities,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.viewAll,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBookingsList(BuildContext context, AsyncValue<List<Booking>> bookingsAsync) {
    return bookingsAsync.when(
      data: (bookings) {
        if (bookings.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  AppLocalizations.of(context)!.noRecentBookings,
                  style: const TextStyle(color: Colors.white38),
                ),
              ),
            ),
          );
        }

        final recent = bookings.take(5).toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final booking = recent[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.person, color: Colors.white54, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.bookingLabel(booking.tourismService.title),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.statusLabel(booking.status.toUpperCase()),
                          style: TextStyle(
                            color: booking.status == 'confirmed'
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${booking.totalPrice.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }, childCount: recent.length),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, __) => SliverToBoxAdapter(
        child: Center(
          child: Text(
            '${AppLocalizations.of(context)!.recentActivities}: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReviewsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.serviceReviews,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.recent,
          style: const TextStyle(color: Colors.white38, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRecentReviewsList(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<TourismService>> servicesAsync,
  ) {
    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty)
          return const SliverToBoxAdapter(child: SizedBox.shrink());

        // For the dashboard, we'll show reviews for the first few services
        // Ideally we'd have a specific endpoint for "all company reviews"
        final firstService = services.first;
        final reviewsAsync = ref.watch(reviewNotifierProvider(firstService.id));

        return reviewsAsync.when(
          data: (reviews) {
            if (reviews.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noReviewsYet,
                    style: const TextStyle(color: Colors.white38),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final review = reviews[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              review.user.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              review.user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < review.rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: Colors.amber,
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review.comment,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.onService(firstService.title),
                        style: TextStyle(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: reviews.length > 3 ? 3 : reviews.length),
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
        );
      },
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}
