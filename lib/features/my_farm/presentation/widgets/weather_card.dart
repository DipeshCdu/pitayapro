import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/farm_provider.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.cloud, color: AppColors.primary, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Weather Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Text('Updated 9:30 AM', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric(Icons.thermostat, '${weather.temperature}°C', 'Feels like ${weather.feelsLike}°C', Colors.redAccent),
              _buildDivider(),
              _buildMetric(Icons.water_drop, '${weather.rainfall}%', 'Rainfall (24h)\n2.4 mm', Colors.blue),
              _buildDivider(),
              _buildMetric(Icons.air, '${weather.humidity}%', 'Humidity\nModerate', Colors.lightBlue),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today\'s Forecast: ${weather.forecast}', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.wb_cloudy, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 4),
                    Text(weather.condition, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: AppColors.divider);
  }
}