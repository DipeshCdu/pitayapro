import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double rainfall;
  final double? maxTemp;
  final double? minTemp;
  final String condition;
  final IconData weatherIcon;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.rainfall,
    this.maxTemp,
    this.minTemp,
    required this.condition,
    required this.weatherIcon,
  });
}

class WeatherService {
  // Darwin, Northern Territory
  static const double lat = -12.4634;
  static const double lon = 130.8456;

  static Future<WeatherData> getCurrentWeather() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat'
      '&longitude=$lon'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code'
      '&daily=temperature_2m_max,temperature_2m_min'
      '&timezone=auto'
      '&forecast_days=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final current = data['current'];
      final daily = data['daily'];

      final weatherCode = current['weather_code'] as int;
      final conditionInfo = _getWeatherCondition(weatherCode);

      return WeatherData(
        temperature: (current['temperature_2m'] as num).toDouble(),
        feelsLike: (current['apparent_temperature'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toDouble(),
        rainfall: (current['precipitation'] as num).toDouble(),
        maxTemp: (daily['temperature_2m_max'][0] as num).toDouble(),
        minTemp: (daily['temperature_2m_min'][0] as num).toDouble(),
        condition: conditionInfo['text'] as String,
        weatherIcon: conditionInfo['icon'] as IconData,
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  static Map<String, dynamic> _getWeatherCondition(int code) {
    // WMO Weather interpretation codes
    if (code == 0) {
      return {'text': 'Clear Sky', 'icon': Icons.wb_sunny};
    } else if (code == 1 || code == 2) {
      return {'text': 'Partly Cloudy', 'icon': Icons.wb_cloudy};
    } else if (code == 3) {
      return {'text': 'Overcast', 'icon': Icons.cloud};
    } else if (code == 45 || code == 48) {
      return {'text': 'Foggy', 'icon': Icons.foggy};
    } else if (code >= 51 && code <= 67) {
      return {'text': 'Rainy', 'icon': Icons.umbrella};
    } else if (code >= 71 && code <= 77) {
      return {'text': 'Snowy', 'icon': Icons.ac_unit};
    } else if (code >= 80 && code <= 82) {
      return {'text': 'Rain Showers', 'icon': Icons.beach_access};
    } else if (code >= 95) {
      return {'text': 'Thunderstorm', 'icon': Icons.thunderstorm};
    } else {
      return {'text': 'Cloudy', 'icon': Icons.cloud};
    }
  }
}