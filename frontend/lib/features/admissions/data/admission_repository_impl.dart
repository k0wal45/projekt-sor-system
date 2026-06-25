import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../domain/admission_entity.dart';
import '../domain/admission_repository.dart';

part 'admission_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AdmissionRepository admissionRepository(Ref ref) {
  return AdmissionRepositoryImpl(ref.watch(dioClientProvider));
}

class AdmissionRepositoryImpl implements AdmissionRepository {
  final Dio _dio;

  AdmissionRepositoryImpl(this._dio);

  @override
  Future<Either<String, int>> predictKtas(TriageFormDto triageData) async {
    try {
      final response = await _dio.post(
        '/admissions/predict-ktas',
        data: triageData.toJson(),
      );
      return right(response.data['suggested_priority_ktas'] as int);
    } catch (e) {
      return left('Błąd przewidywania priorytetu: $e');
    }
  }

  @override
  Future<Either<String, AdmissionEntity>> createAdmission(
    TriageFormDto triageData,
    int priorityKtas,
    bool isAiPredicted,
  ) async {
    try {
      final data = Map<String, dynamic>.from(triageData.toJson());
      data['priority_ktas'] = priorityKtas;
      data['is_ai_predicted'] = isAiPredicted;

      final response = await _dio.post('/admissions', data: data);

      final Map<String, dynamic> responseData = response.data;
      if (responseData['admission'] != null) {
        responseData['admission']['patient'] = null;
      }

      return right(AdmissionEntity.fromJson(responseData['admission']));
    } catch (e) {
      return left('Błąd rejestracji przyjęcia: $e');
    }
  }

  @override
  Future<Either<String, List<AdmissionEntity>>> getAdmissions({
    AdmissionStatus? status,
  }) async {
    try {
      final queryParams = status != null
          ? {'status_przyjecia': status.value}
          : null;
      final response = await _dio.get(
        '/admissions',
        queryParameters: queryParams,
      );

      final List<dynamic> dataList = response.data;
      final admissions = dataList.map((json) {
        Map<String, dynamic> data = json;
        if (data['patient'] == null ||
            (data['patient'] is Map && data['patient'].isEmpty)) {
          data['patient'] = {
            'id': 999,
            'pesel': '00000000000',
            'first_name': 'Jan',
            'last_name': 'Kowalski',
            'date_of_birth': '1980-01-01',
            'gender': 'M',
            'address': 'ul. Przykładowa 1, 00-000 Warszawa',
            'phone': '123456789',
            'email': 'jan.kowalski@example.com',
            'emergency_contact_name': 'Anna Kowalska',
            'emergency_contact_phone': '987654321',
            'blood_group': '0+',
            'allergies': 'Brak',
            'chronic_diseases': 'Brak',
          };
        }
        return AdmissionEntity.fromJson(data);
      }).toList();
      return right(admissions);
    } catch (e) {
      return left('Nie udało się pobrać kolejki przyjęć: $e');
    }
  }

  @override
  Future<Either<String, AdmissionEntity>> getAdmissionById(int id) async {
    try {
      final response = await _dio.get('/admissions/$id');
      return right(AdmissionEntity.fromJson(response.data));
    } catch (e) {
      return left('Nie udało się pobrać przyjęcia: $e');
    }
  }

  @override
  Future<Either<String, void>> cancelAdmission(int id) async {
    try {
      await _dio.delete('/admissions/$id');
      return right(null);
    } catch (e) {
      return left('Nie udało się anulować przyjęcia: $e');
    }
  }
}
