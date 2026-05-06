// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) {
  return _WeatherForecast.fromJson(json);
}

/// @nodoc
mixin _$WeatherForecast {
  List<DailyForecast> get daily => throw _privateConstructorUsedError;

  /// Serializes this WeatherForecast to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherForecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherForecastCopyWith<WeatherForecast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherForecastCopyWith<$Res> {
  factory $WeatherForecastCopyWith(
    WeatherForecast value,
    $Res Function(WeatherForecast) then,
  ) = _$WeatherForecastCopyWithImpl<$Res, WeatherForecast>;
  @useResult
  $Res call({List<DailyForecast> daily});
}

/// @nodoc
class _$WeatherForecastCopyWithImpl<$Res, $Val extends WeatherForecast>
    implements $WeatherForecastCopyWith<$Res> {
  _$WeatherForecastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherForecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daily = null}) {
    return _then(
      _value.copyWith(
            daily: null == daily
                ? _value.daily
                : daily // ignore: cast_nullable_to_non_nullable
                      as List<DailyForecast>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherForecastImplCopyWith<$Res>
    implements $WeatherForecastCopyWith<$Res> {
  factory _$$WeatherForecastImplCopyWith(
    _$WeatherForecastImpl value,
    $Res Function(_$WeatherForecastImpl) then,
  ) = __$$WeatherForecastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DailyForecast> daily});
}

/// @nodoc
class __$$WeatherForecastImplCopyWithImpl<$Res>
    extends _$WeatherForecastCopyWithImpl<$Res, _$WeatherForecastImpl>
    implements _$$WeatherForecastImplCopyWith<$Res> {
  __$$WeatherForecastImplCopyWithImpl(
    _$WeatherForecastImpl _value,
    $Res Function(_$WeatherForecastImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherForecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daily = null}) {
    return _then(
      _$WeatherForecastImpl(
        daily: null == daily
            ? _value._daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<DailyForecast>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherForecastImpl implements _WeatherForecast {
  const _$WeatherForecastImpl({required final List<DailyForecast> daily})
    : _daily = daily;

  factory _$WeatherForecastImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherForecastImplFromJson(json);

  final List<DailyForecast> _daily;
  @override
  List<DailyForecast> get daily {
    if (_daily is EqualUnmodifiableListView) return _daily;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daily);
  }

  @override
  String toString() {
    return 'WeatherForecast(daily: $daily)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherForecastImpl &&
            const DeepCollectionEquality().equals(other._daily, _daily));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_daily));

  /// Create a copy of WeatherForecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherForecastImplCopyWith<_$WeatherForecastImpl> get copyWith =>
      __$$WeatherForecastImplCopyWithImpl<_$WeatherForecastImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherForecastImplToJson(this);
  }
}

abstract class _WeatherForecast implements WeatherForecast {
  const factory _WeatherForecast({required final List<DailyForecast> daily}) =
      _$WeatherForecastImpl;

  factory _WeatherForecast.fromJson(Map<String, dynamic> json) =
      _$WeatherForecastImpl.fromJson;

  @override
  List<DailyForecast> get daily;

  /// Create a copy of WeatherForecast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherForecastImplCopyWith<_$WeatherForecastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) {
  return _DailyForecast.fromJson(json);
}

/// @nodoc
mixin _$DailyForecast {
  DateTime get date => throw _privateConstructorUsedError;
  int get weatherCode => throw _privateConstructorUsedError;
  double get maxTemp => throw _privateConstructorUsedError;
  double get minTemp => throw _privateConstructorUsedError;

  /// Serializes this DailyForecast to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyForecastCopyWith<DailyForecast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyForecastCopyWith<$Res> {
  factory $DailyForecastCopyWith(
    DailyForecast value,
    $Res Function(DailyForecast) then,
  ) = _$DailyForecastCopyWithImpl<$Res, DailyForecast>;
  @useResult
  $Res call({DateTime date, int weatherCode, double maxTemp, double minTemp});
}

/// @nodoc
class _$DailyForecastCopyWithImpl<$Res, $Val extends DailyForecast>
    implements $DailyForecastCopyWith<$Res> {
  _$DailyForecastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? weatherCode = null,
    Object? maxTemp = null,
    Object? minTemp = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weatherCode: null == weatherCode
                ? _value.weatherCode
                : weatherCode // ignore: cast_nullable_to_non_nullable
                      as int,
            maxTemp: null == maxTemp
                ? _value.maxTemp
                : maxTemp // ignore: cast_nullable_to_non_nullable
                      as double,
            minTemp: null == minTemp
                ? _value.minTemp
                : minTemp // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyForecastImplCopyWith<$Res>
    implements $DailyForecastCopyWith<$Res> {
  factory _$$DailyForecastImplCopyWith(
    _$DailyForecastImpl value,
    $Res Function(_$DailyForecastImpl) then,
  ) = __$$DailyForecastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int weatherCode, double maxTemp, double minTemp});
}

/// @nodoc
class __$$DailyForecastImplCopyWithImpl<$Res>
    extends _$DailyForecastCopyWithImpl<$Res, _$DailyForecastImpl>
    implements _$$DailyForecastImplCopyWith<$Res> {
  __$$DailyForecastImplCopyWithImpl(
    _$DailyForecastImpl _value,
    $Res Function(_$DailyForecastImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? weatherCode = null,
    Object? maxTemp = null,
    Object? minTemp = null,
  }) {
    return _then(
      _$DailyForecastImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weatherCode: null == weatherCode
            ? _value.weatherCode
            : weatherCode // ignore: cast_nullable_to_non_nullable
                  as int,
        maxTemp: null == maxTemp
            ? _value.maxTemp
            : maxTemp // ignore: cast_nullable_to_non_nullable
                  as double,
        minTemp: null == minTemp
            ? _value.minTemp
            : minTemp // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyForecastImpl implements _DailyForecast {
  const _$DailyForecastImpl({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
  });

  factory _$DailyForecastImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyForecastImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int weatherCode;
  @override
  final double maxTemp;
  @override
  final double minTemp;

  @override
  String toString() {
    return 'DailyForecast(date: $date, weatherCode: $weatherCode, maxTemp: $maxTemp, minTemp: $minTemp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyForecastImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.weatherCode, weatherCode) ||
                other.weatherCode == weatherCode) &&
            (identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp) &&
            (identical(other.minTemp, minTemp) || other.minTemp == minTemp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, weatherCode, maxTemp, minTemp);

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyForecastImplCopyWith<_$DailyForecastImpl> get copyWith =>
      __$$DailyForecastImplCopyWithImpl<_$DailyForecastImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyForecastImplToJson(this);
  }
}

abstract class _DailyForecast implements DailyForecast {
  const factory _DailyForecast({
    required final DateTime date,
    required final int weatherCode,
    required final double maxTemp,
    required final double minTemp,
  }) = _$DailyForecastImpl;

  factory _DailyForecast.fromJson(Map<String, dynamic> json) =
      _$DailyForecastImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get weatherCode;
  @override
  double get maxTemp;
  @override
  double get minTemp;

  /// Create a copy of DailyForecast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyForecastImplCopyWith<_$DailyForecastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
