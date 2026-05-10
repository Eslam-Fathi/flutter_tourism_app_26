import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../storage/token_storage.dart';
import 'interceptors/rate_limit_interceptor.dart';
import 'interceptors/sanitization_interceptor.dart';

/// A preconfigured [Dio] HTTP client for the SeYaha REST API.
///
/// ## Architecture
/// [DioClient] acts as the **single source of truth** for all outgoing HTTP
/// requests to the backend (`se-yaha.vercel.app`).  It wraps the raw [Dio]
/// instance and applies a layered interceptor pipeline:
///
/// ```
/// Request ──►  SanitizationInterceptor  ──►  RateLimitInterceptor
///         ──►  AuthInterceptor (Bearer)  ──►  PrettyDioLogger (debug only)
///         ──►  se-yaha backend
/// ```
///
/// ## Interceptor order matters
/// Interceptors run in **the order they are added**.  Sanitisation runs first
/// so that cleaned data flows through all subsequent layers.  Rate-limiting
/// runs second so that oversized payloads are never counted as rate-limit
/// attempts.
///
/// ## Dependency injection
/// [DioClient] is injected via Riverpod (see `base_providers.dart`).
/// The [TokenStorage] is also injected, making the client fully testable
/// without real disk I/O.
///
/// ## Usage
/// ```dart
/// final dio = ref.read(dioClientProvider).instance;
/// final response = await dio.get('/api/services');
/// ```
class DioClient {
  /// The base URL for all requests, read from the `API_BASE_URL` environment
  /// variable.  Falls back to the production Vercel URL if not set.
  static String get baseUrl =>
      dotenv.maybeGet('API_BASE_URL') ?? 'https://se-yaha.vercel.app';

  /// Used to read and write the JWT auth token from encrypted local storage.
  final TokenStorage _tokenStorage;

  /// The underlying [Dio] instance.  Exposed via [instance] for use in
  /// repositories.
  late final Dio _dio;

  /// Constructs a [DioClient] and configures the Dio pipeline.
  ///
  /// [tokenStorage] is injected (not created here) to keep this class testable.
  DioClient({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage {
    // ── Base Configuration ────────────────────────────────────────────────
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        // Fail fast on slow connections — avoids blocking the UI for long.
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          // All payloads are JSON; the server also responds with JSON.
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ── Interceptor 1: Input Sanitisation ─────────────────────────────────
    // Strips dangerous characters and rejects payloads that are too large
    // before they ever leave the device.
    _dio.interceptors.add(SanitizationInterceptor());

    // ── Interceptor 2: Rate Limiting ──────────────────────────────────────
    // Prevents the user (or a buggy loop) from hammering auth endpoints.
    // Mirrors the server-side "5 attempts per 15 minutes" rule so that the
    // app fails fast without burning a server-side attempt.
    _dio.interceptors.add(RateLimitInterceptor());

    // ── Interceptor 3: Auth Header Injection ─────────────────────────────
    // Reads the stored JWT and appends it as a Bearer token on every request.
    // The token is fetched asynchronously so that it is always fresh from
    // encrypted storage (FlutterSecureStorage).
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
          // Global error handling logic (e.g., token expiration) can go here.
          // Currently we pass all errors through so individual repositories can
          // decide how to handle them (see `_handleError` in each repo).
          return handler.next(e);
        },
      ),
    );

    // ── Interceptor 4: Pretty Logging (debug builds only) ─────────────────
    // `kDebugMode` is a compile-time constant from `flutter/foundation.dart`.
    // In release builds this block is removed by the tree-shaker, so there is
    // zero overhead in production.
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false, // Headers are usually noise; omit for clarity.
          error: true,
          compact: true,         // Compact format reduces console spam.
        ),
      );
    }
  }

  /// Exposes the configured [Dio] instance to repositories.
  ///
  /// All repositories accept a bare [Dio] (not [DioClient]) so that they can
  /// be unit-tested with a [MockDio] without the full interceptor stack.
  Dio get instance => _dio;
}
