import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../storage/token_storage.dart';
import 'interceptors/rate_limit_interceptor.dart';
import 'interceptors/sanitization_interceptor.dart';

class DioClient {
  static String get baseUrl => dotenv.get('API_BASE_URL', fallback: 'https://se-yaha.vercel.app');
  final TokenStorage _tokenStorage;
  late final Dio _dio;

  DioClient({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(SanitizationInterceptor());
    _dio.interceptors.add(RateLimitInterceptor());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Retrieve the auth token from secure storage
          final token = await _tokenStorage.getToken();
          // If a token exists, add it to the 'Authorization' header
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Global error handling logic (e.g., token expiration) can go here
          return handler.next(e);
        },
      ),
    );

    // Logging only in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get instance => _dio;
}
