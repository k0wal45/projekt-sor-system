// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admission_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdmissionEntity _$AdmissionEntityFromJson(Map<String, dynamic> json) =>
    _AdmissionEntity(
      id: (json['id'] as num).toInt(),
      patientId: (json['id_pacjenta'] as num).toInt(),
      registrarId: (json['id_osoby_przyjmujacej'] as num).toInt(),
      doctorId: (json['id_lekarza_prowadzacego'] as num?)?.toInt(),
      admissionDate: DateTime.parse(json['data_przyjecia'] as String),
      arrivalMode: $enumDecode(_$ArrivalModeEnumMap, json['forma_przybycia']),
      injury: json['injury'] as bool,
      mentalStatus: $enumDecode(_$MentalStatusEnumMap, json['mental_status']),
      pain: json['pain'] as bool,
      painLevel: (json['pain_lvl'] as num).toInt(),
      hr: (json['hr'] as num).toInt(),
      sbp: (json['sbp'] as num).toInt(),
      dbp: (json['dbp'] as num).toInt(),
      rr: (json['rr'] as num).toInt(),
      bt: (json['bt'] as num).toDouble(),
      chiefComplaint: json['chief_complaint'] as String,
      priorityKtas: (json['priority_ktas'] as num).toInt(),
      isAiPredicted: json['is_ai_predicted'] as bool,
      status: $enumDecode(_$AdmissionStatusEnumMap, json['status_przyjecia']),
    );

Map<String, dynamic> _$AdmissionEntityToJson(_AdmissionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_pacjenta': instance.patientId,
      'id_osoby_przyjmujacej': instance.registrarId,
      'id_lekarza_prowadzacego': instance.doctorId,
      'data_przyjecia': instance.admissionDate.toIso8601String(),
      'forma_przybycia': _$ArrivalModeEnumMap[instance.arrivalMode]!,
      'injury': instance.injury,
      'mental_status': _$MentalStatusEnumMap[instance.mentalStatus]!,
      'pain': instance.pain,
      'pain_lvl': instance.painLevel,
      'hr': instance.hr,
      'sbp': instance.sbp,
      'dbp': instance.dbp,
      'rr': instance.rr,
      'bt': instance.bt,
      'chief_complaint': instance.chiefComplaint,
      'priority_ktas': instance.priorityKtas,
      'is_ai_predicted': instance.isAiPredicted,
      'status_przyjecia': _$AdmissionStatusEnumMap[instance.status]!,
    };

const _$ArrivalModeEnumMap = {
  ArrivalMode.pieszo: 'Pieszo',
  ArrivalMode.karetkaPubliczna: 'Karetka publiczna',
  ArrivalMode.pojazdPrywatny: 'Pojazd prywatny',
  ArrivalMode.karetkaPrywatna: 'Karetka prywatna',
  ArrivalMode.inne: 'Inne',
};

const _$MentalStatusEnumMap = {
  MentalStatus.fullyConscious: 'W pełni świadomy',
  MentalStatus.reactsToVoice: 'Reaguje na głos',
  MentalStatus.reactsToPain: 'Reaguje tylko na ból',
  MentalStatus.unresponsive: 'Nieprzytomny/Brak reakcji',
};

const _$AdmissionStatusEnumMap = {
  AdmissionStatus.inQueue: 'W_POCZEKALNI',
  AdmissionStatus.inConsultation: 'W_GABINECIE',
  AdmissionStatus.waitingForResults: 'OCZEKUJE_NA_WYNIKI',
  AdmissionStatus.completed: 'ZAKONCZONE',
};
