import 'package:dio/dio.dart';

/// A Dio interceptor that sanitizes request data and rejects oversized payloads.
///
/// ## Security purpose
/// This interceptor is the **client-side first line of defence** against common
/// input-based vulnerabilities.  It should NOT replace server-side validation —
/// the backend must always re-validate — but it reduces the attack surface by:
///
/// 1. **Rejecting oversized payloads** before they are sent.  A 1 MB limit
///    prevents accidental or intentional data-bombing of the API.
/// 2. **Truncating over-long string fields** to avoid buffer-overflow edge
///    cases and excessive bandwidth.
/// 3. **Escaping common XSS/injection patterns** in string fields.  This
///    protects against "stored XSS" where an attacker enters `<script>` tags
///    through the app's forms, hoping they will be rendered later in a browser.
///
/// ## What this does NOT protect against
/// - SQL injection (handled server-side by Mongoose parameterised queries)
/// - Binary / multipart payloads (only JSON Map/List/String are sanitised)
/// - HTTPS interception (handled by TLS)
///
/// ## Processing order
/// The interceptor runs as the **first interceptor** in the [DioClient]
/// pipeline, before rate-limiting and auth header injection, so that:
/// - Oversized payloads are rejected before counting as rate-limit attempts.
/// - Tokens are never attached to payloads that will be rejected anyway.
class SanitizationInterceptor extends Interceptor {
  /// Maximum allowed size for a request body in bytes (1 MB).
  ///
  /// The check is a rough estimation using `data.toString().length` rather
  /// than true binary size (which would require encoding the JSON first).
  /// In practice this is conservative — the real byte count is slightly larger
  /// than the character count, so legitimate payloads well under 1 MB will
  /// always pass.
  static const int maxRequestBodySize = 1024 * 1024;

  /// Maximum allowed length for a single string field in characters.
  ///
  /// 5 000 characters is generous enough for description fields while
  /// preventing fields from being used as covert data exfiltration channels.
  static const int maxFieldLength = 5000;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = options.data;

    // ── Check 1: Payload size guard ──────────────────────────────────────────
    // Reject immediately if the serialised data exceeds [maxRequestBodySize].
    // `handler.reject` cancels the request and propagates a [DioException]
    // to the caller.
    if (data != null) {
      final dataSize = data.toString().length; // Rough estimation
      if (dataSize > maxRequestBodySize) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Request payload is too large. Max size is 1MB.',
            type: DioExceptionType.cancel,
          ),
        );
      }
    }

    // ── Check 2: Sanitise the request data ───────────────────────────────────
    // Route to the appropriate sanitisation method based on the runtime type
    // of [data].  Binary types (File, FormData) are left untouched.
    if (data is Map<String, dynamic>) {
      options.data = _sanitizeMap(data);
    } else if (data is List) {
      options.data = _sanitizeList(data);
    } else if (data is String) {
      options.data = _sanitizeString(data);
    }

    return handler.next(options);
  }

  // ── Private Sanitisation Helpers ─────────────────────────────────────────────

  /// Recursively sanitises all string values in a JSON object ([Map]).
  ///
  /// Non-string values (numbers, booleans, nulls) are passed through unchanged
  /// because they cannot contain injection payloads.
  Map<String, dynamic> _sanitizeMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, _sanitizeString(value));
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _sanitizeMap(value));  // recurse into nested objects
      } else if (value is List) {
        return MapEntry(key, _sanitizeList(value)); // recurse into arrays
      }
      return MapEntry(key, value);
    });
  }

  /// Recursively sanitises all string values in a JSON array ([List]).
  List<dynamic> _sanitizeList(List<dynamic> list) {
    return list.map((item) {
      if (item is String) {
        return _sanitizeString(item);
      } else if (item is Map<String, dynamic>) {
        return _sanitizeMap(item);
      } else if (item is List) {
        return _sanitizeList(item);
      }
      return item;
    }).toList();
  }

  /// Sanitises a single string value.
  ///
  /// Steps:
  /// 1. **Trim** — removes leading/trailing whitespace.
  /// 2. **Truncate** — caps at [maxFieldLength] characters.
  /// 3. **Escape** — replaces common XSS patterns with inert placeholders.
  ///
  /// The XSS escaping targets:
  /// - `<script` → `[script]`    (opening script tag)
  /// - `</script>` → `[/script]` (closing script tag)
  /// - `javascript:` → `[js-blocked]:` (inline javascript: URL scheme)
  ///
  /// Note: This is intentionally minimal.  A full HTML sanitiser would break
  /// legitimate use cases (e.g. a user including `<` in a service description).
  /// Server-side validation handles more sophisticated attack vectors.
  String _sanitizeString(String value) {
    // Step 1: Trim whitespace
    var sanitized = value.trim();

    // Step 2: Prevent oversized individual fields
    if (sanitized.length > maxFieldLength) {
      sanitized = sanitized.substring(0, maxFieldLength);
    }

    // Step 3: Basic XSS/Injection prevention (escaping common dangerous characters)
    // Note: Proper sanitization should happen on the backend,
    // but client-side cleanup helps reduce the attack surface.
    sanitized = sanitized
        .replaceAll('<script', '[script]')
        .replaceAll('</script>', '[/script]')
        .replaceAll('javascript:', '[js-blocked]:');

    return sanitized;
  }
}
