// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['_id'] as String,
  serviceId: json['service'] as String,
  user: _parseUser(json['user']),
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'service': instance.serviceId,
      'user': instance.user,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$FavoriteImpl _$$FavoriteImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteImpl(
      id: json['_id'] as String,
      service: _parseService(json['service']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FavoriteImplToJson(_$FavoriteImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'service': instance.service,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
