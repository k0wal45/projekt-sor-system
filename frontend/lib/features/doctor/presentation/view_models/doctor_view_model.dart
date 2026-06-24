import 'package:esor/core/providers/repository_providers.dart';
import 'package:esor/features/dashboard/presentation/view_models/my_patients_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../admissions/domain/admission_entity.dart';

part 'doctor_view_model.g.dart';

@riverpod
class AssignPatientViewModel extends _$AssignPatientViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> invoke(int admissionId) async {
    state = const AsyncValue.loading();
    final repo = ref.read(doctorRepositoryProvider);
    final result = await repo.assignPatient(admissionId);

    if (!ref.mounted) return false;

    state = result.fold((err) => AsyncValue.error(err, StackTrace.current), (
      _,
    ) {
      ref.invalidate(myPatientsProvider);
      return const AsyncValue.data(null);
    });
    return !state.hasError;
  }
}

@riverpod
class UpdateStatusViewModel extends _$UpdateStatusViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> invoke(int admissionId, AdmissionStatus status) async {
    state = const AsyncValue.loading();
    final repo = ref.read(doctorRepositoryProvider);
    final result = await repo.updateAdmissionStatus(admissionId, status);

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    return !state.hasError;
  }
}

@riverpod
class OrderDiagnosticsViewModel extends _$OrderDiagnosticsViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> invoke(int admissionId, String testType, String desc) async {
    state = const AsyncValue.loading();
    final repo = ref.read(doctorRepositoryProvider);
    final result = await repo.orderDiagnostics(admissionId, testType, desc);

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    return !state.hasError;
  }
}

@riverpod
class CompleteConsultationViewModel extends _$CompleteConsultationViewModel {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> invoke(
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

    state = result.fold((err) => AsyncValue.error(err, StackTrace.current), (
      _,
    ) {
      ref.invalidate(myPatientsProvider);
      return const AsyncValue.data(null);
    });
    return !state.hasError;
  }
}
