import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/flowering_event_model.dart';
import '../../../../core/widgets/status_chip.dart';

// Mock data to populate the UI
final List<FloweringEvent> mockFloweringEvents = [
  FloweringEvent(
    id: '1',
    varietyName: 'Pink Dragon',
    block: 'Block A1',
    row: 'Row 12',
    status: EventStatus.budding,
    budDate: DateTime.now().subtract(const Duration(days: 45)),
    flowerDate: null,
    harvestDate: null,
    pollinationMethod: 'Hand-pollinated',
    pollenVariety: 'American Beauty',
    fruitSet: 0,
    fruitAborted: 0,
    fruitWeightKg: null,
    brixScore: 12.4,
    fleshColour: null,
    salePricePerKg: 15.0,
    moonPhaseAtFlowering: 'Waxing Crescent',
    growerNotes: 'Good bud development after warm weather.',
  ),
  FloweringEvent(
    id: '2',
    varietyName: 'American Beauty',
    block: 'Block B2',
    row: 'Row 05',
    status: EventStatus.flowering,
    budDate: DateTime.now().subtract(const Duration(days: 60)),
    flowerDate: DateTime.now().subtract(const Duration(days: 30)),
    harvestDate: null,
    pollinationMethod: 'Self-pollinated',
    pollenVariety: null,
    fruitSet: 3,
    fruitAborted: 1,
    fruitWeightKg: null,
    brixScore: 14.8,
    fleshColour: 'Deep Pink',
    salePricePerKg: 15.0,
    moonPhaseAtFlowering: 'Full Moon',
    growerNotes: 'Strong flowering response. Excellent fruit set.',
  ),
  FloweringEvent(
    id: '3',
    varietyName: 'Condor',
    block: 'Block A2',
    row: 'Row 18',
    status: EventStatus.harvested,
    budDate: DateTime.now().subtract(const Duration(days: 90)),
    flowerDate: DateTime.now().subtract(const Duration(days: 60)),
    harvestDate: DateTime.now().subtract(const Duration(days: 30)),
    pollinationMethod: 'Hand-pollinated',
    pollenVariety: 'Pink Dragon',
    fruitSet: 5,
    fruitAborted: 1,
    fruitWeightKg: 2.5,
    brixScore: 16.2,
    fleshColour: 'Red',
    salePricePerKg: 15.0,
    moonPhaseAtFlowering: 'Waning Gibbous',
    growerNotes: 'Excellent variety. High Brix and good yield.',
  ),
];

// 1. Provider to expose the list
final floweringEventsProvider = Provider<List<FloweringEvent>>((ref) {
  return mockFloweringEvents;
});

// 2. Provider to get a single event by ID (This is what the detail screen uses)
final floweringEventByIdProvider = Provider.family<FloweringEvent?, String>((ref, id) {
  final events = ref.watch(floweringEventsProvider);
  return events.where((e) => e.id == id).firstOrNull;
});