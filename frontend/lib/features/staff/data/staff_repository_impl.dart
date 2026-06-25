import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../domain/staff_entity.dart';
import '../domain/staff_repository.dart';

part 'staff_repository_impl.g.dart';

@Riverpod(keepAlive: true)
StaffRepository staffRepository(Ref ref) {
  return StaffRepositoryImpl(ref.watch(dioClientProvider));
}

class StaffRepositoryImpl implements StaffRepository {
  final Dio _dio;

  StaffRepositoryImpl(this._dio);

  @override
  Future<Either<String, List<StaffEntity>>> getStaff({String? query}) async {
    try {
      final response = await _dio.get(
        '/staff',
        queryParameters: query != null && query.isNotEmpty ? {'q': query} : null,
      );
      final List<dynamic> data = response.data;
      final staff = data.map((json) => StaffEntity.fromJson(json)).toList();
      return right(staff);
    } catch (e) {
      return left('Nie udało się pobrać personelu: $e');
    }
  }
}
