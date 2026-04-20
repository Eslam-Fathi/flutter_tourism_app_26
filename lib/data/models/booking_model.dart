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
    @JsonKey(name: 'service') required TourismService tourismService,
    required String user,
    required BookingDates dates,
    required String status,
    required double totalPrice,
    required DateTime createdAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    required String service,
    required BookingDates dates,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateBookingRequestFromJson(json);
}
