import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum EventStatus { budding, flowering, harvested }

class StatusChip extends StatelessWidget {
  final EventStatus status;
  final String label;

  const StatusChip({
    super.key,
    required this.status,
    required this.label,
  });

  Color _getBackgroundColor() {
    switch (status) {
      case EventStatus.budding:
        return AppColors.success.withOpacity(0.15); // Light green
      case EventStatus.flowering:
        return AppColors.primary; // Dark green
      case EventStatus.harvested:
        return AppColors.textSecondary.withOpacity(0.2); // Grey
    }
  }

  Color _getTextColor() {
    switch (status) {
      case EventStatus.budding:
        return AppColors.success;
      case EventStatus.flowering:
        return Colors.white;
      case EventStatus.harvested:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}