import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../flowering/presentation/providers/flowering_provider.dart';
import '../../../../core/theme/app_colors.dart';

class FarmDashboardScreen extends ConsumerWidget {
  const FarmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Removed authState dependency. We just use a hardcoded welcome for now.
    final floweringEvents = ref.watch(floweringListProvider);

    // Calculate real stats using CORRECT field names
    final totalFruitSet =
        floweringEvents.fold<int>(0, (sum, e) => sum + e.fruitSet);
    final avgBrix = floweringEvents.isEmpty
        ? 0.0
        : floweringEvents.fold<double>(0.0, (sum, e) => sum + e.brixScore) /
            floweringEvents.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'My Farm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // ✅ Removed the logout button for now
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Welcome Header (Hardcoded for now)
          Text(
            'Welcome back,',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const Text(
            'Grower', // ✅ Hardcoded instead of authState.email
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // 2. Quick Stats Grid
          Row(
            children: [
              _buildStatCard(
                'Active Events',
                '${floweringEvents.length}',
                Icons.eco,
                AppColors.primary,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Total Fruit',
                '$totalFruitSet',
                Icons.apple,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(
                'Avg Brix',
                '${avgBrix.toStringAsFixed(1)}°',
                Icons.water_drop,
                Colors.blue,
              ),
              const SizedBox(width: 12),
              _buildStatCard('Farm Blocks', '4', Icons.map, Colors.green),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Weather Widget (Mock for Sprint 3)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Weather',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '28°C • Partly Cloudy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '15mm rain in last 3 days',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Recent Flowering Events
          const Text(
            'Recent Flowering Events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...floweringEvents.take(3).map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.varietyName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${e.block} — ${e.row}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        e.flowerDate == null
                            ? 'Pending'
                            : '${e.flowerDate!.day}/${e.flowerDate!.month}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${e.fruitSet} 🍎',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 5. Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            context,
            'Add Flowering Event',
            Icons.add_circle,
            () => context.go('/flowering/add'),
          ),
          const SizedBox(height: 8),
          _buildActionCard(
            context,
            'View Farm Map',
            Icons.map,
            () => context.go('/my-farm/map'),
          ),
          const SizedBox(height: 8),
          _buildActionCard(context, 'Log Pruning', Icons.content_cut, () {}),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}