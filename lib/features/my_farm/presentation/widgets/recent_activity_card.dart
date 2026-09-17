import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/farm_provider.dart';

class RecentActivityCard extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivityCard({super.key, required this.activities});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('View All >', style: TextStyle(color: AppColors.primary))),
            ],
          ),
          const SizedBox(height: 12),
          ...activities.map((activity) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Color(int.parse(activity.colorHex)).withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(activity.icon, color: Color(int.parse(activity.colorHex)), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                      Text(activity.subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text(activity.time, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}