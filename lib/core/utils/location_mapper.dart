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
    'port said': LatLng(31.2653, 32.3019),
    'suez': LatLng(29.9668, 32.5498),
    'mansoura': LatLng(31.0409, 31.3785),
    'tanta': LatLng(30.7865, 31.0004),
    'asyut': LatLng(27.1783, 31.1859),
    'ismailia': LatLng(30.5965, 32.2715),
    'zagazig': LatLng(30.5877, 31.5020),
    'damietta': LatLng(31.4175, 31.8144),
    'minya': LatLng(28.0991, 30.7503),
    'beni suef': LatLng(29.0744, 31.0979),
    'qena': LatLng(26.1551, 32.7160),
    'sohag': LatLng(26.5570, 31.6948),
    'shibin el kom': LatLng(30.5503, 31.0096),
    'banha': LatLng(30.4591, 31.1850),
    'arish': LatLng(31.1316, 33.8033),
    'mallawi': LatLng(27.7303, 30.8418),
    'bilbeis': LatLng(30.4192, 31.5647),
    '10th of ramadan': LatLng(30.3014, 31.7511),
    'kafr el sheikh': LatLng(31.1107, 30.9388),
    'damanhur': LatLng(31.0379, 30.4691),
    'rosetta': LatLng(31.4012, 30.4164),
    'rashid': LatLng(31.4012, 30.4164),
    'mahalla el kubra': LatLng(30.9700, 31.1600),
    '6th of october': LatLng(29.9722, 30.9419),
    'new cairo': LatLng(30.0053, 31.4828),
    'helwan': LatLng(29.8408, 31.2982),
    'obour': LatLng(30.2289, 31.4811),
    'sheikh zayed': LatLng(30.0131, 30.9839),
    'kharga': LatLng(25.4390, 30.5480),
    'safaga': LatLng(26.7292, 33.9367),
    'quseir': LatLng(26.1039, 34.2764),
    'ras sudr': LatLng(29.5878, 32.7126),
    
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
