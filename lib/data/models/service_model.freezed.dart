// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TourismService _$TourismServiceFromJson(Map<String, dynamic> json) {
  return _TourismService.fromJson(json);
}

/// @nodoc
mixin _$TourismService {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parsePrice)
  double get price => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // company can be a plain String ID or a populated Company object from the backend
  @JsonKey(fromJson: _parseId)
  String get company => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseImages)
  List<String> get images => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewsCount => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
  User? get tourGuide => throw _privateConstructorUsedError;

  /// Serializes this TourismService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TourismService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourismServiceCopyWith<TourismService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourismServiceCopyWith<$Res> {
  factory $TourismServiceCopyWith(
    TourismService value,
    $Res Function(TourismService) then,
  ) = _$TourismServiceCopyWithImpl<$Res, TourismService>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    @JsonKey(fromJson: _parsePrice) double price,
    String location,
    String category,
    @JsonKey(fromJson: _parseId) String company,
    String? description,
    @JsonKey(fromJson: _parseImages) List<String> images,
    double rating,
    int reviewsCount,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) User? tourGuide,
  });

  $UserCopyWith<$Res>? get tourGuide;
}

/// @nodoc
class _$TourismServiceCopyWithImpl<$Res, $Val extends TourismService>
    implements $TourismServiceCopyWith<$Res> {
  _$TourismServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourismService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? location = null,
    Object? category = null,
    Object? company = null,
    Object? description = freezed,
    Object? images = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? tourGuide = freezed,
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
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            company: null == company
                ? _value.company
                : company // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewsCount: null == reviewsCount
                ? _value.reviewsCount
                : reviewsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            tourGuide: freezed == tourGuide
                ? _value.tourGuide
                : tourGuide // ignore: cast_nullable_to_non_nullable
                      as User?,
          )
          as $Val,
    );
  }

  /// Create a copy of TourismService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get tourGuide {
    if (_value.tourGuide == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.tourGuide!, (value) {
      return _then(_value.copyWith(tourGuide: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TourismServiceImplCopyWith<$Res>
    implements $TourismServiceCopyWith<$Res> {
  factory _$$TourismServiceImplCopyWith(
    _$TourismServiceImpl value,
    $Res Function(_$TourismServiceImpl) then,
  ) = __$$TourismServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    @JsonKey(fromJson: _parsePrice) double price,
    String location,
    String category,
    @JsonKey(fromJson: _parseId) String company,
    String? description,
    @JsonKey(fromJson: _parseImages) List<String> images,
    double rating,
    int reviewsCount,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) User? tourGuide,
  });

  @override
  $UserCopyWith<$Res>? get tourGuide;
}

/// @nodoc
class __$$TourismServiceImplCopyWithImpl<$Res>
    extends _$TourismServiceCopyWithImpl<$Res, _$TourismServiceImpl>
    implements _$$TourismServiceImplCopyWith<$Res> {
  __$$TourismServiceImplCopyWithImpl(
    _$TourismServiceImpl _value,
    $Res Function(_$TourismServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourismService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? location = null,
    Object? category = null,
    Object? company = null,
    Object? description = freezed,
    Object? images = null,
    Object? rating = null,
    Object? reviewsCount = null,
    Object? tourGuide = freezed,
  }) {
    return _then(
      _$TourismServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        company: null == company
            ? _value.company
            : company // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewsCount: null == reviewsCount
            ? _value.reviewsCount
            : reviewsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        tourGuide: freezed == tourGuide
            ? _value.tourGuide
            : tourGuide // ignore: cast_nullable_to_non_nullable
                  as User?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TourismServiceImpl extends _TourismService {
  const _$TourismServiceImpl({
    @JsonKey(name: '_id') required this.id,
    required this.title,
    @JsonKey(fromJson: _parsePrice) this.price = 0.0,
    required this.location,
    required this.category,
    @JsonKey(fromJson: _parseId) required this.company,
    this.description,
    @JsonKey(fromJson: _parseImages) final List<String> images = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) this.tourGuide,
  }) : _images = images,
       super._();

  factory _$TourismServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$TourismServiceImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  @JsonKey(fromJson: _parsePrice)
  final double price;
  @override
  final String location;
  @override
  final String category;
  // company can be a plain String ID or a populated Company object from the backend
  @override
  @JsonKey(fromJson: _parseId)
  final String company;
  @override
  final String? description;
  final List<String> _images;
  @override
  @JsonKey(fromJson: _parseImages)
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewsCount;
  @override
  @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
  final User? tourGuide;

  @override
  String toString() {
    return 'TourismService(id: $id, title: $title, price: $price, location: $location, category: $category, company: $company, description: $description, images: $images, rating: $rating, reviewsCount: $reviewsCount, tourGuide: $tourGuide)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourismServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.tourGuide, tourGuide) ||
                other.tourGuide == tourGuide));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    price,
    location,
    category,
    company,
    description,
    const DeepCollectionEquality().hash(_images),
    rating,
    reviewsCount,
    tourGuide,
  );

  /// Create a copy of TourismService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourismServiceImplCopyWith<_$TourismServiceImpl> get copyWith =>
      __$$TourismServiceImplCopyWithImpl<_$TourismServiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TourismServiceImplToJson(this);
  }
}

abstract class _TourismService extends TourismService {
  const factory _TourismService({
    @JsonKey(name: '_id') required final String id,
    required final String title,
    @JsonKey(fromJson: _parsePrice) final double price,
    required final String location,
    required final String category,
    @JsonKey(fromJson: _parseId) required final String company,
    final String? description,
    @JsonKey(fromJson: _parseImages) final List<String> images,
    final double rating,
    final int reviewsCount,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
    final User? tourGuide,
  }) = _$TourismServiceImpl;
  const _TourismService._() : super._();

  factory _TourismService.fromJson(Map<String, dynamic> json) =
      _$TourismServiceImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  @JsonKey(fromJson: _parsePrice)
  double get price;
  @override
  String get location;
  @override
  String get category; // company can be a plain String ID or a populated Company object from the backend
  @override
  @JsonKey(fromJson: _parseId)
  String get company;
  @override
  String? get description;
  @override
  @JsonKey(fromJson: _parseImages)
  List<String> get images;
  @override
  double get rating;
  @override
  int get reviewsCount;
  @override
  @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
  User? get tourGuide;

  /// Create a copy of TourismService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourismServiceImplCopyWith<_$TourismServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServiceResponse _$ServiceResponseFromJson(Map<String, dynamic> json) {
  return _ServiceResponse.fromJson(json);
}

/// @nodoc
mixin _$ServiceResponse {
  bool get success => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<TourismService> get data => throw _privateConstructorUsedError;

  /// Serializes this ServiceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceResponseCopyWith<ServiceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceResponseCopyWith<$Res> {
  factory $ServiceResponseCopyWith(
    ServiceResponse value,
    $Res Function(ServiceResponse) then,
  ) = _$ServiceResponseCopyWithImpl<$Res, ServiceResponse>;
  @useResult
  $Res call({bool success, int count, List<TourismService> data});
}

/// @nodoc
class _$ServiceResponseCopyWithImpl<$Res, $Val extends ServiceResponse>
    implements $ServiceResponseCopyWith<$Res> {
  _$ServiceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? count = null,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<TourismService>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceResponseImplCopyWith<$Res>
    implements $ServiceResponseCopyWith<$Res> {
  factory _$$ServiceResponseImplCopyWith(
    _$ServiceResponseImpl value,
    $Res Function(_$ServiceResponseImpl) then,
  ) = __$$ServiceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, int count, List<TourismService> data});
}

/// @nodoc
class __$$ServiceResponseImplCopyWithImpl<$Res>
    extends _$ServiceResponseCopyWithImpl<$Res, _$ServiceResponseImpl>
    implements _$$ServiceResponseImplCopyWith<$Res> {
  __$$ServiceResponseImplCopyWithImpl(
    _$ServiceResponseImpl _value,
    $Res Function(_$ServiceResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? count = null,
    Object? data = null,
  }) {
    return _then(
      _$ServiceResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<TourismService>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceResponseImpl implements _ServiceResponse {
  const _$ServiceResponseImpl({
    required this.success,
    required this.count,
    required final List<TourismService> data,
  }) : _data = data;

  factory _$ServiceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final int count;
  final List<TourismService> _data;
  @override
  List<TourismService> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ServiceResponse(success: $success, count: $count, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    count,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of ServiceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceResponseImplCopyWith<_$ServiceResponseImpl> get copyWith =>
      __$$ServiceResponseImplCopyWithImpl<_$ServiceResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceResponseImplToJson(this);
  }
}

abstract class _ServiceResponse implements ServiceResponse {
  const factory _ServiceResponse({
    required final bool success,
    required final int count,
    required final List<TourismService> data,
  }) = _$ServiceResponseImpl;

  factory _ServiceResponse.fromJson(Map<String, dynamic> json) =
      _$ServiceResponseImpl.fromJson;

  @override
  bool get success;
  @override
  int get count;
  @override
  List<TourismService> get data;

  /// Create a copy of ServiceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceResponseImplCopyWith<_$ServiceResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
