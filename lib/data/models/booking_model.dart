// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'service_model.dart';
import 'user_model.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// Data models for the booking lifecycle in the SeYaha platform.
///
/// ## Domain overview
/// A [Booking] represents a traveller's reservation of a [TourismService]
/// for a specific date range.  It connects three entities:
///
/// ```
/// Booking
///   ├── tourismService: TourismService  (the booked offering)
///   ├── user: User                      (the traveller who booked)
///   ├── tourGuide: User?                (an assigned guide, if any)
///   ├── dates: BookingDates             (start/end)
///   ├── status: String                  (pending|confirmed|rejected|cancelled|completed)
///   ├── totalPrice: double              (price × duration, if applicable)
///   └── notes: String?                  (special requests from the traveller)
/// ```
///
/// ## Polymorphic relationship fields
/// The backend uses MongoDB's `populate()` to optionally expand references.
/// This means `tourismService`, `user`, and `tourGuide` in the JSON can be:
/// - **A plain ObjectId string** — when the reference is NOT populated
/// - **A full nested object** — when the backend DOES populate the reference
///
/// The custom `_read*` and `_parse*` top-level functions handle both forms.
/// This is a deliberate design choice to avoid crashes when the backend
/// changes its population strategy or when certain endpoints return minimal data.
///
/// ## Key name aliasing
/// The backend uses both camelCase (`totalPrice`) and snake_case (`total_price`)
/// field names depending on the endpoint.  The `_read*` functions perform
/// multi-key lookups to handle both naming conventions transparently.

// ── BookingDates ──────────────────────────────────────────────────────────────

/// The date range for a booking.
///
/// [startDate] and [endDate] are ISO-8601 strings from the backend, parsed by
/// Dart's [DateTime.parse] via the json_annotation serialiser.
@freezed
class BookingDates with _$BookingDates {
  const factory BookingDates({
    /// The first day of the booked period.
    required DateTime startDate,

    /// The last day of the booked period (inclusive).
    required DateTime endDate,
  }) = _BookingDates;

  factory BookingDates.fromJson(Map<String, dynamic> json) =>
      _$BookingDatesFromJson(json);
}

// ── Booking ───────────────────────────────────────────────────────────────────

/// Represents a single booking record from the backend API.
///
/// ### JSON example (populated response)
/// ```json
/// {
///   "_id": "663abc...",
///   "service": { "_id": "...", "title": "Luxor Tour", "price": 200, ... },
///   "user": { "_id": "...", "name": "Ahmed Ali", "email": "ahmed@..." },
///   "dates": { "startDate": "2025-06-01T00:00:00Z", "endDate": "2025-06-05T00:00:00Z" },
///   "status": "confirmed",
///   "totalPrice": 800,
///   "notes": "Window seat preferred",
///   "createdAt": "2025-05-01T12:00:00Z",
///   "tourGuide": null
/// }
/// ```
@freezed
class Booking with _$Booking {
  const factory Booking({
    /// The MongoDB ObjectId of this booking document.
    @JsonKey(name: '_id') required String id,

    /// The booked service.  Populated by [_parseService] which handles both
    /// a plain string ObjectId and a full [TourismService] object.
    @JsonKey(readValue: _readService, fromJson: _parseService)
        required TourismService tourismService,

    /// The traveller who made the booking.  May be `null` in some admin-only
    /// responses where user data is excluded for performance.
    @JsonKey(readValue: _readUser, fromJson: _parseUser) User? user,

    /// The start/end dates of the booking.
    required BookingDates dates,

    /// The lifecycle status.  See [BookingStatus] for valid values.
    /// Defaults to `'pending'` — matching the backend's default.
    @Default('pending') String status,

    /// The total price charged for this booking.
    /// Defaults to `0.0` and is populated by [_parsePrice] which handles
    /// multiple field names (`totalPrice`, `total_price`, `price`).
    @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
        @Default(0.0) double totalPrice,

    /// Optional free-text special requests from the traveller.
    String? notes,

    /// When the booking was created on the backend.  Handles both `createdAt`
    /// and `created_at` field names via [_readCreatedAt].
    @JsonKey(readValue: _readCreatedAt) required DateTime createdAt,

    /// The tour guide assigned to this booking, if any.
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) User? tourGuide,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

// ── readValue Functions (multi-key aliasing) ──────────────────────────────────
// These functions are passed to `@JsonKey(readValue: ...)` and are called
// BEFORE the `fromJson` parser.  They handle alternative field names from
// different API endpoints by checking multiple keys and returning the first
// non-null value.

/// Resolves the user/traveller field from multiple possible key names.
Object? _readUser(Map json, String key) =>
    json['user'] ?? json['userId'] ?? json['traveler'];

/// Resolves the tour guide field from multiple possible key names.
Object? _readTourGuide(Map json, String key) =>
    json['tourGuide'] ?? json['tour_guide'];

/// Resolves the service field from multiple possible key names.
Object? _readService(Map json, String key) =>
    json['service'] ?? json['tourismService'];

/// Resolves the createdAt timestamp from multiple possible key names.
Object? _readCreatedAt(Map json, String key) =>
    json['createdAt'] ?? json['created_at'];

/// Resolves the total price from multiple possible field names.
Object? _readTotalPrice(Map json, String key) =>
    json['totalPrice'] ?? json['total_price'] ?? json['price'];

/// Resolves the user/userId field (used in a legacy variant).
Object? _readId(Map json, String key) => json['user'] ?? json['userId'];

// ── fromJson Parser Functions ──────────────────────────────────────────────────
// These functions are called after `readValue` to convert the raw value to
// the correct Dart type.  They handle both string ObjectIds and full objects.

/// Safely parses the service field.
///
/// - If the value is a **String** (bare ObjectId), creates a skeleton
///   [TourismService] with the ID only — enough to display a booking list
///   item without crashing, even when the service hasn't been populated.
/// - If the value is a **Map**, parses it as a full [TourismService].
/// - If `null` or unknown, returns a `N/A` placeholder to avoid throwing.
TourismService _parseService(dynamic value) {
  if (value is String) {
    return TourismService(
      id: value,
      title: 'Unknown Service',
      price: 0,
      location: 'Unknown',
      category: 'Tours',
      company: '',
    );
  }
  if (value is Map) {
    // Convert to Map<String, dynamic> safely for fromJson
    return TourismService.fromJson(Map<String, dynamic>.from(value));
  }
  // If null or unknown, return a placeholder instead of throwing
  return TourismService(
    id: '',
    title: 'N/A',
    price: 0,
    location: '',
    category: 'Tours',
    company: '',
  );
}

/// Safely parses an ID field that might be a plain string or a populated object.
///
/// Returns the `_id` string from a nested object, or the string itself.
String _parseId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    return value['_id']?.toString() ?? value['id']?.toString() ?? '';
  }
  return value.toString();
}

/// Safely parses the price field which might be named 'totalPrice' or 'price',
/// and might be a number or a stringified number from some endpoints.
double _parsePrice(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Safely parses a [User] field that may be a plain ObjectId string or a full
/// user object.
///
/// - **Map**: parsed as a full [User] via [User.fromJson].
/// - **String** (ObjectId): creates a minimal [User] with just the ID — enough
///   to render a booking without full user details.
/// - **null**: returns `null` (user not provided or not populated).
User? _parseUser(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    return User.fromJson(Map<String, dynamic>.from(value));
  }
  if (value is String) {
    return User(
      id: value,
      name: 'User',
      email: '',
      role: 'User',
    );
  }
  return null;
}

// ── CreateBookingRequest ───────────────────────────────────────────────────────

/// Request body sent to `POST /api/bookings` to create a new booking.
///
/// ```json
/// {
///   "service": "663abc...",
///   "dates": { "startDate": "2025-06-01", "endDate": "2025-06-07" },
///   "notes": "Ground floor room please"
/// }
/// ```
@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    /// The ObjectId of the [TourismService] being booked.
    required String service,

    /// The start and end dates for the booking period.
    required BookingDates dates,

    /// Optional special requests or notes from the traveller.
    String? notes,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);
}
