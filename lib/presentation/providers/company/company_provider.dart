import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/company_model.dart';
import '../../../core/utils/placeholder_data.dart';
import '../base/base_providers.dart';

part 'company_provider.g.dart';

@riverpod
class CompanyNotifier extends _$CompanyNotifier {
  @override
  FutureOr<List<Company>> build() async {
    try {
      final repo = ref.read(companyRepositoryProvider);
      final data = await repo.getCompanies();
      if (data.isEmpty) return PlaceholderData.mockCompanies;
      return data;
    } catch (e) {
      return PlaceholderData.mockCompanies;
    }
  }

  Future<void> approveCompany(String id, bool approved) async {
    final repo = ref.read(companyRepositoryProvider);
    await repo.approveCompany(id, approved);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(companyRepositoryProvider).getCompanies());
  }

  Future<void> createCompany(Map<String, dynamic> companyData) async {
    final repo = ref.read(companyRepositoryProvider);
    state = const AsyncLoading();
    try {
      await repo.createCompany(companyData);
      state = await AsyncValue.guard(() => ref.read(companyRepositoryProvider).getCompanies());
    } catch (e) {
      state = await AsyncValue.guard(() => ref.read(companyRepositoryProvider).getCompanies());
      rethrow;
    }
  }
}
