import 'package:dio/dio.dart';

/// A client-side Dio interceptor that enforces request rate limits to prevent
/// spamming API endpoints — particularly the authentication routes.
///
/// ## Why client-side rate limiting?
/// The Node.js backend also enforces rate limits server-side (returning HTTP 429).
/// This client-side mirror serves two complementary purposes:
///
/// 1. **Better UX**: The user sees an immediate, friendly error message before
///    a network round-trip is even made — no waiting for a 429 response.
/// 2. **Reduced server load**: Helps during periods of high traffic or buggy
///    retry loops by never even sending the request.
///
/// ## Two-tier throttling strategy
///
/// ### Tier 1 — General throttle (all endpoints)
/// Any endpoint that receives two requests within 200 ms of each other is
/// rejected.  This is a safeguard against accidental rapid-fire calls caused
/// by double-taps or buggy widget rebuild loops.
///
/// ### Tier 2 — Auth rate limit (login / register only)
/// A sliding-window counter allows **5 attempts per 15 minutes** on
/// `/auth/login` and `/auth/register`.  This mirrors the backend's
/// brute-force protection and is displayed to the user with a countdown.
///
/// ## State
/// Both counters are held in-memory ([_attempts], [_lastRequestTime]).
/// They reset when the app is restarted — this is acceptable because the
/// backend is the authoritative rate limiter for production security.
class RateLimitInterceptor extends Interceptor {
  // ── Auth Rate Limit State ──────────────────────────────────────────────────

  /// Tracks the timestamps of recent auth attempts per endpoint path.
  ///
  /// ```
  /// {
  ///   '/api/auth/login':    [DateTime(t1), DateTime(t2), ...],
  ///   '/api/auth/register': [DateTime(t3)],
  /// }
  /// ```
  final Map<String, List<DateTime>> _attempts = {};

  /// Maximum number of auth attempts allowed within [_authWindow].
  static const int _maxAuthAttempts = 5;

  /// The sliding window over which auth attempts are counted.
  static const Duration _authWindow = Duration(minutes: 15);

  // ── General Throttle State ─────────────────────────────────────────────────

  /// Stores the timestamp of the most recent request for each endpoint path.
  /// Used to detect rapid-fire duplicate requests.
  final Map<String, DateTime> _lastRequestTime = {};

  /// The minimum allowed gap between consecutive requests to the same endpoint.
  /// Requests arriving faster than this are rejected.
  static const Duration _generalThrottle = Duration(milliseconds: 200);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    final now = DateTime.now();

    // ── Tier 1: General Throttle ───────────────────────────────────────────
    // If a request to this path was made within the last 200 ms, reject it.
    // Uses `handler.reject` with type `cancel` so the caller receives a
    // [DioException] without a status code (as if the request was aborted
    // locally, not by the server).
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
    // Record the timestamp of this request before passing it through.
    _lastRequestTime[path] = now;

    // ── Tier 2: Auth Rate Limit ────────────────────────────────────────────
    // Only applies to login and register paths.
    if (path.contains('/auth/login') || path.contains('/auth/register')) {
      // Initialise the attempt list for this path if it doesn't exist yet.
      _attempts.putIfAbsent(path, () => []);

      // Prune entries older than the 15-minute window.
      // This implements the "sliding window" algorithm: only the most recent
      // [_maxAuthAttempts] within the last 15 minutes are counted.
      _attempts[path]!.removeWhere((time) => now.difference(time) > _authWindow);

      if (_attempts[path]!.length >= _maxAuthAttempts) {
        // Calculate how many minutes remain until the oldest attempt expires.
        final oldestAttempt = _attempts[path]!.first;
        final waitMinutes =
            _authWindow.inMinutes - now.difference(oldestAttempt).inMinutes;

        // Reject with a 429-like DioException so that [AuthNotifier._handleAuthError]
        // can display the correct "Too many attempts" message and lock the UI.
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

      // Record this attempt.  Note: the attempt is counted even if the network
      // request subsequently fails — this is intentional.  A wrong-password
      // attempt is still an attempt.
      _attempts[path]!.add(now);
    }

    return handler.next(options);
  }
}
