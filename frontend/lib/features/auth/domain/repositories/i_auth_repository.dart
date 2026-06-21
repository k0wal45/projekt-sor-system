import 'package:fpdart/fpdart.dart';
import '../../../../core/network/failure.dart';
import '../models/user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> fetchProfile();
  Future<Either<Failure, void>> logout();
}
