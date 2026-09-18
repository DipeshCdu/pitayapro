import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/weather_provider.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key, this.weather});

  final dynamic weather; // optional for now

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      data: (weather) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Icon(
                          weather.weatherIcon,
                          color: Colors.amber,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Darwin, NT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Australia',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => ref.refresh(weatherProvider),
                        child: const Icon(Icons.refresh, color: Colors.white70, size: 18),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Condition
              Text(
                weather.condition,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Feels like ${weather.feelsLike.toStringAsFixed(1)}°C',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),

              if (weather.maxTemp != null && weather.minTemp != null) ...[
                const SizedBox(height: 2),
                Text(
                  'H: ${weather.maxTemp!.toStringAsFixed(0)}°  L: ${weather.minTemp!.toStringAsFixed(0)}°',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
              ],

              const SizedBox(height: 12),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 12),

              // Bottom stats
              Row(
                children: [
                  _weatherStat(Icons.water_drop, '${weather.humidity.toStringAsFixed(0)}%', 'Humidity'),
                  const SizedBox(width: 24),
                  _weatherStat(Icons.umbrella, '${weather.rainfall.toStringAsFixed(1)} mm', 'Rainfall'),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
      error: (error, stack) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          children: [
            const Icon(Icons.cloud_off, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            const Text('Unable to load weather', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => ref.refresh(weatherProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherStat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}