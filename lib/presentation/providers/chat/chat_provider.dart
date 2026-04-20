import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/chat_model.dart';
import '../base/base_providers.dart';

part 'chat_provider.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  late String _bookingId;

  @override
  FutureOr<List<ChatMessage>> build() async {
    return []; // Initial empty until connected
  }

  Future<void> initChat(String bookingId) async {
    _bookingId = bookingId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(chatRepositoryProvider).getChatHistory(bookingId));
    
    final token = await ref.read(tokenStorageProvider).getToken();
    ref.read(chatRepositoryProvider).connectWebSocket(token ?? '', 'https://se-yaha.vercel.app', (msg) {
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, msg]);
      }
    });

    ref.onDispose(() {
      ref.read(chatRepositoryProvider).disconnectWebSocket();
    });
  }

  Future<void> sendMessage(String text) async {
    final repo = ref.read(chatRepositoryProvider);
    await repo.sendMessage(_bookingId, text);
  }
}
