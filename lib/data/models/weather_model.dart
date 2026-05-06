import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    required List<DailyForecast> daily,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) => _$WeatherForecastFromJson(json);
}

@freezed
class DailyForecast with _$DailyForecast {
  const factory DailyForecast({
    required DateTime date,
    required int weatherCode,
    required double maxTemp,
    required double minTemp,
  }) = _DailyForecast;

  factory DailyForecast.fromJson(Map<String, dynamic> json) => _$DailyForecastFromJson(json);
}
