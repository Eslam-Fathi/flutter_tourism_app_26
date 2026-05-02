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

  Future<List<TourismService>> _fetchServices({String search = ''}) async {
    final response = await ref.read(serviceRepositoryProvider).getAllServices(search: search);
    
    // Filter services to only show those from approved companies
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
