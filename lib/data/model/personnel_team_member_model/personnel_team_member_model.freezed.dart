// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personnel_team_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonnelTeamMemberModel {

@JsonKey(name: 'personnel_members_id') String get personnelMembersId;@JsonKey(name: 'team_personnel_id') String get teamPersonnelId;@JsonKey(name: 'personnel_id') String get personnelId;@JsonKey(name: 'is_team_leader') bool get isTeamLeader;@JsonKey(name: 'is_primary_leader') bool get isPrimaryLeader;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of PersonnelTeamMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonnelTeamMemberModelCopyWith<PersonnelTeamMemberModel> get copyWith => _$PersonnelTeamMemberModelCopyWithImpl<PersonnelTeamMemberModel>(this as PersonnelTeamMemberModel, _$identity);

  /// Serializes this PersonnelTeamMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonnelTeamMemberModel&&(identical(other.personnelMembersId, personnelMembersId) || other.personnelMembersId == personnelMembersId)&&(identical(other.teamPersonnelId, teamPersonnelId) || other.teamPersonnelId == teamPersonnelId)&&(identical(other.personnelId, personnelId) || other.personnelId == personnelId)&&(identical(other.isTeamLeader, isTeamLeader) || other.isTeamLeader == isTeamLeader)&&(identical(other.isPrimaryLeader, isPrimaryLeader) || other.isPrimaryLeader == isPrimaryLeader)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personnelMembersId,teamPersonnelId,personnelId,isTeamLeader,isPrimaryLeader,createdAt,updatedAt);

@override
String toString() {
  return 'PersonnelTeamMemberModel(personnelMembersId: $personnelMembersId, teamPersonnelId: $teamPersonnelId, personnelId: $personnelId, isTeamLeader: $isTeamLeader, isPrimaryLeader: $isPrimaryLeader, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PersonnelTeamMemberModelCopyWith<$Res>  {
  factory $PersonnelTeamMemberModelCopyWith(PersonnelTeamMemberModel value, $Res Function(PersonnelTeamMemberModel) _then) = _$PersonnelTeamMemberModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'personnel_members_id') String personnelMembersId,@JsonKey(name: 'team_personnel_id') String teamPersonnelId,@JsonKey(name: 'personnel_id') String personnelId,@JsonKey(name: 'is_team_leader') bool isTeamLeader,@JsonKey(name: 'is_primary_leader') bool isPrimaryLeader,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$PersonnelTeamMemberModelCopyWithImpl<$Res>
    implements $PersonnelTeamMemberModelCopyWith<$Res> {
  _$PersonnelTeamMemberModelCopyWithImpl(this._self, this._then);

  final PersonnelTeamMemberModel _self;
  final $Res Function(PersonnelTeamMemberModel) _then;

/// Create a copy of PersonnelTeamMemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? personnelMembersId = null,Object? teamPersonnelId = null,Object? personnelId = null,Object? isTeamLeader = null,Object? isPrimaryLeader = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
personnelMembersId: null == personnelMembersId ? _self.personnelMembersId : personnelMembersId // ignore: cast_nullable_to_non_nullable
as String,teamPersonnelId: null == teamPersonnelId ? _self.teamPersonnelId : teamPersonnelId // ignore: cast_nullable_to_non_nullable
as String,personnelId: null == personnelId ? _self.personnelId : personnelId // ignore: cast_nullable_to_non_nullable
as String,isTeamLeader: null == isTeamLeader ? _self.isTeamLeader : isTeamLeader // ignore: cast_nullable_to_non_nullable
as bool,isPrimaryLeader: null == isPrimaryLeader ? _self.isPrimaryLeader : isPrimaryLeader // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonnelTeamMemberModel].
extension PersonnelTeamMemberModelPatterns on PersonnelTeamMemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonnelTeamMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonnelTeamMemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonnelTeamMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonnelTeamMemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonnelTeamMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonnelTeamMemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'personnel_members_id')  String personnelMembersId, @JsonKey(name: 'team_personnel_id')  String teamPersonnelId, @JsonKey(name: 'personnel_id')  String personnelId, @JsonKey(name: 'is_team_leader')  bool isTeamLeader, @JsonKey(name: 'is_primary_leader')  bool isPrimaryLeader, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonnelTeamMemberModel() when $default != null:
return $default(_that.personnelMembersId,_that.teamPersonnelId,_that.personnelId,_that.isTeamLeader,_that.isPrimaryLeader,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'personnel_members_id')  String personnelMembersId, @JsonKey(name: 'team_personnel_id')  String teamPersonnelId, @JsonKey(name: 'personnel_id')  String personnelId, @JsonKey(name: 'is_team_leader')  bool isTeamLeader, @JsonKey(name: 'is_primary_leader')  bool isPrimaryLeader, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PersonnelTeamMemberModel():
return $default(_that.personnelMembersId,_that.teamPersonnelId,_that.personnelId,_that.isTeamLeader,_that.isPrimaryLeader,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'personnel_members_id')  String personnelMembersId, @JsonKey(name: 'team_personnel_id')  String teamPersonnelId, @JsonKey(name: 'personnel_id')  String personnelId, @JsonKey(name: 'is_team_leader')  bool isTeamLeader, @JsonKey(name: 'is_primary_leader')  bool isPrimaryLeader, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PersonnelTeamMemberModel() when $default != null:
return $default(_that.personnelMembersId,_that.teamPersonnelId,_that.personnelId,_that.isTeamLeader,_that.isPrimaryLeader,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonnelTeamMemberModel implements PersonnelTeamMemberModel {
  const _PersonnelTeamMemberModel({@JsonKey(name: 'personnel_members_id') required this.personnelMembersId, @JsonKey(name: 'team_personnel_id') required this.teamPersonnelId, @JsonKey(name: 'personnel_id') required this.personnelId, @JsonKey(name: 'is_team_leader') required this.isTeamLeader, @JsonKey(name: 'is_primary_leader') required this.isPrimaryLeader, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _PersonnelTeamMemberModel.fromJson(Map<String, dynamic> json) => _$PersonnelTeamMemberModelFromJson(json);

@override@JsonKey(name: 'personnel_members_id') final  String personnelMembersId;
@override@JsonKey(name: 'team_personnel_id') final  String teamPersonnelId;
@override@JsonKey(name: 'personnel_id') final  String personnelId;
@override@JsonKey(name: 'is_team_leader') final  bool isTeamLeader;
@override@JsonKey(name: 'is_primary_leader') final  bool isPrimaryLeader;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of PersonnelTeamMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonnelTeamMemberModelCopyWith<_PersonnelTeamMemberModel> get copyWith => __$PersonnelTeamMemberModelCopyWithImpl<_PersonnelTeamMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonnelTeamMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonnelTeamMemberModel&&(identical(other.personnelMembersId, personnelMembersId) || other.personnelMembersId == personnelMembersId)&&(identical(other.teamPersonnelId, teamPersonnelId) || other.teamPersonnelId == teamPersonnelId)&&(identical(other.personnelId, personnelId) || other.personnelId == personnelId)&&(identical(other.isTeamLeader, isTeamLeader) || other.isTeamLeader == isTeamLeader)&&(identical(other.isPrimaryLeader, isPrimaryLeader) || other.isPrimaryLeader == isPrimaryLeader)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personnelMembersId,teamPersonnelId,personnelId,isTeamLeader,isPrimaryLeader,createdAt,updatedAt);

@override
String toString() {
  return 'PersonnelTeamMemberModel(personnelMembersId: $personnelMembersId, teamPersonnelId: $teamPersonnelId, personnelId: $personnelId, isTeamLeader: $isTeamLeader, isPrimaryLeader: $isPrimaryLeader, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PersonnelTeamMemberModelCopyWith<$Res> implements $PersonnelTeamMemberModelCopyWith<$Res> {
  factory _$PersonnelTeamMemberModelCopyWith(_PersonnelTeamMemberModel value, $Res Function(_PersonnelTeamMemberModel) _then) = __$PersonnelTeamMemberModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'personnel_members_id') String personnelMembersId,@JsonKey(name: 'team_personnel_id') String teamPersonnelId,@JsonKey(name: 'personnel_id') String personnelId,@JsonKey(name: 'is_team_leader') bool isTeamLeader,@JsonKey(name: 'is_primary_leader') bool isPrimaryLeader,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$PersonnelTeamMemberModelCopyWithImpl<$Res>
    implements _$PersonnelTeamMemberModelCopyWith<$Res> {
  __$PersonnelTeamMemberModelCopyWithImpl(this._self, this._then);

  final _PersonnelTeamMemberModel _self;
  final $Res Function(_PersonnelTeamMemberModel) _then;

/// Create a copy of PersonnelTeamMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? personnelMembersId = null,Object? teamPersonnelId = null,Object? personnelId = null,Object? isTeamLeader = null,Object? isPrimaryLeader = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PersonnelTeamMemberModel(
personnelMembersId: null == personnelMembersId ? _self.personnelMembersId : personnelMembersId // ignore: cast_nullable_to_non_nullable
as String,teamPersonnelId: null == teamPersonnelId ? _self.teamPersonnelId : teamPersonnelId // ignore: cast_nullable_to_non_nullable
as String,personnelId: null == personnelId ? _self.personnelId : personnelId // ignore: cast_nullable_to_non_nullable
as String,isTeamLeader: null == isTeamLeader ? _self.isTeamLeader : isTeamLeader // ignore: cast_nullable_to_non_nullable
as bool,isPrimaryLeader: null == isPrimaryLeader ? _self.isPrimaryLeader : isPrimaryLeader // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AddMemberResponse {

 PersonnelTeamMemberModel get data; String get message;
/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddMemberResponseCopyWith<AddMemberResponse> get copyWith => _$AddMemberResponseCopyWithImpl<AddMemberResponse>(this as AddMemberResponse, _$identity);

  /// Serializes this AddMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddMemberResponse&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,message);

@override
String toString() {
  return 'AddMemberResponse(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $AddMemberResponseCopyWith<$Res>  {
  factory $AddMemberResponseCopyWith(AddMemberResponse value, $Res Function(AddMemberResponse) _then) = _$AddMemberResponseCopyWithImpl;
@useResult
$Res call({
 PersonnelTeamMemberModel data, String message
});


$PersonnelTeamMemberModelCopyWith<$Res> get data;

}
/// @nodoc
class _$AddMemberResponseCopyWithImpl<$Res>
    implements $AddMemberResponseCopyWith<$Res> {
  _$AddMemberResponseCopyWithImpl(this._self, this._then);

  final AddMemberResponse _self;
  final $Res Function(AddMemberResponse) _then;

/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? message = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PersonnelTeamMemberModel,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonnelTeamMemberModelCopyWith<$Res> get data {
  
  return $PersonnelTeamMemberModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddMemberResponse].
extension AddMemberResponsePatterns on AddMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _AddMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PersonnelTeamMemberModel data,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
return $default(_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PersonnelTeamMemberModel data,  String message)  $default,) {final _that = this;
switch (_that) {
case _AddMemberResponse():
return $default(_that.data,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PersonnelTeamMemberModel data,  String message)?  $default,) {final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
return $default(_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddMemberResponse implements AddMemberResponse {
  const _AddMemberResponse({required this.data, required this.message});
  factory _AddMemberResponse.fromJson(Map<String, dynamic> json) => _$AddMemberResponseFromJson(json);

@override final  PersonnelTeamMemberModel data;
@override final  String message;

/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddMemberResponseCopyWith<_AddMemberResponse> get copyWith => __$AddMemberResponseCopyWithImpl<_AddMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddMemberResponse&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,message);

@override
String toString() {
  return 'AddMemberResponse(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AddMemberResponseCopyWith<$Res> implements $AddMemberResponseCopyWith<$Res> {
  factory _$AddMemberResponseCopyWith(_AddMemberResponse value, $Res Function(_AddMemberResponse) _then) = __$AddMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 PersonnelTeamMemberModel data, String message
});


@override $PersonnelTeamMemberModelCopyWith<$Res> get data;

}
/// @nodoc
class __$AddMemberResponseCopyWithImpl<$Res>
    implements _$AddMemberResponseCopyWith<$Res> {
  __$AddMemberResponseCopyWithImpl(this._self, this._then);

  final _AddMemberResponse _self;
  final $Res Function(_AddMemberResponse) _then;

/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? message = null,}) {
  return _then(_AddMemberResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PersonnelTeamMemberModel,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonnelTeamMemberModelCopyWith<$Res> get data {
  
  return $PersonnelTeamMemberModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
