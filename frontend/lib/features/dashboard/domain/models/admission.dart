import 'package:freezed_annotation/freezed_annotation.dart';

part 'admission.freezed.dart';
part 'admission.g.dart';

enum AdmissionStatus {
  @JsonValue('W_POCZEKALNI')
  inWaitingRoom,
  @JsonValue('W_GABINECIE')
  inOffice,
  @JsonValue('OCZEKUJE_NA_WYNIKI')
  waitingForResults,
  @JsonValue('ZAKONCZONE')
  completed;

  String get label {
    switch (this) {
      case AdmissionStatus.inWaitingRoom:
        return 'W poczekalni';
      case AdmissionStatus.inOffice:
        return 'W gabinecie';
      case AdmissionStatus.waitingForResults:
        return 'Oczekuje na wyniki';
      case AdmissionStatus.completed:
        return 'Zakończone';
    }
  }
}

@freezed
abstract class Admission with _$Admission {
  const factory Admission({
    required String id,
    required String patientId,
    String? receivingStaffId,
    String? attendingDoctorId,
    required DateTime admissionTime,
    required int priorityKtas,
    required String chiefComplaint,
    required AdmissionStatus status,
  }) = _Admission;

  factory Admission.fromJson(Map<String, dynamic> json) =>
      _$AdmissionFromJson(json);
}
