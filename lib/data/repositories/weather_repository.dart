import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio;

  WeatherRepository({required Dio dio}) : _dio = dio;

  Future<WeatherForecast> getForecast(double lat, double lng) async {
    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'daily': 'weathercode,temperature_2m_max,temperature_2m_min',
          'timezone': 'auto',
        },
      );

      final dailyData = response.data['daily'];
      final List<DailyForecast> dailyForecasts = [];

      for (int i = 0; i < (dailyData['time'] as List).length; i++) {
        dailyForecasts.add(DailyForecast(
          date: DateTime.parse(dailyData['time'][i]),
          weatherCode: dailyData['weathercode'][i],
          maxTemp: (dailyData['temperature_2m_max'][i] as num).toDouble(),
          minTemp: (dailyData['temperature_2m_min'][i] as num).toDouble(),
        ));
      }

      return WeatherForecast(daily: dailyForecasts);
    } catch (e) {
      throw Exception('Failed to load weather forecast: $e');
    }
  }
}
