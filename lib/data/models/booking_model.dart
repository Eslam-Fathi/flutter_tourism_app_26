import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'service_model.dart';
import 'user_model.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingDates with _$BookingDates {
  const factory BookingDates({
    required DateTime startDate,
    required DateTime endDate,
  }) = _BookingDates;

  factory BookingDates.fromJson(Map<String, dynamic> json) => _$BookingDatesFromJson(json);
}

@freezed
class Booking with _$Booking {
  const factory Booking({
    @JsonKey(name: '_id') required String id,
    @JsonKey(readValue: _readService, fromJson: _parseService) required TourismService tourismService,
    @JsonKey(readValue: _readUser, fromJson: _parseUser) User? user,
    required BookingDates dates,
    @Default('pending') String status,
    @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice) @Default(0.0) double totalPrice,
    String? notes,
    @JsonKey(readValue: _readCreatedAt) required DateTime createdAt,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) User? tourGuide,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

Object? _readUser(Map json, String key) => json['user'] ?? json['userId'] ?? json['traveler'];
Object? _readTourGuide(Map json, String key) => json['tourGuide'] ?? json['tour_guide'];
Object? _readService(Map json, String key) => json['service'] ?? json['tourismService'];
Object? _readCreatedAt(Map json, String key) => json['createdAt'] ?? json['created_at'];
Object? _readTotalPrice(Map json, String key) => json['totalPrice'] ?? json['total_price'] ?? json['price'];
Object? _readId(Map json, String key) => json['user'] ?? json['userId'];

/// Safely parses the service field. If it's a string ID, we create a skeleton TourismService.
/// If it's a map, we parse it fully.
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

/// Safely parses an ID field that might be a populated object.
String _parseId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) return value['_id']?.toString() ?? value['id']?.toString() ?? '';
  return value.toString();
}

/// Safely parses the price field which might be named 'totalPrice' or 'price'.
double _parsePrice(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Safely parses a User field.
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

@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    required String service,
    required BookingDates dates,
    String? notes,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateBookingRequestFromJson(json);
}
