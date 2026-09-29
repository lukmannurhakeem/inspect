// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'view_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewUserModel {

 int get count; String get message; List<AuthUser> get users;
/// Create a copy of ViewUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewUserModelCopyWith<ViewUserModel> get copyWith => _$ViewUserModelCopyWithImpl<ViewUserModel>(this as ViewUserModel, _$identity);

  /// Serializes this ViewUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewUserModel&&(identical(other.count, count) || other.count == count)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.users, users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,message,const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'ViewUserModel(count: $count, message: $message, users: $users)';
}


}

/// @nodoc
abstract mixin class $ViewUserModelCopyWith<$Res>  {
  factory $ViewUserModelCopyWith(ViewUserModel value, $Res Function(ViewUserModel) _then) = _$ViewUserModelCopyWithImpl;
@useResult
$Res call({
 int count, String message, List<AuthUser> users
});




}
/// @nodoc
class _$ViewUserModelCopyWithImpl<$Res>
    implements $ViewUserModelCopyWith<$Res> {
  _$ViewUserModelCopyWithImpl(this._self, this._then);

  final ViewUserModel _self;
  final $Res Function(ViewUserModel) _then;

/// Create a copy of ViewUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? message = null,Object? users = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<AuthUser>,
  ));
}

}


/// Adds pattern-matching-related methods to [ViewUserModel].
extension ViewUserModelPatterns on ViewUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewUserModel value)  $default,){
final _that = this;
switch (_that) {
case _ViewUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _ViewUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String message,  List<AuthUser> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewUserModel() when $default != null:
return $default(_that.count,_that.message,_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String message,  List<AuthUser> users)  $default,) {final _that = this;
switch (_that) {
case _ViewUserModel():
return $default(_that.count,_that.message,_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String message,  List<AuthUser> users)?  $default,) {final _that = this;
switch (_that) {
case _ViewUserModel() when $default != null:
return $default(_that.count,_that.message,_that.users);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ViewUserModel implements ViewUserModel {
  const _ViewUserModel({required this.count, required this.message, required final  List<AuthUser> users}): _users = users;
  factory _ViewUserModel.fromJson(Map<String, dynamic> json) => _$ViewUserModelFromJson(json);

@override final  int count;
@override final  String message;
 final  List<AuthUser> _users;
@override List<AuthUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of ViewUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewUserModelCopyWith<_ViewUserModel> get copyWith => __$ViewUserModelCopyWithImpl<_ViewUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViewUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewUserModel&&(identical(other.count, count) || other.count == count)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._users, _users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,message,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'ViewUserModel(count: $count, message: $message, users: $users)';
}


}

/// @nodoc
abstract mixin class _$ViewUserModelCopyWith<$Res> implements $ViewUserModelCopyWith<$Res> {
  factory _$ViewUserModelCopyWith(_ViewUserModel value, $Res Function(_ViewUserModel) _then) = __$ViewUserModelCopyWithImpl;
@override @useResult
$Res call({
 int count, String message, List<AuthUser> users
});




}
/// @nodoc
class __$ViewUserModelCopyWithImpl<$Res>
    implements _$ViewUserModelCopyWith<$Res> {
  __$ViewUserModelCopyWithImpl(this._self, this._then);

  final _ViewUserModel _self;
  final $Res Function(_ViewUserModel) _then;

/// Create a copy of ViewUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? message = null,Object? users = null,}) {
  return _then(_ViewUserModel(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<AuthUser>,
  ));
}


}


/// @nodoc
mixin _$AuthUser {

 int get id; String get email; String get username;@JsonKey(name: 'divisionid') String get divisionId; String get code;@JsonKey(name: 'password_reset') bool get passwordReset;@JsonKey(name: 'is_account_locked') bool get isAccountLocked;@JsonKey(name: 'user_group') String get userGroup;@JsonKey(name: 'first_name') String get firstName;@JsonKey(name: 'last_name') String get lastName;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserCopyWith<AuthUser> get copyWith => _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.code, code) || other.code == code)&&(identical(other.passwordReset, passwordReset) || other.passwordReset == passwordReset)&&(identical(other.isAccountLocked, isAccountLocked) || other.isAccountLocked == isAccountLocked)&&(identical(other.userGroup, userGroup) || other.userGroup == userGroup)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,divisionId,code,passwordReset,isAccountLocked,userGroup,firstName,lastName,createdAt,updatedAt);

@override
String toString() {
  return 'AuthUser(id: $id, email: $email, username: $username, divisionId: $divisionId, code: $code, passwordReset: $passwordReset, isAccountLocked: $isAccountLocked, userGroup: $userGroup, firstName: $firstName, lastName: $lastName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res>  {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) = _$AuthUserCopyWithImpl;
@useResult
$Res call({
 int id, String email, String username,@JsonKey(name: 'divisionid') String divisionId, String code,@JsonKey(name: 'password_reset') bool passwordReset,@JsonKey(name: 'is_account_locked') bool isAccountLocked,@JsonKey(name: 'user_group') String userGroup,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$AuthUserCopyWithImpl<$Res>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = null,Object? divisionId = null,Object? code = null,Object? passwordReset = null,Object? isAccountLocked = null,Object? userGroup = null,Object? firstName = null,Object? lastName = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,divisionId: null == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,passwordReset: null == passwordReset ? _self.passwordReset : passwordReset // ignore: cast_nullable_to_non_nullable
as bool,isAccountLocked: null == isAccountLocked ? _self.isAccountLocked : isAccountLocked // ignore: cast_nullable_to_non_nullable
as bool,userGroup: null == userGroup ? _self.userGroup : userGroup // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUser value)  $default,){
final _that = this;
switch (_that) {
case _AuthUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUser value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String email,  String username, @JsonKey(name: 'divisionid')  String divisionId,  String code, @JsonKey(name: 'password_reset')  bool passwordReset, @JsonKey(name: 'is_account_locked')  bool isAccountLocked, @JsonKey(name: 'user_group')  String userGroup, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.divisionId,_that.code,_that.passwordReset,_that.isAccountLocked,_that.userGroup,_that.firstName,_that.lastName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String email,  String username, @JsonKey(name: 'divisionid')  String divisionId,  String code, @JsonKey(name: 'password_reset')  bool passwordReset, @JsonKey(name: 'is_account_locked')  bool isAccountLocked, @JsonKey(name: 'user_group')  String userGroup, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AuthUser():
return $default(_that.id,_that.email,_that.username,_that.divisionId,_that.code,_that.passwordReset,_that.isAccountLocked,_that.userGroup,_that.firstName,_that.lastName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String email,  String username, @JsonKey(name: 'divisionid')  String divisionId,  String code, @JsonKey(name: 'password_reset')  bool passwordReset, @JsonKey(name: 'is_account_locked')  bool isAccountLocked, @JsonKey(name: 'user_group')  String userGroup, @JsonKey(name: 'first_name')  String firstName, @JsonKey(name: 'last_name')  String lastName, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.divisionId,_that.code,_that.passwordReset,_that.isAccountLocked,_that.userGroup,_that.firstName,_that.lastName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthUser extends AuthUser {
  const _AuthUser({required this.id, required this.email, required this.username, @JsonKey(name: 'divisionid') required this.divisionId, required this.code, @JsonKey(name: 'password_reset') required this.passwordReset, @JsonKey(name: 'is_account_locked') required this.isAccountLocked, @JsonKey(name: 'user_group') required this.userGroup, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

@override final  int id;
@override final  String email;
@override final  String username;
@override@JsonKey(name: 'divisionid') final  String divisionId;
@override final  String code;
@override@JsonKey(name: 'password_reset') final  bool passwordReset;
@override@JsonKey(name: 'is_account_locked') final  bool isAccountLocked;
@override@JsonKey(name: 'user_group') final  String userGroup;
@override@JsonKey(name: 'first_name') final  String firstName;
@override@JsonKey(name: 'last_name') final  String lastName;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserCopyWith<_AuthUser> get copyWith => __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.code, code) || other.code == code)&&(identical(other.passwordReset, passwordReset) || other.passwordReset == passwordReset)&&(identical(other.isAccountLocked, isAccountLocked) || other.isAccountLocked == isAccountLocked)&&(identical(other.userGroup, userGroup) || other.userGroup == userGroup)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,divisionId,code,passwordReset,isAccountLocked,userGroup,firstName,lastName,createdAt,updatedAt);

@override
String toString() {
  return 'AuthUser(id: $id, email: $email, username: $username, divisionId: $divisionId, code: $code, passwordReset: $passwordReset, isAccountLocked: $isAccountLocked, userGroup: $userGroup, firstName: $firstName, lastName: $lastName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) = __$AuthUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String email, String username,@JsonKey(name: 'divisionid') String divisionId, String code,@JsonKey(name: 'password_reset') bool passwordReset,@JsonKey(name: 'is_account_locked') bool isAccountLocked,@JsonKey(name: 'user_group') String userGroup,@JsonKey(name: 'first_name') String firstName,@JsonKey(name: 'last_name') String lastName,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$AuthUserCopyWithImpl<$Res>
    implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = null,Object? divisionId = null,Object? code = null,Object? passwordReset = null,Object? isAccountLocked = null,Object? userGroup = null,Object? firstName = null,Object? lastName = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AuthUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,divisionId: null == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,passwordReset: null == passwordReset ? _self.passwordReset : passwordReset // ignore: cast_nullable_to_non_nullable
as bool,isAccountLocked: null == isAccountLocked ? _self.isAccountLocked : isAccountLocked // ignore: cast_nullable_to_non_nullable
as bool,userGroup: null == userGroup ? _self.userGroup : userGroup // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
