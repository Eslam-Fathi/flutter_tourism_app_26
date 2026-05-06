import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/location_mapper.dart';

class ServiceLocationMap extends StatelessWidget {
  final String locationName;
  final String? title;
  final double height;

  const ServiceLocationMap({
    super.key,
    required this.locationName,
    this.title,
    this.height = 200,
  });

  Future<void> _openExternalMap(LatLng coordinates) async {
    final googleUrl = 'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}';
    final appleUrl = 'https://maps.apple.com/?q=${coordinates.latitude},${coordinates.longitude}';
    
    final uri = Uri.parse(googleUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback for iOS
      final appleUri = Uri.parse(appleUrl);
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coordinates = LocationMapper.getCoordinates(locationName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.map,
                  size: 20,
                  color: isDark ? Colors.white70 : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textBody,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => _openExternalMap(coordinates),
              icon: const Icon(LucideIcons.externalLink, size: 14),
              label: const Text('Open Maps', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: height,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: coordinates,
                initialZoom: 13,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.seyaha.tourism_app',
                  tileProvider: CancellableNetworkTileProvider(),
                  // Applying a dark filter if in dark mode
                  tileBuilder: isDark 
                    ? (context, tileWidget, tile) {
                        return ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            -0.21, -0.72, -0.07, 0, 255,
                            -0.21, -0.72, -0.07, 0, 255,
                            -0.21, -0.72, -0.07, 0, 255,
                            0, 0, 0, 1, 0,
                          ]),
                          child: tileWidget,
                        );
                      }
                    : null,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: coordinates,
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              title ?? locationName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            LucideIcons.mapPin,
                            color: AppColors.primary,
                            size: 35,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(LucideIcons.navigation, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                locationName,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
