// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_verify_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserVerifyTokenModel {

@JsonKey(name: 'expires_at') DateTime? get expiresAt;@JsonKey(name: 'expires_in_seconds') int? get expiresInSeconds;@JsonKey(name: 'issued_at') DateTime? get issuedAt;@JsonKey(name: 'user_id') int? get userId; bool? get valid;
/// Create a copy of UserVerifyTokenModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserVerifyTokenModelCopyWith<UserVerifyTokenModel> get copyWith => _$UserVerifyTokenModelCopyWithImpl<UserVerifyTokenModel>(this as UserVerifyTokenModel, _$identity);

  /// Serializes this UserVerifyTokenModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserVerifyTokenModel&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.valid, valid) || other.valid == valid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expiresAt,expiresInSeconds,issuedAt,userId,valid);

@override
String toString() {
  return 'UserVerifyTokenModel(expiresAt: $expiresAt, expiresInSeconds: $expiresInSeconds, issuedAt: $issuedAt, userId: $userId, valid: $valid)';
}


}

/// @nodoc
abstract mixin class $UserVerifyTokenModelCopyWith<$Res>  {
  factory $UserVerifyTokenModelCopyWith(UserVerifyTokenModel value, $Res Function(UserVerifyTokenModel) _then) = _$UserVerifyTokenModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'expires_in_seconds') int? expiresInSeconds,@JsonKey(name: 'issued_at') DateTime? issuedAt,@JsonKey(name: 'user_id') int? userId, bool? valid
});




}
/// @nodoc
class _$UserVerifyTokenModelCopyWithImpl<$Res>
    implements $UserVerifyTokenModelCopyWith<$Res> {
  _$UserVerifyTokenModelCopyWithImpl(this._self, this._then);

  final UserVerifyTokenModel _self;
  final $Res Function(UserVerifyTokenModel) _then;

/// Create a copy of UserVerifyTokenModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expiresAt = freezed,Object? expiresInSeconds = freezed,Object? issuedAt = freezed,Object? userId = freezed,Object? valid = freezed,}) {
  return _then(_self.copyWith(
expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresInSeconds: freezed == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,valid: freezed == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserVerifyTokenModel].
extension UserVerifyTokenModelPatterns on UserVerifyTokenModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserVerifyTokenModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserVerifyTokenModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserVerifyTokenModel value)  $default,){
final _that = this;
switch (_that) {
case _UserVerifyTokenModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserVerifyTokenModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserVerifyTokenModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'expires_in_seconds')  int? expiresInSeconds, @JsonKey(name: 'issued_at')  DateTime? issuedAt, @JsonKey(name: 'user_id')  int? userId,  bool? valid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserVerifyTokenModel() when $default != null:
return $default(_that.expiresAt,_that.expiresInSeconds,_that.issuedAt,_that.userId,_that.valid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'expires_in_seconds')  int? expiresInSeconds, @JsonKey(name: 'issued_at')  DateTime? issuedAt, @JsonKey(name: 'user_id')  int? userId,  bool? valid)  $default,) {final _that = this;
switch (_that) {
case _UserVerifyTokenModel():
return $default(_that.expiresAt,_that.expiresInSeconds,_that.issuedAt,_that.userId,_that.valid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'expires_in_seconds')  int? expiresInSeconds, @JsonKey(name: 'issued_at')  DateTime? issuedAt, @JsonKey(name: 'user_id')  int? userId,  bool? valid)?  $default,) {final _that = this;
switch (_that) {
case _UserVerifyTokenModel() when $default != null:
return $default(_that.expiresAt,_that.expiresInSeconds,_that.issuedAt,_that.userId,_that.valid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserVerifyTokenModel implements UserVerifyTokenModel {
  const _UserVerifyTokenModel({@JsonKey(name: 'expires_at') this.expiresAt, @JsonKey(name: 'expires_in_seconds') this.expiresInSeconds, @JsonKey(name: 'issued_at') this.issuedAt, @JsonKey(name: 'user_id') this.userId, this.valid});
  factory _UserVerifyTokenModel.fromJson(Map<String, dynamic> json) => _$UserVerifyTokenModelFromJson(json);

@override@JsonKey(name: 'expires_at') final  DateTime? expiresAt;
@override@JsonKey(name: 'expires_in_seconds') final  int? expiresInSeconds;
@override@JsonKey(name: 'issued_at') final  DateTime? issuedAt;
@override@JsonKey(name: 'user_id') final  int? userId;
@override final  bool? valid;

/// Create a copy of UserVerifyTokenModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserVerifyTokenModelCopyWith<_UserVerifyTokenModel> get copyWith => __$UserVerifyTokenModelCopyWithImpl<_UserVerifyTokenModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserVerifyTokenModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserVerifyTokenModel&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.valid, valid) || other.valid == valid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expiresAt,expiresInSeconds,issuedAt,userId,valid);

@override
String toString() {
  return 'UserVerifyTokenModel(expiresAt: $expiresAt, expiresInSeconds: $expiresInSeconds, issuedAt: $issuedAt, userId: $userId, valid: $valid)';
}


}

/// @nodoc
abstract mixin class _$UserVerifyTokenModelCopyWith<$Res> implements $UserVerifyTokenModelCopyWith<$Res> {
  factory _$UserVerifyTokenModelCopyWith(_UserVerifyTokenModel value, $Res Function(_UserVerifyTokenModel) _then) = __$UserVerifyTokenModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'expires_in_seconds') int? expiresInSeconds,@JsonKey(name: 'issued_at') DateTime? issuedAt,@JsonKey(name: 'user_id') int? userId, bool? valid
});




}
/// @nodoc
class __$UserVerifyTokenModelCopyWithImpl<$Res>
    implements _$UserVerifyTokenModelCopyWith<$Res> {
  __$UserVerifyTokenModelCopyWithImpl(this._self, this._then);

  final _UserVerifyTokenModel _self;
  final $Res Function(_UserVerifyTokenModel) _then;

/// Create a copy of UserVerifyTokenModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expiresAt = freezed,Object? expiresInSeconds = freezed,Object? issuedAt = freezed,Object? userId = freezed,Object? valid = freezed,}) {
  return _then(_UserVerifyTokenModel(
expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresInSeconds: freezed == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,valid: freezed == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
