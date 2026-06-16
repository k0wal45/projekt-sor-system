// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Staff _$StaffFromJson(Map<String, dynamic> json) => _Staff(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  academicTitle: json['academicTitle'] as String?,
  role: $enumDecode(_$StaffRoleEnumMap, json['role']),
  loginEmail: json['loginEmail'] as String,
);

Map<String, dynamic> _$StaffToJson(_Staff instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'academicTitle': instance.academicTitle,
  'role': _$StaffRoleEnumMap[instance.role]!,
  'loginEmail': instance.loginEmail,
};

const _$StaffRoleEnumMap = {
  StaffRole.nurse: 'nurse',
  StaffRole.paramedic: 'paramedic',
  StaffRole.doctor: 'doctor',
  StaffRole.admin: 'admin',
};
