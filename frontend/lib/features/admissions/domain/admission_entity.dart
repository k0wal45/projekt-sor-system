import 'package:freezed_annotation/freezed_annotation.dart';

import '../../patients/domain/patient_entity.dart';

part 'admission_entity.freezed.dart';
part 'admission_entity.g.dart';

enum ArrivalMode {
  @JsonValue('Pieszo')
  onFoot('Pieszo'),
  @JsonValue('Karetka publiczna')
  publicAmbulance('Karetka publiczna'),
  @JsonValue('Pojazd prywatny')
  privateVehicle('Pojazd prywatny'),
  @JsonValue('Karetka prywatna')
  privateAmbulance('Karetka prywatna'),
  @JsonValue('Inne')
  other('Inne');

  final String value;
  const ArrivalMode(this.value);
}

enum MentalStatus {
  @JsonValue('W pełni świadomy')
  fullyConscious('W pełni świadomy'),
  @JsonValue('Reaguje na głos')
  reactsToVoice('Reaguje na głos'),
  @JsonValue('Reaguje tylko na ból')
  reactsToPain('Reaguje tylko na ból'),
  @JsonValue('Nieprzytomny/Brak reakcji')
  unresponsive('Nieprzytomny/Brak reakcji');

  final String value;
  const MentalStatus(this.value);
}

enum AdmissionStatus {
  @JsonValue('W_POCZEKALNI')
  inQueue('W_POCZEKALNI'),
  @JsonValue('W_GABINECIE')
  inConsultation('W_GABINECIE'),
  @JsonValue('OCZEKUJE_NA_WYNIKI')
  waitingForResults('OCZEKUJE_NA_WYNIKI'),
  @JsonValue('ZAKONCZONE')
  completed('ZAKONCZONE');

  final String value;
  const AdmissionStatus(this.value);
}

@freezed
abstract class AdmissionEntity with _$AdmissionEntity {
  const factory AdmissionEntity({
    required int id,
    @JsonKey(name: 'id_pacjenta') required int patientId,
    @JsonKey(name: 'id_osoby_przyjmujacej') required int registrarId,
    @JsonKey(name: 'id_lekarza_prowadzacego') int? doctorId,
    @JsonKey(name: 'data_przyjecia') required DateTime admissionDate,
    @JsonKey(name: 'forma_przybycia') required ArrivalMode arrivalMode,
    required bool injury,
    @JsonKey(name: 'mental_status') required MentalStatus mentalStatus,
    required bool pain,
    @JsonKey(name: 'pain_lvl') required int painLevel,
    required int hr,
    required int sbp,
    required int dbp,
    required int rr,
    required double bt,
    @JsonKey(name: 'chief_complaint') required String chiefComplaint,
    @JsonKey(name: 'priority_ktas') required int priorityKtas,
    @JsonKey(name: 'is_ai_predicted') required bool isAiPredicted,
    @JsonKey(name: 'status_przyjecia') required AdmissionStatus status,
    PatientEntity? patient,
  }) = _AdmissionEntity;

  factory AdmissionEntity.fromJson(Map<String, dynamic> json) =>
      _$AdmissionEntityFromJson(json);
}
