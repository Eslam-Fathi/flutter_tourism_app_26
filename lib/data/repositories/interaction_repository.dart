import 'package:dio/dio.dart';
import '../models/interaction_model.dart';

class InteractionRepository {
  final Dio _dio;

  InteractionRepository({required Dio dio}) : _dio = dio;

  Future<Review> addReview(Map<String, dynamic> reviewData) async {
    try {
      final response = await _dio.post('/api/reviews', data: reviewData);
      return Review.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addFavorite(String serviceId) async {
    try {
      await _dio.post('/api/favorites/$serviceId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Favorite>> getMyFavorites() async {
    try {
      final response = await _dio.get('/api/favorites');
      return (response.data['data'] as List).map((e) => Favorite.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Review>> getServiceReviews(String serviceId) async {
    try {
      final response = await _dio.get('/api/services/$serviceId/reviews');
      return (response.data['data'] as List).map((e) => Review.fromJson(e)).toList();
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
