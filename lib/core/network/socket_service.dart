import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'socket_service.g.dart';

@Riverpod(keepAlive: true)
class SocketService extends _$SocketService {
  IO.Socket? _socket;

  @override
  void build() {
    ref.onDispose(() {
      _socket?.disconnect();
    });
  }

  void connect(String token, String baseUrl) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(baseUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .setExtraHeaders({'Authorization': 'Bearer $token'})
      .setQuery({'token': token}) // Sometimes token is needed in query
      .enableAutoConnect()
      .build());

    _socket?.onConnect((_) => print('Global Socket connected'));
    _socket?.onDisconnect((_) => print('Global Socket disconnected'));
    _socket?.onConnectError((err) => print('Socket Connect Error: $err'));
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }
  
  bool get isConnected => _socket?.connected ?? false;
}
