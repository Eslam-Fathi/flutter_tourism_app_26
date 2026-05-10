import 'package:latlong2/latlong.dart';

/// Maps location name strings (from the backend's free-text `location` field)
/// to GPS coordinates ([LatLng]) for use in the interactive map widget.
///
/// ## Problem being solved
/// The backend stores service locations as plain text (e.g. `"Cairo"`,
/// `"Sharm El Sheikh"`, or even `"Near Pyramids of Giza"`).  Map widgets
/// require precise [LatLng] coordinates.  This class bridges that gap with a
/// **curated lookup table** of Egyptian cities and major landmarks.
///
/// ## Matching strategy
/// [getCoordinates] uses a two-pass lookup:
/// 1. **Exact match** on the normalised (lowercase, trimmed) location string.
/// 2. **Partial match** — checks if any known city name appears as a substring
///    in the location string (e.g. `"Cairo, Egypt"` matches `"cairo"`).
/// 3. **Default to Cairo** if no match is found — Cairo is the geographic
///    and demographic centre of Egypt, making it the most sensible fallback.
///
/// ## Extending the map
/// To add a new city or landmark:
/// ```dart
/// 'luxor west bank': LatLng(25.7402, 32.6014),
/// ```
/// All keys must be lowercase.
///
/// ## Data coverage
/// The map covers 50+ Egyptian cities and 12+ iconic landmarks.  Tourist
/// hotspots (Sharm El Sheikh, Dahab, Hurghada) and major administrative
/// capitals are included.
class LocationMapper {
  /// Returns a list of all city/landmark names that have known coordinates.
  ///
  /// Useful for building autocomplete suggestions in the service creation form.
  static List<String> get supportedCities => _egyptCityCoordinates.keys.toList();

  /// Internal lookup table — all keys are lowercase for case-insensitive matching.
  ///
  /// Coordinates are in WGS-84 (standard GPS decimal degrees):
  /// - First value = latitude  (positive = North)
  /// - Second value = longitude (positive = East)
  static const Map<String, LatLng> _egyptCityCoordinates = {
    // ── Major Cities ──────────────────────────────────────────────────────────
    'cairo': LatLng(30.0444, 31.2357),
    'giza': LatLng(29.9792, 31.1342),
    'alexandria': LatLng(31.2001, 29.9187),
    'luxor': LatLng(25.6872, 32.6396),
    'aswan': LatLng(24.0889, 32.8998),

    // ── Red Sea Riviera ───────────────────────────────────────────────────────
    'hurghada': LatLng(27.2579, 33.8116),
    'marsa alam': LatLng(25.0657, 34.8914),
    'el gouna': LatLng(27.3941, 33.6782),
    'sahl hasheesh': LatLng(27.0561, 33.8906),
    'safaga': LatLng(26.7292, 33.9367),
    'quseir': LatLng(26.1039, 34.2764),

    // ── Sinai Peninsula ───────────────────────────────────────────────────────
    'sharm el sheikh': LatLng(27.9158, 34.3299),
    'dahab': LatLng(28.5096, 34.5132),
    'taba': LatLng(29.4936, 34.8967),
    'nuweiba': LatLng(29.0042, 34.6542),
    'saint catherine': LatLng(28.5552, 33.9749),
    'ras sudr': LatLng(29.5878, 32.7126),

    // ── Western Desert / Oases ────────────────────────────────────────────────
    'siwa': LatLng(29.2032, 25.5195),
    'kharga': LatLng(25.4390, 30.5480),
    'fayoum': LatLng(29.3094, 30.8418),

    // ── Mediterranean Coast ───────────────────────────────────────────────────
    'el alamein': LatLng(30.8358, 28.9542),
    'marsa matrouh': LatLng(31.3543, 27.2373),

    // ── Nile Delta Cities ─────────────────────────────────────────────────────
    'port said': LatLng(31.2653, 32.3019),
    'suez': LatLng(29.9668, 32.5498),
    'mansoura': LatLng(31.0409, 31.3785),
    'tanta': LatLng(30.7865, 31.0004),
    'ismailia': LatLng(30.5965, 32.2715),
    'zagazig': LatLng(30.5877, 31.5020),
    'damietta': LatLng(31.4175, 31.8144),
    'kafr el sheikh': LatLng(31.1107, 30.9388),
    'damanhur': LatLng(31.0379, 30.4691),
    'rosetta': LatLng(31.4012, 30.4164),
    'rashid': LatLng(31.4012, 30.4164), // alternative name for Rosetta
    'mahalla el kubra': LatLng(30.9700, 31.1600),
    'shibin el kom': LatLng(30.5503, 31.0096),
    'banha': LatLng(30.4591, 31.1850),

    // ── Upper Egypt Cities ────────────────────────────────────────────────────
    'asyut': LatLng(27.1783, 31.1859),
    'minya': LatLng(28.0991, 30.7503),
    'beni suef': LatLng(29.0744, 31.0979),
    'qena': LatLng(26.1551, 32.7160),
    'sohag': LatLng(26.5570, 31.6948),
    'mallawi': LatLng(27.7303, 30.8418),

    // ── Suez Canal Zone ───────────────────────────────────────────────────────
    'arish': LatLng(31.1316, 33.8033),

    // ── Greater Cairo Satellites ──────────────────────────────────────────────
    '6th of october': LatLng(29.9722, 30.9419),
    '10th of ramadan': LatLng(30.3014, 31.7511),
    'new cairo': LatLng(30.0053, 31.4828),
    'helwan': LatLng(29.8408, 31.2982),
    'obour': LatLng(30.2289, 31.4811),
    'sheikh zayed': LatLng(30.0131, 30.9839),
    'bilbeis': LatLng(30.4192, 31.5647),

    // ── Iconic Landmarks ──────────────────────────────────────────────────────
    // These allow partial matching when a service is named after a landmark
    // rather than its containing city.
    'pyramids of giza': LatLng(29.9792, 31.1342),
    'great sphinx': LatLng(29.9753, 31.1376),
    'egyptian museum': LatLng(30.0478, 31.2336),
    'karnak temple': LatLng(25.7188, 32.6586),
    'luxor temple': LatLng(25.6995, 32.6391),
    'valley of the kings': LatLng(25.7402, 32.6014),
    'abu simbel': LatLng(22.3372, 31.6258),
    'philae temple': LatLng(24.0253, 32.8844),
    'citadel of saladin': LatLng(30.0299, 31.2620),
    'khan el khalili': LatLng(30.0477, 31.2622),
    'mount sinai': LatLng(28.5394, 33.9749),
    'white desert': LatLng(27.2714, 27.2621),
  };

  /// Resolves a location name string to GPS coordinates.
  ///
  /// ### Matching order
  /// 1. **Null / empty check** → returns Cairo (0,0 would be off the map)
  /// 2. **Exact match** on the normalised key (lowercase + trimmed)
  /// 3. **Partial / substring match** (e.g. `"Cairo, Egypt"` → `"cairo"`)
  /// 4. **Default to Cairo** if nothing matches — the geographic centre of Egypt
  ///
  /// [locationName] is the raw string from the backend `location` field.
  /// It may contain extra information such as `"Cairo, Egypt"` or
  /// `"Sharm El Sheikh, South Sinai"`.
  static LatLng getCoordinates(String? locationName) {
    if (locationName == null || locationName.isEmpty) {
      return _egyptCityCoordinates['cairo']!;
    }

    final normalized = locationName.toLowerCase().trim();

    // Pass 1: exact match (fastest path)
    if (_egyptCityCoordinates.containsKey(normalized)) {
      return _egyptCityCoordinates[normalized]!;
    }

    // Pass 2: partial / substring match
    // Iterates all entries and returns the first key found as a substring.
    for (final entry in _egyptCityCoordinates.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }

    // Pass 3: default fallback — Cairo
    return _egyptCityCoordinates['cairo']!;
  }
}
