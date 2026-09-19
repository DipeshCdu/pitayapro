import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/my-farm');
            break;
          case 2:
            context.go('/flowering');
            break;
          case 3:
            context.go('/inputs');
            break;
          case 4:
            // Insights - coming soon
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.agriculture), label: 'My Farm'),
        BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Flowering'),
        BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Inputs'),
        BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
      ],
    );
  }
}