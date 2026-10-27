import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/api_config.dart';
import '../../../core/network/api_exception.dart';

class AuthApi {
  final http.Client _client;

  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    final body = {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'firstName': firstName,
      'lastName': lastName,
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        'phoneNumber': phoneNumber,
    };

    final res = await _client
        .post(
          _uri('/api/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);

    return _handle(res, okCodes: {201});
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _client
        .post(
          _uri('/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        )
        .timeout(ApiConfig.timeout);

    return _handle(res, okCodes: {200});
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final res = await _client
        .post(
          _uri('/api/auth/refresh'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        )
        .timeout(ApiConfig.timeout);

    return _handle(res, okCodes: {200});
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _client
          .post(
            _uri('/api/auth/logout'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(ApiConfig.timeout);
    } catch (_) {
      // Still clear local tokens even if this fails
    }
  }

  Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    final res = await _client
        .get(
          _uri('/api/index'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        )
        .timeout(ApiConfig.timeout);

    return _handle(res, okCodes: {200});
  }

  Map<String, dynamic> _handle(
    http.Response res, {
    required Set<int> okCodes,
  }) {
    if (okCodes.contains(res.statusCode)) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body) as Map<String, dynamic>;
    }

    String message = 'Request failed (${res.statusCode})';
    try {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      message = (json['detail'] ?? json['title'] ?? message).toString();
    } catch (_) {}

    throw ApiException(message, statusCode: res.statusCode);
  }
}