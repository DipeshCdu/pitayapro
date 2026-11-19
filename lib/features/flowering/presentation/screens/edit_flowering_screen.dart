import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pitayapro/core/widgets/status_chip.dart';

import '../../../flowering_event/data/models/flowering_event_model.dart';
import '../providers/flowering_provider.dart';
import '../../../../core/theme/app_colors.dart';

class EditFloweringScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EditFloweringScreen({super.key, required this.eventId});

  @override
  ConsumerState<EditFloweringScreen> createState() =>
      _EditFloweringScreenState();
}

class _EditFloweringScreenState extends ConsumerState<EditFloweringScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _varietyController;
  late TextEditingController _locationController;
  late TextEditingController _pollenVarietyController;
  late TextEditingController _notesController;

  DateTime? _flowerDate;
  DateTime? _budDate;
  String _pollinationMethod = 'Hand-pollinated';
  int _fruitSet = 0;
  double _brixScore = 0.0;
  EventStatus _status = EventStatus.flowering;
  bool _isSubmitting = false;

  final List<String> _varieties = [
    'Pink Dragon', 'American Beauty', 'Condor', 'Sugar Dragon', 'Physical Graffiti'
  ];

  final List<String> _locations = [
    'Work - Row 1', 'Work - Row 2', 'Home - Front Fence', 'Home - Dam'
  ];

  final List<String> _pollenVarieties = [
    'American Beauty', 'Condor', 'Pink Dragon', 'Self-pollinated'
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingEvent();
  }

  void _loadExistingEvent() {
    final events = ref.read(floweringListProvider);
    final event = events.where((e) => e.id == widget.eventId).toList();

    if (event.isEmpty) return;
    final e = event.first;

    _varietyController = TextEditingController(text: e.varietyName);
    _locationController = TextEditingController(text: '${e.block} - ${e.row}');
    _pollenVarietyController = TextEditingController(text: e.pollenVariety ?? '');
    _notesController = TextEditingController(text: e.growerNotes ?? '');

    _flowerDate = e.flowerDate;
    _budDate = e.budDate;
    _pollinationMethod = e.pollinationMethod;
    _fruitSet = e.fruitSet;
    _brixScore = e.brixScore;
    _status = e.status;
  }

  @override
  void dispose() {
    _varietyController.dispose();
    _locationController.dispose();
    _pollenVarietyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectFlowerDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _flowerDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _flowerDate = picked;
        _budDate = picked.subtract(const Duration(days: 30));
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_flowerDate == null || _budDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a flowering date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final locationParts = _locationController.text.split(' - ');
    final block = locationParts.length > 0 ? locationParts[0] : 'Unknown';
    final row = locationParts.length > 1 ? locationParts[1] : 'Unknown';

    final updatedEvent = FloweringEvent(
      id: widget.eventId,
      varietyName: _varietyController.text,
      block: block,
      row: row,
      status: _status,
      budDate: _budDate!,
      flowerDate: _flowerDate!,
      pollinationMethod: _pollinationMethod,
      pollenVariety:
          _pollinationMethod == 'Hand-pollinated' ? _pollenVarietyController.text : null,
      fruitSet: _fruitSet,
      brixScore: _brixScore,
      moonPhaseAtFlowering: 'Waxing Crescent',
      growerNotes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    // ✅ Call the new updateEvent method
    ref.read(floweringListProvider.notifier).updateEvent(updatedEvent);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flowering event updated!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Edit Flowering Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildDropdownField(
              controller: _varietyController,
              label: 'Variety',
              items: _varieties,
              icon: Icons.eco,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              controller: _locationController,
              label: 'Location (Site / Row)',
              items: _locations,
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 24),

            // Flowering Date
            _buildDatePickerField(
              label: 'Flowering Date *',
              date: _flowerDate,
              onTap: _selectFlowerDate,
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),

            // Auto-calculated Bud Date
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Bud Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _budDate != null ? _formatDate(_budDate!) : 'Select a flowering date first',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _budDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status Dropdown
            DropdownButtonFormField<EventStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.flag, color: AppColors.primary),
                border: OutlineInputBorder(),
              ),
              items: EventStatus.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s.name),
                );
              }).toList(),
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 16),

            // Pollination
            const Text(
              'Pollination Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            _buildDropdownField(
              controller: TextEditingController(text: _pollinationMethod),
              label: 'Method',
              items: const ['Hand-pollinated', 'Self-pollinated', 'Wind'],
              icon: Icons.touch_app,
              onChanged: (value) {
                setState(() {
                  _pollinationMethod = value!;
                  if (_pollinationMethod != 'Hand-pollinated') {
                    _pollenVarietyController.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            if (_pollinationMethod == 'Hand-pollinated') ...[
              _buildDropdownField(
                controller: _pollenVarietyController,
                label: 'Pollen Variety Used',
                items: _pollenVarieties,
                icon: Icons.grain,
              ),
              const SizedBox(height: 24),
            ],

            // Fruit Set
            const Text(
              'Fruit Set',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of fruits set', style: TextStyle(color: AppColors.textSecondary)),
                  Row(
                    children: [
                      _buildCounterButton(Icons.remove, () {
                        if (_fruitSet > 0) setState(() => _fruitSet--);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_fruitSet',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildCounterButton(Icons.add, () => setState(() => _fruitSet++)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Brix Score
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              initialValue: _brixScore.toString(),
              decoration: const InputDecoration(
                labelText: 'Brix Score',
                prefixIcon: Icon(Icons.water_drop, color: AppColors.primary),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                final parsed = double.tryParse(v);
                if (parsed != null) _brixScore = parsed;
              },
            ),
            const SizedBox(height: 24),

            // Notes
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Grower Notes',
                prefixIcon: Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: _isSubmitting
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required List<String> items,
    required IconData icon,
    void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: const OutlineInputBorder(),
      ),
      items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (value) {
        if (value != null) {
          controller.text = value;
          if (onChanged != null) onChanged(value);
        }
      },
      validator: (v) => v == null || v.isEmpty ? 'Please select a $label' : null,
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, color: AppColors.textSecondary),
          ),
          controller: TextEditingController(text: date != null ? _formatDate(date) : ''),
          validator: (v) => date == null ? 'Please select a date' : null,
        ),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
    );
  }
}