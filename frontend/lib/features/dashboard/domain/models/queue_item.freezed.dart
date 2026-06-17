// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueueItem {

 Patient get patient; Admission get admission;
/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueItemCopyWith<QueueItem> get copyWith => _$QueueItemCopyWithImpl<QueueItem>(this as QueueItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueItem&&(identical(other.patient, patient) || other.patient == patient)&&(identical(other.admission, admission) || other.admission == admission));
}


@override
int get hashCode => Object.hash(runtimeType,patient,admission);

@override
String toString() {
  return 'QueueItem(patient: $patient, admission: $admission)';
}


}

/// @nodoc
abstract mixin class $QueueItemCopyWith<$Res>  {
  factory $QueueItemCopyWith(QueueItem value, $Res Function(QueueItem) _then) = _$QueueItemCopyWithImpl;
@useResult
$Res call({
 Patient patient, Admission admission
});


$PatientCopyWith<$Res> get patient;$AdmissionCopyWith<$Res> get admission;

}
/// @nodoc
class _$QueueItemCopyWithImpl<$Res>
    implements $QueueItemCopyWith<$Res> {
  _$QueueItemCopyWithImpl(this._self, this._then);

  final QueueItem _self;
  final $Res Function(QueueItem) _then;

/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patient = null,Object? admission = null,}) {
  return _then(_self.copyWith(
patient: null == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as Patient,admission: null == admission ? _self.admission : admission // ignore: cast_nullable_to_non_nullable
as Admission,
  ));
}
/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientCopyWith<$Res> get patient {
  
  return $PatientCopyWith<$Res>(_self.patient, (value) {
    return _then(_self.copyWith(patient: value));
  });
}/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdmissionCopyWith<$Res> get admission {
  
  return $AdmissionCopyWith<$Res>(_self.admission, (value) {
    return _then(_self.copyWith(admission: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueueItem].
extension QueueItemPatterns on QueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueItem value)  $default,){
final _that = this;
switch (_that) {
case _QueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Patient patient,  Admission admission)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
return $default(_that.patient,_that.admission);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Patient patient,  Admission admission)  $default,) {final _that = this;
switch (_that) {
case _QueueItem():
return $default(_that.patient,_that.admission);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Patient patient,  Admission admission)?  $default,) {final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
return $default(_that.patient,_that.admission);case _:
  return null;

}
}

}

/// @nodoc


class _QueueItem implements QueueItem {
  const _QueueItem({required this.patient, required this.admission});
  

@override final  Patient patient;
@override final  Admission admission;

/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueItemCopyWith<_QueueItem> get copyWith => __$QueueItemCopyWithImpl<_QueueItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueItem&&(identical(other.patient, patient) || other.patient == patient)&&(identical(other.admission, admission) || other.admission == admission));
}


@override
int get hashCode => Object.hash(runtimeType,patient,admission);

@override
String toString() {
  return 'QueueItem(patient: $patient, admission: $admission)';
}


}

/// @nodoc
abstract mixin class _$QueueItemCopyWith<$Res> implements $QueueItemCopyWith<$Res> {
  factory _$QueueItemCopyWith(_QueueItem value, $Res Function(_QueueItem) _then) = __$QueueItemCopyWithImpl;
@override @useResult
$Res call({
 Patient patient, Admission admission
});


@override $PatientCopyWith<$Res> get patient;@override $AdmissionCopyWith<$Res> get admission;

}
/// @nodoc
class __$QueueItemCopyWithImpl<$Res>
    implements _$QueueItemCopyWith<$Res> {
  __$QueueItemCopyWithImpl(this._self, this._then);

  final _QueueItem _self;
  final $Res Function(_QueueItem) _then;

/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patient = null,Object? admission = null,}) {
  return _then(_QueueItem(
patient: null == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as Patient,admission: null == admission ? _self.admission : admission // ignore: cast_nullable_to_non_nullable
as Admission,
  ));
}

/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientCopyWith<$Res> get patient {
  
  return $PatientCopyWith<$Res>(_self.patient, (value) {
    return _then(_self.copyWith(patient: value));
  });
}/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdmissionCopyWith<$Res> get admission {
  
  return $AdmissionCopyWith<$Res>(_self.admission, (value) {
    return _then(_self.copyWith(admission: value));
  });
}
}

// dart format on
