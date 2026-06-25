// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffEntity _$StaffEntityFromJson(Map<String, dynamic> json) => _StaffEntity(
  id: (json['id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  academicTitle: json['academic_title'] as String? ?? '',
  role: $enumDecode(_$StaffRoleEnumMap, json['role']),
  email: json['login_email'] as String? ?? '',
);

Map<String, dynamic> _$StaffEntityToJson(_StaffEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'academic_title': instance.academicTitle,
      'role': _$StaffRoleEnumMap[instance.role]!,
      'login_email': instance.email,
    };

const _$StaffRoleEnumMap = {
  StaffRole.nurse: 'PIELEGNIARZ',
  StaffRole.paramedic: 'RATOWNIK',
  StaffRole.doctor: 'LEKARZ',
  StaffRole.admin: 'ADMIN',
};
