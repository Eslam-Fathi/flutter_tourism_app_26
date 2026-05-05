import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class TourismService with _$TourismService {
  const TourismService._();

  const factory TourismService({
    @JsonKey(name: '_id') required String id,
    required String title,
    @JsonKey(fromJson: _parsePrice) @Default(0.0) double price,
    required String location,
    required String category,
    // company can be a plain String ID or a populated Company object from the backend
    @JsonKey(fromJson: _parseId) required String company,
    String? description,
    @JsonKey(fromJson: _parseImages) @Default([]) List<String> images,
    @Default(0.0) double rating,
    @Default(0) int reviewsCount,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) User? tourGuide,
  }) = _TourismService;

  /// Extracts the guide ID from the description if present via [[guideId:XYZ]]
  String? get assignedGuideId {
    if (description == null) return null;
    final regExp = RegExp(r'\[\[guideId:(.*?)\]\]');
    final match = regExp.firstMatch(description!);
    return match?.group(1);
  }

  /// Returns the description without the hidden metadata tag
  String get cleanDescription {
    if (description == null) return '';
    return description!.replaceAll(RegExp(r'\s*\[\[guideId:.*?\]\]'), '').trim();
  }

  factory TourismService.fromJson(Map<String, dynamic> json) => _$TourismServiceFromJson(json);
}

Object? _readTourGuide(Map json, String key) => json['tourGuide'] ?? json['tour_guide'];

/// Safely parses a field that can be either a plain String ID or a populated
/// Mongoose object (Map). Returns the _id string in both cases.
String _parseId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) return value['_id']?.toString() ?? value['id']?.toString() ?? '';
  return value.toString();
}

/// Safely parses the price field which might be a String or Number.
double _parsePrice(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Safely parses images list, handling null or non-list data.
List<String> _parseImages(dynamic value) {
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
}

/// Safely parses a User field.
User? _parseUser(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    return User.fromJson(Map<String, dynamic>.from(value));
  }
  return null;
}

@freezed
class ServiceResponse with _$ServiceResponse {
  const factory ServiceResponse({
    required bool success,
    required int count,
    required List<TourismService> data,
  }) = _ServiceResponse;

  factory ServiceResponse.fromJson(Map<String, dynamic> json) => _$ServiceResponseFromJson(json);
}
