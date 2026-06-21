import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../domain/patient_entity.dart';
import '../domain/patient_repository.dart';

part 'patient_repository_impl.g.dart';

@Riverpod(keepAlive: true)
PatientRepository patientRepository(Ref ref) {
  return PatientRepositoryImpl(ref.watch(dioClientProvider));
}

class PatientRepositoryImpl implements PatientRepository {
  final Dio _dio;

  PatientRepositoryImpl(this._dio);

  @override
  Future<Either<String, List<PatientEntity>>> getPatients({
    String? query,
  }) async {
    try {
      final response = await _dio.get(
        '/patients',
        queryParameters: query != null && query.isNotEmpty
            ? {'last_name': query}
            : null,
      );
      final List<dynamic> data = response.data;
      final patients = data
          .map((json) => PatientEntity.fromJson(json))
          .toList();
      return right(patients);
    } catch (e) {
      return left('Nie udało się pobrać pacjentów: $e');
    }
  }

  @override
  Future<Either<String, PatientEntity>> getPatient(String pesel) async {
    try {
      final response = await _dio.get('/patients/$pesel');
      return right(PatientEntity.fromJson(response.data));
    } catch (e) {
      return left('Nie udało się pobrać pacjenta: $e');
    }
  }

  @override
  Future<Either<String, void>> createPatient(PatientEntity patient) async {
    try {
      await _dio.post('/patients', data: patient.toJson());
      return right(null);
    } catch (e) {
      return left('Nie udało się zapisać pacjenta: $e');
    }
  }

  @override
  Future<Either<String, void>> updatePatient(PatientEntity patient) async {
    try {
      await _dio.put(
        '/patients/${patient.pesel}',
        data: patient.toJson(),
      );
      return right(null);
    } catch (e) {
      return left('Nie udało się zaktualizować pacjenta: $e');
    }
  }
}
