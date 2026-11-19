import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitayapro/core/widgets/status_chip.dart';
import '../../../flowering_event/data/models/flowering_event_model.dart';

final List<FloweringEvent> mockFloweringEvents = [
  FloweringEvent(
    id: '1',
    varietyName: 'Pink Dragon',
    block: 'Work',
    row: 'Row 1',
    status: EventStatus.flowering,
    budDate: DateTime.now().subtract(const Duration(days: 30)),
    flowerDate: DateTime.now(),
    pollinationMethod: 'Hand-pollinated',
    pollenVariety: 'American Beauty',
    fruitSet: 2,
    brixScore: 12.4,
    salePricePerKg: 15.0,
    moonPhaseAtFlowering: 'Waxing Crescent',
    growerNotes: 'First flower opened at night',
  ),
];

class FloweringListNotifier extends StateNotifier<List<FloweringEvent>> {
  FloweringListNotifier() : super(mockFloweringEvents);

  void addEvent(FloweringEvent event) => state = [event, ...state];

  // ✅ ADDED: Method to update an existing event
  void updateEvent(FloweringEvent updatedEvent) {
    state = [
      for (final e in state)
        if (e.id == updatedEvent.id) updatedEvent else e,
    ];
  }

  void removeEvent(String id) =>
      state = state.where((e) => e.id != id).toList();
}

final floweringListProvider =
    StateNotifierProvider<FloweringListNotifier, List<FloweringEvent>>(
  (ref) => FloweringListNotifier(),
);