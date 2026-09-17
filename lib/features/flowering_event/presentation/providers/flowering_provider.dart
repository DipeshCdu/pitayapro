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
    brixScore: 12.4,
    moonPhase: 'Waxing Crescent',
  ),
  FloweringEvent(
    id: '2',
    varietyName: 'American Beauty',
    block: 'Block B2',
    row: 'Row 05',
    status: EventStatus.flowering,
    brixScore: 14.8,
    moonPhase: 'Full Moon',
  ),
  FloweringEvent(
    id: '3',
    varietyName: 'Condor',
    block: 'Block A2',
    row: 'Row 18',
    status: EventStatus.harvested,
    brixScore: 16.2,
    moonPhase: 'Waning Gibbous',
  ),
  FloweringEvent(
    id: '4',
    varietyName: 'Vietnamese White',
    block: 'Block C1',
    row: 'Row 08',
    status: EventStatus.budding,
    brixScore: 11.7,
    moonPhase: 'Last Quarter',
  ),
  FloweringEvent(
    id: '5',
    varietyName: 'Sugar Dragon',
    block: 'Block B1',
    row: 'Row 15',
    status: EventStatus.flowering,
    brixScore: 13.9,
    moonPhase: 'Waning Crescent',
  ),
];

// Provider to expose the list
final floweringEventsProvider = Provider<List<FloweringEvent>>((ref) {
  return mockFloweringEvents;
});