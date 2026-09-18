import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/farm_map_provider.dart';
import '../widgets/block_details_sheet.dart';

class FarmMapScreen extends ConsumerWidget {
  const FarmMapScreen({super.key});

  // Helper function to check if a tapped point is inside a polygon
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j = polygon.length - 1;
    bool oddNodes = false;
    for (i = 0; i < polygon.length; i++) {
      if ((polygon[i].latitude < point.latitude && polygon[j].latitude >= point.latitude) ||
          (polygon[j].latitude < point.latitude && polygon[i].latitude >= point.latitude)) {
        if (polygon[i].longitude + (point.latitude - polygon[i].latitude) / (polygon[j].latitude - polygon[i].latitude) * (polygon[j].longitude - polygon[i].longitude) < point.longitude) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }
    return oddNodes;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(farmMapProvider);
    final mapNotifier = ref.read(farmMapProvider.notifier);

    // Auto-open bottom sheet when a block is selected
    if (mapState.selectedBlock != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BlockDetailsSheet(block: mapState.selectedBlock!),
        ).then((_) => mapNotifier.clearSelection());
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Farm Map',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () {
              // TODO: Implement real GPS location
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(-12.4640, 130.8460), // Center of mock blocks
          initialZoom: 17.0,
          // ✅ FIX: Handle taps on the map to detect polygon clicks
          onTap: (tapPosition, point) {
            bool tappedBlock = false;
            for (var block in mapState.blocks) {
              if (_isPointInPolygon(point, block.boundary)) {
                mapNotifier.selectBlock(block);
                tappedBlock = true;
                break;
              }
            }
            if (!tappedBlock) {
              mapNotifier.clearSelection();
            }
          },
        ),
        children: [
          // 1. OpenStreetMap Tile Layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.pitayapro.app',
          ),

          // 2. Polygon Boundaries (Removed onTap from here)
          PolygonLayer(
            polygons: mapState.blocks.map((block) {
              return Polygon(
                points: block.boundary,
                color: block.color.withOpacity(0.3), // Semi-transparent fill
                borderColor: block.color,
                borderStrokeWidth: 3.0,
                isFilled: true,
              );
            }).toList(),
          ),

          // 3. Center Labels for Blocks
          MarkerLayer(
            markers: mapState.blocks.map((block) {
              return Marker(
                width: 80,
                height: 40,
                point: block.center,
                child: IgnorePointer( // Let taps pass through to the polygon
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                    ),
                    child: Text(
                      block.name,
                      style: TextStyle(
                        color: block.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to Add Block Screen
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text('Add Block', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}