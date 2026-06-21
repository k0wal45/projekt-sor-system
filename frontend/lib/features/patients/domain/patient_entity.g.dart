// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientEntity _$PatientEntityFromJson(Map<String, dynamic> json) =>
    _PatientEntity(
      pesel: json['pesel'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthDate: const PatientBirthDateConverter().fromJson(
        json['date_of_birth'] as String,
      ),
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      emergencyContactName: json['emergency_contact_name'] as String,
      emergencyContactPhone: json['emergency_contact_phone'] as String,
      bloodGroup: $enumDecodeNullable(_$BloodGroupEnumMap, json['blood_group']),
      allergies: json['allergies'] as String,
      chronicDiseases: json['chronic_diseases'] as String,
    );

Map<String, dynamic> _$PatientEntityToJson(
  _PatientEntity instance,
) => <String, dynamic>{
  'pesel': instance.pesel,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'date_of_birth': const PatientBirthDateConverter().toJson(instance.birthDate),
  'gender': _$GenderEnumMap[instance.gender]!,
  'address': instance.address,
  'phone': instance.phone,
  'email': instance.email,
  'emergency_contact_name': instance.emergencyContactName,
  'emergency_contact_phone': instance.emergencyContactPhone,
  'blood_group': _$BloodGroupEnumMap[instance.bloodGroup],
  'allergies': instance.allergies,
  'chronic_diseases': instance.chronicDiseases,
};

const _$GenderEnumMap = {Gender.m: 'M', Gender.k: 'K', Gender.other: 'INNY'};

const _$BloodGroupEnumMap = {
  BloodGroup.aPlus: 'A+',
  BloodGroup.aMinus: 'A-',
  BloodGroup.bPlus: 'B+',
  BloodGroup.bMinus: 'B-',
  BloodGroup.abPlus: 'AB+',
  BloodGroup.abMinus: 'AB-',
  BloodGroup.oPlus: '0+',
  BloodGroup.oMinus: '0-',
};
