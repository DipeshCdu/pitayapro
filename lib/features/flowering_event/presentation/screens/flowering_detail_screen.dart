import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../flowering/presentation/providers/flowering_provider.dart';
import '../../data/models/flowering_event_model.dart';
import '../../../../core/theme/app_colors.dart';

class FloweringDetailScreen extends ConsumerWidget {
  final String eventId;
  const FloweringDetailScreen({super.key, required this.eventId});

  String _fmt(DateTime? d) =>
      d == null ? '—' : '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(floweringListProvider);
    final match = events.where((e) => e.id == eventId).toList();

    if (match.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          title: const Text('Not Found', style: TextStyle(color: Colors.white)),
        ),
        body: const Center(child: Text('This flowering event no longer exists.')),
      );
    }

    final e = match.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(e.varietyName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section('Location', '${e.block} — ${e.row}'),
          _section('Variety', e.varietyName),
          _section('Status', e.status.name),
          _section('Bud Date', _fmt(e.budDate)),
          _section('Flowering Date', _fmt(e.flowerDate)),
          _section('Moon Phase', e.moonPhaseAtFlowering),
          _section('Pollination',
              '${e.pollinationMethod}${e.pollenVariety != null ? ' (${e.pollenVariety})' : ''}'),
          _section('Fruit Set', '${e.fruitSet}'),
          _section('Brix', '${e.brixScore}°'),
          _section('Fruit Weight',
              e.fruitWeightKg != null ? '${e.fruitWeightKg} kg' : '—'),
          _section('Notes', e.growerNotes ?? '—'),
        ],
      ),
    );
  }

  Widget _section(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}