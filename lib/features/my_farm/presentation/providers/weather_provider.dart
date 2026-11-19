import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/models/weather_model.dart';

// 📍 Defaulting to Darwin, NT (CDU location)
const double defaultLat = -12.4634;
const double defaultLon = 130.8456;

// Your API Key
const String apiKey = '5e8eb3e6ccf30a9a3e2e94c9007b8835';

final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final dio = Dio();
  
  try {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'lat': defaultLat,
        'lon': defaultLon,
        'appid': apiKey,
        'units': 'metric', // Celsius
      },
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load weather');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
});