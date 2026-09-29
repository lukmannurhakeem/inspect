// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personnel_team_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonnelTeamModel {

@JsonKey(name: 'team_personnel_id') String? get teamPersonnelId; String? get name;@JsonKey(name: 'parent_team') String? get parentTeam; String? get type; String? get description;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of PersonnelTeamModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonnelTeamModelCopyWith<PersonnelTeamModel> get copyWith => _$PersonnelTeamModelCopyWithImpl<PersonnelTeamModel>(this as PersonnelTeamModel, _$identity);

  /// Serializes this PersonnelTeamModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonnelTeamModel&&(identical(other.teamPersonnelId, teamPersonnelId) || other.teamPersonnelId == teamPersonnelId)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentTeam, parentTeam) || other.parentTeam == parentTeam)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamPersonnelId,name,parentTeam,type,description,createdAt,updatedAt);

@override
String toString() {
  return 'PersonnelTeamModel(teamPersonnelId: $teamPersonnelId, name: $name, parentTeam: $parentTeam, type: $type, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PersonnelTeamModelCopyWith<$Res>  {
  factory $PersonnelTeamModelCopyWith(PersonnelTeamModel value, $Res Function(PersonnelTeamModel) _then) = _$PersonnelTeamModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'team_personnel_id') String? teamPersonnelId, String? name,@JsonKey(name: 'parent_team') String? parentTeam, String? type, String? description,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$PersonnelTeamModelCopyWithImpl<$Res>
    implements $PersonnelTeamModelCopyWith<$Res> {
  _$PersonnelTeamModelCopyWithImpl(this._self, this._then);

  final PersonnelTeamModel _self;
  final $Res Function(PersonnelTeamModel) _then;

/// Create a copy of PersonnelTeamModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamPersonnelId = freezed,Object? name = freezed,Object? parentTeam = freezed,Object? type = freezed,Object? description = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
teamPersonnelId: freezed == teamPersonnelId ? _self.teamPersonnelId : teamPersonnelId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentTeam: freezed == parentTeam ? _self.parentTeam : parentTeam // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonnelTeamModel].
extension PersonnelTeamModelPatterns on PersonnelTeamModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonnelTeamModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonnelTeamModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonnelTeamModel value)  $default,){
final _that = this;
switch (_that) {
case _PersonnelTeamModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonnelTeamModel value)?  $default,){
final _that = this;
switch (_that) {
case _PersonnelTeamModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'team_personnel_id')  String? teamPersonnelId,  String? name, @JsonKey(name: 'parent_team')  String? parentTeam,  String? type,  String? description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonnelTeamModel() when $default != null:
return $default(_that.teamPersonnelId,_that.name,_that.parentTeam,_that.type,_that.description,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'team_personnel_id')  String? teamPersonnelId,  String? name, @JsonKey(name: 'parent_team')  String? parentTeam,  String? type,  String? description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PersonnelTeamModel():
return $default(_that.teamPersonnelId,_that.name,_that.parentTeam,_that.type,_that.description,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'team_personnel_id')  String? teamPersonnelId,  String? name, @JsonKey(name: 'parent_team')  String? parentTeam,  String? type,  String? description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PersonnelTeamModel() when $default != null:
return $default(_that.teamPersonnelId,_that.name,_that.parentTeam,_that.type,_that.description,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonnelTeamModel implements PersonnelTeamModel {
  const _PersonnelTeamModel({@JsonKey(name: 'team_personnel_id') this.teamPersonnelId, this.name, @JsonKey(name: 'parent_team') this.parentTeam, this.type, this.description, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _PersonnelTeamModel.fromJson(Map<String, dynamic> json) => _$PersonnelTeamModelFromJson(json);

@override@JsonKey(name: 'team_personnel_id') final  String? teamPersonnelId;
@override final  String? name;
@override@JsonKey(name: 'parent_team') final  String? parentTeam;
@override final  String? type;
@override final  String? description;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of PersonnelTeamModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonnelTeamModelCopyWith<_PersonnelTeamModel> get copyWith => __$PersonnelTeamModelCopyWithImpl<_PersonnelTeamModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonnelTeamModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonnelTeamModel&&(identical(other.teamPersonnelId, teamPersonnelId) || other.teamPersonnelId == teamPersonnelId)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentTeam, parentTeam) || other.parentTeam == parentTeam)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamPersonnelId,name,parentTeam,type,description,createdAt,updatedAt);

@override
String toString() {
  return 'PersonnelTeamModel(teamPersonnelId: $teamPersonnelId, name: $name, parentTeam: $parentTeam, type: $type, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PersonnelTeamModelCopyWith<$Res> implements $PersonnelTeamModelCopyWith<$Res> {
  factory _$PersonnelTeamModelCopyWith(_PersonnelTeamModel value, $Res Function(_PersonnelTeamModel) _then) = __$PersonnelTeamModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'team_personnel_id') String? teamPersonnelId, String? name,@JsonKey(name: 'parent_team') String? parentTeam, String? type, String? description,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$PersonnelTeamModelCopyWithImpl<$Res>
    implements _$PersonnelTeamModelCopyWith<$Res> {
  __$PersonnelTeamModelCopyWithImpl(this._self, this._then);

  final _PersonnelTeamModel _self;
  final $Res Function(_PersonnelTeamModel) _then;

/// Create a copy of PersonnelTeamModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamPersonnelId = freezed,Object? name = freezed,Object? parentTeam = freezed,Object? type = freezed,Object? description = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PersonnelTeamModel(
teamPersonnelId: freezed == teamPersonnelId ? _self.teamPersonnelId : teamPersonnelId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentTeam: freezed == parentTeam ? _self.parentTeam : parentTeam // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
