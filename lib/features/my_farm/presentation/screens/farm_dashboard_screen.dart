import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../providers/farm_map_provider.dart';
import '../providers/farm_profile_provider.dart';
import '../widgets/weather_card.dart';
import '../../../flowering/presentation/providers/flowering_provider.dart';
import '../../../inputs/presentation/providers/fertilising_provider.dart';
import '../../../pruning/presentation/providers/pruning_provider.dart';
import '../../../soil_tests/presentation/providers/soil_test_provider.dart';

class ActivityItem {
  final String title;
  final String subtitle;
  final DateTime date;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.color,
  });
}

class FarmDashboardScreen extends ConsumerWidget {
  const FarmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farm = ref.watch(farmProfileProvider);
    final blocks = ref.watch(farmMapProvider);
    final flowering = ref.watch(floweringListProvider);
    final fertilising = ref.watch(fertilisingListProvider);
    final pruning = ref.watch(pruningListProvider);
    final soilTests = ref.watch(soilTestListProvider);

    // Quick stats
    final blocksCount = blocks.length;
    final floweringCount = flowering.length;
    final floweringNow =
        flowering.where((e) => e.status == 'Flowering').length;
    final harvestedCount =
        flowering.where((e) => e.status == 'Harvested').length;
    final fertiliserCount = fertilising.length;
    final pruningCount = pruning.length;
    final soilCount = soilTests.length;

    // Recent activity
    final activities = <ActivityItem>[];

    for (final e in flowering) {
      final date =
          e.harvestDate ?? e.floweringDate ?? e.buddingDate ?? DateTime.now();
      activities.add(
        ActivityItem(
          title: 'Flowering: ${e.variety}',
          subtitle: '${e.block} · ${e.status}',
          date: date,
          icon: Icons.local_florist,
          color: Colors.pink,
        ),
      );
    }

    for (final r in fertilising) {
      activities.add(
        ActivityItem(
          title: 'Fertiliser Applied',
          subtitle: '${r.fertiliserName} · ${r.block}',
          date: r.applicationDate,
          icon: Icons.grass,
          color: Colors.green,
        ),
      );
    }

    for (final r in pruning) {
      activities.add(
        ActivityItem(
          title: 'Pruning Done',
          subtitle: '${r.block} · ${r.pruningType}',
          date: r.pruningDate,
          icon: Icons.content_cut,
          color: Colors.orange,
        ),
      );
    }

    for (final r in soilTests) {
      activities.add(
        ActivityItem(
          title: 'Soil Test',
          subtitle: '${r.block} · ${r.overallStatus.name}',
          date: r.testDate,
          icon: Icons.science,
          color: Colors.blue,
        ),
      );
    }

    activities.sort((a, b) => b.date.compareTo(a.date));
    final recent = activities.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Text(
          'My Farm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => context.push('/my-farm/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFarmProfileCard(context, farm, blocksCount),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push('/my-farm/map'),
              icon: const Icon(Icons.map),
              label: const Text('View Farm Map'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const WeatherCard(),
          const SizedBox(height: 16),
          _buildInfrastructureCard(farm),
          const SizedBox(height: 16),
          _buildQuickStats(
            blocksCount: blocksCount,
            floweringCount: floweringCount,
            floweringNow: floweringNow,
            harvestedCount: harvestedCount,
            fertiliserCount: fertiliserCount,
            pruningCount: pruningCount,
            soilCount: soilCount,
          ),
          const SizedBox(height: 16),
          _buildQuickActions(context),
          const SizedBox(height: 16),
          _buildRecentActivity(recent),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  // ====================== PROFILE ======================
  Widget _buildFarmProfileCard(
    BuildContext context,
    FarmProfile farm,
    int blocksCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.cardGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farm.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 15, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            farm.address,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  farm.cropType,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoItem(Icons.person, 'Owner', farm.owner),
              _infoItem(Icons.landscape, 'Climate', farm.climateZone),
              GestureDetector(
                onTap: () => context.push('/my-farm/blocks'),
                child: _infoItem(Icons.map, 'Blocks', '$blocksCount'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ====================== INFRASTRUCTURE ======================
  Widget _buildInfrastructureCard(FarmProfile farm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Infrastructure',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _infraChip(Icons.wb_sunny, farm.growingSystem),
              _infraChip(Icons.grid_view, farm.trellisSystem),
              _infraChip(Icons.water_drop, farm.irrigationSystem),
              _infraChip(Icons.grass, farm.soilType),
              _infraChip(Icons.layers, farm.mulchType),
            ],
          ),
          if (farm.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              farm.notes,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infraChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ====================== QUICK STATS (DYNAMIC) ======================
  Widget _buildQuickStats({
    required int blocksCount,
    required int floweringCount,
    required int floweringNow,
    required int harvestedCount,
    required int fertiliserCount,
    required int pruningCount,
    required int soilCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Quick Stats',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statCard('Blocks', '$blocksCount', Icons.map, Colors.teal),
              const SizedBox(width: 12),
              _statCard(
                'Flowering',
                '$floweringCount',
                Icons.local_florist,
                Colors.pink,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('In Flower', '$floweringNow', Icons.spa, Colors.orange),
              const SizedBox(width: 12),
              _statCard(
                'Harvested',
                '$harvestedCount',
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard(
                'Fertiliser',
                '$fertiliserCount',
                Icons.grass,
                Colors.lightGreen,
              ),
              const SizedBox(width: 12),
              _statCard(
                'Pruning',
                '$pruningCount',
                Icons.content_cut,
                Colors.brown,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('Soil Tests', '$soilCount', Icons.science, Colors.blue),
              const SizedBox(width: 12),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // ====================== QUICK ACTIONS ======================
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _actionButton(
              context,
              icon: Icons.local_florist,
              label: 'Flowering',
              color: Colors.pink,
              onTap: () => context.go('/flowering'),
            ),
            const SizedBox(width: 12),
            _actionButton(
              context,
              icon: Icons.grass,
              label: 'Fertilising',
              color: Colors.green,
              onTap: () => context.go('/inputs'),
            ),
            const SizedBox(width: 12),
            _actionButton(
              context,
              icon: Icons.science,
              label: 'Soil Test',
              color: Colors.blue,
              onTap: () => context.go('/soil-tests'),
            ),
            const SizedBox(width: 12),
            _actionButton(
              context,
              icon: Icons.content_cut,
              label: 'Pruning',
              color: Colors.orange,
              onTap: () => context.go('/pruning'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================== RECENT ACTIVITY (DYNAMIC) ======================
  Widget _buildRecentActivity(List<ActivityItem> recent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No activity yet. Add flowering, fertilising, pruning, or soil tests.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            )
          else
            ...recent.map(_activityRow),
        ],
      ),
    );
  }

  Widget _activityRow(ActivityItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(item.date),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}