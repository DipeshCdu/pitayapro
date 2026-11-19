import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  // ✅ No parameters needed! It auto-detects everything safely.
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    
    // Safely determine the active tab. Defaults to 0 (Home) for all sub-screens.
    int activeIndex = 0; 
    
    if (location.startsWith('/my-farm')) {
      activeIndex = 1;
    } else if (location.startsWith('/flowering')) {
      activeIndex = 2;
    } else if (location == '/insights') {
      activeIndex = 3;
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Keeps all labels visible
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey.shade500,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      elevation: 10,
      currentIndex: activeIndex, // 
      onTap: (index) {
        if (index == 0) context.go('/home');
        if (index == 1) context.go('/my-farm');
        if (index == 2) context.go('/flowering');
        if (index == 3) context.go('/insights');
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.agriculture_outlined),
          activeIcon: Icon(Icons.agriculture),
          label: 'My Farm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist_outlined),
          activeIcon: Icon(Icons.local_florist),
          label: 'Flowering',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insights_outlined),
          activeIcon: Icon(Icons.insights),
          label: 'Insights',
        ),
      ],
    );
  }
}