import 'package:flutter/material.dart';

class WeatherModel {
  final double temperature;
  final String condition;
  final double? maxTemp;
  final double? minTemp;
  final double? feelsLike;
  final int? humidity;
  final double? rainfall;
  final IconData weatherIcon;

  WeatherModel({
    required this.temperature,
    required this.condition,
    this.maxTemp,
    this.minTemp,
    this.feelsLike,
    this.humidity,
    this.rainfall,
    required this.weatherIcon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    String iconCode = json['weather'][0]['icon'];
    IconData icon = Icons.wb_sunny;
    
    if (iconCode.contains('n')) {
      icon = Icons.nightlight_round;
    } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      icon = Icons.water_drop;
    } else if (iconCode.startsWith('13')) {
      icon = Icons.ac_unit;
    } else if (iconCode.startsWith('50') || iconCode.startsWith('04')) {
      icon = Icons.cloud;
    }

    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'].toString(),
      maxTemp: (json['main']['temp_max'] as num?)?.toDouble(),
      minTemp: (json['main']['temp_min'] as num?)?.toDouble(),
      feelsLike: (json['main']['feels_like'] as num?)?.toDouble(),
      humidity: json['main']['humidity'] as int?,
      rainfall: (json['rain']?['1h'] as num?)?.toDouble(),
      weatherIcon: icon,
    );
  }
}