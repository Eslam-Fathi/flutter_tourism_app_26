// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherForecastImpl _$$WeatherForecastImplFromJson(
  Map<String, dynamic> json,
) => _$WeatherForecastImpl(
  daily: (json['daily'] as List<dynamic>)
      .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$WeatherForecastImplToJson(
  _$WeatherForecastImpl instance,
) => <String, dynamic>{'daily': instance.daily};

_$DailyForecastImpl _$$DailyForecastImplFromJson(Map<String, dynamic> json) =>
    _$DailyForecastImpl(
      date: DateTime.parse(json['date'] as String),
      weatherCode: (json['weatherCode'] as num).toInt(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyForecastImplToJson(_$DailyForecastImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'weatherCode': instance.weatherCode,
      'maxTemp': instance.maxTemp,
      'minTemp': instance.minTemp,
    };
