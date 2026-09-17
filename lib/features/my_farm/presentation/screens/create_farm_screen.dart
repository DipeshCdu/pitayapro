// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:uuid/uuid.dart';

// import '../providers/farm_provider.dart';
// import '../../../../core/theme/app_colors.dart';

// class CreateFarmScreen extends ConsumerStatefulWidget {
//   const CreateFarmScreen({super.key});

//   @override
//   ConsumerState<CreateFarmScreen> createState() => _CreateFarmScreenState();
// }

// class _CreateFarmScreenState extends ConsumerState<CreateFarmScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _ownerController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _regionController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _ownerController.dispose();
//     _addressController.dispose();
//     _regionController.dispose();
//     super.dispose();
//   }

//   void _saveFarm() {
//     if (!_formKey.currentState!.validate()) return;

//     final newFarm = Farm(
//       id: const Uuid().v4(),
//       name: _nameController.text.trim(),
//       owner: _ownerController.text.trim().isEmpty ? null : _ownerController.text.trim(),
//       address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
//       region: _regionController.text.trim().isEmpty ? null : _regionController.text.trim(),
//     );

//     ref.read(farmListProvider.notifier).addFarm(newFarm);
//     context.pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Farm'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Farm Name *',
//                 prefixIcon: Icon(Icons.agriculture),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Farm name is required';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _ownerController,
//               decoration: const InputDecoration(
//                 labelText: 'Owner / Manager',
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _addressController,
//               decoration: const InputDecoration(
//                 labelText: 'Address',
//                 prefixIcon: Icon(Icons.location_on),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _regionController,
//               decoration: const InputDecoration(
//                 labelText: 'Region / Climate Zone',
//                 prefixIcon: Icon(Icons.map),
//               ),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _saveFarm,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: const Text('Save Farm'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }