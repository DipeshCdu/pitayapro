import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/farm_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../flowering/presentation/providers/flowering_provider.dart';
import '../../providers/farm_provider.dart';

class FarmDashboardScreen extends ConsumerWidget {
  const FarmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmsAsync = ref.watch(farmsProvider);
    final floweringEvents = ref.watch(floweringListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'My Farm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.push('/my-farm/create'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(farmsProvider),
          ),
        ],
      ),
      body: farmsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(farmsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (farms) {
          if (farms.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.agriculture, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'No farms yet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create Work and Home sites (or any farm name).',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/my-farm/create'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add farm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${farms.length} farm${farms.length == 1 ? '' : 's'}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              ...farms.map((farm) => _FarmCard(farm: farm)),
              const SizedBox(height: 20),
              const Text(
                'Recent flowering',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (floweringEvents.isEmpty)
                const Text('No flowering events yet')
              else
                ...floweringEvents.take(3).map(
                      (e) => ListTile(
                        leading: const Icon(Icons.local_florist),
                        title: Text(e.varietyName),
                        subtitle: Text('${e.block} — ${e.row}'),
                        dense: true,
                      ),
                    ),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

class _FarmCard extends ConsumerWidget {
  final FarmModel farm;
  const _FarmCard({required this.farm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.15),
          child: const Icon(Icons.agriculture, color: AppColors.primary),
        ),
        title: Text(
          farm.farmName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          [
            if (farm.region != null && farm.region!.isNotEmpty) farm.region!,
            if (farm.address != null && farm.address!.isNotEmpty) farm.address!,
            if (farm.climateZone != null && farm.climateZone!.isNotEmpty)
              farm.climateZone!,
          ].join(' · '),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              context.push('/my-farm/edit/${farm.farmId}');
            } else if (value == 'delete') {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete farm?'),
                  content: Text('Delete "${farm.farmName}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                try {
                  await ref.read(farmActionsProvider).delete(farm.farmId);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$e'), backgroundColor: Colors.red),
                    );
                  }
                }
              }
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () => context.push('/my-farm/edit/${farm.farmId}'),
      ),
    );
  }
}