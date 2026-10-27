import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _access = 'access_token';
  static const _refresh = 'refresh_token';
  static const _accessExp = 'access_expires';
  static const _refreshExp = 'refresh_expires';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String accessExpiresAtUtc,
    required String refreshExpiresAtUtc,
  }) async {
    await _storage.write(key: _access, value: accessToken);
    await _storage.write(key: _refresh, value: refreshToken);
    await _storage.write(key: _accessExp, value: accessExpiresAtUtc);
    await _storage.write(key: _refreshExp, value: refreshExpiresAtUtc);
  }

  Future<String?> getAccessToken() => _storage.read(key: _access);

  Future<String?> getRefreshToken() => _storage.read(key: _refresh);

  Future<bool> hasTokens() async {
    final access = await getAccessToken();
    return access != null && access.isNotEmpty;
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}