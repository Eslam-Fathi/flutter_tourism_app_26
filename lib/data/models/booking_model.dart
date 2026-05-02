import 'package:freezed_annotation/freezed_annotation.dart';
import 'service_model.dart';

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
    // The backend might return service as a populated object OR a string ID.
    // We parse it into a TourismService object if possible, otherwise we 
    // handle it resiliently.
    @JsonKey(name: 'service', fromJson: _parseService) required TourismService tourismService,
    @JsonKey(fromJson: _parseId) required String user,
    required BookingDates dates,
    @Default('pending') String status,
    @Default(0.0) double totalPrice,
    String? notes,
    required DateTime createdAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

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

@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    required String service,
    required BookingDates dates,
    String? notes,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateBookingRequestFromJson(json);
}
