import 'package:dio/dio.dart';
import '../models/service_model.dart';

/// Handles all REST API calls for tourism services.
///
/// ## API Endpoints
/// | Method | Path             | Used by                  |
/// |--------|------------------|--------------------------|
/// | GET    | /api/services    | [getAllServices]          |
/// | GET    | /api/services/:id| [getServiceById]         |
/// | POST   | /api/services    | [createService]          |
/// | PUT    | /api/services/:id| [updateService]          |
/// | DELETE | /api/services/:id| [deleteService]          |
///
/// ## Pagination and filtering
/// [getAllServices] supports server-side **pagination** (`page`, `limit`),
/// **full-text search** (`search`), **category filtering** (`category`),
/// and **price filtering** (`maxPrice`).  Only non-null / non-default
/// parameters are included in the query string to keep URLs minimal.
///
/// ## Company relationship
/// A [TourismService] returned by this repository may include a `company`
/// field that is either:
/// - A plain MongoDB ObjectId string (when the backend does not populate it)
/// - A full [Company] object (when the backend populates the reference)
///
/// The custom parsers in `service_model.dart` handle both cases.
class ServiceRepository {
  final Dio _dio;

  ServiceRepository({required Dio dio}) : _dio = dio;

  // ── Read Operations ────────────────────────────────────────────────────────

  /// Fetches a paginated, optionally-filtered list of tourism services.
  ///
  /// ### Parameters
  /// - [page]: The 1-based page number (default: 1).
  /// - [limit]: Number of items per page (default: 20).
  /// - [search]: Full-text search query — matched against title, description.
  /// - [category]: Filter by category (e.g. `'Hotel'`).  Pass `null` or
  ///   `'All'` to fetch all categories.
  /// - [maxPrice]: Upper price bound.  `null` means no price filter.
  ///
  /// Returns a [ServiceResponse] which includes the total count and the
  /// current page's data list, allowing infinite-scroll / pagination.
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
          // Omit 'category' entirely when not filtering — the backend treats
          // a missing parameter as "all categories".
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

  /// Fetches a single tourism service by its MongoDB [id].
  ///
  /// The backend populates related fields (company, tourGuide) so this
  /// response is richer than what appears in list results.
  Future<TourismService> getServiceById(String id) async {
    try {
      final response = await _dio.get('/api/services/$id');
      return TourismService.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Write Operations ───────────────────────────────────────────────────────

  /// Creates a new tourism service.
  ///
  /// [serviceData] should contain at minimum:
  /// ```json
  /// {
  ///   "title": "Luxor Temple Night Tour",
  ///   "description": "...",
  ///   "price": 150,
  ///   "location": "Luxor",
  ///   "category": "Tours",
  ///   "company": "<companyId>"
  /// }
  /// ```
  ///
  /// Returns the newly created [TourismService] with its backend-assigned `_id`.
  ///
  /// Throws if `response.data['data']` is null, which would indicate a backend
  /// serialisation error rather than a permission or validation error.
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

  /// Updates an existing service's fields.
  ///
  /// Only include the fields you want to change in [serviceData] — the backend
  /// performs a partial update (PATCH-like behavior despite using PUT).
  Future<TourismService> updateService(String id, Map<String, dynamic> serviceData) async {
    try {
      final response = await _dio.put('/api/services/$id', data: serviceData);
      return TourismService.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Permanently deletes a tourism service by [id].
  ///
  /// Also cascades deletion of associated bookings on the backend (as defined
  /// in the Mongoose pre-remove middleware for the Service model).
  Future<void> deleteService(String id) async {
    try {
      await _dio.delete('/api/services/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Private Helpers ────────────────────────────────────────────────────────

  /// Converts a [DioException] to a human-readable error message string.
  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'Unknown error';
  }
}
