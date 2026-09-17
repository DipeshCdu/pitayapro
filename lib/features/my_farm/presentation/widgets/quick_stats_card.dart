import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/farm_provider.dart';

class QuickStatsCard extends StatelessWidget {
  final List<FarmStat> stats;

  const QuickStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              const Text('Quick Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(stat.icon, color: Color(int.parse(stat.iconColorHex)), size: 28),
                    const SizedBox(height: 8),
                    Text(stat.title, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    Text(stat.value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(stat.isPositive ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: AppColors.success),
                        Text(stat.change, style: TextStyle(fontSize: 10, color: AppColors.success)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}