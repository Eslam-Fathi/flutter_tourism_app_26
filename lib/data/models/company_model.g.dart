// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyImpl _$$CompanyImplFromJson(Map<String, dynamic> json) =>
    _$CompanyImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      approved: json['approved'] as bool? ?? false,
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      logo: json['logo'] as String?,
      owner: _parseOwner(json['owner']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CompanyImplToJson(_$CompanyImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'approved': instance.approved,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'logo': instance.logo,
      'owner': instance.owner,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
