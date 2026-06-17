// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Admission {

 String get id; String get patientId; String? get receivingStaffId; String? get attendingDoctorId; DateTime get admissionTime; int get priorityKtas; String get chiefComplaint; AdmissionStatus get status;
/// Create a copy of Admission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdmissionCopyWith<Admission> get copyWith => _$AdmissionCopyWithImpl<Admission>(this as Admission, _$identity);

  /// Serializes this Admission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Admission&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.receivingStaffId, receivingStaffId) || other.receivingStaffId == receivingStaffId)&&(identical(other.attendingDoctorId, attendingDoctorId) || other.attendingDoctorId == attendingDoctorId)&&(identical(other.admissionTime, admissionTime) || other.admissionTime == admissionTime)&&(identical(other.priorityKtas, priorityKtas) || other.priorityKtas == priorityKtas)&&(identical(other.chiefComplaint, chiefComplaint) || other.chiefComplaint == chiefComplaint)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,receivingStaffId,attendingDoctorId,admissionTime,priorityKtas,chiefComplaint,status);

@override
String toString() {
  return 'Admission(id: $id, patientId: $patientId, receivingStaffId: $receivingStaffId, attendingDoctorId: $attendingDoctorId, admissionTime: $admissionTime, priorityKtas: $priorityKtas, chiefComplaint: $chiefComplaint, status: $status)';
}


}

/// @nodoc
abstract mixin class $AdmissionCopyWith<$Res>  {
  factory $AdmissionCopyWith(Admission value, $Res Function(Admission) _then) = _$AdmissionCopyWithImpl;
@useResult
$Res call({
 String id, String patientId, String? receivingStaffId, String? attendingDoctorId, DateTime admissionTime, int priorityKtas, String chiefComplaint, AdmissionStatus status
});




}
/// @nodoc
class _$AdmissionCopyWithImpl<$Res>
    implements $AdmissionCopyWith<$Res> {
  _$AdmissionCopyWithImpl(this._self, this._then);

  final Admission _self;
  final $Res Function(Admission) _then;

/// Create a copy of Admission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = null,Object? receivingStaffId = freezed,Object? attendingDoctorId = freezed,Object? admissionTime = null,Object? priorityKtas = null,Object? chiefComplaint = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,receivingStaffId: freezed == receivingStaffId ? _self.receivingStaffId : receivingStaffId // ignore: cast_nullable_to_non_nullable
as String?,attendingDoctorId: freezed == attendingDoctorId ? _self.attendingDoctorId : attendingDoctorId // ignore: cast_nullable_to_non_nullable
as String?,admissionTime: null == admissionTime ? _self.admissionTime : admissionTime // ignore: cast_nullable_to_non_nullable
as DateTime,priorityKtas: null == priorityKtas ? _self.priorityKtas : priorityKtas // ignore: cast_nullable_to_non_nullable
as int,chiefComplaint: null == chiefComplaint ? _self.chiefComplaint : chiefComplaint // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Admission].
extension AdmissionPatterns on Admission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Admission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Admission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Admission value)  $default,){
final _that = this;
switch (_that) {
case _Admission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Admission value)?  $default,){
final _that = this;
switch (_that) {
case _Admission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String patientId,  String? receivingStaffId,  String? attendingDoctorId,  DateTime admissionTime,  int priorityKtas,  String chiefComplaint,  AdmissionStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Admission() when $default != null:
return $default(_that.id,_that.patientId,_that.receivingStaffId,_that.attendingDoctorId,_that.admissionTime,_that.priorityKtas,_that.chiefComplaint,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String patientId,  String? receivingStaffId,  String? attendingDoctorId,  DateTime admissionTime,  int priorityKtas,  String chiefComplaint,  AdmissionStatus status)  $default,) {final _that = this;
switch (_that) {
case _Admission():
return $default(_that.id,_that.patientId,_that.receivingStaffId,_that.attendingDoctorId,_that.admissionTime,_that.priorityKtas,_that.chiefComplaint,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String patientId,  String? receivingStaffId,  String? attendingDoctorId,  DateTime admissionTime,  int priorityKtas,  String chiefComplaint,  AdmissionStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Admission() when $default != null:
return $default(_that.id,_that.patientId,_that.receivingStaffId,_that.attendingDoctorId,_that.admissionTime,_that.priorityKtas,_that.chiefComplaint,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Admission implements Admission {
  const _Admission({required this.id, required this.patientId, this.receivingStaffId, this.attendingDoctorId, required this.admissionTime, required this.priorityKtas, required this.chiefComplaint, required this.status});
  factory _Admission.fromJson(Map<String, dynamic> json) => _$AdmissionFromJson(json);

@override final  String id;
@override final  String patientId;
@override final  String? receivingStaffId;
@override final  String? attendingDoctorId;
@override final  DateTime admissionTime;
@override final  int priorityKtas;
@override final  String chiefComplaint;
@override final  AdmissionStatus status;

/// Create a copy of Admission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdmissionCopyWith<_Admission> get copyWith => __$AdmissionCopyWithImpl<_Admission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdmissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Admission&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.receivingStaffId, receivingStaffId) || other.receivingStaffId == receivingStaffId)&&(identical(other.attendingDoctorId, attendingDoctorId) || other.attendingDoctorId == attendingDoctorId)&&(identical(other.admissionTime, admissionTime) || other.admissionTime == admissionTime)&&(identical(other.priorityKtas, priorityKtas) || other.priorityKtas == priorityKtas)&&(identical(other.chiefComplaint, chiefComplaint) || other.chiefComplaint == chiefComplaint)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,receivingStaffId,attendingDoctorId,admissionTime,priorityKtas,chiefComplaint,status);

@override
String toString() {
  return 'Admission(id: $id, patientId: $patientId, receivingStaffId: $receivingStaffId, attendingDoctorId: $attendingDoctorId, admissionTime: $admissionTime, priorityKtas: $priorityKtas, chiefComplaint: $chiefComplaint, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AdmissionCopyWith<$Res> implements $AdmissionCopyWith<$Res> {
  factory _$AdmissionCopyWith(_Admission value, $Res Function(_Admission) _then) = __$AdmissionCopyWithImpl;
@override @useResult
$Res call({
 String id, String patientId, String? receivingStaffId, String? attendingDoctorId, DateTime admissionTime, int priorityKtas, String chiefComplaint, AdmissionStatus status
});




}
/// @nodoc
class __$AdmissionCopyWithImpl<$Res>
    implements _$AdmissionCopyWith<$Res> {
  __$AdmissionCopyWithImpl(this._self, this._then);

  final _Admission _self;
  final $Res Function(_Admission) _then;

/// Create a copy of Admission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = null,Object? receivingStaffId = freezed,Object? attendingDoctorId = freezed,Object? admissionTime = null,Object? priorityKtas = null,Object? chiefComplaint = null,Object? status = null,}) {
  return _then(_Admission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,receivingStaffId: freezed == receivingStaffId ? _self.receivingStaffId : receivingStaffId // ignore: cast_nullable_to_non_nullable
as String?,attendingDoctorId: freezed == attendingDoctorId ? _self.attendingDoctorId : attendingDoctorId // ignore: cast_nullable_to_non_nullable
as String?,admissionTime: null == admissionTime ? _self.admissionTime : admissionTime // ignore: cast_nullable_to_non_nullable
as DateTime,priorityKtas: null == priorityKtas ? _self.priorityKtas : priorityKtas // ignore: cast_nullable_to_non_nullable
as int,chiefComplaint: null == chiefComplaint ? _self.chiefComplaint : chiefComplaint // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,
  ));
}


}

// dart format on
