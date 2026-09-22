import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/farm_profile_provider.dart';

class EditFarmScreen extends ConsumerStatefulWidget {
  const EditFarmScreen({super.key});

  @override
  ConsumerState<EditFarmScreen> createState() => _EditFarmScreenState();
}

class _EditFarmScreenState extends ConsumerState<EditFarmScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ownerController;
  late TextEditingController _addressController;
  late TextEditingController _regionController;
  late TextEditingController _notesController;

  late String _growingSystem;
  late String _trellisSystem;
  late String _irrigationSystem;
  late String _soilType;
  late String _mulchType;

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
  void initState() {
    super.initState();
    final farm = ref.read(farmProfileProvider);

    _nameController = TextEditingController(text: farm.name);
    _ownerController = TextEditingController(text: farm.owner);
    _addressController = TextEditingController(text: farm.address);
    _regionController = TextEditingController(text: farm.climateZone);
    _notesController = TextEditingController(text: farm.notes);

    _growingSystem = farm.growingSystem;
    _trellisSystem = farm.trellisSystem;
    _irrigationSystem = farm.irrigationSystem;
    _soilType = farm.soilType;
    _mulchType = farm.mulchType;

    if (!growingOptions.contains(_growingSystem)) growingOptions.add(_growingSystem);
    if (!trellisOptions.contains(_trellisSystem)) trellisOptions.add(_trellisSystem);
    if (!irrigationOptions.contains(_irrigationSystem)) {
      irrigationOptions.add(_irrigationSystem);
    }
    if (!soilOptions.contains(_soilType)) soilOptions.add(_soilType);
    if (!mulchOptions.contains(_mulchType)) mulchOptions.add(_mulchType);
  }

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

    final current = ref.read(farmProfileProvider);

    final updated = FarmProfile(
      name: _nameController.text.trim(),
      owner: _ownerController.text.trim(),
      address: _addressController.text.trim(),
      climateZone: _regionController.text.trim(),
      growingSystem: _growingSystem,
      trellisSystem: _trellisSystem,
      irrigationSystem: _irrigationSystem,
      cropType: current.cropType,
      soilType: _soilType,
      mulchType: _mulchType,
      notes: _notesController.text.trim(),
      latitude: current.latitude,
      longitude: current.longitude,
    );

    ref.read(farmProfileProvider.notifier).update(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Farm profile updated'),
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
        title: const Text('Edit Farm Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _title('Basic Information'),
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
            _title('Infrastructure'),
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
            _title('Notes'),
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

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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