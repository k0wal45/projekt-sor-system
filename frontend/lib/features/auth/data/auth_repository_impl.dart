import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/secure_storage_service.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final storage = ref.watch(secureStorageServiceProvider);
  return AuthRepositoryImpl(dio, storage);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SecureStorageService _storage;

  AuthRepositoryImpl(this._dio, this._storage);

  @override
  Future<Either<String, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'login_email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      await _storage.saveToken(token);

      final user = UserEntity.fromJson(
        response.data['user'] as Map<String, dynamic>,
      );
      return right(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return left('Nieprawidłowy email lub hasło.');
      }
      return left('Błąd połączenia z serwerem: ${e.message}');
    } catch (e) {
      return left('Wystąpił nieoczekiwany błąd: $e');
    }
  }

  @override
  Future<Either<String, UserEntity>> getMe() async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        return left('Brak tokenu. Użytkownik niezalogowany.');
      }

      final response = await _dio.get('/auth/me');
      final user = UserEntity.fromJson(response.data as Map<String, dynamic>);
      return right(user);
    } catch (e) {
      return left('Nie udało się pobrać danych użytkownika: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.deleteToken();
  }
}
