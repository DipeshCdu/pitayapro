import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'moon_phase_widget.dart';

class MoonPhaseTimeline extends StatelessWidget {
  final DateTime budDate;
  final DateTime? flowerDate;
  final DateTime? harvestDate;

  const MoonPhaseTimeline({
    super.key,
    required this.budDate,
    this.flowerDate,
    this.harvestDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.brightness_2, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Moon Phase Timeline',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStage('Bud', budDate),
              if (flowerDate != null) _buildStage('Flower', flowerDate!),
              if (harvestDate != null) _buildStage('Harvest', harvestDate!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStage(String label, DateTime date) {
    return Column(
      children: [
        MoonPhaseWidget(
          date: date,
          showDetails: false,
          size: 50,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          '${date.day}/${date.month}',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}