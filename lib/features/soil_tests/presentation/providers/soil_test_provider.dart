import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NutrientStatus { optimal, warning, deficient }

class SoilTestRecord {
  final String id;
  final String block;
  final DateTime testDate;
  final String labName;
  final double? ph;
  final double? nitrogen;
  final double? phosphorus;
  final double? potassium;
  final double? organicMatter;
  final NutrientStatus overallStatus;
  final String? notes;

  SoilTestRecord({
    required this.id,
    required this.block,
    required this.testDate,
    required this.labName,
    this.ph,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    this.organicMatter,
    required this.overallStatus,
    this.notes,
  });
}

class SoilTestNotifier extends StateNotifier<List<SoilTestRecord>> {
  SoilTestNotifier()
      : super([
          SoilTestRecord(
            id: '1',
            block: 'Block A',
            testDate: DateTime.now().subtract(const Duration(days: 15)),
            labName: 'NT Agri Lab',
            ph: 6.4,
            nitrogen: 28,
            phosphorus: 18,
            potassium: 145,
            organicMatter: 3.2,
            overallStatus: NutrientStatus.optimal,
          ),
          SoilTestRecord(
            id: '2',
            block: 'Block B',
            testDate: DateTime.now().subtract(const Duration(days: 40)),
            labName: 'NT Agri Lab',
            ph: 5.6,
            nitrogen: 12,
            phosphorus: 9,
            potassium: 95,
            organicMatter: 2.1,
            overallStatus: NutrientStatus.warning,
            notes: 'Low nitrogen and phosphorus. Recommend organic fertiliser.',
          ),
        ]);

  void addRecord(SoilTestRecord record) {
    state = [record, ...state];
  }

  void updateRecord(SoilTestRecord record) {
    state = [
      for (final r in state)
        if (r.id == record.id) record else r,
    ];
  }

  void deleteRecord(String id) {
    state = state.where((r) => r.id != id).toList();
  }
}

final soilTestListProvider =
    StateNotifierProvider<SoilTestNotifier, List<SoilTestRecord>>((ref) {
  return SoilTestNotifier();
});