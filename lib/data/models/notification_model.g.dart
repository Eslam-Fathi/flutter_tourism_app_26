// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['_id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type: json['type'] as String,
  read: json['read'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'type': instance.type,
  'read': instance.read,
  'createdAt': instance.createdAt.toIso8601String(),
};
