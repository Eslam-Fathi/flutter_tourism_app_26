// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class HistoricalArticle with _$HistoricalArticle {
  const factory HistoricalArticle({
    required String id,
    required String title,
    required String location,
    required String author,
    required String content,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _HistoricalArticle;

  factory HistoricalArticle.fromJson(Map<String, dynamic> json) => _$HistoricalArticleFromJson(json);
}
