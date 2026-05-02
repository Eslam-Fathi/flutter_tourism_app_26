import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/company_model.dart';

import '../base/base_providers.dart';

part 'company_provider.g.dart';

@riverpod
class CompanyNotifier extends _$CompanyNotifier {
  FutureOr<List<Company>> build() async {
    final repo = ref.read(companyRepositoryProvider);
    // Use admin endpoint so pending (unapproved) companies are included.
    // The admin dashboard needs to see ALL companies, not just approved ones.
    final data = await repo.getAllCompaniesForAdmin();
    return data;
  }

  Future<void> approveCompany(String id, bool approved) async {
    final repo = ref.read(companyRepositoryProvider);
    await repo.approveCompany(id, approved);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(companyRepositoryProvider).getCompanies(),
    );
  }

  Future<void> createCompany(Map<String, dynamic> companyData) async {
    final repo = ref.read(companyRepositoryProvider);
    state = const AsyncLoading();
    try {
      await repo.createCompany(companyData);
      state = await AsyncValue.guard(
        () => ref.read(companyRepositoryProvider).getCompanies(),
      );
    } catch (e) {
      state = await AsyncValue.guard(
        () => ref.read(companyRepositoryProvider).getCompanies(),
      );
      rethrow;
    }
  }
}

@riverpod
Future<Company?> myCompany(MyCompanyRef ref) async {
  final companies = await ref.watch(companyNotifierProvider.future);
  final user = ref.watch(authNotifierProvider).user;

  if (user == null) return null;

  try {
    // 1. Try to find company where the current user is the owner
    // 2. Fallback to name match (for legacy data or matching setups)
    return companies.firstWhere(
      (c) => c.owner == user.id || c.name == user.name,
    );
  } catch (_) {
    return null;
  }
}
