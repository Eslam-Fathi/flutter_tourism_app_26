import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'socket_service.g.dart';

/// A **Riverpod-managed** WebSocket service built on top of `socket_io_client`.
///
/// ## Why WebSockets?
/// The SeYaha chat feature requires real-time, bidirectional communication.
/// REST polling is too slow and too expensive.  Socket.IO is used because:
/// - The Node.js backend (se-yaha) already runs Socket.IO.
/// - It handles reconnection and fallback automatically.
/// - It is familiar to the backend team.
///
/// ## Riverpod Integration (`@Riverpod(keepAlive: true)`)
/// The `keepAlive: true` annotation prevents Riverpod from disposing this
/// provider when all widgets stop listening.  This is intentional: we want
/// **one persistent connection** for the entire app session, not a new
/// connection each time the chat screen is opened.
///
/// ## Lifecycle
/// ```
/// 1. AuthNotifier detects a logged-in user
/// 2. MainWrapper calls socketServiceProvider.notifier.connect(token, url)
/// 3. The socket connects and stays alive until the user logs out
/// 4. ref.onDispose() (called on app shutdown) disconnects cleanly
/// ```
///
/// ## Authentication
/// The JWT is passed in both the **Authorization header** and the **query
/// string** (`?token=...`) because Socket.IO middleware implementations vary
/// between backend frameworks.  Sending it in both places ensures compatibility.
///
/// ## Usage example
/// ```dart
/// // Listen for a 'newMessage' event
/// ref.read(socketServiceProvider.notifier).on('newMessage', (data) {
///   print('Message received: $data');
/// });
///
/// // Send a message
/// ref.read(socketServiceProvider.notifier).emit('sendMessage', {
///   'to': recipientId,
///   'content': 'Hello!',
/// });
/// ```
@Riverpod(keepAlive: true)
class SocketService extends _$SocketService {
  /// The underlying `socket_io_client` socket instance.
  /// Nullable — it is `null` before [connect] is called.
  IO.Socket? _socket;

  /// Riverpod `build` method — called once when the provider is first read.
  ///
  /// This provider has `void` state because external code interacts with the
  /// socket via methods ([connect], [on], [emit], etc.), not by observing state.
  ///
  /// [ref.onDispose] registers a cleanup callback that disconnects the socket
  /// when the ProviderScope is disposed (typically on app shutdown).
  @override
  void build() {
    ref.onDispose(() {
      _socket?.disconnect();
    });
  }

  /// Establishes a WebSocket connection to the given [baseUrl].
  ///
  /// **Idempotent**: If a socket is already connected, this method returns
  /// immediately without creating a duplicate connection.
  ///
  /// ### Parameters
  /// - [token]: JWT from [TokenStorage], injected by the caller.  Used to
  ///   authenticate the socket handshake with the server.
  /// - [baseUrl]: The root URL of the Socket.IO server (e.g.
  ///   `https://se-yaha.vercel.app`).
  ///
  /// ### Transport
  /// Only `'websocket'` transport is enabled (polling is disabled) for
  /// performance.  This requires the server to support WebSocket upgrades,
  /// which the Vercel-hosted Node.js backend does.
  void connect(String token, String baseUrl) {
    // Guard: do nothing if already connected to avoid duplicate sockets.
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(baseUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      // Authorization header — standard for HTTP-upgrade WebSocket handshakes.
      .setExtraHeaders({'Authorization': 'Bearer $token'})
      // Query param fallback — some Socket.IO middleware reads from query string.
      .setQuery({'token': token})
      .enableAutoConnect()
      .build());

    // ── Event Handlers ────────────────────────────────────────────────────
    _socket?.onConnect((_) => print('Global Socket connected'));
    _socket?.onDisconnect((_) => print('Global Socket disconnected'));
    _socket?.onConnectError((err) => print('Socket Connect Error: $err'));
  }

  /// Subscribes [handler] to a named Socket.IO [event].
  ///
  /// The handler is called with the raw event data whenever the server emits
  /// that event to this client.
  ///
  /// Example:
  /// ```dart
  /// socketService.on('newMessage', (data) {
  ///   final message = ChatMessage.fromJson(data as Map<String, dynamic>);
  /// });
  /// ```
  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  /// Removes a previously registered event [handler] for the given [event].
  ///
  /// Call this in a widget's `dispose()` to prevent memory leaks from stale
  /// listeners that reference a widget that is no longer in the tree.
  void off(String event) {
    _socket?.off(event);
  }

  /// Sends (emits) [data] to the server under the given [event] name.
  ///
  /// [data] can be a `Map`, `List`, `String`, or any JSON-serialisable object.
  ///
  /// Example:
  /// ```dart
  /// socketService.emit('sendMessage', {
  ///   'conversationId': id,
  ///   'content': message,
  /// });
  /// ```
  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  /// Returns `true` if the socket is currently connected to the server.
  ///
  /// Useful for showing a connection status indicator in the chat UI.
  bool get isConnected => _socket?.connected ?? false;
}
