import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/farm_profile_provider.dart';

class CreateFarmScreen extends ConsumerStatefulWidget {
  const CreateFarmScreen({super.key});

  @override
  ConsumerState<CreateFarmScreen> createState() => _CreateFarmScreenState();
}

class _CreateFarmScreenState extends ConsumerState<CreateFarmScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _addressController = TextEditingController();
  final _regionController = TextEditingController();
  final _notesController = TextEditingController();

  String _growingSystem = 'Open Field';
  String _trellisSystem = 'T-bar Trellis';
  String _irrigationSystem = 'Drip Irrigation';
  String _soilType = 'In-ground';
  String _mulchType = 'Organic Mulch';

  final growingOptions = [
    'Open Field',
    'Greenhouse',
    'Shade Structure',
    'Mixed',
  ];

  final trellisOptions = [
    'Concrete Posts',
    'Timber Posts',
    'Tyre System',
    'T-bar Trellis',
    'Potted System',
    'Other',
  ];

  final irrigationOptions = [
    'Drip Irrigation',
    'Drip',
    'Spray / Overhead',
    'Flood Irrigation',
    'Manual Watering',
    'Automated System',
  ];

  final soilOptions = [
    'In-ground',
    'Raised Beds',
    'Pots / Containers',
    'Mixed',
  ];

  final mulchOptions = [
    'Organic Mulch',
    'Plastic Mulch',
    'None',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final profile = FarmProfile(
      name: _nameController.text.trim(),
      owner: _ownerController.text.trim().isEmpty
          ? 'Owner'
          : _ownerController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? 'Northern Territory, Australia'
          : _addressController.text.trim(),
      climateZone: _regionController.text.trim().isEmpty
          ? 'Tropical'
          : _regionController.text.trim(),
      growingSystem: _growingSystem,
      trellisSystem: _trellisSystem,
      irrigationSystem: _irrigationSystem,
      cropType: 'Dragon Fruit',
      soilType: _soilType,
      mulchType: _mulchType,
      notes: _notesController.text.trim(),
    );

    ref.read(farmProfileProvider.notifier).update(profile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Farm profile saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    context.go('/my-farm');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Create Farm Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _textField(
              controller: _nameController,
              label: 'Farm Name *',
              icon: Icons.agriculture,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _ownerController,
              label: 'Owner / Manager',
              icon: Icons.person,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _addressController,
              label: 'Address / Location',
              icon: Icons.location_on,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _regionController,
              label: 'Region / Climate Zone',
              icon: Icons.map,
            ),
            const SizedBox(height: 28),
            const Text(
              'Infrastructure',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: 'Growing System',
              value: _growingSystem,
              items: growingOptions,
              icon: Icons.wb_sunny,
              onChanged: (v) => setState(() => _growingSystem = v!),
            ),
            const SizedBox(height: 14),
            _dropdown(
              label: 'Trellis / Support',
              value: _trellisSystem,
              items: trellisOptions,
              icon: Icons.grid_view,
              onChanged: (v) => setState(() => _trellisSystem = v!),
            ),
            const SizedBox(height: 14),
            _dropdown(
              label: 'Irrigation',
              value: _irrigationSystem,
              items: irrigationOptions,
              icon: Icons.water_drop,
              onChanged: (v) => setState(() => _irrigationSystem = v!),
            ),
            const SizedBox(height: 14),
            _dropdown(
              label: 'Soil / Growing Medium',
              value: _soilType,
              items: soilOptions,
              icon: Icons.grass,
              onChanged: (v) => setState(() => _soilType = v!),
            ),
            const SizedBox(height: 14),
            _dropdown(
              label: 'Mulch Type',
              value: _mulchType,
              items: mulchOptions,
              icon: Icons.layers,
              onChanged: (v) => setState(() => _mulchType = v!),
            ),
            const SizedBox(height: 28),
            const Text(
              'Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _textField(
              controller: _notesController,
              label: 'Notes',
              icon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: 36),
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
                  'Save Farm Profile',
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

  Widget _textField({
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}