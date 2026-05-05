import 'package:dio/dio.dart';
import '../../core/storage/token_storage.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRepository({required Dio dio, required TokenStorage tokenStorage})
      : _dio = dio,
        _tokenStorage = tokenStorage;

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/api/auth/login', data: request.toJson());
      final authResponse = AuthResponse.fromJson(response.data);
      
      if (authResponse.success) {
        await _tokenStorage.saveToken(authResponse.token);
      }
      
      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post('/api/auth/register', data: request.toJson());
      final authResponse = AuthResponse.fromJson(response.data);
      
      if (authResponse.success) {
        await _tokenStorage.saveToken(authResponse.token);
      }
      
      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> registerAccountOnly(RegisterRequest request) async {
    try {
      final response = await _dio.post('/api/auth/register', data: request.toJson());
      // Do not save the token, just return the response
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User?> getMe() async {
    try {
      final response = await _dio.get('/api/auth/me');
      if (response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data as Map<String, dynamic>;
      return data['error'] ?? data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'Unknown error';
  }
}
