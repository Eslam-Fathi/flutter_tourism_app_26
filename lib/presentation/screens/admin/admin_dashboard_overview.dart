import 'package:flutter/material.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'create_company_screen.dart';

class AdminDashboardOverview extends StatelessWidget {
  const AdminDashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AuroraBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  AppLocalizations.of(context)!.adminOverview,
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
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatCards(),
                    const SizedBox(height: 24),
                    _buildRevenueChart(context),
                    const SizedBox(height: 24),
                    ..._buildRecentFeedback(context),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to company creation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCompanyScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business, color: Colors.white),
        label: Text(AppLocalizations.of(context)!.addCompany, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStatCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final cards = [
          _StatCard(
            title: AppLocalizations.of(context)!.totalUsers,
            value: '1,240',
            icon: Icons.people,
            color: Colors.blueAccent,
            progress: 0.8,
          ),
          _StatCard(
            title: AppLocalizations.of(context)!.companies,
            value: '45',
            icon: Icons.business,
            color: Colors.orangeAccent,
            progress: 0.4,
          ),
          _StatCard(
            title: AppLocalizations.of(context)!.bookings,
            value: '312',
            icon: Icons.book_online,
            color: Colors.greenAccent,
            progress: 0.6,
          ),
          _StatCard(
            title: AppLocalizations.of(context)!.revenue,
            value: '\$14.2k',
            icon: Icons.monetization_on,
            color: Colors.purpleAccent,
            progress: 0.9,
          ),
        ];

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        }
        return Row(
          children: cards
              .map(
                (c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: c,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.revenueOverview,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (v, m) => _buildBottomTitleWidgets(context, v, m),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 1),
                      FlSpot(2, 4),
                      FlSpot(3, 2),
                      FlSpot(4, 5),
                      FlSpot(5, 3.5),
                      FlSpot(6, 6),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTitleWidgets(BuildContext context, double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white54,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(AppLocalizations.of(context)!.mon, style: style);
        break;
      case 1:
        text = Text(AppLocalizations.of(context)!.tue, style: style);
        break;
      case 2:
        text = Text(AppLocalizations.of(context)!.wed, style: style);
        break;
      case 3:
        text = Text(AppLocalizations.of(context)!.thu, style: style);
        break;
      case 4:
        text = Text(AppLocalizations.of(context)!.fri, style: style);
        break;
      case 5:
        text = Text(AppLocalizations.of(context)!.sat, style: style);
        break;
      case 6:
        text = Text(AppLocalizations.of(context)!.sun, style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  List<Widget> _buildRecentFeedback(BuildContext context) {
    return [
      Text(
        AppLocalizations.of(context)!.recentFeedback,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      _FeedbackTile(
        user: 'John D.',
        rating: 5,
        comment: 'Incredible platform, easy to book tours!',
      ),
      _FeedbackTile(
        user: 'Alice M.',
        rating: 4,
        comment: 'Nice selection of companies, but needs map view.',
      ),
      _FeedbackTile(
        user: 'Robert T.',
        rating: 5,
        comment: 'Very smooth experience.',
      ),
    ];
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double progress;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  final String user;
  final int rating;
  final String comment;

  const _FeedbackTile({
    required this.user,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary,
                child: Text(
                  user[0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                user,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 14,
                    color: index < rating ? Colors.amber : Colors.white24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
