import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import '../../providers/admin/user_management_provider.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(userManagementNotifierProvider);
    final filteredUserList = ref.watch(filteredUsersProvider(_query));

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AuroraBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  AppLocalizations.of(context)!.userManagement,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
                floating: true,
              ),
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _query = val),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchUsersHint,
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white38,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: usersAsync.when(
                  data: (_) {
                    if (filteredUserList.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              _query.isEmpty
                                  ? AppLocalizations.of(
                                      context,
                                    )!.noUsersRegistered
                                  : AppLocalizations.of(
                                      context,
                                    )!.noUsersFoundMatching(_query),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final user = filteredUserList[index];
                        return _CompanyAdminTile(
                          name: user.name,
                          email: user.email,
                          role: user.role,
                          userId: user.id,
                        );
                      }, childCount: filteredUserList.length),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  error: (err, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Error loading users: \$err',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyAdminTile extends ConsumerWidget {
  final String name;
  final String email;
  final String role;
  final String userId;

  const _CompanyAdminTile({
    required this.name,
    required this.email,
    required this.role,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = role.toLowerCase() == 'admin';
    final isCompany = role.toLowerCase() == 'company';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAdmin
              ? Colors.redAccent.withValues(alpha: 0.5)
              : isCompany
              ? Colors.blueAccent.withValues(alpha: 0.5)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isAdmin
                ? Colors.redAccent
                : isCompany
                ? Colors.blueAccent
                : AppColors.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                Text(
                  email,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? Colors.redAccent.withValues(alpha: 0.2)
                      : isCompany
                      ? Colors.blueAccent.withValues(alpha: 0.2)
                      : Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: isAdmin
                        ? Colors.redAccent
                        : isCompany
                        ? Colors.blueAccent
                        : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isAdmin) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _showDeleteConfirm(context, ref);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.removeUser,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Remove User', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove \$name? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(userManagementNotifierProvider.notifier)
                  .deleteUser(userId);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.removeUser,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
