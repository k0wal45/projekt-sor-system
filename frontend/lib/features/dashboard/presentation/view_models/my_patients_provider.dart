import 'package:esor/features/admissions/data/admission_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../features/admissions/domain/admission_entity.dart';
import '../../../../features/auth/presentation/view_models/auth_view_model.dart';
import '../../../../features/staff/domain/staff_entity.dart';

part 'my_patients_provider.g.dart';

@riverpod
class MyPatients extends _$MyPatients {
  @override
  FutureOr<List<AdmissionEntity>> build() async {
    final user = ref.watch(authViewModelProvider).value;
    if (user == null || user.role != StaffRole.doctor) return [];

    final repo = ref.watch(admissionRepositoryProvider);

    final result1 = await repo.getAdmissions(
      status: AdmissionStatus.inConsultation,
    );
    final result2 = await repo.getAdmissions(
      status: AdmissionStatus.waitingForResults,
    );

    List<AdmissionEntity> list = [];
    result1.fold((l) => null, (r) => list.addAll(r));
    result2.fold((l) => null, (r) => list.addAll(r));

    return list.where((a) => a.doctorId == user.id).toList();
  }
}
