import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/failure.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/i_auth_repository.dart';

part 'auth_repository.g.dart';

class AuthRepository implements IAuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthRepository(this._dio, this._secureStorage);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'login_email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String;
        await _secureStorage.write(key: 'jwt_token', value: token);
        final user = User.fromJson(
          response.data['user'] as Map<String, dynamic>,
        );
        return right(user);
      } else {
        return left(
          ServerFailure('Nieoczekiwany kod odpowiedzi: ${response.statusCode}'),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return left(const AuthFailure('Błędne dane logowania'));
      }
      return left(NetworkFailure(e.message ?? 'Błąd połączenia sieciowego'));
    } catch (e) {
      return left(UnknownFailure('Nieznany błąd: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> fetchProfile() async {
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      if (token == null) {
        return left(const AuthFailure('Brak tokenu autoryzacyjnego'));
      }

      final response = await _dio.get('/auth/me');

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data as Map<String, dynamic>);
        return right(user);
      } else {
        return left(
          ServerFailure('Błąd pobierania profilu: ${response.statusCode}'),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _secureStorage.delete(key: 'jwt_token');
        return left(const AuthFailure('Sesja wygasła'));
      }
      return left(NetworkFailure(e.message ?? 'Błąd połączenia sieciowego'));
    } catch (e) {
      return left(UnknownFailure('Nieznany błąd: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _secureStorage.delete(key: 'jwt_token');
      return right(null);
    } catch (e) {
      return left(UnknownFailure('Błąd podczas wylogowywania: $e'));
    }
  }
}

@riverpod
IAuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(dio, secureStorage);
}
