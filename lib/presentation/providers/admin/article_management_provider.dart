import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/article_model.dart';
import '../base/base_providers.dart';

part 'article_management_provider.g.dart';

@riverpod
class ArticleNotifier extends _$ArticleNotifier {
  @override
  FutureOr<List<HistoricalArticle>> build() async {
    final repo = ref.read(articleRepositoryProvider);
    return await repo.getArticles();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(articleRepositoryProvider).getArticles());
  }

  Future<void> createArticle(Map<String, dynamic> data) async {
    final repo = ref.read(articleRepositoryProvider);
    await repo.createArticle(data);
    await refresh();
  }

  Future<void> deleteArticle(String id) async {
    final repo = ref.read(articleRepositoryProvider);
    await repo.deleteArticle(id);
    await refresh();
  }
}
