import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ✅ CORRECT IMPORT (3 levels up, then into flowering_event)
import '../../../flowering_event/data/models/flowering_event_model.dart';
import '../providers/flowering_provider.dart';
import '../../../../core/theme/app_colors.dart';

class FloweringListScreen extends ConsumerWidget {
  const FloweringListScreen({super.key});

  @override
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
                final event = events[index];
                return _buildEventCard(context, event);
              },
            ),
    );
  }

  Widget _buildEventCard(BuildContext context, FloweringEvent event) {
    return GestureDetector(
      onTap: () => context.go('/flowering/${event.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.varietyName,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                Text(
                  '${event.fruitSet} 🍎',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${event.block} — ${event.row}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}