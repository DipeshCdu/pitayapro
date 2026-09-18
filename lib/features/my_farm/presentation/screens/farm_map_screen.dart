import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/farm_map_provider.dart';

class FarmMapScreen extends ConsumerStatefulWidget {
  const FarmMapScreen({super.key});

  @override
  ConsumerState<FarmMapScreen> createState() => _FarmMapScreenState();
}

class _FarmMapScreenState extends ConsumerState<FarmMapScreen> {
  final LatLng _farmCenter = const LatLng(-12.4634, 130.8456);
  final MapController _mapController = MapController();

  final List<LatLng> _currentPoints = [];
  bool _isDrawing = false;

  final List<Color> _availableColors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
  ];

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (!_isDrawing) return;
    setState(() {
      _currentPoints.add(point);
    });
  }

  void _startDrawing() {
    setState(() {
      _isDrawing = true;
      _currentPoints.clear();
    });
  }

  void _cancelDrawing() {
    setState(() {
      _isDrawing = false;
      _currentPoints.clear();
    });
  }

  void _finishDrawing() {
    if (_currentPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need at least 3 points to create a land block')),
      );
      return;
    }
    _showSaveBlockDialog();
  }

  void _showSaveBlockDialog() {
    final nameController = TextEditingController();
    Color selectedColor = _availableColors[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Save Land Block'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Block Name (e.g. Block A)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select Color'),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: _availableColors.map((color) {
                      final isSelected = selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => selectedColor = color);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 3)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _cancelDrawing();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final newBlock = FarmBlock(
                      id: const Uuid().v4(),
                      name: name,
                      points: List<LatLng>.from(_currentPoints),
                      color: selectedColor,
                    );

                    ref.read(farmMapProvider.notifier).addBlock(newBlock);

                    setState(() {
                      _isDrawing = false;
                      _currentPoints.clear();
                    });

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(FarmBlock block) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Block?'),
        content: Text('Are you sure you want to delete "${block.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(farmMapProvider.notifier).deleteBlock(block.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blocks = ref.watch(farmMapProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text('Farm Map (${blocks.length} blocks)'),
        actions: [
          if (_isDrawing) ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancelDrawing,
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _finishDrawing,
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () => _mapController.move(_farmCenter, 16),
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _farmCenter,
              initialZoom: 16,
              minZoom: 12,
              maxZoom: 19,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.pitayapro.app',
              ),

              // Saved polygons
              PolygonLayer(
                polygons: blocks.map((block) {
                  return Polygon(
                    points: block.points,
                    color: block.color.withOpacity(0.35),
                    borderColor: block.color,
                    borderStrokeWidth: 3,
                  );
                }).toList(),
              ),

              // Drawing polygon
              if (_currentPoints.length >= 2)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _currentPoints,
                      color: Colors.blue.withOpacity(0.25),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),

              // Drawing points
              if (_currentPoints.isNotEmpty)
                MarkerLayer(
                  markers: _currentPoints.map((point) {
                    return Marker(
                      point: point,
                      width: 16,
                      height: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              // Block labels (tap to delete)
              MarkerLayer(
                markers: blocks.map((block) {
                  final center = LatLng(
                    block.points.map((p) => p.latitude).reduce((a, b) => a + b) /
                        block.points.length,
                    block.points.map((p) => p.longitude).reduce((a, b) => a + b) /
                        block.points.length,
                  );

                  return Marker(
                    point: center,
                    width: 110,
                    height: 36,
                    child: GestureDetector(
                      onLongPress: () => _confirmDelete(block),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            block.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Instruction
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                _isDrawing
                    ? 'Tap to add points. Press ✓ when finished. Long press label to delete.'
                    : 'Press "Draw Land" to create a new block. Long press name to delete.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isDrawing
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              onPressed: _startDrawing,
              icon: const Icon(Icons.pentagon, color: Colors.white),
              label: const Text('Draw Land', style: TextStyle(color: Colors.white)),
            ),
    );
  }
}