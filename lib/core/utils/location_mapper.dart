import 'package:latlong2/latlong.dart';

class LocationMapper {
  /// A mapping of common Egyptian cities and tourist destinations to their coordinates.
  static List<String> get supportedCities => _egyptCityCoordinates.keys.toList();

  static const Map<String, LatLng> _egyptCityCoordinates = {
    'cairo': LatLng(30.0444, 31.2357),
    'giza': LatLng(29.9792, 31.1342),
    'alexandria': LatLng(31.2001, 29.9187),
    'luxor': LatLng(25.6872, 32.6396),
    'aswan': LatLng(24.0889, 32.8998),
    'hurghada': LatLng(27.2579, 33.8116),
    'sharm el sheikh': LatLng(27.9158, 34.3299),
    'dahab': LatLng(28.5096, 34.5132),
    'siwa': LatLng(29.2032, 25.5195),
    'fayoum': LatLng(29.3094, 30.8418),
    'marsa alam': LatLng(25.0657, 34.8914),
    'taba': LatLng(29.4936, 34.8967),
    'el gouna': LatLng(27.3941, 33.6782),
    'sahl hasheesh': LatLng(27.0561, 33.8906),
    'el alamein': LatLng(30.8358, 28.9542),
    'marsa matrouh': LatLng(31.3543, 27.2373),
    'nuweiba': LatLng(29.0042, 34.6542),
    'saint catherine': LatLng(28.5552, 33.9749),
    
    // Landmarks
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

  /// Returns coordinates for a given city name.
  /// If the city is not found, it returns Cairo as a default (center of Egypt).
  static LatLng getCoordinates(String? locationName) {
    if (locationName == null || locationName.isEmpty) {
      return _egyptCityCoordinates['cairo']!;
    }

    final normalized = locationName.toLowerCase().trim();
    
    // Direct match
    if (_egyptCityCoordinates.containsKey(normalized)) {
      return _egyptCityCoordinates[normalized]!;
    }

    // Partial match (e.g. "Cairo, Egypt" contains "cairo")
    for (final entry in _egyptCityCoordinates.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default to Cairo if no match found
    return _egyptCityCoordinates['cairo']!;
  }
}
