import 'package:fpdart/fpdart.dart';
import '../../staff/domain/staff_entity.dart';

abstract class AuthRepository {
  Future<Either<String, StaffEntity>> login(String email, String password);
  Future<Either<String, StaffEntity>> getMe();
  Future<void> logout();
}
