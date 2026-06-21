// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffEntity _$StaffEntityFromJson(Map<String, dynamic> json) => _StaffEntity(
  id: (json['ID'] as num).toInt(),
  firstName: json['FirstName'] as String,
  lastName: json['LastName'] as String,
  academicTitle: json['AcademicTitle'] as String,
  role: $enumDecode(_$StaffRoleEnumMap, json['Role']),
  email: json['LoginEmail'] as String? ?? '',
);

Map<String, dynamic> _$StaffEntityToJson(_StaffEntity instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'FirstName': instance.firstName,
      'LastName': instance.lastName,
      'AcademicTitle': instance.academicTitle,
      'Role': _$StaffRoleEnumMap[instance.role]!,
      'LoginEmail': instance.email,
    };

const _$StaffRoleEnumMap = {
  StaffRole.nurse: 'PIELEGNIARZ',
  StaffRole.paramedic: 'RATOWNIK',
  StaffRole.doctor: 'LEKARZ',
  StaffRole.admin: 'ADMIN',
};
