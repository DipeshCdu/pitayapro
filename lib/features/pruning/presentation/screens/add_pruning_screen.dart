import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/pruning_provider.dart';

class AddPruningScreen extends ConsumerStatefulWidget {
  const AddPruningScreen({super.key});

  @override
  ConsumerState<AddPruningScreen> createState() => _AddPruningScreenState();
}

class _AddPruningScreenState extends ConsumerState<AddPruningScreen> {
  final _formKey = GlobalKey<FormState>();

  final _blockController = TextEditingController();
  final _wasteKgController = TextEditingController();
  final _wasteVolumeController = TextEditingController();
  final _nutrientController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _pruningDate = DateTime.now();
  String _pruningType = 'Maintenance';
  String _method = 'Manual';

  final _typeOptions = ['Light', 'Heavy', 'Formative', 'Maintenance'];
  final _methodOptions = ['Manual', 'Mechanical'];

  @override
  void dispose() {
    _blockController.dispose();
    _wasteKgController.dispose();
    _wasteVolumeController.dispose();
    _nutrientController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _pruningDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _pruningDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final record = PruningRecord(
      id: const Uuid().v4(),
      block: _blockController.text.trim(),
      pruningDate: _pruningDate,
      pruningType: _pruningType,
      greenWasteKg: double.tryParse(_wasteKgController.text),
      greenWasteVolumeM3: double.tryParse(_wasteVolumeController.text),
      method: _method,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      estimatedNutrientExport: double.tryParse(_nutrientController.text),
    );

    ref.read(pruningListProvider.notifier).addRecord(record);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pruning record added'),
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
        title: const Text('Add Pruning Record'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _textField(
              controller: _blockController,
              label: 'Block / Location *',
              icon: Icons.grid_view,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _pruningType,
              decoration: _decoration('Pruning Type', Icons.content_cut),
              items: _typeOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _pruningType = v!),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _method,
              decoration: _decoration('Method', Icons.build),
              items: _methodOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _method = v!),
            ),
            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: AppColors.primary),
              title: const Text('Pruning Date'),
              subtitle: Text(DateFormat('dd MMM yyyy').format(_pruningDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),

            const Text(
              'Green Waste',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: _wasteKgController,
                    label: 'Weight (kg)',
                    icon: Icons.scale,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: _wasteVolumeController,
                    label: 'Volume (m³)',
                    icon: Icons.square_foot,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _textField(
              controller: _nutrientController,
              label: 'Est. Nutrient Export (optional)',
              icon: Icons.eco,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            _textField(
              controller: _notesController,
              label: 'Notes',
              icon: Icons.notes,
              maxLines: 3,
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
                  'Save Record',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
      decoration: _decoration(label, icon),
    );
  }
}