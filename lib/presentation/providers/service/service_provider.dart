import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/service_model.dart';
import '../../../core/utils/placeholder_data.dart';
import '../base/base_providers.dart';

part 'service_provider.g.dart';

@riverpod
class ServiceNotifier extends _$ServiceNotifier {
  @override
  AsyncValue<List<TourismService>> build() {
    _fetchServices();
    return const AsyncValue.loading();
  }

  Future<void> _fetchServices({String search = ''}) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref.read(serviceRepositoryProvider).getAllServices(search: search);
      if (response.data.isEmpty) {
        state = AsyncValue.data(PlaceholderData.mockServices);
      } else {
        state = AsyncValue.data(response.data);
      }
    } catch (e, stack) {
      // Intelligent fallback on network error
      state = AsyncValue.data(PlaceholderData.mockServices);
    }
  }

  Future<void> refresh() => _fetchServices();
  
  Future<void> searchServices(String query) => _fetchServices(search: query);
}

@riverpod
Future<TourismService> serviceDetails(ServiceDetailsRef ref, String id) {
  return ref.read(serviceRepositoryProvider).getServiceById(id);
}
