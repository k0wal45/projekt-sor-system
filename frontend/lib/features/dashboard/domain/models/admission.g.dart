// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Admission _$AdmissionFromJson(Map<String, dynamic> json) => _Admission(
  id: json['id'] as String,
  patientId: json['patientId'] as String,
  receivingStaffId: json['receivingStaffId'] as String?,
  attendingDoctorId: json['attendingDoctorId'] as String?,
  admissionTime: DateTime.parse(json['admissionTime'] as String),
  priorityKtas: (json['priorityKtas'] as num).toInt(),
  chiefComplaint: json['chiefComplaint'] as String,
  status: $enumDecode(_$AdmissionStatusEnumMap, json['status']),
);

Map<String, dynamic> _$AdmissionToJson(_Admission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'receivingStaffId': instance.receivingStaffId,
      'attendingDoctorId': instance.attendingDoctorId,
      'admissionTime': instance.admissionTime.toIso8601String(),
      'priorityKtas': instance.priorityKtas,
      'chiefComplaint': instance.chiefComplaint,
      'status': _$AdmissionStatusEnumMap[instance.status]!,
    };

const _$AdmissionStatusEnumMap = {
  AdmissionStatus.inWaitingRoom: 'W_POCZEKALNI',
  AdmissionStatus.inOffice: 'W_GABINECIE',
  AdmissionStatus.waitingForResults: 'OCZEKUJE_NA_WYNIKI',
  AdmissionStatus.completed: 'ZAKONCZONE',
};
