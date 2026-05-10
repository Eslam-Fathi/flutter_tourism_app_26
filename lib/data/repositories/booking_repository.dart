import 'package:dio/dio.dart';
import '../models/booking_model.dart';

/// Handles all booking-related REST API calls.
///
/// ## API Endpoints
/// | Method | Path                          | Used by                   |
/// |--------|-------------------------------|---------------------------|
/// | GET    | /api/bookings/my-bookings     | [getMyBookings]           |
/// | GET    | /api/bookings/company-bookings| [getCompanyBookings]      |
/// | GET    | /api/bookings/all-bookings    | [getAllBookings] (admin)   |
/// | POST   | /api/bookings                 | [createBooking]           |
/// | PUT    | /api/bookings/:id             | [updateBookingStatus], [assignGuide] |
/// | DELETE | /api/bookings/:id             | [cancelBooking]           |
///
/// ## Access control (enforced by the backend)
/// - `getMyBookings` → available to all authenticated users
/// - `getCompanyBookings` → Manager role only
/// - `getAllBookings` → Admin role only
/// - `createBooking` → authenticated non-admin users
/// - `updateBookingStatus` / `assignGuide` → Manager or Admin
/// - `cancelBooking` → booking owner or Admin
///
/// ## Relationship model nuance
/// The `tourismService` and `user` fields in a [Booking] can be either a plain
/// MongoDB ObjectId string or a fully-populated object, depending on which
/// backend population level was requested.  [Booking.fromJson] uses custom
/// `_readValue` / `_parse*` functions to handle both cases gracefully.
class BookingRepository {
  final Dio _dio;

  BookingRepository({required Dio dio}) : _dio = dio;

  // ── Read Operations ────────────────────────────────────────────────────────

  /// Fetches all bookings made by the currently authenticated user.
  ///
  /// Returns an empty list (not an error) when the user has no bookings.
  /// The `data` field in the response is checked for null/non-List safety
  /// because the backend occasionally returns `"data": null` instead of `[]`.
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

  /// Fetches all bookings for services owned by the authenticated manager's company.
  ///
  /// Used in [CompanyBookingsScreen] to let managers review incoming requests.
  /// Requires the `Manager` role; the backend returns 403 otherwise.
  Future<List<Booking>> getCompanyBookings() async {
    try {
      final response = await _dio.get('/api/bookings/company-bookings');
      return (response.data['data'] as List)
          .map((e) => Booking.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches ALL bookings across the entire platform.
  ///
  /// Admin-only endpoint.  Returns an empty list if the response is malformed.
  Future<List<Booking>> getAllBookings() async {
    try {
      final response = await _dio.get('/api/bookings/all-bookings');
      final list = response.data['data'];
      if (list == null || list is! List) return [];
      return list.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Write Operations ───────────────────────────────────────────────────────

  /// Creates a new booking for a tourism service.
  ///
  /// [bookingData] should follow the backend schema:
  /// ```json
  /// {
  ///   "service": "<serviceId>",
  ///   "dates": { "startDate": "2025-06-01", "endDate": "2025-06-07" },
  ///   "notes": "Window room preferred"
  /// }
  /// ```
  ///
  /// Returns the newly created [Booking] on success.
  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post('/api/bookings', data: bookingData);
      return Booking.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Status Management ──────────────────────────────────────────────────────

  /// Convenience wrapper that confirms a booking (sets status to `'confirmed'`).
  ///
  /// Equivalent to `updateBookingStatus(id, 'confirmed')`.
  Future<Booking> confirmBooking(String id) async {
    return updateBookingStatus(id, 'confirmed');
  }

  /// Updates the [status] of booking [id] to any valid [BookingStatus] value.
  ///
  /// Valid status transitions:
  /// - `pending` → `confirmed` (manager approves)
  /// - `pending` → `rejected`  (manager declines)
  /// - `pending` or `confirmed` → `cancelled` (user cancels)
  /// - `confirmed` → `completed` (service delivered)
  ///
  /// See [BookingStatus] for the full enum.
  Future<Booking> updateBookingStatus(String id, String status) async {
    try {
      final response = await _dio.put('/api/bookings/$id', data: {'status': status});
      return Booking.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Assigns a tour guide (by [guideId]) to booking [id].
  ///
  /// The backend stores the tour guide as a reference on the booking document.
  /// The guide is then displayed to the traveller in the booking detail screen.
  Future<Booking> assignGuide(String id, String guideId) async {
    try {
      final response = await _dio.put('/api/bookings/$id', data: {'tourGuide': guideId});
      return Booking.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Cancels and deletes booking [id].
  ///
  /// Uses DELETE (not a status update) because cancelled bookings are removed
  /// from the database rather than archived.  This mirrors the backend schema.
  Future<void> cancelBooking(String id) async {
    try {
      await _dio.delete('/api/bookings/$id');
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
