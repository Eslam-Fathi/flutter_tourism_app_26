// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HistoricalArticle _$HistoricalArticleFromJson(Map<String, dynamic> json) {
  return _HistoricalArticle.fromJson(json);
}

/// @nodoc
mixin _$HistoricalArticle {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HistoricalArticle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoricalArticle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoricalArticleCopyWith<HistoricalArticle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoricalArticleCopyWith<$Res> {
  factory $HistoricalArticleCopyWith(
    HistoricalArticle value,
    $Res Function(HistoricalArticle) then,
  ) = _$HistoricalArticleCopyWithImpl<$Res, HistoricalArticle>;
  @useResult
  $Res call({
    String id,
    String title,
    String location,
    String author,
    String content,
    @JsonKey(name: 'image_url') String imageUrl,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$HistoricalArticleCopyWithImpl<$Res, $Val extends HistoricalArticle>
    implements $HistoricalArticleCopyWith<$Res> {
  _$HistoricalArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoricalArticle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = null,
    Object? author = null,
    Object? content = null,
    Object? imageUrl = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HistoricalArticleImplCopyWith<$Res>
    implements $HistoricalArticleCopyWith<$Res> {
  factory _$$HistoricalArticleImplCopyWith(
    _$HistoricalArticleImpl value,
    $Res Function(_$HistoricalArticleImpl) then,
  ) = __$$HistoricalArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String location,
    String author,
    String content,
    @JsonKey(name: 'image_url') String imageUrl,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$HistoricalArticleImplCopyWithImpl<$Res>
    extends _$HistoricalArticleCopyWithImpl<$Res, _$HistoricalArticleImpl>
    implements _$$HistoricalArticleImplCopyWith<$Res> {
  __$$HistoricalArticleImplCopyWithImpl(
    _$HistoricalArticleImpl _value,
    $Res Function(_$HistoricalArticleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HistoricalArticle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = null,
    Object? author = null,
    Object? content = null,
    Object? imageUrl = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$HistoricalArticleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoricalArticleImpl implements _HistoricalArticle {
  const _$HistoricalArticleImpl({
    required this.id,
    required this.title,
    required this.location,
    required this.author,
    required this.content,
    @JsonKey(name: 'image_url') required this.imageUrl,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$HistoricalArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoricalArticleImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String location;
  @override
  final String author;
  @override
  final String content;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'HistoricalArticle(id: $id, title: $title, location: $location, author: $author, content: $content, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoricalArticleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    location,
    author,
    content,
    imageUrl,
    createdAt,
  );

  /// Create a copy of HistoricalArticle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoricalArticleImplCopyWith<_$HistoricalArticleImpl> get copyWith =>
      __$$HistoricalArticleImplCopyWithImpl<_$HistoricalArticleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoricalArticleImplToJson(this);
  }
}

abstract class _HistoricalArticle implements HistoricalArticle {
  const factory _HistoricalArticle({
    required final String id,
    required final String title,
    required final String location,
    required final String author,
    required final String content,
    @JsonKey(name: 'image_url') required final String imageUrl,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$HistoricalArticleImpl;

  factory _HistoricalArticle.fromJson(Map<String, dynamic> json) =
      _$HistoricalArticleImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get location;
  @override
  String get author;
  @override
  String get content;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of HistoricalArticle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoricalArticleImplCopyWith<_$HistoricalArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
