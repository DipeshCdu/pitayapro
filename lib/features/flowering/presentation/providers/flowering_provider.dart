import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class FloweringEvent {
  final String id;
  final String variety;
  final String block;
  final String status; // Budding, Flowering, Harvested
  final DateTime? buddingDate;
  final DateTime? floweringDate;
  final DateTime? harvestDate;
  final String? pollinationMethod;
  final String? pollenVariety;
  final int? fruitSet;
  final int? fruitAborted;
  final double? totalWeightKg;
  final double? averageBrix;
  final double? salePricePerKg;
  final String? notes;
  final String? moonPhase;

  FloweringEvent({
    required this.id,
    required this.variety,
    required this.block,
    required this.status,
    this.buddingDate,
    this.floweringDate,
    this.harvestDate,
    this.pollinationMethod,
    this.pollenVariety,
    this.fruitSet,
    this.fruitAborted,
    this.totalWeightKg,
    this.averageBrix,
    this.salePricePerKg,
    this.notes,
    this.moonPhase,
  });

  double? get estimatedReturn {
    if (totalWeightKg == null || salePricePerKg == null) return null;
    return totalWeightKg! * salePricePerKg!;
  }
}

class FloweringNotifier extends StateNotifier<List<FloweringEvent>> {
  FloweringNotifier()
      : super([
          // Sample data
          FloweringEvent(
            id: '1',
            variety: 'Pink Dragon',
            block: 'Block A',
            status: 'Budding',
            averageBrix: 12.4,
            moonPhase: 'Waxing Crescent',
          ),
          FloweringEvent(
            id: '2',
            variety: 'American Beauty',
            block: 'Block B',
            status: 'Flowering',
            averageBrix: 14.8,
            moonPhase: 'Full Moon',
          ),
          FloweringEvent(
            id: '3',
            variety: 'Condor',
            block: 'Block A',
            status: 'Harvested',
            averageBrix: 16.2,
            totalWeightKg: 12.5,
            salePricePerKg: 15,
            moonPhase: 'Waning Gibbous',
          ),
        ]);

  void addEvent(FloweringEvent event) {
    state = [event, ...state];
  }

  void updateEvent(FloweringEvent event) {
    state = [
      for (final e in state)
        if (e.id == event.id) event else e,
    ];
  }

  void deleteEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final floweringListProvider =
    StateNotifierProvider<FloweringNotifier, List<FloweringEvent>>((ref) {
  return FloweringNotifier();
});