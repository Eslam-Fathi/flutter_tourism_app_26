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

  Future<void> toggleFavorite(String serviceId) async {
    final repo = ref.read(interactionRepositoryProvider);
    await repo.addFavorite(serviceId);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.getMyFavorites());
  }
}
