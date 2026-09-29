// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserLoginModel {

@JsonKey(name: 'access_token') String? get accessToken;@JsonKey(name: 'refresh_token') String? get refreshToken; User? get user;@JsonKey(name: 'expires_in') int? get expiresIn;
/// Create a copy of UserLoginModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLoginModelCopyWith<UserLoginModel> get copyWith => _$UserLoginModelCopyWithImpl<UserLoginModel>(this as UserLoginModel, _$identity);

  /// Serializes this UserLoginModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLoginModel&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.user, user) || other.user == user)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,user,expiresIn);

@override
String toString() {
  return 'UserLoginModel(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class $UserLoginModelCopyWith<$Res>  {
  factory $UserLoginModelCopyWith(UserLoginModel value, $Res Function(UserLoginModel) _then) = _$UserLoginModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'refresh_token') String? refreshToken, User? user,@JsonKey(name: 'expires_in') int? expiresIn
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$UserLoginModelCopyWithImpl<$Res>
    implements $UserLoginModelCopyWith<$Res> {
  _$UserLoginModelCopyWithImpl(this._self, this._then);

  final UserLoginModel _self;
  final $Res Function(UserLoginModel) _then;

/// Create a copy of UserLoginModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = freezed,Object? refreshToken = freezed,Object? user = freezed,Object? expiresIn = freezed,}) {
  return _then(_self.copyWith(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of UserLoginModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserLoginModel].
extension UserLoginModelPatterns on UserLoginModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLoginModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLoginModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLoginModel value)  $default,){
final _that = this;
switch (_that) {
case _UserLoginModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLoginModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserLoginModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken,  User? user, @JsonKey(name: 'expires_in')  int? expiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLoginModel() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user,_that.expiresIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken,  User? user, @JsonKey(name: 'expires_in')  int? expiresIn)  $default,) {final _that = this;
switch (_that) {
case _UserLoginModel():
return $default(_that.accessToken,_that.refreshToken,_that.user,_that.expiresIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken,  User? user, @JsonKey(name: 'expires_in')  int? expiresIn)?  $default,) {final _that = this;
switch (_that) {
case _UserLoginModel() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user,_that.expiresIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserLoginModel implements UserLoginModel {
  const _UserLoginModel({@JsonKey(name: 'access_token') this.accessToken, @JsonKey(name: 'refresh_token') this.refreshToken, this.user, @JsonKey(name: 'expires_in') this.expiresIn});
  factory _UserLoginModel.fromJson(Map<String, dynamic> json) => _$UserLoginModelFromJson(json);

@override@JsonKey(name: 'access_token') final  String? accessToken;
@override@JsonKey(name: 'refresh_token') final  String? refreshToken;
@override final  User? user;
@override@JsonKey(name: 'expires_in') final  int? expiresIn;

/// Create a copy of UserLoginModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLoginModelCopyWith<_UserLoginModel> get copyWith => __$UserLoginModelCopyWithImpl<_UserLoginModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserLoginModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLoginModel&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.user, user) || other.user == user)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,user,expiresIn);

@override
String toString() {
  return 'UserLoginModel(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class _$UserLoginModelCopyWith<$Res> implements $UserLoginModelCopyWith<$Res> {
  factory _$UserLoginModelCopyWith(_UserLoginModel value, $Res Function(_UserLoginModel) _then) = __$UserLoginModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'refresh_token') String? refreshToken, User? user,@JsonKey(name: 'expires_in') int? expiresIn
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$UserLoginModelCopyWithImpl<$Res>
    implements _$UserLoginModelCopyWith<$Res> {
  __$UserLoginModelCopyWithImpl(this._self, this._then);

  final _UserLoginModel _self;
  final $Res Function(_UserLoginModel) _then;

/// Create a copy of UserLoginModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = freezed,Object? refreshToken = freezed,Object? user = freezed,Object? expiresIn = freezed,}) {
  return _then(_UserLoginModel(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of UserLoginModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$User {

 int? get id; String? get email; String? get username; String? get divisionid; String? get code;@JsonKey(name: 'password_reset') bool? get passwordReset;@JsonKey(name: 'is_account_locked') bool? get isAccountLocked;@JsonKey(name: 'user_group') String? get userGroup;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.divisionid, divisionid) || other.divisionid == divisionid)&&(identical(other.code, code) || other.code == code)&&(identical(other.passwordReset, passwordReset) || other.passwordReset == passwordReset)&&(identical(other.isAccountLocked, isAccountLocked) || other.isAccountLocked == isAccountLocked)&&(identical(other.userGroup, userGroup) || other.userGroup == userGroup)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,divisionid,code,passwordReset,isAccountLocked,userGroup,firstName,lastName,createdAt,updatedAt);

@override
String toString() {
  return 'User(id: $id, email: $email, username: $username, divisionid: $divisionid, code: $code, passwordReset: $passwordReset, isAccountLocked: $isAccountLocked, userGroup: $userGroup, firstName: $firstName, lastName: $lastName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int? id, String? email, String? username, String? divisionid, String? code,@JsonKey(name: 'password_reset') bool? passwordReset,@JsonKey(name: 'is_account_locked') bool? isAccountLocked,@JsonKey(name: 'user_group') String? userGroup,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? email = freezed,Object? username = freezed,Object? divisionid = freezed,Object? code = freezed,Object? passwordReset = freezed,Object? isAccountLocked = freezed,Object? userGroup = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,divisionid: freezed == divisionid ? _self.divisionid : divisionid // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,passwordReset: freezed == passwordReset ? _self.passwordReset : passwordReset // ignore: cast_nullable_to_non_nullable
as bool?,isAccountLocked: freezed == isAccountLocked ? _self.isAccountLocked : isAccountLocked // ignore: cast_nullable_to_non_nullable
as bool?,userGroup: freezed == userGroup ? _self.userGroup : userGroup // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? email,  String? username,  String? divisionid,  String? code, @JsonKey(name: 'password_reset')  bool? passwordReset, @JsonKey(name: 'is_account_locked')  bool? isAccountLocked, @JsonKey(name: 'user_group')  String? userGroup, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.divisionid,_that.code,_that.passwordReset,_that.isAccountLocked,_that.userGroup,_that.firstName,_that.lastName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? email,  String? username,  String? divisionid,  String? code, @JsonKey(name: 'password_reset')  bool? passwordReset, @JsonKey(name: 'is_account_locked')  bool? isAccountLocked, @JsonKey(name: 'user_group')  String? userGroup, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.username,_that.divisionid,_that.code,_that.passwordReset,_that.isAccountLocked,_that.userGroup,_that.firstName,_that.lastName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? email,  String? username,  String? divisionid,  String? code, @JsonKey(name: 'password_reset')  bool? passwordReset, @JsonKey(name: 'is_account_locked')  bool? isAccountLocked, @JsonKey(name: 'user_group')  String? userGroup, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.divisionid,_that.code,_that.passwordReset,_that.isAccountLocked,_that.userGroup,_that.firstName,_that.lastName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({this.id, this.email, this.username, this.divisionid, this.code, @JsonKey(name: 'password_reset') this.passwordReset, @JsonKey(name: 'is_account_locked') this.isAccountLocked, @JsonKey(name: 'user_group') this.userGroup, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int? id;
@override final  String? email;
@override final  String? username;
@override final  String? divisionid;
@override final  String? code;
@override@JsonKey(name: 'password_reset') final  bool? passwordReset;
@override@JsonKey(name: 'is_account_locked') final  bool? isAccountLocked;
@override@JsonKey(name: 'user_group') final  String? userGroup;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.divisionid, divisionid) || other.divisionid == divisionid)&&(identical(other.code, code) || other.code == code)&&(identical(other.passwordReset, passwordReset) || other.passwordReset == passwordReset)&&(identical(other.isAccountLocked, isAccountLocked) || other.isAccountLocked == isAccountLocked)&&(identical(other.userGroup, userGroup) || other.userGroup == userGroup)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,divisionid,code,passwordReset,isAccountLocked,userGroup,firstName,lastName,createdAt,updatedAt);

@override
String toString() {
  return 'User(id: $id, email: $email, username: $username, divisionid: $divisionid, code: $code, passwordReset: $passwordReset, isAccountLocked: $isAccountLocked, userGroup: $userGroup, firstName: $firstName, lastName: $lastName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? email, String? username, String? divisionid, String? code,@JsonKey(name: 'password_reset') bool? passwordReset,@JsonKey(name: 'is_account_locked') bool? isAccountLocked,@JsonKey(name: 'user_group') String? userGroup,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? email = freezed,Object? username = freezed,Object? divisionid = freezed,Object? code = freezed,Object? passwordReset = freezed,Object? isAccountLocked = freezed,Object? userGroup = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,divisionid: freezed == divisionid ? _self.divisionid : divisionid // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,passwordReset: freezed == passwordReset ? _self.passwordReset : passwordReset // ignore: cast_nullable_to_non_nullable
as bool?,isAccountLocked: freezed == isAccountLocked ? _self.isAccountLocked : isAccountLocked // ignore: cast_nullable_to_non_nullable
as bool?,userGroup: freezed == userGroup ? _self.userGroup : userGroup // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
