import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../flowering/presentation/providers/flowering_provider.dart';
import '../../../inputs/presentation/providers/fertilising_provider.dart';
import '../../../soil_tests/presentation/providers/soil_test_provider.dart';
import '../../../my_farm/presentation/providers/farm_map_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowering = ref.watch(floweringListProvider);
    final fertilising = ref.watch(fertilisingListProvider);
    final soilTests = ref.watch(soilTestListProvider);
    final blocks = ref.watch(farmMapProvider);

    // Flowering stats
    final totalFlowering = flowering.length;
    final harvested = flowering.where((e) => e.status == 'Harvested').length;
    final budding = flowering.where((e) => e.status == 'Budding').length;
    final floweringNow = flowering.where((e) => e.status == 'Flowering').length;

    final brixValues = flowering
        .where((e) => e.averageBrix != null)
        .map((e) => e.averageBrix!)
        .toList();
    final avgBrix = brixValues.isEmpty
        ? null
        : brixValues.reduce((a, b) => a + b) / brixValues.length;

    final totalReturn = flowering
        .where((e) => e.estimatedReturn != null)
        .fold<double>(0, (sum, e) => sum + e.estimatedReturn!);

    // Fertilising stats
    final totalFertiliserKg =
        fertilising.fold<double>(0, (sum, r) => sum + r.quantityKg);
    final totalFertiliserCost = fertilising
        .where((r) => r.cost != null)
        .fold<double>(0, (sum, r) => sum + r.cost!);

    // Soil stats
    final optimal =
        soilTests.where((s) => s.overallStatus.name == 'optimal').length;
    final warning =
        soilTests.where((s) => s.overallStatus.name == 'warning').length;
    final deficient =
        soilTests.where((s) => s.overallStatus.name == 'deficient').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Insights'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Farm Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Top summary row
          Row(
            children: [
              _statCard('Blocks', '${blocks.length}', Icons.map, Colors.teal),
              const SizedBox(width: 12),
              _statCard(
                'Flowering',
                '$totalFlowering',
                Icons.local_florist,
                Colors.pink,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard(
                'Fertiliser',
                '${fertilising.length}',
                Icons.grass,
                Colors.green,
              ),
              const SizedBox(width: 12),
              _statCard(
                'Soil Tests',
                '${soilTests.length}',
                Icons.science,
                Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            'Flowering Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _infoCard([
            _row('Budding', '$budding'),
            _row('Flowering', '$floweringNow'),
            _row('Harvested', '$harvested'),
            _row(
              'Average Brix',
              avgBrix != null ? '${avgBrix.toStringAsFixed(1)}°' : '-',
            ),
            _row(
              'Estimated Return',
              totalReturn > 0 ? '\$${totalReturn.toStringAsFixed(0)}' : '-',
            ),
          ]),

          const SizedBox(height: 24),
          const Text(
            'Fertilising Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _infoCard([
            _row('Total Applications', '${fertilising.length}'),
            _row('Total Quantity', '${totalFertiliserKg.toStringAsFixed(1)} kg'),
            _row(
              'Total Cost',
              totalFertiliserCost > 0
                  ? '\$${totalFertiliserCost.toStringAsFixed(0)}'
                  : '-',
            ),
          ]),

          const SizedBox(height: 24),
          const Text(
            'Soil Health',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _infoCard([
            _row('Optimal', '$optimal', valueColor: Colors.green),
            _row('Warning', '$warning', valueColor: Colors.orange),
            _row('Deficient', '$deficient', valueColor: Colors.red),
          ]),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_graph, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Insights update automatically when you add flowering, fertilising, or soil test records.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}