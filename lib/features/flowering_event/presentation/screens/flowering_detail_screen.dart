import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/flowering_event_model.dart';
import '../widgets/moon_phase_timeline.dart';
import '../providers/flowering_provider.dart'; // ✅ CRITICAL IMPORT

class FloweringDetailScreen extends ConsumerWidget {
  final String eventId;

  const FloweringDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ This is where we use the provider to get the data
    final event = ref.watch(floweringEventByIdProvider(eventId));

    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          title: const Text('Event Not Found'),
        ),
        body: const Center(
          child: Text('Flowering event not found.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Header Card
          _buildHeaderCard(event),
          const SizedBox(height: 16),

          // 2. Moon Phase Timeline
          MoonPhaseTimeline(
            budDate: event.budDate,
            flowerDate: event.flowerDate,
            harvestDate: event.harvestDate,
          ),
          const SizedBox(height: 16),

          // 3. Fruit Results (if harvested or has fruit set)
          if (event.status == EventStatus.harvested || event.fruitSet > 0) ...[
            _buildFruitResultsCard(event),
            const SizedBox(height: 16),
          ],

          // 4. Return on Fruit (ROI)
          if (event.estimatedReturn != null) ...[
            _buildROICard(event),
            const SizedBox(height: 16),
          ],

          // 5. Grower Notes
          if (event.growerNotes != null && event.growerNotes!.isNotEmpty) ...[
            _buildNotesCard(event),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderCard(FloweringEvent event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.varietyName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                '${event.block} • ${event.row}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Brix', '${event.brixScore}°', Icons.water_drop),
              _buildStatItem('Stage', _formatStatus(event.status), Icons.track_changes),
              _buildStatItem(
                'Pollination',
                event.pollinationMethod.split(' ')[0],
                Icons.touch_app,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildFruitResultsCard(FloweringEvent event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_basket, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Fruit Results',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultRow('Fruit Set', '${event.fruitSet}', Icons.check_circle),
          const SizedBox(height: 8),
          _buildResultRow('Fruit Aborted', '${event.fruitAborted}', Icons.cancel),
          if (event.fruitWeightKg != null) ...[
            const SizedBox(height: 8),
            _buildResultRow('Total Weight', '${event.fruitWeightKg} kg', Icons.scale),
          ],
          if (event.fleshColour != null) ...[
            const SizedBox(height: 8),
            _buildResultRow('Flesh Colour', event.fleshColour!, Icons.palette),
          ],
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildROICard(FloweringEvent event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.success, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Return on Fruit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildROIItem('Total Weight', '${event.fruitWeightKg} kg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildROIItem('Price/kg', '\$${event.salePricePerKg}'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Estimated Return',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  '\$${event.estimatedReturn!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildROIItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard(FloweringEvent event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Grower Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              event.growerNotes!,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatus(EventStatus status) {
    switch (status) {
      case EventStatus.budding:
        return 'Budding';
      case EventStatus.flowering:
        return 'Flowering';
      case EventStatus.harvested:
        return 'Harvested';
    }
  }
}