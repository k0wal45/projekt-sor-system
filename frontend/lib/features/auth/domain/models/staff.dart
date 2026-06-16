import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

enum StaffRole {
  @JsonValue('nurse')
  nurse,
  @JsonValue('paramedic')
  paramedic,
  @JsonValue('doctor')
  doctor,
  @JsonValue('admin')
  admin,
}

@freezed
abstract class Staff with _$Staff {
  const factory Staff({
    required String id,
    required String firstName,
    required String lastName,
    String? academicTitle,
    required StaffRole role,
    required String loginEmail,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
}
