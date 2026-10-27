import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  static const String baseUrl = 'https://pitaya-pro.onrender.com';
  
  // 70 seconds timeout to allow for Render.com cold starts
  static const Duration _timeout = Duration(seconds: 70);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool requiresAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (requiresAuth) 'Authorization': 'Bearer ${await getToken()}',
    };

    print('🌐 [API] POST $endpoint | Body: $body');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body.isNotEmpty ? jsonEncode(body) : null,
    ).timeout(_timeout);

    print('📡 [API] Response Status: ${response.statusCode} | Body: ${response.body}');
    return response;
  }

  Future<http.Response> get(String endpoint, {bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (requiresAuth) 'Authorization': 'Bearer ${await getToken()}',
    };

    print('🌐 [API] GET $endpoint');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    ).timeout(_timeout);

    print('📡 [API] Response Status: ${response.statusCode} | Body: ${response.body}');
    return response;
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());