import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class TourismService with _$TourismService {
  const factory TourismService({
    @JsonKey(name: '_id') required String id,
    required String title,
    @Default(0.0) double price,
    required String location,
    required String category,
    // company can be a plain String ID or a populated Company object from the backend
    @JsonKey(fromJson: _parseId) required String company,
    String? description,
    @Default([]) List<String> images,
    @Default(0.0) double rating,
    @Default(0) int reviewsCount,
  }) = _TourismService;

  factory TourismService.fromJson(Map<String, dynamic> json) => _$TourismServiceFromJson(json);
}

/// Safely parses a field that can be either a plain String ID or a populated
/// Mongoose object (Map). Returns the _id string in both cases.
String _parseId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) return value['_id']?.toString() ?? value['id']?.toString() ?? '';
  return value.toString();
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
