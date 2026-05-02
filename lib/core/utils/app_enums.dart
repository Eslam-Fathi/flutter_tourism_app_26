// ─────────────────────────────────────────────────────────────────────────────
// ALL enum values below are sourced directly from the backend Mongoose schemas
// at https://github.com/3bdulrahman-M3/SeYaha
// DO NOT change 'value' fields without updating the backend schema first.
// ─────────────────────────────────────────────────────────────────────────────

// ── Company Category ─────────────────────────────────────────────────────────
// Source: models/Company.js → enum: ['Hotel', 'RealEstate', 'Tours', 'Cars']
enum CompanyCategory {
  hotel('Hotel', 'Hotel 🏨'),
  realEstate('RealEstate', 'Real Estate 🏢'),
  tours('Tours', 'Tours 🗺️'),
  cars('Cars', 'Cars 🚗');

  final String value; // sent to backend (must match schema exactly)
  final String label; // shown in UI
  const CompanyCategory(this.value, this.label);
}

// ── Service Category ──────────────────────────────────────────────────────────
// Source: models/Service.js → enum: ['Hotel', 'RealEstate', 'Tours', 'Cars']
// Same enum as CompanyCategory — the backend reuses the same 4 values.
enum ServiceCategory {
  hotel('Hotel', 'Hotel 🏨'),
  realEstate('RealEstate', 'Real Estate 🏢'),
  tours('Tours', 'Tours 🗺️'),
  cars('Cars', 'Cars 🚗');

  final String value; // sent to backend
  final String label; // shown in UI
  const ServiceCategory(this.value, this.label);
}

// ── Booking Status ────────────────────────────────────────────────────────────
// Source: models/Booking.js → enum: ['pending','confirmed','rejected','cancelled','completed']
enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  rejected('rejected'),   // ← was missing before
  cancelled('cancelled'),
  completed('completed');

  final String value;
  const BookingStatus(this.value);
}

// ── User Roles ────────────────────────────────────────────────────────────────
// Source: models/User.js → enum: ['User', 'Manager', 'Admin', 'TourGuide']
enum UserRole {
  user('User'),
  manager('Manager'),
  tourGuide('TourGuide'),
  admin('Admin');

  final String value;
  const UserRole(this.value);
}
