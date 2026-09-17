import '../../../../core/widgets/status_chip.dart';

class FloweringEvent {
  final String id;
  final String varietyName;
  final String block;
  final String row;
  final EventStatus status;
  final double brixScore;
  final String moonPhase;
  final String? imageUrl; // Optional network image

  FloweringEvent({
    required this.id,
    required this.varietyName,
    required this.block,
    required this.row,
    required this.status,
    required this.brixScore,
    required this.moonPhase,
    this.imageUrl,
  });
}