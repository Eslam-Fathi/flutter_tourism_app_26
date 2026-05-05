import 'package:dio/dio.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final Dio _dio;

  BookingRepository({required Dio dio}) : _dio = dio;

  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await _dio.get('/api/bookings/my-bookings');
      final list = response.data['data'];
      if (list == null || list is! List) return [];
      return list.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<List<Booking>> getCompanyBookings() async {
    try {
      final response = await _dio.get('/api/bookings/company-bookings');
      return (response.data['data'] as List).map((e) => Booking.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post('/api/bookings', data: bookingData);
      return Booking.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Booking> confirmBooking(String id) async {
    return updateBookingStatus(id, 'confirmed');
  }

  Future<Booking> updateBookingStatus(String id, String status) async {
    try {
      final response = await _dio.put('/api/bookings/$id', data: {'status': status});
      return Booking.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Booking> assignGuide(String id, String guideId) async {
    try {
      final response = await _dio.put('/api/bookings/$id', data: {'tourGuide': guideId});
      return Booking.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      await _dio.delete('/api/bookings/$id');
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
