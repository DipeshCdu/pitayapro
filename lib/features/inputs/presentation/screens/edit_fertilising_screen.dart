import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/fertilising_provider.dart';

class EditFertilisingScreen extends ConsumerStatefulWidget {
  final String recordId;

  const EditFertilisingScreen({super.key, required this.recordId});

  @override
  ConsumerState<EditFertilisingScreen> createState() => _EditFertilisingScreenState();
}

class _EditFertilisingScreenState extends ConsumerState<EditFertilisingScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _blockController;
  late TextEditingController _quantityController;
  late TextEditingController _costController;
  late TextEditingController _notesController;

  late DateTime _applicationDate;
  late String _method;

  final List<String> _methodOptions = ['Broadcast', 'Drip', 'Foliar', 'Manual'];

  @override
  void initState() {
    super.initState();
    final records = ref.read(fertilisingListProvider);
    final record = records.firstWhere((r) => r.id == widget.recordId);

    _nameController = TextEditingController(text: record.fertiliserName);
    _blockController = TextEditingController(text: record.block);
    _quantityController = TextEditingController(text: record.quantityKg.toString());
    _costController = TextEditingController(text: record.cost?.toString() ?? '');
    _notesController = TextEditingController(text: record.notes ?? '');
    _applicationDate = record.applicationDate;
    _method = record.method;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _blockController.dispose();
    _quantityController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _applicationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _applicationDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = FertilisingRecord(
      id: widget.recordId,
      fertiliserName: _nameController.text.trim(),
      block: _blockController.text.trim(),
      applicationDate: _applicationDate,
      quantityKg: double.tryParse(_quantityController.text) ?? 0,
      method: _method,
      cost: double.tryParse(_costController.text),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    ref.read(fertilisingListProvider.notifier).updateRecord(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record updated'), backgroundColor: Colors.green),
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
        title: const Text('Edit Fertilising Record'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _textField(
              controller: _nameController,
              label: 'Fertiliser Name *',
              icon: Icons.grass,
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
            _textField(
              controller: _quantityController,
              label: 'Quantity (kg) *',
              icon: Icons.scale,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _method,
              decoration: InputDecoration(
                labelText: 'Application Method',
                prefixIcon: const Icon(Icons.water_drop),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _methodOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _method = v!),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, color: AppColors.primary),
              title: const Text('Application Date'),
              subtitle: Text(DateFormat('dd MMM yyyy').format(_applicationDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            _textField(
              controller: _costController,
              label: 'Cost (\$) (optional)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _textField(
              controller: _notesController,
              label: 'Notes (optional)',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
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