import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_entity.freezed.dart';
part 'patient_entity.g.dart';

enum Gender {
  @JsonValue('M')
  m('M'),
  @JsonValue('K')
  k('K'),
  @JsonValue('INNY')
  other('INNY');

  final String value;
  const Gender(this.value);
}

enum BloodGroup {
  @JsonValue('A+')
  aPlus('A+'),
  @JsonValue('A-')
  aMinus('A-'),
  @JsonValue('B+')
  bPlus('B+'),
  @JsonValue('B-')
  bMinus('B-'),
  @JsonValue('AB+')
  abPlus('AB+'),
  @JsonValue('AB-')
  abMinus('AB-'),
  @JsonValue('0+')
  oPlus('0+'),
  @JsonValue('0-')
  oMinus('0-');

  final String value;
  const BloodGroup(this.value);
}

class PatientBirthDateConverter implements JsonConverter<DateTime, String> {
  const PatientBirthDateConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json).toUtc();
  }

  @override
  String toJson(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

@freezed
abstract class PatientEntity with _$PatientEntity {
  const factory PatientEntity({
    required String pesel,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'date_of_birth')
    @PatientBirthDateConverter()
    required DateTime birthDate,
    required Gender gender,
    required String address,
    required String phone,
    required String email,
    @JsonKey(name: 'emergency_contact_name')
    required String emergencyContactName,
    @JsonKey(name: 'emergency_contact_phone')
    required String emergencyContactPhone,
    @JsonKey(name: 'blood_group') required BloodGroup? bloodGroup,
    required String allergies,
    @JsonKey(name: 'chronic_diseases') required String chronicDiseases,
  }) = _PatientEntity;

  factory PatientEntity.fromJson(Map<String, dynamic> json) =>
      _$PatientEntityFromJson(json);
}
