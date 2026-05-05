// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingDates _$BookingDatesFromJson(Map<String, dynamic> json) {
  return _BookingDates.fromJson(json);
}

/// @nodoc
mixin _$BookingDates {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this BookingDates to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingDates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingDatesCopyWith<BookingDates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDatesCopyWith<$Res> {
  factory $BookingDatesCopyWith(
    BookingDates value,
    $Res Function(BookingDates) then,
  ) = _$BookingDatesCopyWithImpl<$Res, BookingDates>;
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class _$BookingDatesCopyWithImpl<$Res, $Val extends BookingDates>
    implements $BookingDatesCopyWith<$Res> {
  _$BookingDatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingDates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = null, Object? endDate = null}) {
    return _then(
      _value.copyWith(
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingDatesImplCopyWith<$Res>
    implements $BookingDatesCopyWith<$Res> {
  factory _$$BookingDatesImplCopyWith(
    _$BookingDatesImpl value,
    $Res Function(_$BookingDatesImpl) then,
  ) = __$$BookingDatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class __$$BookingDatesImplCopyWithImpl<$Res>
    extends _$BookingDatesCopyWithImpl<$Res, _$BookingDatesImpl>
    implements _$$BookingDatesImplCopyWith<$Res> {
  __$$BookingDatesImplCopyWithImpl(
    _$BookingDatesImpl _value,
    $Res Function(_$BookingDatesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingDates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = null, Object? endDate = null}) {
    return _then(
      _$BookingDatesImpl(
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingDatesImpl implements _BookingDates {
  const _$BookingDatesImpl({required this.startDate, required this.endDate});

  factory _$BookingDatesImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingDatesImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  @override
  String toString() {
    return 'BookingDates(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDatesImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of BookingDates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDatesImplCopyWith<_$BookingDatesImpl> get copyWith =>
      __$$BookingDatesImplCopyWithImpl<_$BookingDatesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingDatesImplToJson(this);
  }
}

abstract class _BookingDates implements BookingDates {
  const factory _BookingDates({
    required final DateTime startDate,
    required final DateTime endDate,
  }) = _$BookingDatesImpl;

  factory _BookingDates.fromJson(Map<String, dynamic> json) =
      _$BookingDatesImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// Create a copy of BookingDates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingDatesImplCopyWith<_$BookingDatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readService, fromJson: _parseService)
  TourismService get tourismService => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readUser, fromJson: _parseUser)
  User? get user => throw _privateConstructorUsedError;
  BookingDates get dates => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
  double get totalPrice => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readCreatedAt)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
  User? get tourGuide => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(readValue: _readService, fromJson: _parseService)
    TourismService tourismService,
    @JsonKey(readValue: _readUser, fromJson: _parseUser) User? user,
    BookingDates dates,
    String status,
    @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
    double totalPrice,
    String? notes,
    @JsonKey(readValue: _readCreatedAt) DateTime createdAt,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) User? tourGuide,
  });

  $TourismServiceCopyWith<$Res> get tourismService;
  $UserCopyWith<$Res>? get user;
  $BookingDatesCopyWith<$Res> get dates;
  $UserCopyWith<$Res>? get tourGuide;
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tourismService = null,
    Object? user = freezed,
    Object? dates = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? tourGuide = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tourismService: null == tourismService
                ? _value.tourismService
                : tourismService // ignore: cast_nullable_to_non_nullable
                      as TourismService,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User?,
            dates: null == dates
                ? _value.dates
                : dates // ignore: cast_nullable_to_non_nullable
                      as BookingDates,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            tourGuide: freezed == tourGuide
                ? _value.tourGuide
                : tourGuide // ignore: cast_nullable_to_non_nullable
                      as User?,
          )
          as $Val,
    );
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TourismServiceCopyWith<$Res> get tourismService {
    return $TourismServiceCopyWith<$Res>(_value.tourismService, (value) {
      return _then(_value.copyWith(tourismService: value) as $Val);
    });
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingDatesCopyWith<$Res> get dates {
    return $BookingDatesCopyWith<$Res>(_value.dates, (value) {
      return _then(_value.copyWith(dates: value) as $Val);
    });
  }

  /// Create a copy of Booking
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
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(readValue: _readService, fromJson: _parseService)
    TourismService tourismService,
    @JsonKey(readValue: _readUser, fromJson: _parseUser) User? user,
    BookingDates dates,
    String status,
    @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
    double totalPrice,
    String? notes,
    @JsonKey(readValue: _readCreatedAt) DateTime createdAt,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) User? tourGuide,
  });

  @override
  $TourismServiceCopyWith<$Res> get tourismService;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $BookingDatesCopyWith<$Res> get dates;
  @override
  $UserCopyWith<$Res>? get tourGuide;
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tourismService = null,
    Object? user = freezed,
    Object? dates = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? tourGuide = freezed,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tourismService: null == tourismService
            ? _value.tourismService
            : tourismService // ignore: cast_nullable_to_non_nullable
                  as TourismService,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        dates: null == dates
            ? _value.dates
            : dates // ignore: cast_nullable_to_non_nullable
                  as BookingDates,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(readValue: _readService, fromJson: _parseService)
    required this.tourismService,
    @JsonKey(readValue: _readUser, fromJson: _parseUser) this.user,
    required this.dates,
    this.status = 'pending',
    @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
    this.totalPrice = 0.0,
    this.notes,
    @JsonKey(readValue: _readCreatedAt) required this.createdAt,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser) this.tourGuide,
  });

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(readValue: _readService, fromJson: _parseService)
  final TourismService tourismService;
  @override
  @JsonKey(readValue: _readUser, fromJson: _parseUser)
  final User? user;
  @override
  final BookingDates dates;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
  final double totalPrice;
  @override
  final String? notes;
  @override
  @JsonKey(readValue: _readCreatedAt)
  final DateTime createdAt;
  @override
  @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
  final User? tourGuide;

  @override
  String toString() {
    return 'Booking(id: $id, tourismService: $tourismService, user: $user, dates: $dates, status: $status, totalPrice: $totalPrice, notes: $notes, createdAt: $createdAt, tourGuide: $tourGuide)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tourismService, tourismService) ||
                other.tourismService == tourismService) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.dates, dates) || other.dates == dates) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.tourGuide, tourGuide) ||
                other.tourGuide == tourGuide));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tourismService,
    user,
    dates,
    status,
    totalPrice,
    notes,
    createdAt,
    tourGuide,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(readValue: _readService, fromJson: _parseService)
    required final TourismService tourismService,
    @JsonKey(readValue: _readUser, fromJson: _parseUser) final User? user,
    required final BookingDates dates,
    final String status,
    @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
    final double totalPrice,
    final String? notes,
    @JsonKey(readValue: _readCreatedAt) required final DateTime createdAt,
    @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
    final User? tourGuide,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(readValue: _readService, fromJson: _parseService)
  TourismService get tourismService;
  @override
  @JsonKey(readValue: _readUser, fromJson: _parseUser)
  User? get user;
  @override
  BookingDates get dates;
  @override
  String get status;
  @override
  @JsonKey(readValue: _readTotalPrice, fromJson: _parsePrice)
  double get totalPrice;
  @override
  String? get notes;
  @override
  @JsonKey(readValue: _readCreatedAt)
  DateTime get createdAt;
  @override
  @JsonKey(readValue: _readTourGuide, fromJson: _parseUser)
  User? get tourGuide;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateBookingRequest _$CreateBookingRequestFromJson(Map<String, dynamic> json) {
  return _CreateBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateBookingRequest {
  String get service => throw _privateConstructorUsedError;
  BookingDates get dates => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CreateBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateBookingRequestCopyWith<CreateBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBookingRequestCopyWith<$Res> {
  factory $CreateBookingRequestCopyWith(
    CreateBookingRequest value,
    $Res Function(CreateBookingRequest) then,
  ) = _$CreateBookingRequestCopyWithImpl<$Res, CreateBookingRequest>;
  @useResult
  $Res call({String service, BookingDates dates, String? notes});

  $BookingDatesCopyWith<$Res> get dates;
}

/// @nodoc
class _$CreateBookingRequestCopyWithImpl<
  $Res,
  $Val extends CreateBookingRequest
>
    implements $CreateBookingRequestCopyWith<$Res> {
  _$CreateBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = null,
    Object? dates = null,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            service: null == service
                ? _value.service
                : service // ignore: cast_nullable_to_non_nullable
                      as String,
            dates: null == dates
                ? _value.dates
                : dates // ignore: cast_nullable_to_non_nullable
                      as BookingDates,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingDatesCopyWith<$Res> get dates {
    return $BookingDatesCopyWith<$Res>(_value.dates, (value) {
      return _then(_value.copyWith(dates: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateBookingRequestImplCopyWith<$Res>
    implements $CreateBookingRequestCopyWith<$Res> {
  factory _$$CreateBookingRequestImplCopyWith(
    _$CreateBookingRequestImpl value,
    $Res Function(_$CreateBookingRequestImpl) then,
  ) = __$$CreateBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String service, BookingDates dates, String? notes});

  @override
  $BookingDatesCopyWith<$Res> get dates;
}

/// @nodoc
class __$$CreateBookingRequestImplCopyWithImpl<$Res>
    extends _$CreateBookingRequestCopyWithImpl<$Res, _$CreateBookingRequestImpl>
    implements _$$CreateBookingRequestImplCopyWith<$Res> {
  __$$CreateBookingRequestImplCopyWithImpl(
    _$CreateBookingRequestImpl _value,
    $Res Function(_$CreateBookingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = null,
    Object? dates = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$CreateBookingRequestImpl(
        service: null == service
            ? _value.service
            : service // ignore: cast_nullable_to_non_nullable
                  as String,
        dates: null == dates
            ? _value.dates
            : dates // ignore: cast_nullable_to_non_nullable
                  as BookingDates,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBookingRequestImpl implements _CreateBookingRequest {
  const _$CreateBookingRequestImpl({
    required this.service,
    required this.dates,
    this.notes,
  });

  factory _$CreateBookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBookingRequestImplFromJson(json);

  @override
  final String service;
  @override
  final BookingDates dates;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreateBookingRequest(service: $service, dates: $dates, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBookingRequestImpl &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.dates, dates) || other.dates == dates) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, service, dates, notes);

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
  get copyWith =>
      __$$CreateBookingRequestImplCopyWithImpl<_$CreateBookingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBookingRequestImplToJson(this);
  }
}

abstract class _CreateBookingRequest implements CreateBookingRequest {
  const factory _CreateBookingRequest({
    required final String service,
    required final BookingDates dates,
    final String? notes,
  }) = _$CreateBookingRequestImpl;

  factory _CreateBookingRequest.fromJson(Map<String, dynamic> json) =
      _$CreateBookingRequestImpl.fromJson;

  @override
  String get service;
  @override
  BookingDates get dates;
  @override
  String? get notes;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
