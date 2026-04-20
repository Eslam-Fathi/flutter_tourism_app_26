import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class TourismService with _$TourismService {
  const factory TourismService({
    @JsonKey(name: '_id') required String id,
    required String title,
    required double price,
    required String location,
    required String category,
    required String company,
    String? description,
    @Default([]) List<String> images,
    @Default(0.0) double rating,
    @Default(0) int reviewsCount,
  }) = _TourismService;

  factory TourismService.fromJson(Map<String, dynamic> json) => _$TourismServiceFromJson(json);
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
