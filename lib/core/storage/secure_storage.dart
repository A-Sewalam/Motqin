import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken        = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId       = 'user_id';
  static const _keyUserEmail    = 'user_email';

  static Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  static Future<String?> getToken() =>
      _storage.read(key: _keyToken);

  static Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  static Future<void> saveUserId(String id) =>
      _storage.write(key: _keyUserId, value: id);

  static Future<String?> getUserId() =>
      _storage.read(key: _keyUserId);

  static Future<void> saveUserEmail(String email) =>
      _storage.write(key: _keyUserEmail, value: email);

  static Future<String?> getUserEmail() =>
      _storage.read(key: _keyUserEmail);

  static Future<void> clearAll() => _storage.deleteAll();
}
