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
      TriageFormDto triageData, int priorityKtas, bool isAiPredicted) async {
    try {
      final data = Map<String, dynamic>.from(triageData.toJson());
      data['priority_ktas'] = priorityKtas;
      data['is_ai_predicted'] = isAiPredicted;

      final response = await _dio.post(
        '/admissions',
        data: data,
      );
      return right(AdmissionEntity.fromJson(response.data['admission']));
    } catch (e) {
      return left('Błąd rejestracji przyjęcia: $e');
    }
  }

  @override
  Future<Either<String, List<AdmissionEntity>>> getAdmissions({AdmissionStatus? status}) async {
    try {
      final queryParams = status != null ? {'status_przyjecia': status.value} : null;
      final response = await _dio.get('/admissions', queryParameters: queryParams);
      
      final List<dynamic> dataList = response.data;
      final admissions = dataList.map((json) => AdmissionEntity.fromJson(json)).toList();
      return right(admissions);
    } catch (e) {
      return left('Nie udało się pobrać kolejki przyjęć: $e');
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
