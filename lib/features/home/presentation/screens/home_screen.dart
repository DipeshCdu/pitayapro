import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../my_farm/presentation/providers/weather_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // ========== App Bar ==========
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.primary,
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Colors.white),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'My Farm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ========== Body ==========
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildFarmHeader(),
                  const SizedBox(height: 16),
                  _buildWeatherCard(ref),
                  const SizedBox(height: 16),
                  _buildQuickStats(),
                  const SizedBox(height: 16),
                  _buildRecentActivity(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // ========== Bottom Navigation ==========
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            // Already on Home
          } else if (index == 1) {
            context.go('/flowering');
          }
          // We will add other tabs later
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Farm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Flowering',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Inputs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Soil Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }

  // ===================== FARM HEADER =====================
  Widget _buildFarmHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.agriculture, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pitaya Pro Farm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Northern Territory, Australia',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Dragon Fruit',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== WEATHER CARD =====================
  Widget _buildWeatherCard(WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: weatherAsync.when(
        data: (weather) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weather Overview',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Updated just now',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _weatherItem(
                    Icons.thermostat,
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    'Feels like ${weather.feelsLike.toStringAsFixed(1)}°C',
                  ),
                  _weatherItem(
                    Icons.water_drop_outlined,
                    '${weather.rainfall.toStringAsFixed(1)} mm',
                    'Rainfall',
                  ),
                  _weatherItem(
                    Icons.opacity,
                    '${weather.humidity.toStringAsFixed(0)}%',
                    'Humidity',
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 110,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Column(
          children: [
            const Text(
              'Weather Overview',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load weather',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            TextButton(
              onPressed: () => ref.refresh(weatherProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ===================== QUICK STATS =====================
  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statItem('Total Plants', '2,450', Icons.eco, Colors.green),
              _statItem('Flowering', '320', Icons.local_florist, Colors.pink),
              _statItem('Fruiting', '615', Icons.spa, Colors.deepOrange),
              _statItem('Healthy', '2,210', Icons.check_circle, Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ===================== RECENT ACTIVITY =====================
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'View All >',
                style: TextStyle(fontSize: 13, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _activityItem(
            Icons.water_drop,
            'Irrigation Completed',
            'Sector A1 • 1,200 plants',
            'Today, 8:15 AM',
            Colors.blue,
          ),
          _activityItem(
            Icons.grass,
            'Fertilizer Applied',
            'Organic Booster • Sector B2',
            'Yesterday, 2:30 PM',
            Colors.green,
          ),
          _activityItem(
            Icons.bug_report_outlined,
            'Pest Scouting',
            'No major issues detected',
            'May 18, 10:00 AM',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _activityItem(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}