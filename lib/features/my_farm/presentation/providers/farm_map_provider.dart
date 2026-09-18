import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/farm_block_model.dart';

class FarmMapState {
  final List<FarmBlock> blocks;
  final FarmBlock? selectedBlock;

  FarmMapState({required this.blocks, this.selectedBlock});

  FarmMapState copyWith({List<FarmBlock>? blocks, FarmBlock? selectedBlock}) {
    return FarmMapState(
      blocks: blocks ?? this.blocks,
      selectedBlock: selectedBlock ?? this.selectedBlock,
    );
  }
}

class FarmMapNotifier extends StateNotifier<FarmMapState> {
  FarmMapNotifier() : super(FarmMapState(blocks: _mockBlocks));

  void selectBlock(FarmBlock block) {
    state = state.copyWith(selectedBlock: block);
  }

  void clearSelection() {
    state = state.copyWith(selectedBlock: null);
  }

  // Mock data representing actual GPS polygon boundaries
  static final List<FarmBlock> _mockBlocks = [
    FarmBlock(
      id: '1',
      name: 'Block A1',
      variety: 'Pink Dragon',
      areaHa: 0.35,
      plantCount: 560,
      color: const Color(0xFF2E7D32), // Deep Green
      boundary: [
        const LatLng(-12.4630, 130.8450),
        const LatLng(-12.4630, 130.8460),
        const LatLng(-12.4640, 130.8460),
        const LatLng(-12.4640, 130.8450),
      ],
    ),
    FarmBlock(
      id: '2',
      name: 'Block A2',
      variety: 'American Beauty',
      areaHa: 0.28,
      plantCount: 420,
      color: const Color(0xFF1565C0), // Blue
      boundary: [
        const LatLng(-12.4630, 130.8462),
        const LatLng(-12.4630, 130.8472),
        const LatLng(-12.4640, 130.8472),
        const LatLng(-12.4640, 130.8462),
      ],
    ),
    FarmBlock(
      id: '3',
      name: 'Block B1',
      variety: 'Sugar Dragon',
      areaHa: 0.32,
      plantCount: 510,
      color: const Color(0xFFE65100), // Orange
      boundary: [
        const LatLng(-12.4642, 130.8450),
        const LatLng(-12.4642, 130.8460),
        const LatLng(-12.4652, 130.8460),
        const LatLng(-12.4652, 130.8450),
      ],
    ),
  ];
}

final farmMapProvider = StateNotifierProvider<FarmMapNotifier, FarmMapState>((ref) {
  return FarmMapNotifier();
});