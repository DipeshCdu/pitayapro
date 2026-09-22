import 'package:flutter_riverpod/flutter_riverpod.dart';

class PruningRecord {
  final String id;
  final String block;
  final DateTime pruningDate;
  final String pruningType; // Light, Heavy, Formative, Maintenance
  final double? greenWasteKg;
  final double? greenWasteVolumeM3;
  final String? method; // Manual, Mechanical
  final String? notes;
  final double? estimatedNutrientExport; // simple optional number

  PruningRecord({
    required this.id,
    required this.block,
    required this.pruningDate,
    required this.pruningType,
    this.greenWasteKg,
    this.greenWasteVolumeM3,
    this.method,
    this.notes,
    this.estimatedNutrientExport,
  });
}

class PruningNotifier extends StateNotifier<List<PruningRecord>> {
  PruningNotifier()
      : super([
          PruningRecord(
            id: '1',
            block: 'Block A',
            pruningDate: DateTime.now().subtract(const Duration(days: 5)),
            pruningType: 'Maintenance',
            greenWasteKg: 120,
            greenWasteVolumeM3: 0.8,
            method: 'Manual',
            notes: 'Removed old unproductive stems',
            estimatedNutrientExport: 3.5,
          ),
          PruningRecord(
            id: '2',
            block: 'Block B',
            pruningDate: DateTime.now().subtract(const Duration(days: 20)),
            pruningType: 'Heavy',
            greenWasteKg: 250,
            method: 'Mechanical',
            estimatedNutrientExport: 7.2,
          ),
        ]);

  void addRecord(PruningRecord record) {
    state = [record, ...state];
  }

  void updateRecord(PruningRecord record) {
    state = [
      for (final r in state)
        if (r.id == record.id) record else r,
    ];
  }

  void deleteRecord(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}

final pruningListProvider =
    StateNotifierProvider<PruningNotifier, List<PruningRecord>>((ref) {
  return PruningNotifier();
});