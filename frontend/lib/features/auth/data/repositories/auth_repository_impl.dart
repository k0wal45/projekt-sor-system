import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/models/staff.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_mock_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthMockDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Staff>> login(String email, String password) async {
    try {
      final staff = await dataSource.login(email, password);
      return Right(staff);
    } on InvalidCredentialsException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
