import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/farm_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/recent_activity_card.dart';
import '../../../../core/theme/app_colors.dart';

class FarmDashboardScreen extends ConsumerWidget {
  const FarmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(farmDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.white),
        title: const Text('My Farm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
           IconButton(
    icon: const Icon(Icons.edit, color: Colors.white),
    onPressed: () => context.go('/my-farm/create'),
  ),
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farm Header
            Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: AppColors.cardGreen, shape: BoxShape.circle),
                  child: const Icon(Icons.agriculture, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(data.farmName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const Icon(Icons.chevron_right, size: 20),
                      ]),
                      Row(children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(data.location, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ]),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.cardGreen, borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    const Icon(Icons.eco, color: AppColors.success, size: 16),
                    const SizedBox(width: 4),
                    const Text('Dragon Fruit', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 12)),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Widgets
            WeatherCard(weather: data.weather),
            const SizedBox(height: 16),
            QuickStatsCard(stats: data.stats),
            const SizedBox(height: 16),
            RecentActivityCard(activities: data.activities),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
      child: BottomNavigationBar(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // My Farm is active
        onTap: (index) {
          if (index == 1) context.go('/flowering');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My Farm'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Flowering'),
          BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Inputs'),
          BottomNavigationBarItem(icon: Icon(Icons.biotech), label: 'Soil Tests'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
        ],
      ),
    );
  }
}