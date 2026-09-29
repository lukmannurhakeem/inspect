import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _s = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _s;

  Future<String?> get token => _s.read(key: 'access_token');

  Future<String?> get refreshToken => _s.read(key: 'refresh_token');

  Future<DateTime?> get refreshExpiry async {
    final raw = await _s.read(key: 'refresh_expiry');
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    required DateTime refreshExpiry,
  }) async {
    await _s.write(key: 'access_token', value: token);
    await _s.write(key: 'refresh_token', value: refreshToken);
    await _s.write(
      key: 'refresh_expiry',
      value: refreshExpiry.toIso8601String(),
    );
  }

  Future<void> clearTokens() => _s.deleteAll();
}
