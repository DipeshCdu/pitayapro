import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/soil_test_provider.dart';

class SoilTestDetailScreen extends ConsumerWidget {
  final String recordId;

  const SoilTestDetailScreen({super.key, required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(soilTestListProvider);
    final record = records.firstWhere(
      (r) => r.id == recordId,
      orElse: () => SoilTestRecord(
        id: '',
        block: 'Not Found',
        testDate: DateTime.now(),
        labName: '',
        overallStatus: NutrientStatus.optimal,
      ),
    );

    if (record.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Record not found')),
      );
    }

    final statusColor = _statusColor(record.overallStatus);
    final statusText = _statusText(record.overallStatus);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(record.block),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref, record),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.science, color: statusColor, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy').format(record.testDate),
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Basic info
          _sectionCard(
            title: 'Test Information',
            children: [
              _infoRow('Block', record.block),
              _infoRow('Lab', record.labName),
              _infoRow(
                'Date',
                DateFormat('dd MMM yyyy').format(record.testDate),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Nutrients
          _sectionCard(
            title: 'Nutrient Levels',
            children: [
              _infoRow('pH', record.ph?.toStringAsFixed(1) ?? '-'),
              _infoRow('Nitrogen (N)', record.nitrogen?.toStringAsFixed(1) ?? '-'),
              _infoRow('Phosphorus (P)', record.phosphorus?.toStringAsFixed(1) ?? '-'),
              _infoRow('Potassium (K)', record.potassium?.toStringAsFixed(1) ?? '-'),
              _infoRow(
                'Organic Matter',
                record.organicMatter != null
                    ? '${record.organicMatter!.toStringAsFixed(1)}%'
                    : '-',
              ),
            ],
          ),

          if (record.notes != null && record.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionCard(
              title: 'Notes / Recommendations',
              children: [
                Text(
                  record.notes!,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Color _statusColor(NutrientStatus status) {
    switch (status) {
      case NutrientStatus.optimal:
        return Colors.green;
      case NutrientStatus.warning:
        return Colors.orange;
      case NutrientStatus.deficient:
        return Colors.red;
    }
  }

  String _statusText(NutrientStatus status) {
    switch (status) {
      case NutrientStatus.optimal:
        return 'Optimal';
      case NutrientStatus.warning:
        return 'Warning';
      case NutrientStatus.deficient:
        return 'Deficient';
    }
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SoilTestRecord record,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Soil Test?'),
        content: Text('Delete test for "${record.block}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(soilTestListProvider.notifier).deleteRecord(record.id);
              Navigator.pop(context);
              context.pop();
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