// ─────────────────────────────────────────────────────────────────────────────
// ALL enum values below are sourced directly from the backend Mongoose schemas
// at https://github.com/3bdulrahman-M3/SeYaha
// DO NOT change 'value' fields without updating the backend schema first.
// ─────────────────────────────────────────────────────────────────────────────

// Application-wide enumeration types for domain concepts shared between the
// Flutter client and the Node.js / Mongoose backend.
//
// Design principle — "single source of truth"
// Each `value` field in every enum exactly matches the string sent in the API
// request/response.  Using enums (rather than bare strings) means:
// - Typos are caught at compile time instead of at runtime.
// - Renaming a category only requires a change in one place.
// - The IDE provides autocompletion for all valid values.
//
// Backend synchronisation
// When the backend Mongoose schema changes, the corresponding enum in this file
// must be updated simultaneously.  The comment at the top of each enum cites
// the exact model file and field for traceability.

// ── Company Category ──────────────────────────────────────────────────────────
// Source: models/Company.js → enum: ['Hotel', 'RealEstate', 'Tours', 'Cars']

/// Classifies a tourism company into one of the four backend-defined categories.
///
/// The [label] includes an emoji for use in filter chips, dropdowns, and
/// category badges in the UI — it is never sent to the API.
///
/// The [value] is the exact string expected by the backend `category` field.
///
/// Usage:
/// ```dart
/// // Sending to the API:
/// 'category': CompanyCategory.hotel.value,       // → "Hotel"
///
/// // Displaying in the UI:
/// Text(CompanyCategory.tours.label),             // → "Tours 🗺️"
///
/// // Getting the colour for a category chip:
/// AppColors.categoryColors[CompanyCategory.hotel.value]
/// ```
enum CompanyCategory {
  hotel('Hotel', 'Hotel 🏨'),
  realEstate('RealEstate', 'Real Estate 🏢'),
  tours('Tours', 'Tours 🗺️'),
  cars('Cars', 'Cars 🚗');

  /// The exact string value sent to and received from the backend API.
  /// Must match the Mongoose schema enum exactly (case-sensitive).
  final String value; // sent to backend (must match schema exactly)

  /// A human-readable label for display in the UI.
  /// Includes an emoji for at-a-glance category recognition.
  final String label; // shown in UI
  const CompanyCategory(this.value, this.label);
}

// ── Service Category ──────────────────────────────────────────────────────────
// Source: models/Service.js → enum: ['Hotel', 'RealEstate', 'Tours', 'Cars']
// Same enum as CompanyCategory — the backend reuses the same 4 values.

/// Classifies a tourism **service** into one of the four backend-defined categories.
///
/// Structurally identical to [CompanyCategory] because the backend `Service`
/// model reuses the same four categories as the `Company` model.  They are kept
/// as separate enums so that future divergence (e.g. adding a "Flights" service
/// category without a matching company category) is straightforward.
///
/// Used in:
/// - [ServiceRepository.getAllServices] → the `category` query parameter
/// - [ExploreScreen] → filter chip selection
/// - [ServiceCard] → category badge colour via [AppColors.categoryColors]
enum ServiceCategory {
  hotel('Hotel', 'Hotel 🏨'),
  realEstate('RealEstate', 'Real Estate 🏢'),
  tours('Tours', 'Tours 🗺️'),
  cars('Cars', 'Cars 🚗');

  /// The exact string value sent to the backend API.
  final String value; // sent to backend

  /// Human-readable label shown in the UI.
  final String label; // shown in UI
  const ServiceCategory(this.value, this.label);
}

// ── Booking Status ─────────────────────────────────────────────────────────────
// Source: models/Booking.js → enum: ['pending','confirmed','rejected','cancelled','completed']

/// Represents the lifecycle state of a booking.
///
/// ### Status Flow
/// ```
/// pending ──► confirmed ──► completed
///         └──► rejected
///         └──► cancelled   (user-initiated)
/// ```
///
/// The [value] strings are sent to `PUT /api/bookings/:id` as `{ "status": value }`.
///
/// Used in:
/// - [BookingRepository.updateBookingStatus] to send status changes
/// - Badge colours in booking list widgets (see [AppColors.statusPending], etc.)
/// - Admin and company dashboards for filtering bookings by status
enum BookingStatus {
  /// The booking has been submitted but not yet reviewed by the company.
  pending('pending'),

  /// The company has accepted the booking.
  confirmed('confirmed'),

  /// The company has declined the booking request.
  rejected('rejected'), // ← was missing before — added for completeness

  /// The booking was cancelled (usually by the user before confirmation).
  cancelled('cancelled'),

  /// The service has been delivered and the booking is closed.
  completed('completed');

  /// The exact string sent to the backend API.
  final String value;
  const BookingStatus(this.value);
}

// ── User Roles ────────────────────────────────────────────────────────────────
// Source: models/User.js → enum: ['User', 'Manager', 'Admin', 'TourGuide']

/// The set of roles a user can have in the SeYaha platform.
///
/// Roles govern:
/// - Which **home screen** is shown (see `MyApp._getHome`)
/// - Which **navigation tabs** are visible (see `MainWrapper._getDestinations`)
/// - Which **API endpoints** are accessible (enforced server-side)
///
/// ### Role-to-screen mapping
/// | Role        | Root Widget           | Key permissions              |
/// |-------------|-----------------------|------------------------------|
/// | `User`      | [MainWrapper]         | Browse, book services        |
/// | `Manager`   | [CompanyMainWrapper]  | Manage company & services    |
/// | `TourGuide` | [MainWrapper]         | View assigned tours          |
/// | `Admin`     | [AdminMainWrapper]    | Full platform management     |
///
/// Note: `Manager` and `Company` are treated identically in the routing logic
/// (`role.toLowerCase() == 'company' || role.toLowerCase() == 'manager'`).
enum UserRole {
  /// Regular traveller — the default role on registration.
  user('User'),

  /// Company manager — can create/edit services and manage bookings.
  manager('Manager'),

  /// Assigned tour guide — sees their schedule and assigned tours.
  tourGuide('TourGuide'),

  /// Platform administrator — full access to all data and management screens.
  admin('Admin');

  /// The exact string stored on the backend user document and returned by
  /// `GET /api/auth/me` in the `role` field.
  final String value;
  const UserRole(this.value);
}
