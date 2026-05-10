import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Maps WMO (World Meteorological Organization) weather condition codes to
/// a human-readable description and a corresponding [LucideIcons] icon.
///
/// ## Data source
/// Open-Meteo (https://open-meteo.com) is used as the weather API.  It returns
/// a `weathercode` integer in each forecast entry that follows the
/// **WMO Weather Interpretation Codes** standard (WMO Table 4677).
///
/// ## Why a static utility class?
/// Weather code mapping is **pure data transformation** with no state — a class
/// with only a static method is the idiomatic Dart approach.  It keeps the
/// logic centralised so that multiple widgets ([WeatherForecastWidget], the home
/// screen weather card, etc.) all produce consistent labels and icons.
///
/// ## Usage
/// ```dart
/// final (icon, label) = WeatherUtils.getWeatherInfo(weathercode);
/// Icon(icon)              // e.g. LucideIcons.sun
/// Text(label)             // e.g. 'Clear Sky'
/// ```
class WeatherUtils {
  /// Converts a WMO [code] integer into an `(IconData, String)` record.
  ///
  /// The returned tuple contains:
  /// 1. An [IconData] from `lucide_icons_flutter` — chosen for their clean,
  ///    consistent line style that fits the app's minimal aesthetic.
  /// 2. A short English description suitable for display on the weather card.
  ///
  /// ### WMO Code Reference
  /// | Code range | Condition           |
  /// |------------|---------------------|
  /// | 0          | Clear sky           |
  /// | 1, 2, 3    | Partly cloudy       |
  /// | 45, 48     | Fog / icy fog       |
  /// | 51–55      | Drizzle             |
  /// | 61–65      | Rain                |
  /// | 71–75      | Snow                |
  /// | 77         | Snow grains         |
  /// | 80–82      | Rain showers        |
  /// | 85, 86     | Snow showers        |
  /// | 95         | Thunderstorm        |
  /// | 96, 99     | Thunderstorm + hail |
  ///
  /// Unrecognised codes return a question-mark icon and 'Unknown'.
  static (IconData, String) getWeatherInfo(int code) {
    switch (code) {
      case 0:
        // WMO 0: Completely clear sky with no cloud cover.
        return (LucideIcons.sun, 'Clear Sky');
      case 1:
      case 2:
      case 3:
        // WMO 1–3: Increasing cloud cover — from "mainly clear" to "overcast".
        return (LucideIcons.cloudSun, 'Partly Cloudy');
      case 45:
      case 48:
        // WMO 45: Fog. 48: Depositing rime fog (fog that freezes on contact).
        return (LucideIcons.cloudFog, 'Foggy');
      case 51:
      case 53:
      case 55:
        // WMO 51–55: Drizzle — light (51), moderate (53), dense (55).
        return (LucideIcons.cloudDrizzle, 'Drizzle');
      case 61:
      case 63:
      case 65:
        // WMO 61–65: Rain — slight (61), moderate (63), heavy (65).
        return (LucideIcons.cloudRain, 'Rain');
      case 71:
      case 73:
      case 75:
        // WMO 71–75: Snow fall — slight (71), moderate (73), heavy (75).
        return (LucideIcons.cloudSnow, 'Snow');
      case 77:
        // WMO 77: Snow grains — tiny ice pellets, typically in cold climates.
        return (LucideIcons.snowflake, 'Snow Grains');
      case 80:
      case 81:
      case 82:
        // WMO 80–82: Rain showers — slight (80), moderate (81), violent (82).
        return (LucideIcons.cloudRainWind, 'Rain Showers');
      case 85:
      case 86:
        // WMO 85–86: Snow showers — slight (85), heavy (86).
        return (LucideIcons.cloudSnow, 'Snow Showers');
      case 95:
        // WMO 95: Thunderstorm (slight or moderate) with no hail.
        return (LucideIcons.cloudLightning, 'Thunderstorm');
      case 96:
      case 99:
        // WMO 96: Thunderstorm with slight hail.
        // WMO 99: Thunderstorm with heavy hail.
        return (LucideIcons.cloudLightning, 'Thunderstorm & Hail');
      default:
        // Fallback for any code not covered above (future WMO additions, etc.)
        return (LucideIcons.badgeQuestionMark, 'Unknown');
    }
  }
}
