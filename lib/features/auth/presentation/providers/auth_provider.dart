import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitayapro/core/network/api_client.dart';
import 'package:pitayapro/core/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final UserModel? currentUser;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.currentUser,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _apiClient;

  AuthNotifier(this._apiClient) : super(AuthState());

  static final RegExp _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,100}$');

  bool isValidPassword(String password) {
    return _passwordRegex.hasMatch(password);
  }

  Future<void> fetchCurrentUser() async {
    try {
      final response = await _apiClient.get('/api/index');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final user = UserModel.fromJson(body);
        state = AuthState(
          isLoading: state.isLoading,
          isAuthenticated: true,
          currentUser: user,
          error: null,
        );
      }
    } catch (e) {
      print('Failed to fetch user: $e');
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = AuthState(isLoading: true, error: null);
    print(' [AUTH] Starting login...');

    try {
      final response = await _apiClient.post('/api/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('✅ [AUTH] Login successful! Saving tokens...');
        await _apiClient.saveTokens(body['accessToken'], body['refreshToken']);
        
        // Fetch user profile immediately after login
        await fetchCurrentUser(); 
      } else {
        final body = jsonDecode(response.body);
        state = AuthState(isLoading: false, error: body['detail'] ?? 'Invalid email or password');
      }
    } catch (e) {
      state = AuthState(isLoading: false, error: 'Network error. Please check your connection.');
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    if (password != confirmPassword) {
      state = AuthState(error: 'Passwords do not match');
      return;
    }

    if (!isValidPassword(password)) {
      state = AuthState(error: 'Password must be 8-100 chars with 1 uppercase, 1 lowercase, and 1 number.');
      return;
    }

    state = AuthState(isLoading: true, error: null);
    print('🔄 [AUTH] Starting registration...');

    try {
      final response = await _apiClient.post('/api/auth/register', {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'firstName': firstName,
        'lastName': lastName,
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber,
      });

      if (response.statusCode == 201) {
        print('✅ [AUTH] Registration successful!');
        state = AuthState(isLoading: false, error: null);
      } else {
        final body = jsonDecode(response.body);
        print('❌ [AUTH] Registration failed: ${body['detail']}');
        state = AuthState(isLoading: false, error: body['detail'] ?? 'Registration failed');
      }
    } catch (e) {
      print(' [AUTH] Network error: $e');
      state = AuthState(isLoading: false, error: 'Network error. The server may be waking up.');
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiClientProvider));
});