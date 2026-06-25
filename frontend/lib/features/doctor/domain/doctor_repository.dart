import 'package:fpdart/fpdart.dart';
import '../../admissions/domain/admission_entity.dart';

abstract class DoctorRepository {
  Future<Either<String, List<AdmissionEntity>>> getDoctorAdmissions({bool history = false});
  Future<Either<String, void>> assignPatient(int admissionId);
  Future<Either<String, void>> updateAdmissionStatus(int admissionId, AdmissionStatus status);
  Future<Either<String, void>> orderDiagnostics(int admissionId, String testType, String description);
  Future<Either<String, void>> completeConsultation(int admissionId, String interview, String icd10, String decision);
}
