import 'package:flutter/material.dart'; // ✅ THIS IS THE KEY IMPORT!
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- MODELS ---
class WeatherData {
  final double temperature;
  final double feelsLike;
  final double rainfall;
  final double humidity;
  final String condition;
  final String forecast;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.rainfall,
    required this.humidity,
    required this.condition,
    required this.forecast,
  });
}

class FarmStat {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon; // ✅ Now IconData is recognized
  final String iconColorHex;

  FarmStat({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.iconColorHex,
  });
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon; // ✅ Now IconData is recognized
  final String colorHex;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.colorHex,
  });
}

class FarmDashboardData {
  final String farmName;
  final String location;
  final WeatherData weather;
  final List<FarmStat> stats;
  final List<ActivityItem> activities;

  FarmDashboardData({
    required this.farmName,
    required this.location,
    required this.weather,
    required this.stats,
    required this.activities,
  });
}

// --- PROVIDER ---
final farmDashboardProvider = Provider<FarmDashboardData>((ref) {
  return FarmDashboardData(
    farmName: 'Pitaya Pro Farm',
    location: 'Green Valley, Thailand',
    weather: WeatherData(
      temperature: 31,
      feelsLike: 34,
      rainfall: 12,
      humidity: 78,
      condition: 'Partly cloudy',
      forecast: '25°C – 32°C',
    ),
    stats: [
      FarmStat(
        title: 'Total Plants',
        value: '2,450',
        change: '5.2% vs last month',
        isPositive: true,
        icon: Icons.grass, // ✅ Now Icons is recognized
        iconColorHex: '0xFF2E7D32',
      ),
      FarmStat(
        title: 'Flowering',
        value: '320',
        change: '13.1% of total',
        isPositive: true,
        icon: Icons.local_florist,
        iconColorHex: '0xFFE91E63',
      ),
      FarmStat(
        title: 'Fruiting',
        value: '615',
        change: '25.1% of total',
        isPositive: true,
        icon: Icons.apple,
        iconColorHex: '0xFFD32F2F',
      ),
      FarmStat(
        title: 'Healthy Plants',
        value: '2,210',
        change: '3.8% vs last month',
        isPositive: true,
        icon: Icons.check_circle,
        iconColorHex: '0xFF1B5E20',
      ),
    ],
    activities: [
      ActivityItem(
        title: 'Irrigation Completed',
        subtitle: 'Sector A1 • 1,200 plants',
        time: 'Today, 8:15 AM',
        icon: Icons.water_drop, // ✅ Now Icons is recognized
        colorHex: '0xFF4CAF50',
      ),
      ActivityItem(
        title: 'Fertilizer Applied',
        subtitle: 'Organic Booster • Sector B2',
        time: 'Yesterday, 2:30 PM',
        icon: Icons.science,
        colorHex: '0xFF9C27B0',
      ),
      ActivityItem(
        title: 'Pest Scouting',
        subtitle: 'No major issues detected',
        time: 'May 18, 10:00 AM',
        icon: Icons.bug_report,
        colorHex: '0xFFFF9800',
      ),
    ],
  );
});