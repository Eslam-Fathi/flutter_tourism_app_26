// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'service_model.dart';
import 'user_model.dart';

part 'interaction_model.freezed.dart';
part 'interaction_model.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'service') required String serviceId,
    @JsonKey(fromJson: _parseUser) required User user,
    required int rating,
    required String comment,
    DateTime? createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    @JsonKey(name: '_id') required String id,
    @JsonKey(fromJson: _parseService) required TourismService service,
    DateTime? createdAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);
}

User _parseUser(dynamic value) {
  if (value is Map) {
    return User.fromJson(Map<String, dynamic>.from(value));
  }
  return User(
    id: value.toString(),
    name: 'User',
  );
}

TourismService _parseService(dynamic value) {
  if (value is Map) {
    return TourismService.fromJson(Map<String, dynamic>.from(value));
  }
  return TourismService(
    id: value.toString(),
    title: 'Service',
    location: '',
    category: '',
    company: '',
  );
}
