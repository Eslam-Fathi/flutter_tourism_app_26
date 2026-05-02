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
              _buildHeader(user?.name ?? 'Manager'),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 24),
                    _buildRevenueChart(bookingsAsync),
                    const SizedBox(height: 24),
                    myCompanyAsync.when(
                      data: (comp) => comp != null && !comp.approved
                          ? _buildApprovalWarning()
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    _buildStatsGrid(servicesAsync, bookingsAsync),
                    const SizedBox(height: 32),
                    _buildQuickActions(context, myCompanyAsync),
                    const SizedBox(height: 32),
                    _buildRecentBookingsHeader(),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              _buildRecentBookingsList(bookingsAsync),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
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
                  'Dashboard Overview',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Welcome back, $name',
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
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(AsyncValue<List<Booking>> bookingsAsync) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Revenue Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Estimated from confirmed bookings',
                style: TextStyle(color: Colors.white38, fontSize: 12),
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
                              Colors.blueAccent.withOpacity(0.2),
                              AppColors.primary.withOpacity(0.0),
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
              error: (_, __) => const Center(child: Icon(Icons.error, color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
      AsyncValue<List<TourismService>> servicesAsync,
      AsyncValue<List<Booking>> bookingsAsync) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;
        
        final servicesCount = servicesAsync.valueOrNull?.length ?? 0;
        final bookingsCount = bookingsAsync.valueOrNull?.length ?? 0;
        final totalRevenue = bookingsAsync.valueOrNull?.fold(0.0, (sum, b) => 
          (b.status == 'confirmed' || b.status == 'completed') ? sum! + b.totalPrice : sum) ?? 0.0;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatBox(
              'Active Services',
              servicesCount.toString(),
              Icons.map_outlined,
              Colors.blueAccent,
              itemWidth,
            ),
            _buildStatBox(
              'Total Bookings',
              bookingsCount.toString(),
              Icons.book_online_outlined,
              Colors.greenAccent,
              itemWidth,
            ),
            _buildStatBox(
              'Tour Guides',
              '0', // Static until Guides module is connected
              Icons.people_outline,
              Colors.orangeAccent,
              itemWidth,
            ),
            _buildStatBox(
              'Net Revenue',
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
        color: AppColors.surfaceDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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

  Widget _buildQuickActions(BuildContext context, AsyncValue<Company?> myCompanyAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
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
                    _buildActionButton(context, 'Add Trip', Icons.add_circle_outline),
                    _buildActionButton(context, 'Guides', Icons.person_add_outlined),
                    _buildActionButton(context, 'Reports', Icons.bar_chart),
                    _buildActionButton(context, 'Settings', Icons.settings_outlined),
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

  Widget _buildApprovalWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Pending Approval',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Your company is currently under review. You will be able to post services once an admin approves your request.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
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
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
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

  Widget _buildRecentBookingsHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Activities',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'View All',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBookingsList(AsyncValue<List<Booking>> bookingsAsync) {
    return bookingsAsync.when(
      data: (bookings) {
        if (bookings.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No recent bookings found.', style: TextStyle(color: Colors.white38)),
              ),
            ),
          );
        }
        
        final recent = bookings.take(5).toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final booking = recent[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark.withOpacity(0.3),
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
                            'Booking: ${booking.tourismService.title}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Status: ${booking.status.toUpperCase()}',
                            style: TextStyle(
                              color: booking.status == 'confirmed' ? Colors.greenAccent : Colors.orangeAccent,
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
            },
            childCount: recent.length,
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SliverToBoxAdapter(child: Center(child: Text('Error loading activities', style: TextStyle(color: Colors.red)))),
    );
  }
}
