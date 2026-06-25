// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientEntity {

 int get id; String get pesel;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'date_of_birth')@PatientBirthDateConverter() DateTime get birthDate; Gender get gender; String get address; String get phone; String get email;@JsonKey(name: 'emergency_contact_name') String get emergencyContactName;@JsonKey(name: 'emergency_contact_phone') String get emergencyContactPhone;@JsonKey(name: 'blood_group') BloodGroup? get bloodGroup; String get allergies;@JsonKey(name: 'chronic_diseases') String get chronicDiseases;
/// Create a copy of PatientEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientEntityCopyWith<PatientEntity> get copyWith => _$PatientEntityCopyWithImpl<PatientEntity>(this as PatientEntity, _$identity);

  /// Serializes this PatientEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.pesel, pesel) || other.pesel == pesel)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.emergencyContactName, emergencyContactName) || other.emergencyContactName == emergencyContactName)&&(identical(other.emergencyContactPhone, emergencyContactPhone) || other.emergencyContactPhone == emergencyContactPhone)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pesel,firstName,lastName,birthDate,gender,address,phone,email,emergencyContactName,emergencyContactPhone,bloodGroup,allergies,chronicDiseases);

@override
String toString() {
  return 'PatientEntity(id: $id, pesel: $pesel, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, gender: $gender, address: $address, phone: $phone, email: $email, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, bloodGroup: $bloodGroup, allergies: $allergies, chronicDiseases: $chronicDiseases)';
}


}

/// @nodoc
abstract mixin class $PatientEntityCopyWith<$Res>  {
  factory $PatientEntityCopyWith(PatientEntity value, $Res Function(PatientEntity) _then) = _$PatientEntityCopyWithImpl;
@useResult
$Res call({
 int id, String pesel,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'date_of_birth')@PatientBirthDateConverter() DateTime birthDate, Gender gender, String address, String phone, String email,@JsonKey(name: 'emergency_contact_name') String emergencyContactName,@JsonKey(name: 'emergency_contact_phone') String emergencyContactPhone,@JsonKey(name: 'blood_group') BloodGroup? bloodGroup, String allergies,@JsonKey(name: 'chronic_diseases') String chronicDiseases
});




}
/// @nodoc
class _$PatientEntityCopyWithImpl<$Res>
    implements $PatientEntityCopyWith<$Res> {
  _$PatientEntityCopyWithImpl(this._self, this._then);

  final PatientEntity _self;
  final $Res Function(PatientEntity) _then;

/// Create a copy of PatientEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pesel = null,Object? firstName = null,Object? lastName = null,Object? birthDate = null,Object? gender = null,Object? address = null,Object? phone = null,Object? email = null,Object? emergencyContactName = null,Object? emergencyContactPhone = null,Object? bloodGroup = freezed,Object? allergies = null,Object? chronicDiseases = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,pesel: null == pesel ? _self.pesel : pesel // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emergencyContactName: null == emergencyContactName ? _self.emergencyContactName : emergencyContactName // ignore: cast_nullable_to_non_nullable
as String,emergencyContactPhone: null == emergencyContactPhone ? _self.emergencyContactPhone : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as BloodGroup?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,chronicDiseases: null == chronicDiseases ? _self.chronicDiseases : chronicDiseases // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientEntity].
extension PatientEntityPatterns on PatientEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientEntity value)  $default,){
final _that = this;
switch (_that) {
case _PatientEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PatientEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String pesel, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'date_of_birth')@PatientBirthDateConverter()  DateTime birthDate,  Gender gender,  String address,  String phone,  String email, @JsonKey(name: 'emergency_contact_name')  String emergencyContactName, @JsonKey(name: 'emergency_contact_phone')  String emergencyContactPhone, @JsonKey(name: 'blood_group')  BloodGroup? bloodGroup,  String allergies, @JsonKey(name: 'chronic_diseases')  String chronicDiseases)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientEntity() when $default != null:
return $default(_that.id,_that.pesel,_that.firstName,_that.lastName,_that.birthDate,_that.gender,_that.address,_that.phone,_that.email,_that.emergencyContactName,_that.emergencyContactPhone,_that.bloodGroup,_that.allergies,_that.chronicDiseases);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String pesel, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'date_of_birth')@PatientBirthDateConverter()  DateTime birthDate,  Gender gender,  String address,  String phone,  String email, @JsonKey(name: 'emergency_contact_name')  String emergencyContactName, @JsonKey(name: 'emergency_contact_phone')  String emergencyContactPhone, @JsonKey(name: 'blood_group')  BloodGroup? bloodGroup,  String allergies, @JsonKey(name: 'chronic_diseases')  String chronicDiseases)  $default,) {final _that = this;
switch (_that) {
case _PatientEntity():
return $default(_that.id,_that.pesel,_that.firstName,_that.lastName,_that.birthDate,_that.gender,_that.address,_that.phone,_that.email,_that.emergencyContactName,_that.emergencyContactPhone,_that.bloodGroup,_that.allergies,_that.chronicDiseases);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String pesel, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'date_of_birth')@PatientBirthDateConverter()  DateTime birthDate,  Gender gender,  String address,  String phone,  String email, @JsonKey(name: 'emergency_contact_name')  String emergencyContactName, @JsonKey(name: 'emergency_contact_phone')  String emergencyContactPhone, @JsonKey(name: 'blood_group')  BloodGroup? bloodGroup,  String allergies, @JsonKey(name: 'chronic_diseases')  String chronicDiseases)?  $default,) {final _that = this;
switch (_that) {
case _PatientEntity() when $default != null:
return $default(_that.id,_that.pesel,_that.firstName,_that.lastName,_that.birthDate,_that.gender,_that.address,_that.phone,_that.email,_that.emergencyContactName,_that.emergencyContactPhone,_that.bloodGroup,_that.allergies,_that.chronicDiseases);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientEntity implements PatientEntity {
  const _PatientEntity({required this.id, required this.pesel, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, @JsonKey(name: 'date_of_birth')@PatientBirthDateConverter() required this.birthDate, required this.gender, required this.address, required this.phone, required this.email, @JsonKey(name: 'emergency_contact_name') required this.emergencyContactName, @JsonKey(name: 'emergency_contact_phone') required this.emergencyContactPhone, @JsonKey(name: 'blood_group') required this.bloodGroup, required this.allergies, @JsonKey(name: 'chronic_diseases') required this.chronicDiseases});
  factory _PatientEntity.fromJson(Map<String, dynamic> json) => _$PatientEntityFromJson(json);

@override final  int id;
@override final  String pesel;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'date_of_birth')@PatientBirthDateConverter() final  DateTime birthDate;
@override final  Gender gender;
@override final  String address;
@override final  String phone;
@override final  String email;
@override@JsonKey(name: 'emergency_contact_name') final  String emergencyContactName;
@override@JsonKey(name: 'emergency_contact_phone') final  String emergencyContactPhone;
@override@JsonKey(name: 'blood_group') final  BloodGroup? bloodGroup;
@override final  String allergies;
@override@JsonKey(name: 'chronic_diseases') final  String chronicDiseases;

/// Create a copy of PatientEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientEntityCopyWith<_PatientEntity> get copyWith => __$PatientEntityCopyWithImpl<_PatientEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.pesel, pesel) || other.pesel == pesel)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.emergencyContactName, emergencyContactName) || other.emergencyContactName == emergencyContactName)&&(identical(other.emergencyContactPhone, emergencyContactPhone) || other.emergencyContactPhone == emergencyContactPhone)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.chronicDiseases, chronicDiseases) || other.chronicDiseases == chronicDiseases));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pesel,firstName,lastName,birthDate,gender,address,phone,email,emergencyContactName,emergencyContactPhone,bloodGroup,allergies,chronicDiseases);

@override
String toString() {
  return 'PatientEntity(id: $id, pesel: $pesel, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, gender: $gender, address: $address, phone: $phone, email: $email, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, bloodGroup: $bloodGroup, allergies: $allergies, chronicDiseases: $chronicDiseases)';
}


}

/// @nodoc
abstract mixin class _$PatientEntityCopyWith<$Res> implements $PatientEntityCopyWith<$Res> {
  factory _$PatientEntityCopyWith(_PatientEntity value, $Res Function(_PatientEntity) _then) = __$PatientEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String pesel,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'date_of_birth')@PatientBirthDateConverter() DateTime birthDate, Gender gender, String address, String phone, String email,@JsonKey(name: 'emergency_contact_name') String emergencyContactName,@JsonKey(name: 'emergency_contact_phone') String emergencyContactPhone,@JsonKey(name: 'blood_group') BloodGroup? bloodGroup, String allergies,@JsonKey(name: 'chronic_diseases') String chronicDiseases
});




}
/// @nodoc
class __$PatientEntityCopyWithImpl<$Res>
    implements _$PatientEntityCopyWith<$Res> {
  __$PatientEntityCopyWithImpl(this._self, this._then);

  final _PatientEntity _self;
  final $Res Function(_PatientEntity) _then;

/// Create a copy of PatientEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pesel = null,Object? firstName = null,Object? lastName = null,Object? birthDate = null,Object? gender = null,Object? address = null,Object? phone = null,Object? email = null,Object? emergencyContactName = null,Object? emergencyContactPhone = null,Object? bloodGroup = freezed,Object? allergies = null,Object? chronicDiseases = null,}) {
  return _then(_PatientEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,pesel: null == pesel ? _self.pesel : pesel // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emergencyContactName: null == emergencyContactName ? _self.emergencyContactName : emergencyContactName // ignore: cast_nullable_to_non_nullable
as String,emergencyContactPhone: null == emergencyContactPhone ? _self.emergencyContactPhone : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as BloodGroup?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,chronicDiseases: null == chronicDiseases ? _self.chronicDiseases : chronicDiseases // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
