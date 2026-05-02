import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

import '../../providers/company/company_provider.dart';
import 'widgets/create_company_dialog.dart';

class AdminCompaniesScreen extends ConsumerStatefulWidget {
  const AdminCompaniesScreen({super.key});

  @override
  ConsumerState<AdminCompaniesScreen> createState() => _AdminCompaniesScreenState();
}

class _AdminCompaniesScreenState extends ConsumerState<AdminCompaniesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companiesState = ref.watch(companyNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Company Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Pending Requests'),
            Tab(text: 'All Companies'),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: Responsive.isDesktop(context) ? 0 : 90),
        child: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const CreateCompanyDialog(),
            );
          },
          backgroundColor: Colors.redAccent,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Company',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: AuroraBackground(
        child: companiesState.when(
          data: (companies) {
            final pending = companies.where((c) => !c.approved).toList();
            
            return TabBarView(
              controller: _tabController,
              children: [
                _buildCompanyList(pending, 'No pending requests found.'),
                _buildCompanyList(companies, 'No companies available.'),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyList(List<dynamic> companies, String emptyMessage) {
    if (companies.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return _CompanyAdminTile(
          companyId: company.id,
          name: company.name,
          category: company.category,
          isApproved: company.approved,
        );
      },
    );
  }
}

class _CompanyAdminTile extends ConsumerWidget {
  final String companyId;
  final String name;
  final String category;
  final bool isApproved;

  const _CompanyAdminTile({
    required this.companyId,
    required this.name,
    required this.category,
    required this.isApproved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isApproved
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isApproved ? 'Approved' : 'Pending',
                  style: TextStyle(
                    color: isApproved
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (!isApproved)
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(companyNotifierProvider.notifier)
                        .approveCompany(companyId, true);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
