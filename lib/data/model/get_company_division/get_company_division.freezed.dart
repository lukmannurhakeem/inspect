// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_company_division.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetCompanyDivision {

 String? get divisionid; String? get customerid; String? get divisionname; String? get divisioncode; String? get logo; String? get address; String? get telephone; String? get website; String? get email; String? get fax; String? get culture; String? get timezone;
/// Create a copy of GetCompanyDivision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCompanyDivisionCopyWith<GetCompanyDivision> get copyWith => _$GetCompanyDivisionCopyWithImpl<GetCompanyDivision>(this as GetCompanyDivision, _$identity);

  /// Serializes this GetCompanyDivision to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCompanyDivision&&(identical(other.divisionid, divisionid) || other.divisionid == divisionid)&&(identical(other.customerid, customerid) || other.customerid == customerid)&&(identical(other.divisionname, divisionname) || other.divisionname == divisionname)&&(identical(other.divisioncode, divisioncode) || other.divisioncode == divisioncode)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.telephone, telephone) || other.telephone == telephone)&&(identical(other.website, website) || other.website == website)&&(identical(other.email, email) || other.email == email)&&(identical(other.fax, fax) || other.fax == fax)&&(identical(other.culture, culture) || other.culture == culture)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,divisionid,customerid,divisionname,divisioncode,logo,address,telephone,website,email,fax,culture,timezone);

@override
String toString() {
  return 'GetCompanyDivision(divisionid: $divisionid, customerid: $customerid, divisionname: $divisionname, divisioncode: $divisioncode, logo: $logo, address: $address, telephone: $telephone, website: $website, email: $email, fax: $fax, culture: $culture, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $GetCompanyDivisionCopyWith<$Res>  {
  factory $GetCompanyDivisionCopyWith(GetCompanyDivision value, $Res Function(GetCompanyDivision) _then) = _$GetCompanyDivisionCopyWithImpl;
@useResult
$Res call({
 String? divisionid, String? customerid, String? divisionname, String? divisioncode, String? logo, String? address, String? telephone, String? website, String? email, String? fax, String? culture, String? timezone
});




}
/// @nodoc
class _$GetCompanyDivisionCopyWithImpl<$Res>
    implements $GetCompanyDivisionCopyWith<$Res> {
  _$GetCompanyDivisionCopyWithImpl(this._self, this._then);

  final GetCompanyDivision _self;
  final $Res Function(GetCompanyDivision) _then;

/// Create a copy of GetCompanyDivision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? divisionid = freezed,Object? customerid = freezed,Object? divisionname = freezed,Object? divisioncode = freezed,Object? logo = freezed,Object? address = freezed,Object? telephone = freezed,Object? website = freezed,Object? email = freezed,Object? fax = freezed,Object? culture = freezed,Object? timezone = freezed,}) {
  return _then(_self.copyWith(
divisionid: freezed == divisionid ? _self.divisionid : divisionid // ignore: cast_nullable_to_non_nullable
as String?,customerid: freezed == customerid ? _self.customerid : customerid // ignore: cast_nullable_to_non_nullable
as String?,divisionname: freezed == divisionname ? _self.divisionname : divisionname // ignore: cast_nullable_to_non_nullable
as String?,divisioncode: freezed == divisioncode ? _self.divisioncode : divisioncode // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,fax: freezed == fax ? _self.fax : fax // ignore: cast_nullable_to_non_nullable
as String?,culture: freezed == culture ? _self.culture : culture // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCompanyDivision].
extension GetCompanyDivisionPatterns on GetCompanyDivision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetCompanyDivision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetCompanyDivision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetCompanyDivision value)  $default,){
final _that = this;
switch (_that) {
case _GetCompanyDivision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetCompanyDivision value)?  $default,){
final _that = this;
switch (_that) {
case _GetCompanyDivision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? divisionid,  String? customerid,  String? divisionname,  String? divisioncode,  String? logo,  String? address,  String? telephone,  String? website,  String? email,  String? fax,  String? culture,  String? timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetCompanyDivision() when $default != null:
return $default(_that.divisionid,_that.customerid,_that.divisionname,_that.divisioncode,_that.logo,_that.address,_that.telephone,_that.website,_that.email,_that.fax,_that.culture,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? divisionid,  String? customerid,  String? divisionname,  String? divisioncode,  String? logo,  String? address,  String? telephone,  String? website,  String? email,  String? fax,  String? culture,  String? timezone)  $default,) {final _that = this;
switch (_that) {
case _GetCompanyDivision():
return $default(_that.divisionid,_that.customerid,_that.divisionname,_that.divisioncode,_that.logo,_that.address,_that.telephone,_that.website,_that.email,_that.fax,_that.culture,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? divisionid,  String? customerid,  String? divisionname,  String? divisioncode,  String? logo,  String? address,  String? telephone,  String? website,  String? email,  String? fax,  String? culture,  String? timezone)?  $default,) {final _that = this;
switch (_that) {
case _GetCompanyDivision() when $default != null:
return $default(_that.divisionid,_that.customerid,_that.divisionname,_that.divisioncode,_that.logo,_that.address,_that.telephone,_that.website,_that.email,_that.fax,_that.culture,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetCompanyDivision implements GetCompanyDivision {
  const _GetCompanyDivision({this.divisionid, this.customerid, this.divisionname, this.divisioncode, this.logo, this.address, this.telephone, this.website, this.email, this.fax, this.culture, this.timezone});
  factory _GetCompanyDivision.fromJson(Map<String, dynamic> json) => _$GetCompanyDivisionFromJson(json);

@override final  String? divisionid;
@override final  String? customerid;
@override final  String? divisionname;
@override final  String? divisioncode;
@override final  String? logo;
@override final  String? address;
@override final  String? telephone;
@override final  String? website;
@override final  String? email;
@override final  String? fax;
@override final  String? culture;
@override final  String? timezone;

/// Create a copy of GetCompanyDivision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetCompanyDivisionCopyWith<_GetCompanyDivision> get copyWith => __$GetCompanyDivisionCopyWithImpl<_GetCompanyDivision>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetCompanyDivisionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCompanyDivision&&(identical(other.divisionid, divisionid) || other.divisionid == divisionid)&&(identical(other.customerid, customerid) || other.customerid == customerid)&&(identical(other.divisionname, divisionname) || other.divisionname == divisionname)&&(identical(other.divisioncode, divisioncode) || other.divisioncode == divisioncode)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.telephone, telephone) || other.telephone == telephone)&&(identical(other.website, website) || other.website == website)&&(identical(other.email, email) || other.email == email)&&(identical(other.fax, fax) || other.fax == fax)&&(identical(other.culture, culture) || other.culture == culture)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,divisionid,customerid,divisionname,divisioncode,logo,address,telephone,website,email,fax,culture,timezone);

@override
String toString() {
  return 'GetCompanyDivision(divisionid: $divisionid, customerid: $customerid, divisionname: $divisionname, divisioncode: $divisioncode, logo: $logo, address: $address, telephone: $telephone, website: $website, email: $email, fax: $fax, culture: $culture, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$GetCompanyDivisionCopyWith<$Res> implements $GetCompanyDivisionCopyWith<$Res> {
  factory _$GetCompanyDivisionCopyWith(_GetCompanyDivision value, $Res Function(_GetCompanyDivision) _then) = __$GetCompanyDivisionCopyWithImpl;
@override @useResult
$Res call({
 String? divisionid, String? customerid, String? divisionname, String? divisioncode, String? logo, String? address, String? telephone, String? website, String? email, String? fax, String? culture, String? timezone
});




}
/// @nodoc
class __$GetCompanyDivisionCopyWithImpl<$Res>
    implements _$GetCompanyDivisionCopyWith<$Res> {
  __$GetCompanyDivisionCopyWithImpl(this._self, this._then);

  final _GetCompanyDivision _self;
  final $Res Function(_GetCompanyDivision) _then;

/// Create a copy of GetCompanyDivision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? divisionid = freezed,Object? customerid = freezed,Object? divisionname = freezed,Object? divisioncode = freezed,Object? logo = freezed,Object? address = freezed,Object? telephone = freezed,Object? website = freezed,Object? email = freezed,Object? fax = freezed,Object? culture = freezed,Object? timezone = freezed,}) {
  return _then(_GetCompanyDivision(
divisionid: freezed == divisionid ? _self.divisionid : divisionid // ignore: cast_nullable_to_non_nullable
as String?,customerid: freezed == customerid ? _self.customerid : customerid // ignore: cast_nullable_to_non_nullable
as String?,divisionname: freezed == divisionname ? _self.divisionname : divisionname // ignore: cast_nullable_to_non_nullable
as String?,divisioncode: freezed == divisioncode ? _self.divisioncode : divisioncode // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,fax: freezed == fax ? _self.fax : fax // ignore: cast_nullable_to_non_nullable
as String?,culture: freezed == culture ? _self.culture : culture // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
