import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../models/staff.dart';

abstract class AuthRepository {
  Future<Either<Failure, Staff>> login(String email, String password);
}
