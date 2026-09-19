import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/fertilising_provider.dart';

class FertilisingDetailScreen extends ConsumerWidget {
  final String recordId;

  const FertilisingDetailScreen({super.key, required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(fertilisingListProvider);
    final record = records.firstWhere(
      (r) => r.id == recordId,
      orElse: () => FertilisingRecord(
        id: '',
        fertiliserName: 'Not Found',
        block: '',
        applicationDate: DateTime.now(),
        quantityKg: 0,
        method: '',
      ),
    );

    if (record.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Record not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(record.fertiliserName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/inputs/edit/${record.id}'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref, record),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            title: 'Fertiliser Details',
            children: [
              _infoRow('Name', record.fertiliserName),
              _infoRow('Block / Location', record.block),
              _infoRow('Method', record.method),
              _infoRow(
                'Application Date',
                DateFormat('dd MMM yyyy').format(record.applicationDate),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Quantity & Cost',
            children: [
              _infoRow('Quantity', '${record.quantityKg} kg'),
              _infoRow(
                'Cost',
                record.cost != null ? '\$${record.cost!.toStringAsFixed(2)}' : '-',
              ),
            ],
          ),
          if (record.notes != null && record.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _sectionCard(
              title: 'Notes',
              children: [
                Text(
                  record.notes!,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ],
        ],
      ),
    );
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

  void _confirmDelete(BuildContext context, WidgetRef ref, FertilisingRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record?'),
        content: Text('Delete "${record.fertiliserName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(fertilisingListProvider.notifier).deleteRecord(record.id);
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