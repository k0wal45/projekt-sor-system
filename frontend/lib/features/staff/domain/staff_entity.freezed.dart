// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffEntity {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'academic_title') String get academicTitle;@JsonKey(name: 'role') StaffRole get role;@JsonKey(name: 'login_email') String get email;
/// Create a copy of StaffEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffEntityCopyWith<StaffEntity> get copyWith => _$StaffEntityCopyWithImpl<StaffEntity>(this as StaffEntity, _$identity);

  /// Serializes this StaffEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.academicTitle, academicTitle) || other.academicTitle == academicTitle)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,academicTitle,role,email);

@override
String toString() {
  return 'StaffEntity(id: $id, firstName: $firstName, lastName: $lastName, academicTitle: $academicTitle, role: $role, email: $email)';
}


}

/// @nodoc
abstract mixin class $StaffEntityCopyWith<$Res>  {
  factory $StaffEntityCopyWith(StaffEntity value, $Res Function(StaffEntity) _then) = _$StaffEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'academic_title') String academicTitle,@JsonKey(name: 'role') StaffRole role,@JsonKey(name: 'login_email') String email
});




}
/// @nodoc
class _$StaffEntityCopyWithImpl<$Res>
    implements $StaffEntityCopyWith<$Res> {
  _$StaffEntityCopyWithImpl(this._self, this._then);

  final StaffEntity _self;
  final $Res Function(StaffEntity) _then;

/// Create a copy of StaffEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? academicTitle = null,Object? role = null,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,academicTitle: null == academicTitle ? _self.academicTitle : academicTitle // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as StaffRole,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffEntity].
extension StaffEntityPatterns on StaffEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffEntity value)  $default,){
final _that = this;
switch (_that) {
case _StaffEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StaffEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'academic_title')  String academicTitle, @JsonKey(name: 'role')  StaffRole role, @JsonKey(name: 'login_email')  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffEntity() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.academicTitle,_that.role,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'academic_title')  String academicTitle, @JsonKey(name: 'role')  StaffRole role, @JsonKey(name: 'login_email')  String email)  $default,) {final _that = this;
switch (_that) {
case _StaffEntity():
return $default(_that.id,_that.firstName,_that.lastName,_that.academicTitle,_that.role,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'academic_title')  String academicTitle, @JsonKey(name: 'role')  StaffRole role, @JsonKey(name: 'login_email')  String email)?  $default,) {final _that = this;
switch (_that) {
case _StaffEntity() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.academicTitle,_that.role,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffEntity extends StaffEntity {
  const _StaffEntity({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, @JsonKey(name: 'academic_title') this.academicTitle = '', @JsonKey(name: 'role') required this.role, @JsonKey(name: 'login_email') this.email = ''}): super._();
  factory _StaffEntity.fromJson(Map<String, dynamic> json) => _$StaffEntityFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'academic_title') final  String academicTitle;
@override@JsonKey(name: 'role') final  StaffRole role;
@override@JsonKey(name: 'login_email') final  String email;

/// Create a copy of StaffEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffEntityCopyWith<_StaffEntity> get copyWith => __$StaffEntityCopyWithImpl<_StaffEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.academicTitle, academicTitle) || other.academicTitle == academicTitle)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,academicTitle,role,email);

@override
String toString() {
  return 'StaffEntity(id: $id, firstName: $firstName, lastName: $lastName, academicTitle: $academicTitle, role: $role, email: $email)';
}


}

/// @nodoc
abstract mixin class _$StaffEntityCopyWith<$Res> implements $StaffEntityCopyWith<$Res> {
  factory _$StaffEntityCopyWith(_StaffEntity value, $Res Function(_StaffEntity) _then) = __$StaffEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'academic_title') String academicTitle,@JsonKey(name: 'role') StaffRole role,@JsonKey(name: 'login_email') String email
});




}
/// @nodoc
class __$StaffEntityCopyWithImpl<$Res>
    implements _$StaffEntityCopyWith<$Res> {
  __$StaffEntityCopyWithImpl(this._self, this._then);

  final _StaffEntity _self;
  final $Res Function(_StaffEntity) _then;

/// Create a copy of StaffEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? academicTitle = null,Object? role = null,Object? email = null,}) {
  return _then(_StaffEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,academicTitle: null == academicTitle ? _self.academicTitle : academicTitle // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as StaffRole,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
