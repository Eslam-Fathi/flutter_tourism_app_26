import 'package:dio/dio.dart';
import '../models/service_model.dart';

class ServiceRepository {
  final Dio _dio;

  ServiceRepository({required Dio dio}) : _dio = dio;

  Future<ServiceResponse> getAllServices({
    int page = 1,
    int limit = 20,
    String search = '',
    String? category,
    double? maxPrice,
  }) async {
    try {
      final response = await _dio.get(
        '/api/services',
        queryParameters: {
          'page': page,
          'limit': limit,
          'search': search,
          if (category != null && category != 'All') 'category': category,
          if (maxPrice != null) 'maxPrice': maxPrice,
        },
      );
      final responseData = response.data;
      if (responseData == null) throw 'No response from server';
      return ServiceResponse.fromJson(responseData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TourismService> getServiceById(String id) async {
    try {
      final response = await _dio.get('/api/services/$id');
      return TourismService.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TourismService> createService(Map<String, dynamic> serviceData) async {
    try {
      final response = await _dio.post('/api/services', data: serviceData);
      final data = response.data['data'];
      if (data == null) throw 'Failed to parse service data from response';
      return TourismService.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TourismService> updateService(String id, Map<String, dynamic> serviceData) async {
    try {
      final response = await _dio.put('/api/services/$id', data: serviceData);
      return TourismService.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await _dio.delete('/api/services/$id');
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
