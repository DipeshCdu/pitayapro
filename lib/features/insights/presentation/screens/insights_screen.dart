import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitayapro/core/widgets/status_chip.dart';
import '../../../flowering/presentation/providers/flowering_provider.dart';
import '../../../flowering_event/data/models/flowering_event_model.dart';
import '../../../../core/theme/app_colors.dart';

class NutrientStatus {
  final String name;
  final double value;
  final double low;
  final double high;
  final String unit;

  NutrientStatus({
    required this.name,
    required this.value,
    required this.low,
    required this.high,
    required this.unit,
  });

  String get status {
    if (value < low) return 'Deficient';
    if (value > high) return 'Excess';
    return 'Optimal';
  }

  Color get statusColor {
    if (value < low) return Colors.red;
    if (value > high) return Colors.orange;
    return Colors.green;
  }
}

// Data from Jungle Jim leaf test PDF (FILE NO: 2505191646)
final List<NutrientStatus> mockLeafTest = [
  NutrientStatus(name: 'Nitrogen (N)', value: 0.61, low: 2.2, high: 3.0, unit: '%'),
  NutrientStatus(name: 'Phosphorus (P)', value: 0.64, low: 0.18, high: 0.25, unit: '%'),
  NutrientStatus(name: 'Potassium (K)', value: 1.52, low: 1.8, high: 3.0, unit: '%'),
  NutrientStatus(name: 'Sulphur (S)', value: 0.43, low: 0.25, high: 0.45, unit: '%'),
  NutrientStatus(name: 'Calcium (Ca)', value: 4.04, low: 2.0, high: 4.0, unit: '%'),
  NutrientStatus(name: 'Magnesium (Mg)', value: 1.4, low: 0.3, high: 0.7, unit: '%'),
  NutrientStatus(name: 'Iron (Fe)', value: 20, low: 80, high: 200, unit: 'ppm'),
  NutrientStatus(name: 'Manganese (Mn)', value: 74, low: 50, high: 400, unit: 'ppm'),
  NutrientStatus(name: 'Zinc (Zn)', value: 51, low: 15, high: 28, unit: 'ppm'),
  NutrientStatus(name: 'Copper (Cu)', value: 1.5, low: 10, high: 25, unit: 'ppm'),
  NutrientStatus(name: 'Boron (B)', value: 38, low: 30, high: 60, unit: 'ppm'),
];

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(floweringListProvider);

    // ✅ Calculate real stats using CORRECT field names and ENUM values
    final avgBrix = events.isEmpty
        ? 0.0
        : events.fold<double>(0.0, (sum, e) => sum + e.brixScore) / events.length;
    final totalFruit = events.fold<int>(0, (sum, e) => sum + e.fruitSet);
    
    // ✅ CORRECT ENUM VALUES: budding, flowering, harvested
    final buddingCount = events.where((e) => e.status == EventStatus.budding).length;
    final floweringCount = events.where((e) => e.status == EventStatus.flowering).length;
    final harvestedCount = events.where((e) => e.status == EventStatus.harvested).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Farm Insights',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Leaf Test Health (Jungle Jim PDF data)
          const Text(
            'Leaf Test Health (Latest)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...mockLeafTest.map((n) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(n.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '${n.value} ${n.unit} (Range: ${n.low}-${n.high})',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: n.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        n.status,
                        style: TextStyle(
                          color: n.statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),

          // 2. Flowering Performance (Calculated from Provider)
          const Text(
            'Flowering Performance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetric('Avg Brix', '${avgBrix.toStringAsFixed(1)}°', Icons.water_drop),
                    _buildMetric('Total Fruit', '$totalFruit', Icons.apple),
                    _buildMetric('Events', '${events.length}', Icons.eco),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Status Breakdown (using CORRECT enum comparisons)
          const Text(
            'Event Status Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildStatusRow('Budding', buddingCount, Colors.blue),
                _buildStatusRow('Flowering', floweringCount, Colors.purple),
                _buildStatusRow('Harvested', harvestedCount, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Agronomy Insights (Yana's Rules)
          const Text(
            'Agronomy Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInsightRow('💧', 'Rain Trigger', 'Flowers opened 3 days after 15mm rain (Oct 15).'),
                const SizedBox(height: 12),
                _buildInsightRow('🌱', 'Bud Estimation', 'Bud date is automatically calculated as 30 days prior to flowering.'),
                const SizedBox(height: 12),
                _buildInsightRow('🌙', 'Moon Phase', 'Track lunar cycles to optimize flowering timing.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildStatusRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text('$count', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }
}