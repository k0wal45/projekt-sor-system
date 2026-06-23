import 'package:dio/dio.dart';
import 'package:esor/core/network/dio_client.dart';
import 'package:esor/core/network/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('DioClient Provider', () {
    test('dioClient provides Dio instance with base url', () {
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(mockStorage),
        ],
      );

      final dio = container.read(dioClientProvider);

      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, isNotEmpty);
      expect(dio.interceptors, isNotEmpty);
    });
  });

  group('Dio Interceptor', () {
    test('injects Authorization header if token exists', () async {
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(mockStorage),
        ],
      );

      when(() => mockStorage.getToken()).thenAnswer((_) async => 'fake-jwt-token');

      final dio = container.read(dioClientProvider);
      
      // Get the injected interceptor
      final interceptor = dio.interceptors.firstWhere((i) => i is InterceptorsWrapper) as InterceptorsWrapper;
      
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      interceptor.onRequest!(options, handler);
      
      await Future.delayed(const Duration(milliseconds: 50));

      expect(options.headers['Authorization'], 'Bearer fake-jwt-token');
      verify(() => handler.next(options)).called(1);
    });

    test('does not inject Authorization header if token does not exist', () async {
      final container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(mockStorage),
        ],
      );

      when(() => mockStorage.getToken()).thenAnswer((_) async => null);

      final dio = container.read(dioClientProvider);
      
      final interceptor = dio.interceptors.firstWhere((i) => i is InterceptorsWrapper) as InterceptorsWrapper;
      
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      interceptor.onRequest!(options, handler);
      
      await Future.delayed(const Duration(milliseconds: 50));

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });
  });
}
