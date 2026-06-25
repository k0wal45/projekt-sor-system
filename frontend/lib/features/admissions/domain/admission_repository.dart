import 'package:fpdart/fpdart.dart';
import 'admission_entity.dart';

class TriageFormDto {
  final int patientId;
  final ArrivalMode arrivalMode;
  final bool injury;
  final MentalStatus mentalStatus;
  final bool pain;
  final int painLevel;
  final int hr;
  final int sbp;
  final int dbp;
  final int rr;
  final double bt;
  final String chiefComplaint;

  TriageFormDto({
    required this.patientId,
    required this.arrivalMode,
    required this.injury,
    required this.mentalStatus,
    required this.pain,
    required this.painLevel,
    required this.hr,
    required this.sbp,
    required this.dbp,
    required this.rr,
    required this.bt,
    required this.chiefComplaint,
  });

  Map<String, dynamic> toJson() => {
        'id_pacjenta': patientId,
        'forma_przybycia': arrivalMode.value,
        'injury': injury,
        'mental_status': mentalStatus.value,
        'pain': pain,
        'pain_lvl': painLevel,
        'hr': hr,
        'sbp': sbp,
        'dbp': dbp,
        'rr': rr,
        'bt': bt,
        'chief_complaint': chiefComplaint,
      };
}

abstract class AdmissionRepository {
  Future<Either<String, int>> predictKtas(TriageFormDto triageData);
  Future<Either<String, AdmissionEntity>> createAdmission(
      TriageFormDto triageData, int priorityKtas, bool isAiPredicted);
  Future<Either<String, List<AdmissionEntity>>> getAdmissions({AdmissionStatus? status});
  Future<Either<String, AdmissionEntity>> getAdmissionById(int id);
  Future<Either<String, void>> cancelAdmission(int id);
}
