import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/interaction_model.dart';
import '../base/base_providers.dart';

part 'interaction_provider.g.dart';

@riverpod
class FavoriteNotifier extends _$FavoriteNotifier {
  @override
  FutureOr<List<Favorite>> build() async {
    final repo = ref.read(interactionRepositoryProvider);
    return await repo.getMyFavorites();
  }

  bool isFavorite(String serviceId) {
    return state.when(
      data: (favorites) => favorites.any((f) => f.service.id == serviceId),
      loading: () => false,
      error: (_, __) => false,
    );
  }

  Future<void> toggleFavorite(String serviceId) async {
    final repo = ref.read(interactionRepositoryProvider);
    final currentlyFavorite = isFavorite(serviceId);

    try {
      if (currentlyFavorite) {
        await repo.removeFavorite(serviceId);
      } else {
        await repo.addFavorite(serviceId);
      }
      // Refresh the list
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => repo.getMyFavorites());
    } catch (e) {
      // Revert or handle error
    }
  }
}
