// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TourismServiceImpl _$$TourismServiceImplFromJson(Map<String, dynamic> json) =>
    _$TourismServiceImpl(
      id: json['_id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      category: json['category'] as String,
      company: json['company'] as String,
      description: json['description'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TourismServiceImplToJson(
  _$TourismServiceImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'location': instance.location,
  'category': instance.category,
  'company': instance.company,
  'description': instance.description,
  'images': instance.images,
  'rating': instance.rating,
  'reviewsCount': instance.reviewsCount,
};

_$ServiceResponseImpl _$$ServiceResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ServiceResponseImpl(
  success: json['success'] as bool,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => TourismService.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ServiceResponseImplToJson(
  _$ServiceResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'count': instance.count,
  'data': instance.data,
};
