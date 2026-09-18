import '../../../../core/widgets/status_chip.dart';

class FloweringEvent {
  final String id;
  final String varietyName;
  final String block;
  final String row;
  final EventStatus status;
  
  // Dates
  final DateTime budDate;
  final DateTime? flowerDate;
  final DateTime? harvestDate;
  
  // Pollination
  final String pollinationMethod; // e.g., 'Hand-pollinated', 'Self-pollinated'
  final String? pollenVariety;
  
  // Fruit Results
  final int fruitSet;
  final int fruitAborted;
  final double? fruitWeightKg; // Total weight
  final double brixScore;
  final String? fleshColour;
  
  // Return on Fruit (ROI)
  final double? salePricePerKg;
  
  // Moon Phase (Auto-calculated, but stored for quick access)
  final String moonPhaseAtFlowering;
  
  // Notes
  final String? growerNotes;

  FloweringEvent({
    required this.id,
    required this.varietyName,
    required this.block,
    required this.row,
    required this.status,
    required this.budDate,
    this.flowerDate,
    this.harvestDate,
    this.pollinationMethod = 'Unknown',
    this.pollenVariety,
    this.fruitSet = 0,
    this.fruitAborted = 0,
    this.fruitWeightKg,
    this.brixScore = 0.0,
    this.fleshColour,
    this.salePricePerKg,
    required this.moonPhaseAtFlowering,
    this.growerNotes,
  });

  // Helper to calculate days between dates
  int? get daysBudToFlower {
    if (flowerDate == null) return null;
    return flowerDate!.difference(budDate).inDays;
  }

  int? get daysFlowerToHarvest {
    if (harvestDate == null || flowerDate == null) return null;
    return harvestDate!.difference(flowerDate!).inDays;
  }

  double? get estimatedReturn {
    if (fruitWeightKg == null || salePricePerKg == null) return null;
    return fruitWeightKg! * salePricePerKg!;
  }
}