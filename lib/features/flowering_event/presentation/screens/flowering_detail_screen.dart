import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pitayapro/features/flowering/presentation/providers/flowering_provider.dart';

import '../../../../core/theme/app_colors.dart';

class FloweringDetailScreen extends ConsumerWidget {
  final String eventId;

  const FloweringDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(floweringListProvider);
    final event = events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => FloweringEvent(
        id: '',
        variety: 'Not Found',
        block: '',
        status: '',
      ),
    );

    if (event.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Event not found')),
      );
    }

    Color statusColor;
    switch (event.status) {
      case 'Budding':
        statusColor = Colors.orange;
        break;
      case 'Flowering':
        statusColor = Colors.green;
        break;
      case 'Harvested':
        statusColor = Colors.blueGrey;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(event.variety),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref, event),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (event.averageBrix != null)
                  Text(
                    '${event.averageBrix}° Brix',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Basic Info
          _sectionCard(
            title: 'Basic Information',
            children: [
              _infoRow('Variety', event.variety),
              _infoRow('Block / Location', event.block),
              if (event.moonPhase != null) _infoRow('Moon Phase', event.moonPhase!),
            ],
          ),

          const SizedBox(height: 12),

          // Dates
          _sectionCard(
            title: 'Dates',
            children: [
              _infoRow('Budding Date', _formatDate(event.buddingDate)),
              _infoRow('Flowering Date', _formatDate(event.floweringDate)),
              _infoRow('Harvest Date', _formatDate(event.harvestDate)),
            ],
          ),

          const SizedBox(height: 12),

          // Pollination
          _sectionCard(
            title: 'Pollination',
            children: [
              _infoRow('Method', event.pollinationMethod ?? '-'),
              _infoRow('Pollen Variety', event.pollenVariety ?? '-'),
            ],
          ),

          const SizedBox(height: 12),

          // Fruit Results
          _sectionCard(
            title: 'Fruit Results',
            children: [
              _infoRow('Fruit Set', event.fruitSet?.toString() ?? '-'),
              _infoRow('Fruit Aborted', event.fruitAborted?.toString() ?? '-'),
              _infoRow('Total Weight', event.totalWeightKg != null ? '${event.totalWeightKg} kg' : '-'),
              _infoRow('Average Brix', event.averageBrix != null ? '${event.averageBrix}°' : '-'),
              _infoRow('Sale Price / kg', event.salePricePerKg != null ? '\$${event.salePricePerKg}' : '-'),
              if (event.estimatedReturn != null)
                _infoRow(
                  'Estimated Return',
                  '\$${event.estimatedReturn!.toStringAsFixed(2)}',
                  isHighlight: true,
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Notes
          if (event.notes != null && event.notes!.isNotEmpty)
            _sectionCard(
              title: 'Grower Notes',
              children: [
                Text(
                  event.notes!,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy').format(date);
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              fontSize: isHighlight ? 16 : 14,
              color: isHighlight ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, FloweringEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        content: Text('Are you sure you want to delete "${event.variety}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(floweringListProvider.notifier).deleteEvent(event.id);
              Navigator.pop(context); // close dialog
              context.pop(); // go back to list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}