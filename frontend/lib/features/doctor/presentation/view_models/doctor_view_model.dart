import 'package:esor/core/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../admissions/domain/admission_entity.dart';

part 'doctor_view_model.g.dart';

@riverpod
class DoctorViewModel extends _$DoctorViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> assignPatient(int admissionId) async {
    state = const AsyncValue.loading();
    final repo = ref.read(doctorRepositoryProvider);
    final result = await repo.assignPatient(admissionId);

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    return !state.hasError;
  }

  Future<bool> updateStatus(int admissionId, AdmissionStatus status) async {
    state = const AsyncValue.loading();
    final repo = ref.read(doctorRepositoryProvider);
    final result = await repo.updateAdmissionStatus(admissionId, status);

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    return !state.hasError;
  }

  Future<bool> orderDiagnostics(
    int admissionId,
    String testType,
    String desc,
  ) async {
    state = const AsyncValue.loading();
    final repo = ref.read(doctorRepositoryProvider);
    final result = await repo.orderDiagnostics(admissionId, testType, desc);

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    return !state.hasError;
  }

  Future<bool> completeConsultation(
    int admissionId,
    String interview,
    String icd10,
    String decision,
  ) async {
    state = const AsyncValue.loading();
    final repo = ref.read(doctorRepositoryProvider);
    final result = await repo.completeConsultation(
      admissionId,
      interview,
      icd10,
      decision,
    );

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    return !state.hasError;
  }
}
