import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/chat_model.dart';
import '../base/base_providers.dart';

part 'chat_provider.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  FutureOr<List<ChatMessage>> build(String bookingId) async {
    // Fetch initial history
    final history = await ref.read(chatRepositoryProvider).getChatHistory(bookingId);
    
    // Connect WebSocket for real-time updates
    _initWebSocket(bookingId);
    
    return history;
  }

  Future<void> _initWebSocket(String bookingId) async {
    final token = await ref.read(tokenStorageProvider).getToken();
    ref.read(chatRepositoryProvider).connectWebSocket(
      token ?? '', 
      'https://se-yaha.vercel.app', 
      (msg) {
        // Safely update state with new message from WebSocket
        final currentMessages = state.valueOrNull ?? [];
        if (!currentMessages.any((m) => m.id == msg.id)) {
          state = AsyncValue.data([...currentMessages, msg]);
        }
      },
    );

    ref.onDispose(() {
      ref.read(chatRepositoryProvider).disconnectWebSocket();
    });
  }

  Future<void> sendMessage(String text) async {
    final repo = ref.read(chatRepositoryProvider);
    // Use bookingId from build parameter
    final msg = await repo.sendMessage(bookingId, text);
    
    final currentMessages = state.valueOrNull ?? [];
    if (!currentMessages.any((m) => m.id == msg.id)) {
      state = AsyncValue.data([...currentMessages, msg]);
    }
  }
}
