// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_site_by_customer_id_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetSiteByCustomerIdModel {

@JsonKey(name: 'customer_id') String? get customerId;@JsonKey(name: 'sites') List<SiteCustomer>? get siteCustomers; int? get total;
/// Create a copy of GetSiteByCustomerIdModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetSiteByCustomerIdModelCopyWith<GetSiteByCustomerIdModel> get copyWith => _$GetSiteByCustomerIdModelCopyWithImpl<GetSiteByCustomerIdModel>(this as GetSiteByCustomerIdModel, _$identity);

  /// Serializes this GetSiteByCustomerIdModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetSiteByCustomerIdModel&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other.siteCustomers, siteCustomers)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerId,const DeepCollectionEquality().hash(siteCustomers),total);

@override
String toString() {
  return 'GetSiteByCustomerIdModel(customerId: $customerId, siteCustomers: $siteCustomers, total: $total)';
}


}

/// @nodoc
abstract mixin class $GetSiteByCustomerIdModelCopyWith<$Res>  {
  factory $GetSiteByCustomerIdModelCopyWith(GetSiteByCustomerIdModel value, $Res Function(GetSiteByCustomerIdModel) _then) = _$GetSiteByCustomerIdModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'sites') List<SiteCustomer>? siteCustomers, int? total
});




}
/// @nodoc
class _$GetSiteByCustomerIdModelCopyWithImpl<$Res>
    implements $GetSiteByCustomerIdModelCopyWith<$Res> {
  _$GetSiteByCustomerIdModelCopyWithImpl(this._self, this._then);

  final GetSiteByCustomerIdModel _self;
  final $Res Function(GetSiteByCustomerIdModel) _then;

/// Create a copy of GetSiteByCustomerIdModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerId = freezed,Object? siteCustomers = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,siteCustomers: freezed == siteCustomers ? _self.siteCustomers : siteCustomers // ignore: cast_nullable_to_non_nullable
as List<SiteCustomer>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetSiteByCustomerIdModel].
extension GetSiteByCustomerIdModelPatterns on GetSiteByCustomerIdModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetSiteByCustomerIdModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetSiteByCustomerIdModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetSiteByCustomerIdModel value)  $default,){
final _that = this;
switch (_that) {
case _GetSiteByCustomerIdModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetSiteByCustomerIdModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetSiteByCustomerIdModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'sites')  List<SiteCustomer>? siteCustomers,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetSiteByCustomerIdModel() when $default != null:
return $default(_that.customerId,_that.siteCustomers,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'sites')  List<SiteCustomer>? siteCustomers,  int? total)  $default,) {final _that = this;
switch (_that) {
case _GetSiteByCustomerIdModel():
return $default(_that.customerId,_that.siteCustomers,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'sites')  List<SiteCustomer>? siteCustomers,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _GetSiteByCustomerIdModel() when $default != null:
return $default(_that.customerId,_that.siteCustomers,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetSiteByCustomerIdModel implements GetSiteByCustomerIdModel {
  const _GetSiteByCustomerIdModel({@JsonKey(name: 'customer_id') this.customerId, @JsonKey(name: 'sites') final  List<SiteCustomer>? siteCustomers, this.total}): _siteCustomers = siteCustomers;
  factory _GetSiteByCustomerIdModel.fromJson(Map<String, dynamic> json) => _$GetSiteByCustomerIdModelFromJson(json);

@override@JsonKey(name: 'customer_id') final  String? customerId;
 final  List<SiteCustomer>? _siteCustomers;
@override@JsonKey(name: 'sites') List<SiteCustomer>? get siteCustomers {
  final value = _siteCustomers;
  if (value == null) return null;
  if (_siteCustomers is EqualUnmodifiableListView) return _siteCustomers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? total;

/// Create a copy of GetSiteByCustomerIdModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetSiteByCustomerIdModelCopyWith<_GetSiteByCustomerIdModel> get copyWith => __$GetSiteByCustomerIdModelCopyWithImpl<_GetSiteByCustomerIdModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetSiteByCustomerIdModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetSiteByCustomerIdModel&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other._siteCustomers, _siteCustomers)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerId,const DeepCollectionEquality().hash(_siteCustomers),total);

@override
String toString() {
  return 'GetSiteByCustomerIdModel(customerId: $customerId, siteCustomers: $siteCustomers, total: $total)';
}


}

/// @nodoc
abstract mixin class _$GetSiteByCustomerIdModelCopyWith<$Res> implements $GetSiteByCustomerIdModelCopyWith<$Res> {
  factory _$GetSiteByCustomerIdModelCopyWith(_GetSiteByCustomerIdModel value, $Res Function(_GetSiteByCustomerIdModel) _then) = __$GetSiteByCustomerIdModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'sites') List<SiteCustomer>? siteCustomers, int? total
});




}
/// @nodoc
class __$GetSiteByCustomerIdModelCopyWithImpl<$Res>
    implements _$GetSiteByCustomerIdModelCopyWith<$Res> {
  __$GetSiteByCustomerIdModelCopyWithImpl(this._self, this._then);

  final _GetSiteByCustomerIdModel _self;
  final $Res Function(_GetSiteByCustomerIdModel) _then;

/// Create a copy of GetSiteByCustomerIdModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerId = freezed,Object? siteCustomers = freezed,Object? total = freezed,}) {
  return _then(_GetSiteByCustomerIdModel(
customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,siteCustomers: freezed == siteCustomers ? _self._siteCustomers : siteCustomers // ignore: cast_nullable_to_non_nullable
as List<SiteCustomer>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SiteCustomer {

 String? get siteid;@JsonKey(name: 'sitecode') String? get siteCode;@JsonKey(name: 'customerid') String? get customerId;@JsonKey(name: 'sitename') String? get siteName; String? get area; String? get description; String? get notes;@JsonKey(name: 'divisionid') String? get divisionId;@JsonKey(name: 'divisionname') String? get divisionName; String? get logo; String? get address; bool? get archived;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of SiteCustomer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteCustomerCopyWith<SiteCustomer> get copyWith => _$SiteCustomerCopyWithImpl<SiteCustomer>(this as SiteCustomer, _$identity);

  /// Serializes this SiteCustomer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteCustomer&&(identical(other.siteid, siteid) || other.siteid == siteid)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.area, area) || other.area == area)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteid,siteCode,customerId,siteName,area,description,notes,divisionId,divisionName,logo,address,archived,createdAt,updatedAt);

@override
String toString() {
  return 'SiteCustomer(siteid: $siteid, siteCode: $siteCode, customerId: $customerId, siteName: $siteName, area: $area, description: $description, notes: $notes, divisionId: $divisionId, divisionName: $divisionName, logo: $logo, address: $address, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SiteCustomerCopyWith<$Res>  {
  factory $SiteCustomerCopyWith(SiteCustomer value, $Res Function(SiteCustomer) _then) = _$SiteCustomerCopyWithImpl;
@useResult
$Res call({
 String? siteid,@JsonKey(name: 'sitecode') String? siteCode,@JsonKey(name: 'customerid') String? customerId,@JsonKey(name: 'sitename') String? siteName, String? area, String? description, String? notes,@JsonKey(name: 'divisionid') String? divisionId,@JsonKey(name: 'divisionname') String? divisionName, String? logo, String? address, bool? archived,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$SiteCustomerCopyWithImpl<$Res>
    implements $SiteCustomerCopyWith<$Res> {
  _$SiteCustomerCopyWithImpl(this._self, this._then);

  final SiteCustomer _self;
  final $Res Function(SiteCustomer) _then;

/// Create a copy of SiteCustomer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? siteid = freezed,Object? siteCode = freezed,Object? customerId = freezed,Object? siteName = freezed,Object? area = freezed,Object? description = freezed,Object? notes = freezed,Object? divisionId = freezed,Object? divisionName = freezed,Object? logo = freezed,Object? address = freezed,Object? archived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
siteid: freezed == siteid ? _self.siteid : siteid // ignore: cast_nullable_to_non_nullable
as String?,siteCode: freezed == siteCode ? _self.siteCode : siteCode // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,divisionId: freezed == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String?,divisionName: freezed == divisionName ? _self.divisionName : divisionName // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteCustomer].
extension SiteCustomerPatterns on SiteCustomer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteCustomer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteCustomer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteCustomer value)  $default,){
final _that = this;
switch (_that) {
case _SiteCustomer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteCustomer value)?  $default,){
final _that = this;
switch (_that) {
case _SiteCustomer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? siteid, @JsonKey(name: 'sitecode')  String? siteCode, @JsonKey(name: 'customerid')  String? customerId, @JsonKey(name: 'sitename')  String? siteName,  String? area,  String? description,  String? notes, @JsonKey(name: 'divisionid')  String? divisionId, @JsonKey(name: 'divisionname')  String? divisionName,  String? logo,  String? address,  bool? archived, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteCustomer() when $default != null:
return $default(_that.siteid,_that.siteCode,_that.customerId,_that.siteName,_that.area,_that.description,_that.notes,_that.divisionId,_that.divisionName,_that.logo,_that.address,_that.archived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? siteid, @JsonKey(name: 'sitecode')  String? siteCode, @JsonKey(name: 'customerid')  String? customerId, @JsonKey(name: 'sitename')  String? siteName,  String? area,  String? description,  String? notes, @JsonKey(name: 'divisionid')  String? divisionId, @JsonKey(name: 'divisionname')  String? divisionName,  String? logo,  String? address,  bool? archived, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SiteCustomer():
return $default(_that.siteid,_that.siteCode,_that.customerId,_that.siteName,_that.area,_that.description,_that.notes,_that.divisionId,_that.divisionName,_that.logo,_that.address,_that.archived,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? siteid, @JsonKey(name: 'sitecode')  String? siteCode, @JsonKey(name: 'customerid')  String? customerId, @JsonKey(name: 'sitename')  String? siteName,  String? area,  String? description,  String? notes, @JsonKey(name: 'divisionid')  String? divisionId, @JsonKey(name: 'divisionname')  String? divisionName,  String? logo,  String? address,  bool? archived, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SiteCustomer() when $default != null:
return $default(_that.siteid,_that.siteCode,_that.customerId,_that.siteName,_that.area,_that.description,_that.notes,_that.divisionId,_that.divisionName,_that.logo,_that.address,_that.archived,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SiteCustomer implements SiteCustomer {
  const _SiteCustomer({this.siteid, @JsonKey(name: 'sitecode') this.siteCode, @JsonKey(name: 'customerid') this.customerId, @JsonKey(name: 'sitename') this.siteName, this.area, this.description, this.notes, @JsonKey(name: 'divisionid') this.divisionId, @JsonKey(name: 'divisionname') this.divisionName, this.logo, this.address, this.archived, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _SiteCustomer.fromJson(Map<String, dynamic> json) => _$SiteCustomerFromJson(json);

@override final  String? siteid;
@override@JsonKey(name: 'sitecode') final  String? siteCode;
@override@JsonKey(name: 'customerid') final  String? customerId;
@override@JsonKey(name: 'sitename') final  String? siteName;
@override final  String? area;
@override final  String? description;
@override final  String? notes;
@override@JsonKey(name: 'divisionid') final  String? divisionId;
@override@JsonKey(name: 'divisionname') final  String? divisionName;
@override final  String? logo;
@override final  String? address;
@override final  bool? archived;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of SiteCustomer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteCustomerCopyWith<_SiteCustomer> get copyWith => __$SiteCustomerCopyWithImpl<_SiteCustomer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteCustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteCustomer&&(identical(other.siteid, siteid) || other.siteid == siteid)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.area, area) || other.area == area)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteid,siteCode,customerId,siteName,area,description,notes,divisionId,divisionName,logo,address,archived,createdAt,updatedAt);

@override
String toString() {
  return 'SiteCustomer(siteid: $siteid, siteCode: $siteCode, customerId: $customerId, siteName: $siteName, area: $area, description: $description, notes: $notes, divisionId: $divisionId, divisionName: $divisionName, logo: $logo, address: $address, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SiteCustomerCopyWith<$Res> implements $SiteCustomerCopyWith<$Res> {
  factory _$SiteCustomerCopyWith(_SiteCustomer value, $Res Function(_SiteCustomer) _then) = __$SiteCustomerCopyWithImpl;
@override @useResult
$Res call({
 String? siteid,@JsonKey(name: 'sitecode') String? siteCode,@JsonKey(name: 'customerid') String? customerId,@JsonKey(name: 'sitename') String? siteName, String? area, String? description, String? notes,@JsonKey(name: 'divisionid') String? divisionId,@JsonKey(name: 'divisionname') String? divisionName, String? logo, String? address, bool? archived,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$SiteCustomerCopyWithImpl<$Res>
    implements _$SiteCustomerCopyWith<$Res> {
  __$SiteCustomerCopyWithImpl(this._self, this._then);

  final _SiteCustomer _self;
  final $Res Function(_SiteCustomer) _then;

/// Create a copy of SiteCustomer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteid = freezed,Object? siteCode = freezed,Object? customerId = freezed,Object? siteName = freezed,Object? area = freezed,Object? description = freezed,Object? notes = freezed,Object? divisionId = freezed,Object? divisionName = freezed,Object? logo = freezed,Object? address = freezed,Object? archived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_SiteCustomer(
siteid: freezed == siteid ? _self.siteid : siteid // ignore: cast_nullable_to_non_nullable
as String?,siteCode: freezed == siteCode ? _self.siteCode : siteCode // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,divisionId: freezed == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String?,divisionName: freezed == divisionName ? _self.divisionName : divisionName // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
