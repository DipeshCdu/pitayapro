import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class EditFarmScreen extends ConsumerStatefulWidget {
  const EditFarmScreen({super.key});

  @override
  ConsumerState<EditFarmScreen> createState() => _EditFarmScreenState();
}

class _EditFarmScreenState extends ConsumerState<EditFarmScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Pitaya Pro Farm');
  final _ownerController = TextEditingController(text: 'Ramesh');
  final _addressController = TextEditingController(text: 'Northern Territory, Australia');
  final _regionController = TextEditingController(text: 'Tropical');

  String _growingSystem = 'Open Field';
  String _trellisSystem = 'T-bar Trellis';
  String _irrigationSystem = 'Drip Irrigation';

  final List<String> growingOptions = [
    'Open Field',
    'Greenhouse',
    'Shade Structure',
    'Mixed',
  ];

  final List<String> trellisOptions = [
    'Concrete Posts',
    'Timber Posts',
    'Tyre System',
    'T-bar Trellis',
    'Potted System',
    'Other',
  ];

  final List<String> irrigationOptions = [
    'Drip',
    'Spray / Overhead',
    'Flood Irrigation',
    'Manual Watering',
    'Automated System',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Save to provider / database later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Farm profile updated successfully'),
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
        title: const Text('Edit Farm Profile'),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Section: Basic Info
            _sectionTitle('Basic Information'),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _nameController,
              label: 'Farm Name *',
              icon: Icons.agriculture,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Farm name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            _buildTextField(
              controller: _ownerController,
              label: 'Owner / Manager',
              icon: Icons.person,
            ),
            const SizedBox(height: 14),

            _buildTextField(
              controller: _addressController,
              label: 'Address / Location',
              icon: Icons.location_on,
              maxLines: 2,
            ),
            const SizedBox(height: 14),

            _buildTextField(
              controller: _regionController,
              label: 'Region / Climate Zone',
              icon: Icons.map,
            ),

            const SizedBox(height: 28),

            // Section: Infrastructure
            _sectionTitle('Infrastructure'),
            const SizedBox(height: 12),

            _buildDropdown(
              label: 'Growing System',
              value: _growingSystem,
              items: growingOptions,
              icon: Icons.wb_sunny,
              onChanged: (value) {
                setState(() => _growingSystem = value!);
              },
            ),
            const SizedBox(height: 14),

            _buildDropdown(
              label: 'Trellis / Support System',
              value: _trellisSystem,
              items: trellisOptions,
              icon: Icons.grid_view,
              onChanged: (value) {
                setState(() => _trellisSystem = value!);
              },
            ),
            const SizedBox(height: 14),

            _buildDropdown(
              label: 'Irrigation System',
              value: _irrigationSystem,
              items: irrigationOptions,
              icon: Icons.water_drop,
              onChanged: (value) {
                setState(() => _irrigationSystem = value!);
              },
            ),

            const SizedBox(height: 36),

            // Save Button
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
            const SizedBox(height: 20),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}