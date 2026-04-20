import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/chat_model.dart';

class ChatRepository {
  final Dio _dio;
  IO.Socket? _socket;

  ChatRepository({required Dio dio}) : _dio = dio;

  Future<List<ChatMessage>> getChatHistory(String bookingId) async {
    try {
      final response = await _dio.get('/api/messages/$bookingId');
      return (response.data['data'] as List).map((e) => ChatMessage.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ChatMessage> sendMessage(String bookingId, String content) async {
    try {
      final response = await _dio.post('/api/messages', data: {
        'booking': bookingId,
        'content': content
      });
      return ChatMessage.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  void connectWebSocket(String token, String baseUrl, Function(ChatMessage) onMessageReceived) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(baseUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .setExtraHeaders({'Authorization': 'Bearer $token'})
      .build());

    _socket?.onConnect((_) {
      print('Chat Socket connected');
    });

    _socket?.on('receiveMessage', (data) {
      onMessageReceived(ChatMessage.fromJson(data));
    });
  }

  void disconnectWebSocket() {
    _socket?.disconnect();
    _socket = null;
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'Unknown error';
  }
}
