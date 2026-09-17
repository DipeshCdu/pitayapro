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
  final _farmNameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _addressController = TextEditingController();
  final _regionController = TextEditingController();

  @override
  void dispose() {
    _farmNameController.dispose();
    _ownerController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(farmProfileProvider);

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
          'Farm Profile Setup',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.read(farmProfileProvider.notifier).saveProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Farm profile saved successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                // Optional: Navigate back after saving
                // context.pop();
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Farm Details'),
            _buildTextField(
              controller: _farmNameController,
              label: 'Farm Name',
              hint: 'e.g., Pitaya Pro Farm',
              icon: Icons.agriculture,
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateFarmName(val),
            ),
            _buildTextField(
              controller: _ownerController,
              label: 'Owner / Manager',
              hint: 'Your name',
              icon: Icons.person,
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateOwnerName(val),
            ),
            _buildTextField(
              controller: _addressController,
              label: 'Address',
              hint: 'Farm address',
              icon: Icons.location_on,
              maxLines: 2,
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateAddress(val),
            ),
            _buildTextField(
              controller: _regionController,
              label: 'Region / Climate Zone',
              hint: 'e.g., Tropical, Subtropical',
              icon: Icons.public,
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateRegion(val),
            ),
            const SizedBox(height: 16),
            _buildGPSButton(),
            if (profile.latitude != null && profile.longitude != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'GPS: ${profile.latitude!.toStringAsFixed(4)}, ${profile.longitude!.toStringAsFixed(4)}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            _buildSectionTitle('Growing System'),
            _buildDropdown(
              label: 'Growing System Type',
              value: profile.growingSystem,
              items: const [
                DropdownMenuItem(value: GrowingSystemType.openField, child: Text('Open Field')),
                DropdownMenuItem(value: GrowingSystemType.greenhouse, child: Text('Greenhouse')),
                DropdownMenuItem(value: GrowingSystemType.shadeStructure, child: Text('Shade Structure')),
              ],
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateGrowingSystem(val!),
            ),
            _buildDropdown(
              label: 'Trellis / Support System',
              value: profile.trellisType,
              items: const [
                DropdownMenuItem(value: TrellisType.concrete, child: Text('Concrete Posts')),
                DropdownMenuItem(value: TrellisType.timber, child: Text('Timber Posts')),
                DropdownMenuItem(value: TrellisType.tyre, child: Text('Tyre System')),
                DropdownMenuItem(value: TrellisType.tbar, child: Text('T-bar / Custom')),
                DropdownMenuItem(value: TrellisType.potted, child: Text('Potted System')),
                DropdownMenuItem(value: TrellisType.other, child: Text('Other')),
              ],
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateTrellisType(val!),
            ),
            if (profile.trellisType == TrellisType.other)
              _buildTextField(
                label: 'Custom Trellis Type',
                hint: 'Describe your system',
                icon: Icons.description,
                onChanged: (val) => ref.read(farmProfileProvider.notifier).updateCustomTrellis(val),
              ),
            _buildDropdown(
              label: 'Irrigation System',
              value: profile.irrigationType,
              items: const [
                DropdownMenuItem(value: IrrigationType.drip, child: Text('Drip Irrigation')),
                DropdownMenuItem(value: IrrigationType.spray, child: Text('Spray / Overhead')),
                DropdownMenuItem(value: IrrigationType.flood, child: Text('Flood Irrigation')),
                DropdownMenuItem(value: IrrigationType.manual, child: Text('Manual Watering')),
                DropdownMenuItem(value: IrrigationType.automated, child: Text('Automated System')),
              ],
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateIrrigationType(val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Soil & Planting'),
            _buildDropdown(
              label: 'Soil Type',
              value: profile.soilType,
              items: const [
                DropdownMenuItem(value: SoilType.sandy, child: Text('Sandy')),
                DropdownMenuItem(value: SoilType.loam, child: Text('Loam')),
                DropdownMenuItem(value: SoilType.clay, child: Text('Clay')),
                DropdownMenuItem(value: SoilType.improved, child: Text('Improved')),
              ],
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateSoilType(val!),
            ),
            _buildDropdown(
              label: 'Mulching Type',
              value: profile.mulchType,
              items: const [
                DropdownMenuItem(value: MulchType.organic, child: Text('Organic')),
                DropdownMenuItem(value: MulchType.plastic, child: Text('Plastic')),
                DropdownMenuItem(value: MulchType.none, child: Text('None')),
              ],
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateMulchType(val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Notes & Observations'),
            _buildTextField(
              label: 'Additional Notes',
              hint: 'Seasonal reflections, trial results, farm improvements...',
              icon: Icons.note,
              maxLines: 4,
              onChanged: (val) => ref.read(farmProfileProvider.notifier).updateNotes(val),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  // ✅ FIXED: Removed 'required' from controller so it's truly optional
  Widget _buildTextField({
    TextEditingController? controller, 
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
        maxLines: maxLines,
        onChanged: onChanged,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildGPSButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Implement actual GPS picker (e.g., geolocator package)
        // For now, simulate GPS coordinates (Darwin, Australia)
        ref.read(farmProfileProvider.notifier).updateGPS(-12.4634, 130.8456);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('GPS coordinates captured!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      icon: const Icon(Icons.my_location),
      label: const Text('Auto-detect GPS Location'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}