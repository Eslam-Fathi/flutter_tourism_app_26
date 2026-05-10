import 'package:dio/dio.dart';
import '../../core/storage/token_storage.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

/// Handles all authentication-related API calls.
///
/// ## Responsibilities
/// - Login and registration via the REST API
/// - Persisting / clearing the JWT in [TokenStorage]
/// - Fetching the current user profile (`GET /api/auth/me`)
/// - Centralised [DioException] → user-facing error message translation
///
/// ## Dependencies (injected via constructor)
/// | Dependency      | Purpose                                  |
/// |-----------------|------------------------------------------|
/// | [Dio]           | HTTP client with auth header middleware  |
/// | [TokenStorage]  | Encrypted on-device token persistence    |
///
/// ## Token persistence strategy
/// - **[login]** and **[register]**: always save the token after success.
/// - **[registerAccountOnly]**: registers but does NOT save the token.
///   Used when an admin creates a sub-account (e.g. a company manager)
///   without logging in as that user.
/// - **[logout]**: deletes the token from encrypted storage.
///
/// ## Error handling
/// All methods catch [DioException] and convert it to a plain [String]
/// error message via [_handleError].  Callers (providers) then populate
/// their `errorMessage` state field with this string.
class AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRepository({required Dio dio, required TokenStorage tokenStorage})
    : _dio = dio,
      _tokenStorage = tokenStorage;

  // ── Login ──────────────────────────────────────────────────────────────────

  /// Authenticates the user with the backend and saves the JWT.
  ///
  /// ### Flow
  /// 1. POST `/api/auth/login` with email/password
  /// 2. Parse the [AuthResponse] (which includes the JWT and user profile)
  /// 3. If `success == true`, persist the JWT to [TokenStorage]
  /// 4. Return the full [AuthResponse] to the provider
  ///
  /// Throws a [String] error message on failure (network error, wrong
  /// credentials, or rate limit exceeded).
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      final authResponse = AuthResponse.fromJson(response.data);

      if (authResponse.success) {
        // Persist the JWT so subsequent app launches can restore the session.
        await _tokenStorage.saveToken(authResponse.token);
      }

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Register ───────────────────────────────────────────────────────────────

  /// Registers a new user and saves the JWT.
  ///
  /// This is the standard registration path for travellers and tour guides.
  /// After registration, the JWT is saved so the user is immediately logged in.
  ///
  /// Throws a [String] error message on failure (e.g. email already in use).
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      final authResponse = AuthResponse.fromJson(response.data);

      if (authResponse.success) {
        await _tokenStorage.saveToken(authResponse.token);
      }

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Registers a new user account WITHOUT saving the JWT.
  ///
  /// Used when a manager registers a sub-account (e.g. an additional company
  /// user) on behalf of someone else.  The current user's session is unaffected.
  ///
  /// The caller is responsible for handling the [AuthResponse] appropriately.
  Future<AuthResponse> registerAccountOnly(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      // Do not save the token, just return the response
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Session ────────────────────────────────────────────────────────────────

  /// Fetches the currently authenticated user's profile.
  ///
  /// Calls `GET /api/auth/me` using the JWT that [DioClient]'s auth interceptor
  /// automatically attaches.  This is the primary way to restore a session
  /// from a stored token on app startup.
  ///
  /// Returns `null` if the token is invalid, expired, or the server returns
  /// `success: false`.  Throws a [String] on network error.
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

  /// Logs out the current user by deleting the stored JWT.
  ///
  /// After this call, [DioClient]'s auth interceptor will no longer attach a
  /// Bearer token, and `GET /api/auth/me` will return an unauthorised error.
  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }

  // ── Private Helpers ────────────────────────────────────────────────────────

  /// Converts a [DioException] to a human-readable [String] error message.
  ///
  /// Priority:
  /// 1. `response.data['error']` — backend's primary error field
  /// 2. `response.data['message']` — backend's secondary error field
  /// 3. `e.message` — Dio's built-in error message (network/timeout errors)
  /// 4. `'An error occurred'` — final fallback
  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data as Map<String, dynamic>;
      return data['error'] ?? data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'Unknown error';
  }
}
