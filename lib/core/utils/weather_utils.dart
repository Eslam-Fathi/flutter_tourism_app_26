import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WeatherUtils {
  static (IconData, String) getWeatherInfo(int code) {
    switch (code) {
      case 0:
        return (LucideIcons.sun, 'Clear Sky');
      case 1:
      case 2:
      case 3:
        return (LucideIcons.cloudSun, 'Partly Cloudy');
      case 45:
      case 48:
        return (LucideIcons.cloudFog, 'Foggy');
      case 51:
      case 53:
      case 55:
        return (LucideIcons.cloudDrizzle, 'Drizzle');
      case 61:
      case 63:
      case 65:
        return (LucideIcons.cloudRain, 'Rain');
      case 71:
      case 73:
      case 75:
        return (LucideIcons.cloudSnow, 'Snow');
      case 77:
        return (LucideIcons.snowflake, 'Snow Grains');
      case 80:
      case 81:
      case 82:
        return (LucideIcons.cloudRainWind, 'Rain Showers');
      case 85:
      case 86:
        return (LucideIcons.cloudSnow, 'Snow Showers');
      case 95:
        return (LucideIcons.cloudLightning, 'Thunderstorm');
      case 96:
      case 99:
        return (LucideIcons.cloudLightning, 'Thunderstorm & Hail');
      default:
        return (LucideIcons.badgeQuestionMark, 'Unknown');
    }
  }
}
