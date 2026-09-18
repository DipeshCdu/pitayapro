import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class FarmBlock {
  final String id;
  final String name;
  final List<LatLng> points;
  final Color color;

  FarmBlock({
    required this.id,
    required this.name,
    required this.points,
    required this.color,
  });
}

class FarmMapNotifier extends StateNotifier<List<FarmBlock>> {
  FarmMapNotifier() : super([]);

  void addBlock(FarmBlock block) {
    state = [...state, block];
  }

  void deleteBlock(String id) {
    state = state.where((block) => block.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

final farmMapProvider =
    StateNotifierProvider<FarmMapNotifier, List<FarmBlock>>((ref) {
  return FarmMapNotifier();
});