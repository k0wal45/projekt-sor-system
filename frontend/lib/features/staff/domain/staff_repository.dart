import 'package:fpdart/fpdart.dart';
import 'staff_entity.dart';

abstract class StaffRepository {
  Future<Either<String, List<StaffEntity>>> getStaff({String? query});
}
