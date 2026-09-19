import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class FertilisingRecord {
  final String id;
  final String fertiliserName;
  final String block;
  final DateTime applicationDate;
  final double quantityKg;
  final String method; // Broadcast, Drip, Foliar
  final String? notes;
  final double? cost;

  FertilisingRecord({
    required this.id,
    required this.fertiliserName,
    required this.block,
    required this.applicationDate,
    required this.quantityKg,
    required this.method,
    this.notes,
    this.cost,
  });
}

class FertilisingNotifier extends StateNotifier<List<FertilisingRecord>> {
  FertilisingNotifier()
      : super([
          // Sample data
          FertilisingRecord(
            id: '1',
            fertiliserName: 'Organic Booster 12-24-12',
            block: 'Block A',
            applicationDate: DateTime.now().subtract(const Duration(days: 2)),
            quantityKg: 25,
            method: 'Drip',
            cost: 45,
          ),
          FertilisingRecord(
            id: '2',
            fertiliserName: 'Pitaya Special Mix',
            block: 'Block B',
            applicationDate: DateTime.now().subtract(const Duration(days: 7)),
            quantityKg: 40,
            method: 'Broadcast',
            cost: 80,
          ),
        ]);

  void addRecord(FertilisingRecord record) {
    state = [record, ...state];
  }

  void updateRecord(FertilisingRecord record) {
    state = [
      for (final r in state)
        if (r.id == record.id) record else r,
    ];
  }

  void deleteRecord(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}

final fertilisingListProvider =
    StateNotifierProvider<FertilisingNotifier, List<FertilisingRecord>>((ref) {
  return FertilisingNotifier();
});