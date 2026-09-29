// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_site_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetSiteModel {

 List<Site> get sites; int? get total; int? get page; int? get limit; int? get totalPages;
/// Create a copy of GetSiteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetSiteModelCopyWith<GetSiteModel> get copyWith => _$GetSiteModelCopyWithImpl<GetSiteModel>(this as GetSiteModel, _$identity);

  /// Serializes this GetSiteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetSiteModel&&const DeepCollectionEquality().equals(other.sites, sites)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sites),total,page,limit,totalPages);

@override
String toString() {
  return 'GetSiteModel(sites: $sites, total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $GetSiteModelCopyWith<$Res>  {
  factory $GetSiteModelCopyWith(GetSiteModel value, $Res Function(GetSiteModel) _then) = _$GetSiteModelCopyWithImpl;
@useResult
$Res call({
 List<Site> sites, int? total, int? page, int? limit, int? totalPages
});




}
/// @nodoc
class _$GetSiteModelCopyWithImpl<$Res>
    implements $GetSiteModelCopyWith<$Res> {
  _$GetSiteModelCopyWithImpl(this._self, this._then);

  final GetSiteModel _self;
  final $Res Function(GetSiteModel) _then;

/// Create a copy of GetSiteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sites = null,Object? total = freezed,Object? page = freezed,Object? limit = freezed,Object? totalPages = freezed,}) {
  return _then(_self.copyWith(
sites: null == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<Site>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetSiteModel].
extension GetSiteModelPatterns on GetSiteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetSiteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetSiteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetSiteModel value)  $default,){
final _that = this;
switch (_that) {
case _GetSiteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetSiteModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetSiteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Site> sites,  int? total,  int? page,  int? limit,  int? totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetSiteModel() when $default != null:
return $default(_that.sites,_that.total,_that.page,_that.limit,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Site> sites,  int? total,  int? page,  int? limit,  int? totalPages)  $default,) {final _that = this;
switch (_that) {
case _GetSiteModel():
return $default(_that.sites,_that.total,_that.page,_that.limit,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Site> sites,  int? total,  int? page,  int? limit,  int? totalPages)?  $default,) {final _that = this;
switch (_that) {
case _GetSiteModel() when $default != null:
return $default(_that.sites,_that.total,_that.page,_that.limit,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetSiteModel implements GetSiteModel {
  const _GetSiteModel({final  List<Site> sites = const [], this.total, this.page, this.limit, this.totalPages}): _sites = sites;
  factory _GetSiteModel.fromJson(Map<String, dynamic> json) => _$GetSiteModelFromJson(json);

 final  List<Site> _sites;
@override@JsonKey() List<Site> get sites {
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sites);
}

@override final  int? total;
@override final  int? page;
@override final  int? limit;
@override final  int? totalPages;

/// Create a copy of GetSiteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetSiteModelCopyWith<_GetSiteModel> get copyWith => __$GetSiteModelCopyWithImpl<_GetSiteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetSiteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetSiteModel&&const DeepCollectionEquality().equals(other._sites, _sites)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sites),total,page,limit,totalPages);

@override
String toString() {
  return 'GetSiteModel(sites: $sites, total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$GetSiteModelCopyWith<$Res> implements $GetSiteModelCopyWith<$Res> {
  factory _$GetSiteModelCopyWith(_GetSiteModel value, $Res Function(_GetSiteModel) _then) = __$GetSiteModelCopyWithImpl;
@override @useResult
$Res call({
 List<Site> sites, int? total, int? page, int? limit, int? totalPages
});




}
/// @nodoc
class __$GetSiteModelCopyWithImpl<$Res>
    implements _$GetSiteModelCopyWith<$Res> {
  __$GetSiteModelCopyWithImpl(this._self, this._then);

  final _GetSiteModel _self;
  final $Res Function(_GetSiteModel) _then;

/// Create a copy of GetSiteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sites = null,Object? total = freezed,Object? page = freezed,Object? limit = freezed,Object? totalPages = freezed,}) {
  return _then(_GetSiteModel(
sites: null == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<Site>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Site {

 String? get siteid;@JsonKey(name: 'sitecode') String? get siteCode;@JsonKey(name: 'customerid') String? get customerId;@JsonKey(name: 'sitename') String? get siteName; String? get area; String? get description; String? get notes;@JsonKey(name: 'divisionid') String? get divisionId;@JsonKey(name: 'divisionname') String? get divisionName; String? get logo; String? get address; bool? get archived;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteCopyWith<Site> get copyWith => _$SiteCopyWithImpl<Site>(this as Site, _$identity);

  /// Serializes this Site to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Site&&(identical(other.siteid, siteid) || other.siteid == siteid)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.area, area) || other.area == area)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteid,siteCode,customerId,siteName,area,description,notes,divisionId,divisionName,logo,address,archived,createdAt,updatedAt);

@override
String toString() {
  return 'Site(siteid: $siteid, siteCode: $siteCode, customerId: $customerId, siteName: $siteName, area: $area, description: $description, notes: $notes, divisionId: $divisionId, divisionName: $divisionName, logo: $logo, address: $address, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SiteCopyWith<$Res>  {
  factory $SiteCopyWith(Site value, $Res Function(Site) _then) = _$SiteCopyWithImpl;
@useResult
$Res call({
 String? siteid,@JsonKey(name: 'sitecode') String? siteCode,@JsonKey(name: 'customerid') String? customerId,@JsonKey(name: 'sitename') String? siteName, String? area, String? description, String? notes,@JsonKey(name: 'divisionid') String? divisionId,@JsonKey(name: 'divisionname') String? divisionName, String? logo, String? address, bool? archived,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$SiteCopyWithImpl<$Res>
    implements $SiteCopyWith<$Res> {
  _$SiteCopyWithImpl(this._self, this._then);

  final Site _self;
  final $Res Function(Site) _then;

/// Create a copy of Site
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
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Site].
extension SitePatterns on Site {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Site value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Site() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Site value)  $default,){
final _that = this;
switch (_that) {
case _Site():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Site value)?  $default,){
final _that = this;
switch (_that) {
case _Site() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? siteid, @JsonKey(name: 'sitecode')  String? siteCode, @JsonKey(name: 'customerid')  String? customerId, @JsonKey(name: 'sitename')  String? siteName,  String? area,  String? description,  String? notes, @JsonKey(name: 'divisionid')  String? divisionId, @JsonKey(name: 'divisionname')  String? divisionName,  String? logo,  String? address,  bool? archived, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Site() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? siteid, @JsonKey(name: 'sitecode')  String? siteCode, @JsonKey(name: 'customerid')  String? customerId, @JsonKey(name: 'sitename')  String? siteName,  String? area,  String? description,  String? notes, @JsonKey(name: 'divisionid')  String? divisionId, @JsonKey(name: 'divisionname')  String? divisionName,  String? logo,  String? address,  bool? archived, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Site():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? siteid, @JsonKey(name: 'sitecode')  String? siteCode, @JsonKey(name: 'customerid')  String? customerId, @JsonKey(name: 'sitename')  String? siteName,  String? area,  String? description,  String? notes, @JsonKey(name: 'divisionid')  String? divisionId, @JsonKey(name: 'divisionname')  String? divisionName,  String? logo,  String? address,  bool? archived, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Site() when $default != null:
return $default(_that.siteid,_that.siteCode,_that.customerId,_that.siteName,_that.area,_that.description,_that.notes,_that.divisionId,_that.divisionName,_that.logo,_that.address,_that.archived,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Site implements Site {
  const _Site({this.siteid, @JsonKey(name: 'sitecode') this.siteCode, @JsonKey(name: 'customerid') this.customerId, @JsonKey(name: 'sitename') this.siteName, this.area, this.description, this.notes, @JsonKey(name: 'divisionid') this.divisionId, @JsonKey(name: 'divisionname') this.divisionName, this.logo, this.address, this.archived, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);

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
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteCopyWith<_Site> get copyWith => __$SiteCopyWithImpl<_Site>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SiteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Site&&(identical(other.siteid, siteid) || other.siteid == siteid)&&(identical(other.siteCode, siteCode) || other.siteCode == siteCode)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.area, area) || other.area == area)&&(identical(other.description, description) || other.description == description)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.divisionName, divisionName) || other.divisionName == divisionName)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,siteid,siteCode,customerId,siteName,area,description,notes,divisionId,divisionName,logo,address,archived,createdAt,updatedAt);

@override
String toString() {
  return 'Site(siteid: $siteid, siteCode: $siteCode, customerId: $customerId, siteName: $siteName, area: $area, description: $description, notes: $notes, divisionId: $divisionId, divisionName: $divisionName, logo: $logo, address: $address, archived: $archived, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SiteCopyWith<$Res> implements $SiteCopyWith<$Res> {
  factory _$SiteCopyWith(_Site value, $Res Function(_Site) _then) = __$SiteCopyWithImpl;
@override @useResult
$Res call({
 String? siteid,@JsonKey(name: 'sitecode') String? siteCode,@JsonKey(name: 'customerid') String? customerId,@JsonKey(name: 'sitename') String? siteName, String? area, String? description, String? notes,@JsonKey(name: 'divisionid') String? divisionId,@JsonKey(name: 'divisionname') String? divisionName, String? logo, String? address, bool? archived,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$SiteCopyWithImpl<$Res>
    implements _$SiteCopyWith<$Res> {
  __$SiteCopyWithImpl(this._self, this._then);

  final _Site _self;
  final $Res Function(_Site) _then;

/// Create a copy of Site
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? siteid = freezed,Object? siteCode = freezed,Object? customerId = freezed,Object? siteName = freezed,Object? area = freezed,Object? description = freezed,Object? notes = freezed,Object? divisionId = freezed,Object? divisionName = freezed,Object? logo = freezed,Object? address = freezed,Object? archived = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Site(
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
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
