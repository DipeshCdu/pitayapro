import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/soil_test_provider.dart';

class AddSoilTestScreen extends ConsumerStatefulWidget {
  const AddSoilTestScreen({super.key});

  @override
  ConsumerState<AddSoilTestScreen> createState() => _AddSoilTestScreenState();
}

class _AddSoilTestScreenState extends ConsumerState<AddSoilTestScreen> {
  final _formKey = GlobalKey<FormState>();

  final _blockController = TextEditingController();
  final _labController = TextEditingController();
  final _phController = TextEditingController();
  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();
  final _omController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _testDate = DateTime.now();
  NutrientStatus _status = NutrientStatus.optimal;

  @override
  void dispose() {
    _blockController.dispose();
    _labController.dispose();
    _phController.dispose();
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _omController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _testDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _testDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final record = SoilTestRecord(
      id: const Uuid().v4(),
      block: _blockController.text.trim(),
      testDate: _testDate,
      labName: _labController.text.trim().isEmpty
          ? 'Unknown Lab'
          : _labController.text.trim(),
      ph: double.tryParse(_phController.text),
      nitrogen: double.tryParse(_nController.text),
      phosphorus: double.tryParse(_pController.text),
      potassium: double.tryParse(_kController.text),
      organicMatter: double.tryParse(_omController.text),
      overallStatus: _status,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    ref.read(soilTestListProvider.notifier).addRecord(record);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Soil test added'),
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
        title: const Text('Add Soil Test'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Basic Info'),
            const SizedBox(height: 12),
            _textField(
              controller: _blockController,
              label: 'Block / Location *',
              icon: Icons.grid_view,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            _textField(
              controller: _labController,
              label: 'Lab Name',
              icon: Icons.business,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: AppColors.primary),
              title: const Text('Test Date'),
              subtitle: Text(DateFormat('dd MMM yyyy').format(_testDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<NutrientStatus>(
              value: _status,
              decoration: InputDecoration(
                labelText: 'Overall Status',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: NutrientStatus.optimal,
                  child: Text('Optimal'),
                ),
                DropdownMenuItem(
                  value: NutrientStatus.warning,
                  child: Text('Warning'),
                ),
                DropdownMenuItem(
                  value: NutrientStatus.deficient,
                  child: Text('Deficient'),
                ),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),

            const SizedBox(height: 24),
            _sectionTitle('Nutrient Levels'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _textField(
                    controller: _phController,
                    label: 'pH',
                    icon: Icons.water,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: _omController,
                    label: 'Organic Matter %',
                    icon: Icons.grass,
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
                    controller: _nController,
                    label: 'Nitrogen (N)',
                    icon: Icons.eco,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: _pController,
                    label: 'Phosphorus (P)',
                    icon: Icons.eco,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _textField(
              controller: _kController,
              label: 'Potassium (K)',
              icon: Icons.eco,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),
            _sectionTitle('Notes'),
            const SizedBox(height: 12),
            _textField(
              controller: _notesController,
              label: 'Recommendations / Notes',
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
                  'Save Soil Test',
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
}