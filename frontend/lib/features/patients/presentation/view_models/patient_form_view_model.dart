import 'package:esor/core/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/patient_entity.dart';

part 'patient_form_view_model.g.dart';

@riverpod
class PatientFormViewModel extends _$PatientFormViewModel {
  @override
  AsyncValue<PatientEntity?> build() => const AsyncValue.data(null);

  Future<void> loadPatient(String pesel) async {
    state = const AsyncValue.loading();
    final repo = ref.read(patientRepositoryProvider);
    final result = await repo.getPatient(pesel);

    state = result.fold(
      (err) => AsyncValue.error(err, StackTrace.current),
      (patient) => AsyncValue.data(patient),
    );
  }

  Future<bool> savePatient(PatientEntity patient, bool isCreate) async {
    state = const AsyncValue.loading();
    final repo = ref.read(patientRepositoryProvider);

    final result = isCreate
        ? await repo.createPatient(patient)
        : await repo.updatePatient(patient);

    state = result.fold((err) => AsyncValue.error(err, StackTrace.current), (
      _,
    ) {
      ref.invalidate(patientRepositoryProvider);
      return AsyncValue.data(patient);
    });

    return !state.hasError;
  }
}
