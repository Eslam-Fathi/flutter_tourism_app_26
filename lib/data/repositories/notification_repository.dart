import 'package:dio/dio.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final Dio _dio;

  NotificationRepository({required Dio dio}) : _dio = dio;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get('/api/notifications');
      final data = response.data['data'];
      if (data == null) return [];
      return (data as List).map((e) => NotificationModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _dio.put('/api/notifications/$id/read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.put('/api/notifications/read-all');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _dio.delete('/api/notifications/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'Unknown error';
  }
}
