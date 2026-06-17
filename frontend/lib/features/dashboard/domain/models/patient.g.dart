// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Patient _$PatientFromJson(Map<String, dynamic> json) => _Patient(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  pesel: json['pesel'] as String,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  gender: json['gender'] as String?,
);

Map<String, dynamic> _$PatientToJson(_Patient instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'pesel': instance.pesel,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'gender': instance.gender,
};
