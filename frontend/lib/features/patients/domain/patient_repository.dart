import 'package:fpdart/fpdart.dart';
import 'patient_entity.dart';

abstract class PatientRepository {
  Future<Either<String, List<PatientEntity>>> getPatients({String? query});
  Future<Either<String, PatientEntity>> getPatient(String pesel);
  Future<Either<String, PatientEntity>> getPatientById(int id);
  Future<Either<String, void>> createPatient(PatientEntity patient);
  Future<Either<String, void>> updatePatient(PatientEntity patient);
}
