import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../my_farm/presentation/providers/weather_provider.dart';
import '../../../flowering/presentation/providers/flowering_provider.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final floweringEvents = ref.watch(floweringListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.agriculture, color: Colors.white, size: 26),
            SizedBox(width: 10),
            Text(
              'Pitaya Pro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
          _buildGreeting(context),
          const SizedBox(height: 16),

          // Weather
          _buildWeatherSummary(weatherAsync),
          const SizedBox(height: 20),

          // Quick Access
          const Text(
            'Quick Access',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildQuickAccess(context),
          const SizedBox(height: 24),

          // Recent Flowering
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Flowering',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => context.go('/flowering'),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFloweringOverview(floweringEvents),
          const SizedBox(height: 20),

          // Tip
          _buildTipCard(),
          const SizedBox(height: 30),
        ],
      ),
bottomNavigationBar: const AppBottomNav(currentIndex: 0),    );
  }

  // ====================== GREETING ======================
  Widget _buildGreeting(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardGreen,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(Icons.person, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good day, Ramesh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Here’s your farm overview',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => context.go('/my-farm'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text('My Farm'),
        ),
      ],
    );
  }

  // ====================== WEATHER ======================
  Widget _buildWeatherSummary(AsyncValue weatherAsync) {
    return weatherAsync.when(
      data: (weather) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.condition,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'H: ${weather.maxTemp?.toStringAsFixed(0) ?? '-'}°  L: ${weather.minTemp?.toStringAsFixed(0) ?? '-'}°',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(weather.weatherIcon, size: 48, color: Colors.amber),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text('Unable to load weather'),
      ),
    );
  }

  // ====================== QUICK ACCESS ======================
  Widget _buildQuickAccess(BuildContext context) {
    final items = [
      {
        'icon': Icons.agriculture,
        'label': 'My Farm',
        'color': Colors.green,
        'route': '/my-farm'
      },
      {
        'icon': Icons.local_florist,
        'label': 'Flowering',
        'color': Colors.pink,
        'route': '/flowering'
      },
      {
        'icon': Icons.grass,
        'label': 'Inputs',
        'color': Colors.teal,
        'route': '/inputs',
      },
      {
        'icon': Icons.science,
        'label': 'Soil Tests',
        'color': Colors.blue,
        'route': '/soil-tests',
      },
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (item['route'] != null) {
                context.go(item['route'] as String);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ====================== FLOWERING ======================
  Widget _buildFloweringOverview(List floweringEvents) {
    if (floweringEvents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(child: Text('No flowering events yet')),
      );
    }

    final recent = floweringEvents.take(3).toList();

    return Column(
      children: recent.map((event) {
        Color statusColor;
        switch (event.status) {
          case 'Budding':
            statusColor = Colors.orange;
            break;
          case 'Flowering':
            statusColor = Colors.green;
            break;
          case 'Harvested':
            statusColor = Colors.blueGrey;
            break;
          default:
            statusColor = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_florist,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.variety,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      event.block,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  event.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ====================== TIP ======================
  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tip of the day',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ensure proper irrigation during flowering for better fruit set.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}