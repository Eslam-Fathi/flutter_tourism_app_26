// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoricalArticleImpl _$$HistoricalArticleImplFromJson(
  Map<String, dynamic> json,
) => _$HistoricalArticleImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  location: json['location'] as String,
  author: json['author'] as String,
  content: json['content'] as String,
  imageUrl: json['image_url'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$HistoricalArticleImplToJson(
  _$HistoricalArticleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'location': instance.location,
  'author': instance.author,
  'content': instance.content,
  'image_url': instance.imageUrl,
  'created_at': instance.createdAt.toIso8601String(),
};
