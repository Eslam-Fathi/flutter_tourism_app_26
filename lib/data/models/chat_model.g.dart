// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['_id'] as String,
      booking: json['booking'] as String,
      content: json['content'] as String,
      sender: _senderFromJson(json['sender']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'booking': instance.booking,
      'content': instance.content,
      'sender': instance.sender,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
