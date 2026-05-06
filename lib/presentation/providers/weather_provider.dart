import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/models/weather_model.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return WeatherRepository(dio: dio);
});

final weatherForecastProvider = FutureProvider.family<WeatherForecast, ({double lat, double lng})>((ref, coords) async {
  final repository = ref.watch(weatherRepositoryProvider);
  return repository.getForecast(coords.lat, coords.lng);
});
