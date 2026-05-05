import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserRepository {
  final Dio _dio;

  UserRepository({required Dio dio}) : _dio = dio;

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get('/api/users');
      return (response.data['data'] as List).map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final response = await _dio.get('/api/users/$id');
      if (response.data['data'] == null) return null;
      return User.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return null; // Return null instead of throwing for unauthorized requests
      }
      throw _handleError(e);
    }
  }

  Future<List<User>> getTourGuides() async {
    try {
      final response = await _dio.get('/api/users/tour-guides');
      final list = response.data['data'];
      if (list == null || list is! List) return [];
      return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _dio.delete('/api/users/$id');
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
