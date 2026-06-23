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
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'academic_title') @Default('') String academicTitle,
    @JsonKey(name: 'role') required StaffRole role,
    @JsonKey(name: 'login_email') @Default('') String email,
  }) = _StaffEntity;

  factory StaffEntity.fromJson(Map<String, dynamic> json) =>
      _$StaffEntityFromJson(json);
}
