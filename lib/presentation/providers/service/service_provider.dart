import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_tourism_app_26/presentation/providers/company/company_provider.dart';
import '../../../data/models/service_model.dart';
import '../base/base_providers.dart';

part 'service_provider.g.dart';

@riverpod
class ServiceNotifier extends _$ServiceNotifier {
  @override
  Future<List<TourismService>> build() async {
    return _fetchServices();
  }

  Future<List<TourismService>> _fetchServices({
    String search = '',
    String? category,
    double? maxPrice,
  }) async {
    final response = await ref.read(serviceRepositoryProvider).getAllServices(
      search: search,
      category: category,
      maxPrice: maxPrice,
    );
    
    // Filter services to only show those from approved companies
    // Note: In production, the backend should handle this, but keeping it for safety
    final companies = await ref.read(companyNotifierProvider.future);
    final approvedCompanyIds = companies.where((c) => c.approved).map((c) => c.id).toSet();
    
    return response.data.where((s) => approvedCompanyIds.contains(s.company)).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchServices());
  }
  
  Future<void> searchServices(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchServices(search: query));
  }

  Future<void> applyFilters({String? category, double? maxPrice}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchServices(
      category: category,
      maxPrice: maxPrice,
    ));
  }
}

@riverpod
Future<TourismService> serviceDetails(ServiceDetailsRef ref, String id) {
  return ref.read(serviceRepositoryProvider).getServiceById(id);
}

@riverpod
Future<List<TourismService>> companyServices(CompanyServicesRef ref) async {
  final services = await ref.watch(serviceNotifierProvider.future);
  final myComp = await ref.watch(myCompanyProvider.future);
  
  if (myComp == null) return [];
  
  return services.where((s) => s.company == myComp.id).toList();
}
