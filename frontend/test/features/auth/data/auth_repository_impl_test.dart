import 'package:dio/dio.dart';
import 'package:esor/core/network/secure_storage_service.dart';
import 'package:esor/features/auth/data/auth_repository_impl.dart';
import 'package:esor/features/staff/domain/staff_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late AuthRepositoryImpl repository;
  late MockDio mockDio;
  late MockSecureStorageService mockSecureStorage;

  setUp(() {
    mockDio = MockDio();
    mockSecureStorage = MockSecureStorageService();
    repository = AuthRepositoryImpl(mockDio, mockSecureStorage);
  });

  group('AuthRepositoryImpl', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testToken = 'fake_jwt_token';

    final testUserJson = {
      'id': 1,
      'first_name': 'Jan',
      'last_name': 'Kowalski',
      'email': testEmail,
      'login_email': testEmail,
      'academic_title': 'dr',
      'role': 'LEKARZ',
      'pwz_number': '1234567',
    };

    group('login', () {
      test('returns Right(StaffEntity) on successful login and saves token', () async {
        // Arrange
        when(() => mockDio.post(
              '/auth/login',
              data: any(named: 'data'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/auth/login'),
              data: {'token': testToken, 'user': testUserJson},
              statusCode: 200,
            ));

        when(() => mockSecureStorage.saveToken(testToken)).thenAnswer((_) async {});

        // Act
        final result = await repository.login(testEmail, testPassword);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should not return left'),
          (user) {
            expect(user.email, testEmail);
            expect(user.firstName, 'Jan');
            expect(user.role, StaffRole.doctor);
          },
        );
        verify(() => mockSecureStorage.saveToken(testToken)).called(1);
      });

      test('returns Left with message on 401 Unauthorized', () async {
        // Arrange
        when(() => mockDio.post(
              '/auth/login',
              data: any(named: 'data'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          response: Response(requestOptions: RequestOptions(path: '/auth/login'), statusCode: 401),
        ));

        // Act
        final result = await repository.login(testEmail, testPassword);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, 'Nieprawidłowy email lub hasło.'),
          (r) => fail('Should not return right'),
        );
        verifyNever(() => mockSecureStorage.saveToken(any()));
      });

      test('returns Left on network error', () async {
        // Arrange
        when(() => mockDio.post(
              '/auth/login',
              data: any(named: 'data'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionError,
          message: 'Connection failed',
        ));

        // Act
        final result = await repository.login(testEmail, testPassword);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, contains('Błąd połączenia')),
          (r) => fail('Should not return right'),
        );
      });
    });

    group('getMe', () {
      test('returns Left when token is null', () async {
        // Arrange
        when(() => mockSecureStorage.getToken()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getMe();

        // Assert
        expect(result.isLeft(), isTrue);
        verifyNever(() => mockDio.get(any()));
      });

      test('returns Right(StaffEntity) when token exists and api succeeds', () async {
        // Arrange
        when(() => mockSecureStorage.getToken()).thenAnswer((_) async => testToken);
        when(() => mockDio.get('/auth/me')).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/auth/me'),
              data: testUserJson,
              statusCode: 200,
            ));

        // Act
        final result = await repository.getMe();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should not return left'),
          (user) {
            expect(user.firstName, 'Jan');
          },
        );
      });
    });

    group('logout', () {
      test('deletes token from secure storage', () async {
        // Arrange
        when(() => mockSecureStorage.deleteToken()).thenAnswer((_) async {});

        // Act
        await repository.logout();

        // Assert
        verify(() => mockSecureStorage.deleteToken()).called(1);
      });
    });
  });
}
