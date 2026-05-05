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
      tourismService: _parseService(_readService(json, 'tourismService')),
      user: _parseUser(_readUser(json, 'user')),
      dates: BookingDates.fromJson(json['dates'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'pending',
      totalPrice: _readTotalPrice(json, 'totalPrice') == null
          ? 0.0
          : _parsePrice(_readTotalPrice(json, 'totalPrice')),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(_readCreatedAt(json, 'createdAt') as String),
      tourGuide: _parseUser(_readTourGuide(json, 'tourGuide')),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'tourismService': instance.tourismService,
      'user': instance.user,
      'dates': instance.dates,
      'status': instance.status,
      'totalPrice': instance.totalPrice,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'tourGuide': instance.tourGuide,
    };

_$CreateBookingRequestImpl _$$CreateBookingRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateBookingRequestImpl(
  service: json['service'] as String,
  dates: BookingDates.fromJson(json['dates'] as Map<String, dynamic>),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$CreateBookingRequestImplToJson(
  _$CreateBookingRequestImpl instance,
) => <String, dynamic>{
  'service': instance.service,
  'dates': instance.dates,
  'notes': instance.notes,
};
