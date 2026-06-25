import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_service.g.dart';

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) {
  final iosOptions = const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final macOsOptions = const MacOsOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final storage = FlutterSecureStorage(
    iOptions: iosOptions,
    mOptions: macOsOptions,
  );

  return SecureStorageService(storage);
}

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const _tokenKey = 'jwt_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }
}
