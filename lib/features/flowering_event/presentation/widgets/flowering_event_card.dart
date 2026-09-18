import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/flowering_event_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../services/moon_phase_service.dart';

class FloweringEventCard extends StatelessWidget {
  final FloweringEvent event;

  const FloweringEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/flowering/${event.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: Visual Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_florist, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),

            // Middle: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.varietyName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${event.block} • ${event.row}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StatusChip(status: event.status, label: _formatStatus(event.status)),
                      const SizedBox(width: 8),
                      if (event.daysBudToFlower != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                          child: Text('${event.daysBudToFlower} days to flower', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Right: Brix & Moon Phase
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Brix', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                Text('${event.brixScore}°', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.success)),
                const SizedBox(height: 8),
                
                // ✅ Moon Phase Visual (Emoji)
                Text(
                  MoonPhaseService.getMoonPhaseIcon(event.flowerDate ?? DateTime.now()),
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 2),
                Text(
                  event.moonPhaseAtFlowering,
                  style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(EventStatus status) {
    switch (status) {
      case EventStatus.budding: return 'Budding';
      case EventStatus.flowering: return 'Flowering';
      case EventStatus.harvested: return 'Harvested';
    }
  }
}