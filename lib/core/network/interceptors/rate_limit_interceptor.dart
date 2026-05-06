import 'package:dio/dio.dart';

/// A client-side interceptor to prevent spamming endpoints.
/// specifically implements the "5 attempts per 15 minutes" rule for auth routes.
class RateLimitInterceptor extends Interceptor {
  final Map<String, List<DateTime>> _attempts = {};
  
  static const int _maxAuthAttempts = 5;
  static const Duration _authWindow = Duration(minutes: 15);
  
  // General throttle to prevent accidental rapid-fire requests on any endpoint
  final Map<String, DateTime> _lastRequestTime = {};
  static const Duration _generalThrottle = Duration(milliseconds: 200);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    final now = DateTime.now();

    // 1. General Throttling (prevent duplicate rapid-fire requests)
    if (_lastRequestTime.containsKey(path)) {
      if (now.difference(_lastRequestTime[path]!) < _generalThrottle) {
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
            error: 'Request throttled. Please wait a moment.',
          ),
        );
      }
    }
    _lastRequestTime[path] = now;

    // 2. Specific Auth Rate Limiting (Login/Register)
    if (path.contains('/auth/login') || path.contains('/auth/register')) {
      _attempts.putIfAbsent(path, () => []);
      
      // Remove attempts that are older than the 15-minute window
      _attempts[path]!.removeWhere((time) => now.difference(time) > _authWindow);
      
      if (_attempts[path]!.length >= _maxAuthAttempts) {
        // Calculate remaining wait time
        final oldestAttempt = _attempts[path]!.first;
        final waitMinutes = _authWindow.inMinutes - now.difference(oldestAttempt).inMinutes;
        
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            error: 'Too many attempts. Please try again in $waitMinutes minutes.',
            response: Response(
              requestOptions: options,
              statusCode: 429,
              statusMessage: 'Too Many Requests',
              data: {'message': 'Too many attempts. Please try again in $waitMinutes minutes.'},
            ),
          ),
        );
      }
      
      // Note: We count the attempt here. 
      // If the request fails, it's still an attempt.
      _attempts[path]!.add(now);
    }

    return handler.next(options);
  }
}
