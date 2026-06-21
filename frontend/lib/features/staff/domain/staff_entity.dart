import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_entity.freezed.dart';
part 'staff_entity.g.dart';

enum StaffRole {
  @JsonValue('PIELEGNIARZ')
  nurse('PIELEGNIARZ'),
  @JsonValue('RATOWNIK')
  paramedic('RATOWNIK'),
  @JsonValue('LEKARZ')
  doctor('LEKARZ'),
  @JsonValue('ADMIN')
  admin('ADMIN');

  final String value;
  const StaffRole(this.value);
}

extension StaffRoleDisplay on StaffRole {
  String get displayName {
    switch (this) {
      case StaffRole.nurse:
        return 'Pielęgniarka/Pielęgniarz';
      case StaffRole.paramedic:
        return 'Ratownik medyczny';
      case StaffRole.doctor:
        return 'Lekarz';
      case StaffRole.admin:
        return 'Administrator';
    }
  }
}

@freezed
abstract class StaffEntity with _$StaffEntity {
  const factory StaffEntity({
    @JsonKey(name: 'ID') required int id,
    @JsonKey(name: 'FirstName') required String firstName,
    @JsonKey(name: 'LastName') required String lastName,
    @JsonKey(name: 'AcademicTitle') required String academicTitle,
    @JsonKey(name: 'Role') required StaffRole role,
    @JsonKey(name: 'LoginEmail') @Default('') String email,
  }) = _StaffEntity;

  factory StaffEntity.fromJson(Map<String, dynamic> json) =>
      _$StaffEntityFromJson(json);
}
