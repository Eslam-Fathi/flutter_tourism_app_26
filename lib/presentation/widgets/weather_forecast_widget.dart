import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/weather_utils.dart';
import '../providers/weather_provider.dart';

class WeatherForecastWidget extends ConsumerWidget {
  final double lat;
  final double lng;

  const WeatherForecastWidget({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherForecastProvider((lat: lat, lng: lng)));

    return weatherAsync.when(
      data: (weather) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    '7-Day Forecast',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: weather.daily.map((forecast) {
                    final (icon, label) = WeatherUtils.getWeatherInfo(forecast.weatherCode);
                    final isToday = DateFormat('yyyy-MM-dd').format(forecast.date) == 
                                   DateFormat('yyyy-MM-dd').format(DateTime.now());

                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isToday 
                            ? AppColors.primary.withValues(alpha: 0.08) 
                            : AppColors.background.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isToday 
                              ? AppColors.primary.withValues(alpha: 0.3) 
                              : Colors.grey.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isToday ? 'Today' : DateFormat('E, MMM d').format(forecast.date),
                            style: TextStyle(
                              color: isToday ? AppColors.primary : AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Icon(
                            icon, 
                            color: isToday ? AppColors.primary : AppColors.textBody, 
                            size: 28,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${forecast.maxTemp.round()}°',
                            style: TextStyle(
                              color: AppColors.textBody,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '${forecast.minTemp.round()}°',
                            style: TextStyle(
                              color: AppColors.textMuted.withValues(alpha: 0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            label,
                            style: TextStyle(
                              color: isToday ? AppColors.primary : AppColors.textMuted,
                              fontSize: 10,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      error: (err, stack) => const SizedBox.shrink(), // Silently hide on error or show a fallback
    );
  }
}
