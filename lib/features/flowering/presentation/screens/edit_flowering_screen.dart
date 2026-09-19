import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/flowering_provider.dart';

class EditFloweringScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EditFloweringScreen({super.key, required this.eventId});

  @override
  ConsumerState<EditFloweringScreen> createState() => _EditFloweringScreenState();
}

class _EditFloweringScreenState extends ConsumerState<EditFloweringScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _varietyController;
  late TextEditingController _blockController;
  late TextEditingController _pollenVarietyController;
  late TextEditingController _fruitSetController;
  late TextEditingController _fruitAbortedController;
  late TextEditingController _weightController;
  late TextEditingController _brixController;
  late TextEditingController _priceController;
  late TextEditingController _notesController;

  late String _status;
  String? _pollinationMethod;
  DateTime? _buddingDate;
  DateTime? _floweringDate;
  DateTime? _harvestDate;

  final List<String> _statusOptions = ['Budding', 'Flowering', 'Harvested'];
  final List<String> _pollinationOptions = [
    'Self-pollinated',
    'Hand-pollinated',
    'Cross-pollinated',
    'Open-pollinated',
    'Bee / insect-pollinated',
    'Not pollinated',
    'Unknown',
  ];

  @override
  void initState() {
    super.initState();

    final events = ref.read(floweringListProvider);
    final event = events.firstWhere((e) => e.id == widget.eventId);

    _varietyController = TextEditingController(text: event.variety);
    _blockController = TextEditingController(text: event.block);
    _pollenVarietyController = TextEditingController(text: event.pollenVariety ?? '');
    _fruitSetController = TextEditingController(text: event.fruitSet?.toString() ?? '');
    _fruitAbortedController = TextEditingController(text: event.fruitAborted?.toString() ?? '');
    _weightController = TextEditingController(text: event.totalWeightKg?.toString() ?? '');
    _brixController = TextEditingController(text: event.averageBrix?.toString() ?? '');
    _priceController = TextEditingController(text: event.salePricePerKg?.toString() ?? '');
    _notesController = TextEditingController(text: event.notes ?? '');

    _status = event.status;
    _pollinationMethod = event.pollinationMethod;
    _buddingDate = event.buddingDate;
    _floweringDate = event.floweringDate;
    _harvestDate = event.harvestDate;
  }

  @override
  void dispose() {
    _varietyController.dispose();
    _blockController.dispose();
    _pollenVarietyController.dispose();
    _fruitSetController.dispose();
    _fruitAbortedController.dispose();
    _weightController.dispose();
    _brixController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime? current,
    required Function(DateTime) onPicked,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) onPicked(picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updatedEvent = FloweringEvent(
      id: widget.eventId,
      variety: _varietyController.text.trim(),
      block: _blockController.text.trim(),
      status: _status,
      buddingDate: _buddingDate,
      floweringDate: _floweringDate,
      harvestDate: _harvestDate,
      pollinationMethod: _pollinationMethod,
      pollenVariety: _pollenVarietyController.text.trim().isEmpty
          ? null
          : _pollenVarietyController.text.trim(),
      fruitSet: int.tryParse(_fruitSetController.text),
      fruitAborted: int.tryParse(_fruitAbortedController.text),
      totalWeightKg: double.tryParse(_weightController.text),
      averageBrix: double.tryParse(_brixController.text),
      salePricePerKg: double.tryParse(_priceController.text),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    ref.read(floweringListProvider.notifier).updateEvent(updatedEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Flowering event updated'),
        backgroundColor: Colors.green,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Edit Flowering Event'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Basic Information'),
            const SizedBox(height: 12),

            _textField(
              controller: _varietyController,
              label: 'Variety Name *',
              icon: Icons.local_florist,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            _textField(
              controller: _blockController,
              label: 'Block / Location *',
              icon: Icons.grid_view,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            _dropdown(
              label: 'Status',
              value: _status,
              items: _statusOptions,
              onChanged: (v) => setState(() => _status = v!),
            ),

            const SizedBox(height: 24),
            _sectionTitle('Dates'),
            const SizedBox(height: 12),

            _dateTile(
              title: 'Budding Date',
              date: _buddingDate,
              onTap: () => _pickDate(
                current: _buddingDate,
                onPicked: (d) => setState(() => _buddingDate = d),
              ),
            ),
            _dateTile(
              title: 'Flowering Date',
              date: _floweringDate,
              onTap: () => _pickDate(
                current: _floweringDate,
                onPicked: (d) => setState(() => _floweringDate = d),
              ),
            ),
            _dateTile(
              title: 'Harvest Date',
              date: _harvestDate,
              onTap: () => _pickDate(
                current: _harvestDate,
                onPicked: (d) => setState(() => _harvestDate = d),
              ),
            ),

            const SizedBox(height: 24),
            _sectionTitle('Pollination'),
            const SizedBox(height: 12),

            _dropdown(
              label: 'Pollination Method',
              value: _pollinationMethod,
              items: _pollinationOptions,
              onChanged: (v) => setState(() => _pollinationMethod = v),
              isOptional: true,
            ),
            const SizedBox(height: 12),

            _textField(
              controller: _pollenVarietyController,
              label: 'Pollen Variety (optional)',
              icon: Icons.spa,
            ),

            const SizedBox(height: 24),
            _sectionTitle('Fruit Results'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: _fruitSetController,
                    label: 'Fruit Set',
                    icon: Icons.check_circle_outline,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: _fruitAbortedController,
                    label: 'Fruit Aborted',
                    icon: Icons.cancel_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: _weightController,
                    label: 'Total Weight (kg)',
                    icon: Icons.scale,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: _brixController,
                    label: 'Brix',
                    icon: Icons.opacity,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _textField(
              controller: _priceController,
              label: 'Sale Price per kg (\$)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),
            _sectionTitle('Notes'),
            const SizedBox(height: 12),

            _textField(
              controller: _notesController,
              label: 'Grower Notes',
              icon: Icons.notes,
              maxLines: 4,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool isOptional = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      items: [
        if (isOptional)
          const DropdownMenuItem(value: null, child: Text('Select...')),
        ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))),
      ],
      onChanged: onChanged,
    );
  }

  Widget _dateTile({
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_today, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(
        date != null ? DateFormat('dd MMM yyyy').format(date) : 'Not set',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}