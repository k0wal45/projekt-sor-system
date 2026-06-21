import 'package:fpdart/fpdart.dart';
import 'user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> login(String email, String password);
  Future<Either<String, UserEntity>> getMe();
  Future<void> logout();
}
