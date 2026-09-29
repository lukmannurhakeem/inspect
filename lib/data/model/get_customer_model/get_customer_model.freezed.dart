// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetCustomerModel {

 List<Customer> get customers; int? get total; int? get page; int? get limit; int? get totalPages;
/// Create a copy of GetCustomerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCustomerModelCopyWith<GetCustomerModel> get copyWith => _$GetCustomerModelCopyWithImpl<GetCustomerModel>(this as GetCustomerModel, _$identity);

  /// Serializes this GetCustomerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCustomerModel&&const DeepCollectionEquality().equals(other.customers, customers)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(customers),total,page,limit,totalPages);

@override
String toString() {
  return 'GetCustomerModel(customers: $customers, total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $GetCustomerModelCopyWith<$Res>  {
  factory $GetCustomerModelCopyWith(GetCustomerModel value, $Res Function(GetCustomerModel) _then) = _$GetCustomerModelCopyWithImpl;
@useResult
$Res call({
 List<Customer> customers, int? total, int? page, int? limit, int? totalPages
});




}
/// @nodoc
class _$GetCustomerModelCopyWithImpl<$Res>
    implements $GetCustomerModelCopyWith<$Res> {
  _$GetCustomerModelCopyWithImpl(this._self, this._then);

  final GetCustomerModel _self;
  final $Res Function(GetCustomerModel) _then;

/// Create a copy of GetCustomerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customers = null,Object? total = freezed,Object? page = freezed,Object? limit = freezed,Object? totalPages = freezed,}) {
  return _then(_self.copyWith(
customers: null == customers ? _self.customers : customers // ignore: cast_nullable_to_non_nullable
as List<Customer>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCustomerModel].
extension GetCustomerModelPatterns on GetCustomerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetCustomerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetCustomerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetCustomerModel value)  $default,){
final _that = this;
switch (_that) {
case _GetCustomerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetCustomerModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetCustomerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Customer> customers,  int? total,  int? page,  int? limit,  int? totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetCustomerModel() when $default != null:
return $default(_that.customers,_that.total,_that.page,_that.limit,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Customer> customers,  int? total,  int? page,  int? limit,  int? totalPages)  $default,) {final _that = this;
switch (_that) {
case _GetCustomerModel():
return $default(_that.customers,_that.total,_that.page,_that.limit,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Customer> customers,  int? total,  int? page,  int? limit,  int? totalPages)?  $default,) {final _that = this;
switch (_that) {
case _GetCustomerModel() when $default != null:
return $default(_that.customers,_that.total,_that.page,_that.limit,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetCustomerModel implements GetCustomerModel {
  const _GetCustomerModel({final  List<Customer> customers = const [], this.total, this.page, this.limit, this.totalPages}): _customers = customers;
  factory _GetCustomerModel.fromJson(Map<String, dynamic> json) => _$GetCustomerModelFromJson(json);

 final  List<Customer> _customers;
@override@JsonKey() List<Customer> get customers {
  if (_customers is EqualUnmodifiableListView) return _customers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customers);
}

@override final  int? total;
@override final  int? page;
@override final  int? limit;
@override final  int? totalPages;

/// Create a copy of GetCustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetCustomerModelCopyWith<_GetCustomerModel> get copyWith => __$GetCustomerModelCopyWithImpl<_GetCustomerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetCustomerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCustomerModel&&const DeepCollectionEquality().equals(other._customers, _customers)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_customers),total,page,limit,totalPages);

@override
String toString() {
  return 'GetCustomerModel(customers: $customers, total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$GetCustomerModelCopyWith<$Res> implements $GetCustomerModelCopyWith<$Res> {
  factory _$GetCustomerModelCopyWith(_GetCustomerModel value, $Res Function(_GetCustomerModel) _then) = __$GetCustomerModelCopyWithImpl;
@override @useResult
$Res call({
 List<Customer> customers, int? total, int? page, int? limit, int? totalPages
});




}
/// @nodoc
class __$GetCustomerModelCopyWithImpl<$Res>
    implements _$GetCustomerModelCopyWith<$Res> {
  __$GetCustomerModelCopyWithImpl(this._self, this._then);

  final _GetCustomerModel _self;
  final $Res Function(_GetCustomerModel) _then;

/// Create a copy of GetCustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customers = null,Object? total = freezed,Object? page = freezed,Object? limit = freezed,Object? totalPages = freezed,}) {
  return _then(_GetCustomerModel(
customers: null == customers ? _self._customers : customers // ignore: cast_nullable_to_non_nullable
as List<Customer>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Customer {

 String? get customerid; String? get customername; String? get sitecode;@JsonKey(name: 'account_code') String? get accountCode; String? get agent;@JsonKey(name: 'agent_name') String? get agentName; String? get notes; String? get logo; String? get address; bool? get archived; String? get divisionid; String? get divisionname;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.customerid, customerid) || other.customerid == customerid)&&(identical(other.customername, customername) || other.customername == customername)&&(identical(other.sitecode, sitecode) || other.sitecode == sitecode)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.divisionid, divisionid) || other.divisionid == divisionid)&&(identical(other.divisionname, divisionname) || other.divisionname == divisionname)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerid,customername,sitecode,accountCode,agent,agentName,notes,logo,address,archived,divisionid,divisionname,createdAt,updatedAt);

@override
String toString() {
  return 'Customer(customerid: $customerid, customername: $customername, sitecode: $sitecode, accountCode: $accountCode, agent: $agent, agentName: $agentName, notes: $notes, logo: $logo, address: $address, archived: $archived, divisionid: $divisionid, divisionname: $divisionname, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 String? customerid, String? customername, String? sitecode,@JsonKey(name: 'account_code') String? accountCode, String? agent,@JsonKey(name: 'agent_name') String? agentName, String? notes, String? logo, String? address, bool? archived, String? divisionid, String? divisionname,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerid = freezed,Object? customername = freezed,Object? sitecode = freezed,Object? accountCode = freezed,Object? agent = freezed,Object? agentName = freezed,Object? notes = freezed,Object? logo = freezed,Object? address = freezed,Object? archived = freezed,Object? divisionid = freezed,Object? divisionname = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
customerid: freezed == customerid ? _self.customerid : customerid // ignore: cast_nullable_to_non_nullable
as String?,customername: freezed == customername ? _self.customername : customername // ignore: cast_nullable_to_non_nullable
as String?,sitecode: freezed == sitecode ? _self.sitecode : sitecode // ignore: cast_nullable_to_non_nullable
as String?,accountCode: freezed == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String?,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,divisionid: freezed == divisionid ? _self.divisionid : divisionid // ignore: cast_nullable_to_non_nullable
as String?,divisionname: freezed == divisionname ? _self.divisionname : divisionname // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? customerid,  String? customername,  String? sitecode, @JsonKey(name: 'account_code')  String? accountCode,  String? agent, @JsonKey(name: 'agent_name')  String? agentName,  String? notes,  String? logo,  String? address,  bool? archived,  String? divisionid,  String? divisionname, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.customerid,_that.customername,_that.sitecode,_that.accountCode,_that.agent,_that.agentName,_that.notes,_that.logo,_that.address,_that.archived,_that.divisionid,_that.divisionname,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? customerid,  String? customername,  String? sitecode, @JsonKey(name: 'account_code')  String? accountCode,  String? agent, @JsonKey(name: 'agent_name')  String? agentName,  String? notes,  String? logo,  String? address,  bool? archived,  String? divisionid,  String? divisionname, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.customerid,_that.customername,_that.sitecode,_that.accountCode,_that.agent,_that.agentName,_that.notes,_that.logo,_that.address,_that.archived,_that.divisionid,_that.divisionname,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? customerid,  String? customername,  String? sitecode, @JsonKey(name: 'account_code')  String? accountCode,  String? agent, @JsonKey(name: 'agent_name')  String? agentName,  String? notes,  String? logo,  String? address,  bool? archived,  String? divisionid,  String? divisionname, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.customerid,_that.customername,_that.sitecode,_that.accountCode,_that.agent,_that.agentName,_that.notes,_that.logo,_that.address,_that.archived,_that.divisionid,_that.divisionname,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer implements Customer {
  const _Customer({this.customerid, this.customername, this.sitecode, @JsonKey(name: 'account_code') this.accountCode, this.agent, @JsonKey(name: 'agent_name') this.agentName, this.notes, this.logo, this.address, this.archived, this.divisionid, this.divisionname, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override final  String? customerid;
@override final  String? customername;
@override final  String? sitecode;
@override@JsonKey(name: 'account_code') final  String? accountCode;
@override final  String? agent;
@override@JsonKey(name: 'agent_name') final  String? agentName;
@override final  String? notes;
@override final  String? logo;
@override final  String? address;
@override final  bool? archived;
@override final  String? divisionid;
@override final  String? divisionname;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.customerid, customerid) || other.customerid == customerid)&&(identical(other.customername, customername) || other.customername == customername)&&(identical(other.sitecode, sitecode) || other.sitecode == sitecode)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.divisionid, divisionid) || other.divisionid == divisionid)&&(identical(other.divisionname, divisionname) || other.divisionname == divisionname)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerid,customername,sitecode,accountCode,agent,agentName,notes,logo,address,archived,divisionid,divisionname,createdAt,updatedAt);

@override
String toString() {
  return 'Customer(customerid: $customerid, customername: $customername, sitecode: $sitecode, accountCode: $accountCode, agent: $agent, agentName: $agentName, notes: $notes, logo: $logo, address: $address, archived: $archived, divisionid: $divisionid, divisionname: $divisionname, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 String? customerid, String? customername, String? sitecode,@JsonKey(name: 'account_code') String? accountCode, String? agent,@JsonKey(name: 'agent_name') String? agentName, String? notes, String? logo, String? address, bool? archived, String? divisionid, String? divisionname,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerid = freezed,Object? customername = freezed,Object? sitecode = freezed,Object? accountCode = freezed,Object? agent = freezed,Object? agentName = freezed,Object? notes = freezed,Object? logo = freezed,Object? address = freezed,Object? archived = freezed,Object? divisionid = freezed,Object? divisionname = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Customer(
customerid: freezed == customerid ? _self.customerid : customerid // ignore: cast_nullable_to_non_nullable
as String?,customername: freezed == customername ? _self.customername : customername // ignore: cast_nullable_to_non_nullable
as String?,sitecode: freezed == sitecode ? _self.sitecode : sitecode // ignore: cast_nullable_to_non_nullable
as String?,accountCode: freezed == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String?,agent: freezed == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String?,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,divisionid: freezed == divisionid ? _self.divisionid : divisionid // ignore: cast_nullable_to_non_nullable
as String?,divisionname: freezed == divisionname ? _self.divisionname : divisionname // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
