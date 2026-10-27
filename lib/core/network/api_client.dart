import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  static const String baseUrl = 'https://pitaya-pro.onrender.com';
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

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String endpoint) async {
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
    ).timeout(_timeout);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(requiresAuth: !endpoint.contains('/auth/')), // Auth endpoints don't need token
      body: jsonEncode(body),
    ).timeout(_timeout);
  }

  // 👇 ADDED PUT for Updates
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: jsonEncode(body),
    ).timeout(_timeout);
  }

  // 👇 ADDED DELETE for Deletions
  Future<http.Response> delete(String endpoint) async {
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(),
    ).timeout(_timeout);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());