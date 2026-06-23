import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../../admissions/domain/admission_entity.dart';
import '../domain/doctor_repository.dart';

part 'doctor_repository_impl.g.dart';

@Riverpod(keepAlive: true)
DoctorRepository doctorRepository(Ref ref) {
  return DoctorRepositoryImpl(ref.watch(dioClientProvider));
}

class DoctorRepositoryImpl implements DoctorRepository {
  final Dio _dio;

  DoctorRepositoryImpl(this._dio);

  @override
  Future<Either<String, List<AdmissionEntity>>> getDoctorAdmissions({bool history = false}) async {
    try {
      final response = await _dio.get(
        '/doctor/admissions',
        queryParameters: history ? {'history': 'true'} : null,
      );
      final List<dynamic> data = response.data;
      final admissions = data.map((json) => AdmissionEntity.fromJson(json)).toList();
      return right(admissions);
    } catch (e) {
      return left('Nie udało się pobrać przypisanych pacjentów: $e');
    }
  }

  @override
  Future<Either<String, void>> assignPatient(int admissionId) async {
    try {
      await _dio.put('/admissions/$admissionId/assign');
      return right(null);
    } catch (e) {
      return left('Nie udało się przypisać pacjenta: $e');
    }
  }

  @override
  Future<Either<String, void>> updateAdmissionStatus(int admissionId, AdmissionStatus status) async {
    try {
      await _dio.patch(
        '/admissions/$admissionId/status',
        data: {'status_przyjecia': status.value},
      );
      return right(null);
    } catch (e) {
      return left('Nie udało się zaktualizować statusu: $e');
    }
  }

  @override
  Future<Either<String, void>> orderDiagnostics(int admissionId, String testType, String description) async {
    try {
      await _dio.post(
        '/diagnostic-orders',
        data: {
          'id_przyjecia': admissionId,
          'typ_badania': testType,
          'opis_zlecenia': description,
        },
      );
      return right(null);
    } catch (e) {
      return left('Nie udało się zlecić badania: $e');
    }
  }

  @override
  Future<Either<String, void>> completeConsultation(int admissionId, String interview, String icd10, String decision) async {
    try {
      await _dio.post(
        '/consultations',
        data: {
          'id_przyjecia': admissionId,
          'wywiad_lekarski': interview,
          'rozpoznanie_icd10': icd10,
          'decyzja_wyjsciowa': decision,
        },
      );
      return right(null);
    } catch (e) {
      return left('Nie udało się zakończyć konsultacji: $e');
    }
  }
}
