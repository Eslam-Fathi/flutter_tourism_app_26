import 'package:dio/dio.dart';

/// Interceptor that sanitizes request data and rejects oversized payloads.
class SanitizationInterceptor extends Interceptor {
  /// Maximum allowed size for a request body in bytes (1MB).
  static const int maxRequestBodySize = 1024 * 1024;

  /// Maximum allowed length for a single string field.
  static const int maxFieldLength = 5000;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = options.data;

    // 1. Check for oversized payload
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

    // 2. Sanitize data
    if (data is Map<String, dynamic>) {
      options.data = _sanitizeMap(data);
    } else if (data is List) {
      options.data = _sanitizeList(data);
    } else if (data is String) {
      options.data = _sanitizeString(data);
    }

    return handler.next(options);
  }

  Map<String, dynamic> _sanitizeMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, _sanitizeString(value));
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, _sanitizeMap(value));
      } else if (value is List) {
        return MapEntry(key, _sanitizeList(value));
      }
      return MapEntry(key, value);
    });
  }

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

  String _sanitizeString(String value) {
    // Trim whitespace
    var sanitized = value.trim();

    // Prevent oversized individual fields
    if (sanitized.length > maxFieldLength) {
      sanitized = sanitized.substring(0, maxFieldLength);
    }

    // Basic XSS/Injection prevention (escaping common dangerous characters)
    // Note: Proper sanitization should happen on the backend, 
    // but client-side cleanup helps reduce the attack surface.
    sanitized = sanitized
        .replaceAll('<script', '[script]')
        .replaceAll('</script>', '[/script]')
        .replaceAll('javascript:', '[js-blocked]:');

    return sanitized;
  }
}
