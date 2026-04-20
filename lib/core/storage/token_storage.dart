import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;

  TokenStorage() : _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveOnboardingStatus(String userId, bool status) async {
    await _storage.write(key: 'onboarded_$userId', value: status.toString());
  }

  Future<bool> getOnboardingStatus(String userId) async {
    final value = await _storage.read(key: 'onboarded_$userId');
    return value == 'true';
  }
}
