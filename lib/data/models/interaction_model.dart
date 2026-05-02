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
    required User user,
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
    required TourismService service,
    DateTime? createdAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);
}
