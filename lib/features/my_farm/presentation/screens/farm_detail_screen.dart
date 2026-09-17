// import 'package:flutter/material.dart';
// import '../providers/farm_provider.dart';
// import '../../../../core/theme/app_colors.dart';

// class FarmDetailScreen extends StatelessWidget {
//   final Farm farm;

//   const FarmDetailScreen({super.key, required this.farm});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(farm.name),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Farm Name: ${farm.name}', style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 12),
//             Text('Owner: ${farm.owner ?? "-"}'),
//             const SizedBox(height: 8),
//             Text('Address: ${farm.address ?? "-"}'),
//             const SizedBox(height: 8),
//             Text('Region: ${farm.region ?? "-"}'),
//           ],
//         ),
//       ),
//     );
//   }
// }