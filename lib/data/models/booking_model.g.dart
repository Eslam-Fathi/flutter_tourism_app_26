// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingDatesImpl _$$BookingDatesImplFromJson(Map<String, dynamic> json) =>
    _$BookingDatesImpl(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$BookingDatesImplToJson(_$BookingDatesImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['_id'] as String,
      tourismService: TourismService.fromJson(
        json['service'] as Map<String, dynamic>,
      ),
      user: json['user'] as String,
      dates: BookingDates.fromJson(json['dates'] as Map<String, dynamic>),
      status: json['status'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'service': instance.tourismService,
      'user': instance.user,
      'dates': instance.dates,
      'status': instance.status,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$CreateBookingRequestImpl _$$CreateBookingRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateBookingRequestImpl(
  service: json['service'] as String,
  dates: BookingDates.fromJson(json['dates'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CreateBookingRequestImplToJson(
  _$CreateBookingRequestImpl instance,
) => <String, dynamic>{'service': instance.service, 'dates': instance.dates};
