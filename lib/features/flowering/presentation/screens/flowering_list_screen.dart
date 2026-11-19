import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../flowering_event/data/models/flowering_event_model.dart';
import '../providers/flowering_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart'; // ✅ Added Bottom Nav

// ✅ 1. MUST extend ConsumerWidget to use 'ref'
class FloweringListScreen extends ConsumerWidget {
  const FloweringListScreen({super.key});

  @override
  // ✅ 2. 'ref' is automatically provided here
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(floweringListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Flowering Events',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.go('/flowering/add'),
          ),
        ],
      ),
      body: events.isEmpty
          ? const Center(
              child: Text(
                'No flowering events yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                // ✅ 3. Pass 'ref' into the helper method
                return _buildEventCard(context, ref, events[index]);
              },
            ),
    bottomNavigationBar: const AppBottomNav(),    );
  }

  // ✅ 4. Add 'WidgetRef ref' to the method parameters
  Widget _buildEventCard(BuildContext context, WidgetRef ref, FloweringEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_florist, color: AppColors.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.varietyName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${event.block} — ${event.row}', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  ],
                ),
              ),
              
              // ✅ Edit Button
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primary, size: 22),
                onPressed: () => context.go('/flowering/edit/${event.id}'),
              ),
              
              // ✅ Delete Button (Now 'ref' is defined!)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                onPressed: () {
                  ref.read(floweringListProvider.notifier).removeEvent(event.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event deleted'), backgroundColor: Colors.red),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                event.flowerDate == null
                    ? 'Flowering: pending'
                    : 'Flowered: ${event.flowerDate!.day}/${event.flowerDate!.month}/${event.flowerDate!.year}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Text('${event.fruitSet} 🍎', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}