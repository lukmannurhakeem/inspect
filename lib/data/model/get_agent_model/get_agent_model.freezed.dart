// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_agent_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetAgentModel {

@JsonKey(name: 'data') List<Agent> get agents; String? get message; Pagination? get pagination;
/// Create a copy of GetAgentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetAgentModelCopyWith<GetAgentModel> get copyWith => _$GetAgentModelCopyWithImpl<GetAgentModel>(this as GetAgentModel, _$identity);

  /// Serializes this GetAgentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetAgentModel&&const DeepCollectionEquality().equals(other.agents, agents)&&(identical(other.message, message) || other.message == message)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(agents),message,pagination);

@override
String toString() {
  return 'GetAgentModel(agents: $agents, message: $message, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $GetAgentModelCopyWith<$Res>  {
  factory $GetAgentModelCopyWith(GetAgentModel value, $Res Function(GetAgentModel) _then) = _$GetAgentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'data') List<Agent> agents, String? message, Pagination? pagination
});


$PaginationCopyWith<$Res>? get pagination;

}
/// @nodoc
class _$GetAgentModelCopyWithImpl<$Res>
    implements $GetAgentModelCopyWith<$Res> {
  _$GetAgentModelCopyWithImpl(this._self, this._then);

  final GetAgentModel _self;
  final $Res Function(GetAgentModel) _then;

/// Create a copy of GetAgentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agents = null,Object? message = freezed,Object? pagination = freezed,}) {
  return _then(_self.copyWith(
agents: null == agents ? _self.agents : agents // ignore: cast_nullable_to_non_nullable
as List<Agent>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as Pagination?,
  ));
}
/// Create a copy of GetAgentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [GetAgentModel].
extension GetAgentModelPatterns on GetAgentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetAgentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAgentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetAgentModel value)  $default,){
final _that = this;
switch (_that) {
case _GetAgentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetAgentModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetAgentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'data')  List<Agent> agents,  String? message,  Pagination? pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAgentModel() when $default != null:
return $default(_that.agents,_that.message,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'data')  List<Agent> agents,  String? message,  Pagination? pagination)  $default,) {final _that = this;
switch (_that) {
case _GetAgentModel():
return $default(_that.agents,_that.message,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'data')  List<Agent> agents,  String? message,  Pagination? pagination)?  $default,) {final _that = this;
switch (_that) {
case _GetAgentModel() when $default != null:
return $default(_that.agents,_that.message,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetAgentModel implements GetAgentModel {
  const _GetAgentModel({@JsonKey(name: 'data') final  List<Agent> agents = const [], this.message, this.pagination}): _agents = agents;
  factory _GetAgentModel.fromJson(Map<String, dynamic> json) => _$GetAgentModelFromJson(json);

 final  List<Agent> _agents;
@override@JsonKey(name: 'data') List<Agent> get agents {
  if (_agents is EqualUnmodifiableListView) return _agents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agents);
}

@override final  String? message;
@override final  Pagination? pagination;

/// Create a copy of GetAgentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetAgentModelCopyWith<_GetAgentModel> get copyWith => __$GetAgentModelCopyWithImpl<_GetAgentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetAgentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetAgentModel&&const DeepCollectionEquality().equals(other._agents, _agents)&&(identical(other.message, message) || other.message == message)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_agents),message,pagination);

@override
String toString() {
  return 'GetAgentModel(agents: $agents, message: $message, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$GetAgentModelCopyWith<$Res> implements $GetAgentModelCopyWith<$Res> {
  factory _$GetAgentModelCopyWith(_GetAgentModel value, $Res Function(_GetAgentModel) _then) = __$GetAgentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'data') List<Agent> agents, String? message, Pagination? pagination
});


@override $PaginationCopyWith<$Res>? get pagination;

}
/// @nodoc
class __$GetAgentModelCopyWithImpl<$Res>
    implements _$GetAgentModelCopyWith<$Res> {
  __$GetAgentModelCopyWithImpl(this._self, this._then);

  final _GetAgentModel _self;
  final $Res Function(_GetAgentModel) _then;

/// Create a copy of GetAgentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agents = null,Object? message = freezed,Object? pagination = freezed,}) {
  return _then(_GetAgentModel(
agents: null == agents ? _self._agents : agents // ignore: cast_nullable_to_non_nullable
as List<Agent>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as Pagination?,
  ));
}

/// Create a copy of GetAgentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$Agent {

 String? get agentid; String? get agentname; String? get accountcode; String? get notes; String? get address; String? get status;
/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentCopyWith<Agent> get copyWith => _$AgentCopyWithImpl<Agent>(this as Agent, _$identity);

  /// Serializes this Agent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Agent&&(identical(other.agentid, agentid) || other.agentid == agentid)&&(identical(other.agentname, agentname) || other.agentname == agentname)&&(identical(other.accountcode, accountcode) || other.accountcode == accountcode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.address, address) || other.address == address)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentid,agentname,accountcode,notes,address,status);

@override
String toString() {
  return 'Agent(agentid: $agentid, agentname: $agentname, accountcode: $accountcode, notes: $notes, address: $address, status: $status)';
}


}

/// @nodoc
abstract mixin class $AgentCopyWith<$Res>  {
  factory $AgentCopyWith(Agent value, $Res Function(Agent) _then) = _$AgentCopyWithImpl;
@useResult
$Res call({
 String? agentid, String? agentname, String? accountcode, String? notes, String? address, String? status
});




}
/// @nodoc
class _$AgentCopyWithImpl<$Res>
    implements $AgentCopyWith<$Res> {
  _$AgentCopyWithImpl(this._self, this._then);

  final Agent _self;
  final $Res Function(Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agentid = freezed,Object? agentname = freezed,Object? accountcode = freezed,Object? notes = freezed,Object? address = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
agentid: freezed == agentid ? _self.agentid : agentid // ignore: cast_nullable_to_non_nullable
as String?,agentname: freezed == agentname ? _self.agentname : agentname // ignore: cast_nullable_to_non_nullable
as String?,accountcode: freezed == accountcode ? _self.accountcode : accountcode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Agent].
extension AgentPatterns on Agent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Agent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Agent value)  $default,){
final _that = this;
switch (_that) {
case _Agent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Agent value)?  $default,){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? agentid,  String? agentname,  String? accountcode,  String? notes,  String? address,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that.agentid,_that.agentname,_that.accountcode,_that.notes,_that.address,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? agentid,  String? agentname,  String? accountcode,  String? notes,  String? address,  String? status)  $default,) {final _that = this;
switch (_that) {
case _Agent():
return $default(_that.agentid,_that.agentname,_that.accountcode,_that.notes,_that.address,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? agentid,  String? agentname,  String? accountcode,  String? notes,  String? address,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that.agentid,_that.agentname,_that.accountcode,_that.notes,_that.address,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Agent implements Agent {
  const _Agent({this.agentid, this.agentname, this.accountcode, this.notes, this.address, this.status});
  factory _Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);

@override final  String? agentid;
@override final  String? agentname;
@override final  String? accountcode;
@override final  String? notes;
@override final  String? address;
@override final  String? status;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentCopyWith<_Agent> get copyWith => __$AgentCopyWithImpl<_Agent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Agent&&(identical(other.agentid, agentid) || other.agentid == agentid)&&(identical(other.agentname, agentname) || other.agentname == agentname)&&(identical(other.accountcode, accountcode) || other.accountcode == accountcode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.address, address) || other.address == address)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentid,agentname,accountcode,notes,address,status);

@override
String toString() {
  return 'Agent(agentid: $agentid, agentname: $agentname, accountcode: $accountcode, notes: $notes, address: $address, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AgentCopyWith<$Res> implements $AgentCopyWith<$Res> {
  factory _$AgentCopyWith(_Agent value, $Res Function(_Agent) _then) = __$AgentCopyWithImpl;
@override @useResult
$Res call({
 String? agentid, String? agentname, String? accountcode, String? notes, String? address, String? status
});




}
/// @nodoc
class __$AgentCopyWithImpl<$Res>
    implements _$AgentCopyWith<$Res> {
  __$AgentCopyWithImpl(this._self, this._then);

  final _Agent _self;
  final $Res Function(_Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agentid = freezed,Object? agentname = freezed,Object? accountcode = freezed,Object? notes = freezed,Object? address = freezed,Object? status = freezed,}) {
  return _then(_Agent(
agentid: freezed == agentid ? _self.agentid : agentid // ignore: cast_nullable_to_non_nullable
as String?,agentname: freezed == agentname ? _self.agentname : agentname // ignore: cast_nullable_to_non_nullable
as String?,accountcode: freezed == accountcode ? _self.accountcode : accountcode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Pagination {

 int? get limit; int? get page; int? get total;
/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationCopyWith<Pagination> get copyWith => _$PaginationCopyWithImpl<Pagination>(this as Pagination, _$identity);

  /// Serializes this Pagination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pagination&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,page,total);

@override
String toString() {
  return 'Pagination(limit: $limit, page: $page, total: $total)';
}


}

/// @nodoc
abstract mixin class $PaginationCopyWith<$Res>  {
  factory $PaginationCopyWith(Pagination value, $Res Function(Pagination) _then) = _$PaginationCopyWithImpl;
@useResult
$Res call({
 int? limit, int? page, int? total
});




}
/// @nodoc
class _$PaginationCopyWithImpl<$Res>
    implements $PaginationCopyWith<$Res> {
  _$PaginationCopyWithImpl(this._self, this._then);

  final Pagination _self;
  final $Res Function(Pagination) _then;

/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limit = freezed,Object? page = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Pagination].
extension PaginationPatterns on Pagination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pagination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pagination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pagination value)  $default,){
final _that = this;
switch (_that) {
case _Pagination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pagination value)?  $default,){
final _that = this;
switch (_that) {
case _Pagination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? limit,  int? page,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pagination() when $default != null:
return $default(_that.limit,_that.page,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? limit,  int? page,  int? total)  $default,) {final _that = this;
switch (_that) {
case _Pagination():
return $default(_that.limit,_that.page,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? limit,  int? page,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _Pagination() when $default != null:
return $default(_that.limit,_that.page,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pagination implements Pagination {
  const _Pagination({this.limit, this.page, this.total});
  factory _Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);

@override final  int? limit;
@override final  int? page;
@override final  int? total;

/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationCopyWith<_Pagination> get copyWith => __$PaginationCopyWithImpl<_Pagination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pagination&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,page,total);

@override
String toString() {
  return 'Pagination(limit: $limit, page: $page, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaginationCopyWith<$Res> implements $PaginationCopyWith<$Res> {
  factory _$PaginationCopyWith(_Pagination value, $Res Function(_Pagination) _then) = __$PaginationCopyWithImpl;
@override @useResult
$Res call({
 int? limit, int? page, int? total
});




}
/// @nodoc
class __$PaginationCopyWithImpl<$Res>
    implements _$PaginationCopyWith<$Res> {
  __$PaginationCopyWithImpl(this._self, this._then);

  final _Pagination _self;
  final $Res Function(_Pagination) _then;

/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limit = freezed,Object? page = freezed,Object? total = freezed,}) {
  return _then(_Pagination(
limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
