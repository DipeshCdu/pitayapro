import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/moon_phase_widget.dart';
import '../widgets/moon_phase_timeline.dart';
import '../../data/models/flowering_event_model.dart';
import '../../../../services/moon_phase_service.dart';

class FloweringDetailScreen extends StatelessWidget {
  final FloweringEvent event;

  const FloweringDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final budDate = DateTime.now().subtract(const Duration(days: 45));
    final flowerDate = DateTime.now().subtract(const Duration(days: 30));
    final harvestDate = DateTime.now();

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
          'Flowering Event Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Edit event
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          _buildHeaderCard(event),
          const SizedBox(height: 16),

          // Moon Phase Timeline
          MoonPhaseTimeline(
            budDate: budDate,
            flowerDate: flowerDate,
            harvestDate: harvestDate,
          ),
          const SizedBox(height: 16),

          // Event Details
          _buildDetailsCard(event, budDate, flowerDate),
          const SizedBox(height: 16),

          // Fruit Results
          _buildFruitResultsCard(),
          const SizedBox(height: 16),

          // ROI Card
          _buildROICard(),
          const SizedBox(height: 16),

          // Moon Phase Info
          _buildMoonPhaseInfoCard(budDate, flowerDate, harvestDate),
          const SizedBox(height: 16),

          // Grower Notes
          _buildNotesCard(),
          const SizedBox(height: 24),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add notes or photos
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_a_photo, color: Colors.white),
        label: const Text('Add Photo', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeaderCard(FloweringEvent event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_florist,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Brix', '${event.brixScore}°', Icons.water_drop),
              _buildStatItem('Stage', _getStageText(event.status), Icons.track_changes),
              _buildStatItem('Moon', event.moonPhase, Icons.brightness_2),
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
            fontSize: 18,
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

  Widget _buildDetailsCard(FloweringEvent event, DateTime budDate, DateTime flowerDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.event, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Event Timeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimelineRow('Budding Date', budDate, Icons.grass),
          const SizedBox(height: 12),
          _buildTimelineRow('Flowering Date', flowerDate, Icons.local_florist),
          const SizedBox(height: 12),
          _buildTimelineRow('Harvest Date', DateTime.now(), Icons.shopping_basket),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                Text(
                  '30 days from flower to harvest',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(String label, DateTime date, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          MoonPhaseService.getMoonPhaseIcon(date),
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _buildFruitResultsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
          _buildResultRow('Fruit Set', '5', Icons.check_circle),
          const SizedBox(height: 8),
          _buildResultRow('Fruit Aborted', '1', Icons.cancel),
          const SizedBox(height: 8),
          _buildResultRow('Weight', '2.5 kg', Icons.scale),
          const SizedBox(height: 8),
          _buildResultRow('Size', 'Large (350g avg)', Icons.straighten),
          const SizedBox(height: 8),
          _buildResultRow('Brix Reading', '14.8°', Icons.water_drop),
          const SizedBox(height: 8),
          _buildResultRow('Flesh Color', 'Deep Pink', Icons.palette),
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

  Widget _buildROICard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
                child: _buildROIItem('Total Weight', '2.5 kg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildROIItem('Price/kg', '\$15'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Return',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '\$37.50',
                  style: TextStyle(
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

  Widget _buildMoonPhaseInfoCard(DateTime budDate, DateTime flowerDate, DateTime harvestDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.brightness_2, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Moon Phase Analysis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMoonPhaseDetail('Bud Stage', budDate),
          const SizedBox(height: 12),
          _buildMoonPhaseDetail('Flowering', flowerDate),
          const SizedBox(height: 12),
          _buildMoonPhaseDetail('Harvest', harvestDate),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Flowering during Full Moon showed 15% better fruit set',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoonPhaseDetail(String stage, DateTime date) {
    final phaseName = MoonPhaseService.getMoonPhaseName(date);
    final icon = MoonPhaseService.getMoonPhaseIcon(date);
    final illumination = MoonPhaseService.getMoonIllumination(date);

    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stage,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                phaseName,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${illumination.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
            Text(
              'illuminated',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            child: const Text(
              'Good bud development after warm weather. Strong flowering response. Would recommend keeping this variety for propagation.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildTag('Keep Variety', Icons.check),
              _buildTag('High Brix', Icons.water_drop),
              _buildTag('Good Set', Icons.star),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  String _getStageText(dynamic status) {
    return status.toString().split('.').last;
  }
}