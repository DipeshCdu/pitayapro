import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloweringEvent {
  final String id;
  final String variety;
  final String block;
  final String status; // Budding, Flowering, Harvested
  final double? brix;
  final String moonPhase;

  FloweringEvent({
    required this.id,
    required this.variety,
    required this.block,
    required this.status,
    this.brix,
    required this.moonPhase,
  });
}

final floweringListProvider = Provider<List<FloweringEvent>>((ref) {
  // Temporary dummy data
  return [
    FloweringEvent(
      id: '1',
      variety: 'Pink Dragon',
      block: 'Block A1 • Row 12',
      status: 'Budding',
      brix: 12.4,
      moonPhase: 'Waxing Crescent',
    ),
    FloweringEvent(
      id: '2',
      variety: 'American Beauty',
      block: 'Block B2 • Row 05',
      status: 'Flowering',
      brix: 14.8,
      moonPhase: 'Full Moon',
    ),
    FloweringEvent(
      id: '3',
      variety: 'Condor',
      block: 'Block A2 • Row 18',
      status: 'Harvested',
      brix: 16.2,
      moonPhase: 'Waning Gibbous',
    ),
    FloweringEvent(
      id: '4',
      variety: 'Vietnamese White',
      block: 'Block C1 • Row 08',
      status: 'Budding',
      brix: 11.7,
      moonPhase: 'Last Quarter',
    ),
    FloweringEvent(
      id: '5',
      variety: 'Sugar Dragon',
      block: 'Block B1 • Row 15',
      status: 'Flowering',
      brix: 13.9,
      moonPhase: 'Waning Crescent',
    ),
  ];
});