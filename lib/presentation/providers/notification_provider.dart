import 'package:flutter_tourism_app_26/core/network/socket_service.dart';
import 'package:flutter_tourism_app_26/presentation/providers/base/base_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/notification_model.dart';

part 'notification_provider.g.dart';

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  FutureOr<List<NotificationModel>> build() async {
    // Listen for real-time notifications
    _setupSocketListener();
    return _fetchNotifications();
  }

  void _setupSocketListener() {
    final socketService = ref.read(socketServiceProvider.notifier);
    
    // Using ref.onDispose to clean up the listener when provider is disposed
    ref.onDispose(() {
      socketService.off('newNotification');
    });

    socketService.on('newNotification', (data) {
      if (state.hasValue) {
        final newNotification = NotificationModel.fromJson(data);
        // Avoid duplicates if any
        if (!state.value!.any((n) => n.id == newNotification.id)) {
          state = AsyncValue.data([newNotification, ...state.value!]);
        }
      }
    });
  }

  Future<List<NotificationModel>> _fetchNotifications() async {
    final repo = ref.read(notificationRepositoryProvider);
    return await repo.getNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchNotifications());
  }

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(id);
    // Optimistic update
    if (state.hasValue) {
      final updatedList = state.value!.map((n) {
        if (n.id == id) {
          return n.copyWith(read: true);
        }
        return n;
      }).toList();
      state = AsyncValue.data(updatedList);
    }
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAllAsRead();
    if (state.hasValue) {
      final updatedList = state.value!
          .map((n) => n.copyWith(read: true))
          .toList();
      state = AsyncValue.data(updatedList);
    }
  }

  Future<void> deleteNotification(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.deleteNotification(id);
    if (state.hasValue) {
      final updatedList = state.value!.where((n) => n.id != id).toList();
      state = AsyncValue.data(updatedList);
    }
  }

  int get unreadCount {
    if (!state.hasValue) return 0;
    return state.value!.where((n) => !n.read).length;
  }
}
