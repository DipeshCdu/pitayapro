import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double rainfall;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.rainfall,
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
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation'
      '&timezone=auto',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final current = data['current'];

      return WeatherData(
        temperature: (current['temperature_2m'] as num).toDouble(),
        feelsLike: (current['apparent_temperature'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toDouble(),
        rainfall: (current['precipitation'] as num).toDouble(),
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}