import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/token_storage.dart';
import '../../data/auth_api.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final String? error;
  final String? email;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.isLoading = false,
    this.error,
    this.email,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? error,
    String? email,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      email: email ?? this.email,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi _api;
  final TokenStorage _storage;

  AuthNotifier(this._api, this._storage) : super(const AuthState()) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final has = await _storage.hasTokens();
    state = state.copyWith(
      status: has ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _api.login(email: email, password: password);
      await _storage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        accessExpiresAtUtc: data['accessTokenExpiresAtUtc'] as String,
        refreshExpiresAtUtc: data['refreshTokenExpiresAtUtc'] as String,
      );
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.authenticated,
        email: email,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.unauthenticated,
        error: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.unauthenticated,
        error: 'Login failed. Server may be waking up — try again.',
      );
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
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _api.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.unauthenticated,
        clearError: true,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Register failed. Server may be waking up — try again.',
      );
    }
  }

  Future<void> logout() async {
    final refresh = await _storage.getRefreshToken();
    if (refresh != null) {
      await _api.logout(refresh);
    }
    await _storage.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authApiProvider = Provider((ref) => AuthApi());
final tokenStorageProvider = Provider((ref) => TokenStorage());

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authApiProvider),
    ref.watch(tokenStorageProvider),
  );
});