import 'package:esor/core/network/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = SecureStorageService(mockStorage);
  });

  group('SecureStorageService', () {
    test('saveToken saves token under correct key', () async {
      when(() => mockStorage.write(key: 'jwt_token', value: 'my-token'))
          .thenAnswer((_) async {});

      await service.saveToken('my-token');

      verify(() => mockStorage.write(key: 'jwt_token', value: 'my-token')).called(1);
    });

    test('getToken returns saved token', () async {
      when(() => mockStorage.read(key: 'jwt_token'))
          .thenAnswer((_) async => 'saved-token');

      final token = await service.getToken();

      expect(token, 'saved-token');
      verify(() => mockStorage.read(key: 'jwt_token')).called(1);
    });

    test('deleteToken deletes the token', () async {
      when(() => mockStorage.delete(key: 'jwt_token'))
          .thenAnswer((_) async {});

      await service.deleteToken();

      verify(() => mockStorage.delete(key: 'jwt_token')).called(1);
    });

    test('write saves any key-value pair', () async {
      when(() => mockStorage.write(key: 'custom_key', value: 'custom_val'))
          .thenAnswer((_) async {});

      await service.write('custom_key', 'custom_val');

      verify(() => mockStorage.write(key: 'custom_key', value: 'custom_val')).called(1);
    });

    test('read reads any key', () async {
      when(() => mockStorage.read(key: 'custom_key'))
          .thenAnswer((_) async => 'custom_val');

      final val = await service.read('custom_key');

      expect(val, 'custom_val');
      verify(() => mockStorage.read(key: 'custom_key')).called(1);
    });
  });
}
