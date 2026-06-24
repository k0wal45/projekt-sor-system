// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admission_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdmissionEntity {

 int get id;@JsonKey(name: 'id_pacjenta') int get patientId;@JsonKey(name: 'id_osoby_przyjmujacej') int get registrarId;@JsonKey(name: 'id_lekarza_prowadzacego') int? get doctorId;@JsonKey(name: 'data_przyjecia') DateTime get admissionDate;@JsonKey(name: 'forma_przybycia') ArrivalMode get arrivalMode; bool get injury;@JsonKey(name: 'mental_status') MentalStatus get mentalStatus; bool get pain;@JsonKey(name: 'pain_lvl') int get painLevel; int get hr; int get sbp; int get dbp; int get rr; double get bt;@JsonKey(name: 'chief_complaint') String get chiefComplaint;@JsonKey(name: 'priority_ktas') int get priorityKtas;@JsonKey(name: 'is_ai_predicted') bool get isAiPredicted;@JsonKey(name: 'status_przyjecia') AdmissionStatus get status; PatientEntity? get patient;
/// Create a copy of AdmissionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdmissionEntityCopyWith<AdmissionEntity> get copyWith => _$AdmissionEntityCopyWithImpl<AdmissionEntity>(this as AdmissionEntity, _$identity);

  /// Serializes this AdmissionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdmissionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.registrarId, registrarId) || other.registrarId == registrarId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.admissionDate, admissionDate) || other.admissionDate == admissionDate)&&(identical(other.arrivalMode, arrivalMode) || other.arrivalMode == arrivalMode)&&(identical(other.injury, injury) || other.injury == injury)&&(identical(other.mentalStatus, mentalStatus) || other.mentalStatus == mentalStatus)&&(identical(other.pain, pain) || other.pain == pain)&&(identical(other.painLevel, painLevel) || other.painLevel == painLevel)&&(identical(other.hr, hr) || other.hr == hr)&&(identical(other.sbp, sbp) || other.sbp == sbp)&&(identical(other.dbp, dbp) || other.dbp == dbp)&&(identical(other.rr, rr) || other.rr == rr)&&(identical(other.bt, bt) || other.bt == bt)&&(identical(other.chiefComplaint, chiefComplaint) || other.chiefComplaint == chiefComplaint)&&(identical(other.priorityKtas, priorityKtas) || other.priorityKtas == priorityKtas)&&(identical(other.isAiPredicted, isAiPredicted) || other.isAiPredicted == isAiPredicted)&&(identical(other.status, status) || other.status == status)&&(identical(other.patient, patient) || other.patient == patient));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,patientId,registrarId,doctorId,admissionDate,arrivalMode,injury,mentalStatus,pain,painLevel,hr,sbp,dbp,rr,bt,chiefComplaint,priorityKtas,isAiPredicted,status,patient]);

@override
String toString() {
  return 'AdmissionEntity(id: $id, patientId: $patientId, registrarId: $registrarId, doctorId: $doctorId, admissionDate: $admissionDate, arrivalMode: $arrivalMode, injury: $injury, mentalStatus: $mentalStatus, pain: $pain, painLevel: $painLevel, hr: $hr, sbp: $sbp, dbp: $dbp, rr: $rr, bt: $bt, chiefComplaint: $chiefComplaint, priorityKtas: $priorityKtas, isAiPredicted: $isAiPredicted, status: $status, patient: $patient)';
}


}

/// @nodoc
abstract mixin class $AdmissionEntityCopyWith<$Res>  {
  factory $AdmissionEntityCopyWith(AdmissionEntity value, $Res Function(AdmissionEntity) _then) = _$AdmissionEntityCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'id_pacjenta') int patientId,@JsonKey(name: 'id_osoby_przyjmujacej') int registrarId,@JsonKey(name: 'id_lekarza_prowadzacego') int? doctorId,@JsonKey(name: 'data_przyjecia') DateTime admissionDate,@JsonKey(name: 'forma_przybycia') ArrivalMode arrivalMode, bool injury,@JsonKey(name: 'mental_status') MentalStatus mentalStatus, bool pain,@JsonKey(name: 'pain_lvl') int painLevel, int hr, int sbp, int dbp, int rr, double bt,@JsonKey(name: 'chief_complaint') String chiefComplaint,@JsonKey(name: 'priority_ktas') int priorityKtas,@JsonKey(name: 'is_ai_predicted') bool isAiPredicted,@JsonKey(name: 'status_przyjecia') AdmissionStatus status, PatientEntity? patient
});


$PatientEntityCopyWith<$Res>? get patient;

}
/// @nodoc
class _$AdmissionEntityCopyWithImpl<$Res>
    implements $AdmissionEntityCopyWith<$Res> {
  _$AdmissionEntityCopyWithImpl(this._self, this._then);

  final AdmissionEntity _self;
  final $Res Function(AdmissionEntity) _then;

/// Create a copy of AdmissionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = null,Object? registrarId = null,Object? doctorId = freezed,Object? admissionDate = null,Object? arrivalMode = null,Object? injury = null,Object? mentalStatus = null,Object? pain = null,Object? painLevel = null,Object? hr = null,Object? sbp = null,Object? dbp = null,Object? rr = null,Object? bt = null,Object? chiefComplaint = null,Object? priorityKtas = null,Object? isAiPredicted = null,Object? status = null,Object? patient = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,registrarId: null == registrarId ? _self.registrarId : registrarId // ignore: cast_nullable_to_non_nullable
as int,doctorId: freezed == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as int?,admissionDate: null == admissionDate ? _self.admissionDate : admissionDate // ignore: cast_nullable_to_non_nullable
as DateTime,arrivalMode: null == arrivalMode ? _self.arrivalMode : arrivalMode // ignore: cast_nullable_to_non_nullable
as ArrivalMode,injury: null == injury ? _self.injury : injury // ignore: cast_nullable_to_non_nullable
as bool,mentalStatus: null == mentalStatus ? _self.mentalStatus : mentalStatus // ignore: cast_nullable_to_non_nullable
as MentalStatus,pain: null == pain ? _self.pain : pain // ignore: cast_nullable_to_non_nullable
as bool,painLevel: null == painLevel ? _self.painLevel : painLevel // ignore: cast_nullable_to_non_nullable
as int,hr: null == hr ? _self.hr : hr // ignore: cast_nullable_to_non_nullable
as int,sbp: null == sbp ? _self.sbp : sbp // ignore: cast_nullable_to_non_nullable
as int,dbp: null == dbp ? _self.dbp : dbp // ignore: cast_nullable_to_non_nullable
as int,rr: null == rr ? _self.rr : rr // ignore: cast_nullable_to_non_nullable
as int,bt: null == bt ? _self.bt : bt // ignore: cast_nullable_to_non_nullable
as double,chiefComplaint: null == chiefComplaint ? _self.chiefComplaint : chiefComplaint // ignore: cast_nullable_to_non_nullable
as String,priorityKtas: null == priorityKtas ? _self.priorityKtas : priorityKtas // ignore: cast_nullable_to_non_nullable
as int,isAiPredicted: null == isAiPredicted ? _self.isAiPredicted : isAiPredicted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,patient: freezed == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as PatientEntity?,
  ));
}
/// Create a copy of AdmissionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientEntityCopyWith<$Res>? get patient {
    if (_self.patient == null) {
    return null;
  }

  return $PatientEntityCopyWith<$Res>(_self.patient!, (value) {
    return _then(_self.copyWith(patient: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdmissionEntity].
extension AdmissionEntityPatterns on AdmissionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdmissionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdmissionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdmissionEntity value)  $default,){
final _that = this;
switch (_that) {
case _AdmissionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdmissionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AdmissionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'id_pacjenta')  int patientId, @JsonKey(name: 'id_osoby_przyjmujacej')  int registrarId, @JsonKey(name: 'id_lekarza_prowadzacego')  int? doctorId, @JsonKey(name: 'data_przyjecia')  DateTime admissionDate, @JsonKey(name: 'forma_przybycia')  ArrivalMode arrivalMode,  bool injury, @JsonKey(name: 'mental_status')  MentalStatus mentalStatus,  bool pain, @JsonKey(name: 'pain_lvl')  int painLevel,  int hr,  int sbp,  int dbp,  int rr,  double bt, @JsonKey(name: 'chief_complaint')  String chiefComplaint, @JsonKey(name: 'priority_ktas')  int priorityKtas, @JsonKey(name: 'is_ai_predicted')  bool isAiPredicted, @JsonKey(name: 'status_przyjecia')  AdmissionStatus status,  PatientEntity? patient)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdmissionEntity() when $default != null:
return $default(_that.id,_that.patientId,_that.registrarId,_that.doctorId,_that.admissionDate,_that.arrivalMode,_that.injury,_that.mentalStatus,_that.pain,_that.painLevel,_that.hr,_that.sbp,_that.dbp,_that.rr,_that.bt,_that.chiefComplaint,_that.priorityKtas,_that.isAiPredicted,_that.status,_that.patient);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'id_pacjenta')  int patientId, @JsonKey(name: 'id_osoby_przyjmujacej')  int registrarId, @JsonKey(name: 'id_lekarza_prowadzacego')  int? doctorId, @JsonKey(name: 'data_przyjecia')  DateTime admissionDate, @JsonKey(name: 'forma_przybycia')  ArrivalMode arrivalMode,  bool injury, @JsonKey(name: 'mental_status')  MentalStatus mentalStatus,  bool pain, @JsonKey(name: 'pain_lvl')  int painLevel,  int hr,  int sbp,  int dbp,  int rr,  double bt, @JsonKey(name: 'chief_complaint')  String chiefComplaint, @JsonKey(name: 'priority_ktas')  int priorityKtas, @JsonKey(name: 'is_ai_predicted')  bool isAiPredicted, @JsonKey(name: 'status_przyjecia')  AdmissionStatus status,  PatientEntity? patient)  $default,) {final _that = this;
switch (_that) {
case _AdmissionEntity():
return $default(_that.id,_that.patientId,_that.registrarId,_that.doctorId,_that.admissionDate,_that.arrivalMode,_that.injury,_that.mentalStatus,_that.pain,_that.painLevel,_that.hr,_that.sbp,_that.dbp,_that.rr,_that.bt,_that.chiefComplaint,_that.priorityKtas,_that.isAiPredicted,_that.status,_that.patient);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'id_pacjenta')  int patientId, @JsonKey(name: 'id_osoby_przyjmujacej')  int registrarId, @JsonKey(name: 'id_lekarza_prowadzacego')  int? doctorId, @JsonKey(name: 'data_przyjecia')  DateTime admissionDate, @JsonKey(name: 'forma_przybycia')  ArrivalMode arrivalMode,  bool injury, @JsonKey(name: 'mental_status')  MentalStatus mentalStatus,  bool pain, @JsonKey(name: 'pain_lvl')  int painLevel,  int hr,  int sbp,  int dbp,  int rr,  double bt, @JsonKey(name: 'chief_complaint')  String chiefComplaint, @JsonKey(name: 'priority_ktas')  int priorityKtas, @JsonKey(name: 'is_ai_predicted')  bool isAiPredicted, @JsonKey(name: 'status_przyjecia')  AdmissionStatus status,  PatientEntity? patient)?  $default,) {final _that = this;
switch (_that) {
case _AdmissionEntity() when $default != null:
return $default(_that.id,_that.patientId,_that.registrarId,_that.doctorId,_that.admissionDate,_that.arrivalMode,_that.injury,_that.mentalStatus,_that.pain,_that.painLevel,_that.hr,_that.sbp,_that.dbp,_that.rr,_that.bt,_that.chiefComplaint,_that.priorityKtas,_that.isAiPredicted,_that.status,_that.patient);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdmissionEntity implements AdmissionEntity {
  const _AdmissionEntity({required this.id, @JsonKey(name: 'id_pacjenta') required this.patientId, @JsonKey(name: 'id_osoby_przyjmujacej') required this.registrarId, @JsonKey(name: 'id_lekarza_prowadzacego') this.doctorId, @JsonKey(name: 'data_przyjecia') required this.admissionDate, @JsonKey(name: 'forma_przybycia') required this.arrivalMode, required this.injury, @JsonKey(name: 'mental_status') required this.mentalStatus, required this.pain, @JsonKey(name: 'pain_lvl') required this.painLevel, required this.hr, required this.sbp, required this.dbp, required this.rr, required this.bt, @JsonKey(name: 'chief_complaint') required this.chiefComplaint, @JsonKey(name: 'priority_ktas') required this.priorityKtas, @JsonKey(name: 'is_ai_predicted') required this.isAiPredicted, @JsonKey(name: 'status_przyjecia') required this.status, this.patient});
  factory _AdmissionEntity.fromJson(Map<String, dynamic> json) => _$AdmissionEntityFromJson(json);

@override final  int id;
@override@JsonKey(name: 'id_pacjenta') final  int patientId;
@override@JsonKey(name: 'id_osoby_przyjmujacej') final  int registrarId;
@override@JsonKey(name: 'id_lekarza_prowadzacego') final  int? doctorId;
@override@JsonKey(name: 'data_przyjecia') final  DateTime admissionDate;
@override@JsonKey(name: 'forma_przybycia') final  ArrivalMode arrivalMode;
@override final  bool injury;
@override@JsonKey(name: 'mental_status') final  MentalStatus mentalStatus;
@override final  bool pain;
@override@JsonKey(name: 'pain_lvl') final  int painLevel;
@override final  int hr;
@override final  int sbp;
@override final  int dbp;
@override final  int rr;
@override final  double bt;
@override@JsonKey(name: 'chief_complaint') final  String chiefComplaint;
@override@JsonKey(name: 'priority_ktas') final  int priorityKtas;
@override@JsonKey(name: 'is_ai_predicted') final  bool isAiPredicted;
@override@JsonKey(name: 'status_przyjecia') final  AdmissionStatus status;
@override final  PatientEntity? patient;

/// Create a copy of AdmissionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdmissionEntityCopyWith<_AdmissionEntity> get copyWith => __$AdmissionEntityCopyWithImpl<_AdmissionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdmissionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdmissionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.registrarId, registrarId) || other.registrarId == registrarId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.admissionDate, admissionDate) || other.admissionDate == admissionDate)&&(identical(other.arrivalMode, arrivalMode) || other.arrivalMode == arrivalMode)&&(identical(other.injury, injury) || other.injury == injury)&&(identical(other.mentalStatus, mentalStatus) || other.mentalStatus == mentalStatus)&&(identical(other.pain, pain) || other.pain == pain)&&(identical(other.painLevel, painLevel) || other.painLevel == painLevel)&&(identical(other.hr, hr) || other.hr == hr)&&(identical(other.sbp, sbp) || other.sbp == sbp)&&(identical(other.dbp, dbp) || other.dbp == dbp)&&(identical(other.rr, rr) || other.rr == rr)&&(identical(other.bt, bt) || other.bt == bt)&&(identical(other.chiefComplaint, chiefComplaint) || other.chiefComplaint == chiefComplaint)&&(identical(other.priorityKtas, priorityKtas) || other.priorityKtas == priorityKtas)&&(identical(other.isAiPredicted, isAiPredicted) || other.isAiPredicted == isAiPredicted)&&(identical(other.status, status) || other.status == status)&&(identical(other.patient, patient) || other.patient == patient));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,patientId,registrarId,doctorId,admissionDate,arrivalMode,injury,mentalStatus,pain,painLevel,hr,sbp,dbp,rr,bt,chiefComplaint,priorityKtas,isAiPredicted,status,patient]);

@override
String toString() {
  return 'AdmissionEntity(id: $id, patientId: $patientId, registrarId: $registrarId, doctorId: $doctorId, admissionDate: $admissionDate, arrivalMode: $arrivalMode, injury: $injury, mentalStatus: $mentalStatus, pain: $pain, painLevel: $painLevel, hr: $hr, sbp: $sbp, dbp: $dbp, rr: $rr, bt: $bt, chiefComplaint: $chiefComplaint, priorityKtas: $priorityKtas, isAiPredicted: $isAiPredicted, status: $status, patient: $patient)';
}


}

/// @nodoc
abstract mixin class _$AdmissionEntityCopyWith<$Res> implements $AdmissionEntityCopyWith<$Res> {
  factory _$AdmissionEntityCopyWith(_AdmissionEntity value, $Res Function(_AdmissionEntity) _then) = __$AdmissionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'id_pacjenta') int patientId,@JsonKey(name: 'id_osoby_przyjmujacej') int registrarId,@JsonKey(name: 'id_lekarza_prowadzacego') int? doctorId,@JsonKey(name: 'data_przyjecia') DateTime admissionDate,@JsonKey(name: 'forma_przybycia') ArrivalMode arrivalMode, bool injury,@JsonKey(name: 'mental_status') MentalStatus mentalStatus, bool pain,@JsonKey(name: 'pain_lvl') int painLevel, int hr, int sbp, int dbp, int rr, double bt,@JsonKey(name: 'chief_complaint') String chiefComplaint,@JsonKey(name: 'priority_ktas') int priorityKtas,@JsonKey(name: 'is_ai_predicted') bool isAiPredicted,@JsonKey(name: 'status_przyjecia') AdmissionStatus status, PatientEntity? patient
});


@override $PatientEntityCopyWith<$Res>? get patient;

}
/// @nodoc
class __$AdmissionEntityCopyWithImpl<$Res>
    implements _$AdmissionEntityCopyWith<$Res> {
  __$AdmissionEntityCopyWithImpl(this._self, this._then);

  final _AdmissionEntity _self;
  final $Res Function(_AdmissionEntity) _then;

/// Create a copy of AdmissionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = null,Object? registrarId = null,Object? doctorId = freezed,Object? admissionDate = null,Object? arrivalMode = null,Object? injury = null,Object? mentalStatus = null,Object? pain = null,Object? painLevel = null,Object? hr = null,Object? sbp = null,Object? dbp = null,Object? rr = null,Object? bt = null,Object? chiefComplaint = null,Object? priorityKtas = null,Object? isAiPredicted = null,Object? status = null,Object? patient = freezed,}) {
  return _then(_AdmissionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,registrarId: null == registrarId ? _self.registrarId : registrarId // ignore: cast_nullable_to_non_nullable
as int,doctorId: freezed == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as int?,admissionDate: null == admissionDate ? _self.admissionDate : admissionDate // ignore: cast_nullable_to_non_nullable
as DateTime,arrivalMode: null == arrivalMode ? _self.arrivalMode : arrivalMode // ignore: cast_nullable_to_non_nullable
as ArrivalMode,injury: null == injury ? _self.injury : injury // ignore: cast_nullable_to_non_nullable
as bool,mentalStatus: null == mentalStatus ? _self.mentalStatus : mentalStatus // ignore: cast_nullable_to_non_nullable
as MentalStatus,pain: null == pain ? _self.pain : pain // ignore: cast_nullable_to_non_nullable
as bool,painLevel: null == painLevel ? _self.painLevel : painLevel // ignore: cast_nullable_to_non_nullable
as int,hr: null == hr ? _self.hr : hr // ignore: cast_nullable_to_non_nullable
as int,sbp: null == sbp ? _self.sbp : sbp // ignore: cast_nullable_to_non_nullable
as int,dbp: null == dbp ? _self.dbp : dbp // ignore: cast_nullable_to_non_nullable
as int,rr: null == rr ? _self.rr : rr // ignore: cast_nullable_to_non_nullable
as int,bt: null == bt ? _self.bt : bt // ignore: cast_nullable_to_non_nullable
as double,chiefComplaint: null == chiefComplaint ? _self.chiefComplaint : chiefComplaint // ignore: cast_nullable_to_non_nullable
as String,priorityKtas: null == priorityKtas ? _self.priorityKtas : priorityKtas // ignore: cast_nullable_to_non_nullable
as int,isAiPredicted: null == isAiPredicted ? _self.isAiPredicted : isAiPredicted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdmissionStatus,patient: freezed == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as PatientEntity?,
  ));
}

/// Create a copy of AdmissionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientEntityCopyWith<$Res>? get patient {
    if (_self.patient == null) {
    return null;
  }

  return $PatientEntityCopyWith<$Res>(_self.patient!, (value) {
    return _then(_self.copyWith(patient: value));
  });
}
}

// dart format on
