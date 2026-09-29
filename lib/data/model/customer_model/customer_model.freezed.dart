// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerModel {

 String get name; String get accountCode; String get division; String get status;
/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<CustomerModel> get copyWith => _$CustomerModelCopyWithImpl<CustomerModel>(this as CustomerModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerModel&&(identical(other.name, name) || other.name == name)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.division, division) || other.division == division)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,name,accountCode,division,status);

@override
String toString() {
  return 'CustomerModel(name: $name, accountCode: $accountCode, division: $division, status: $status)';
}


}

/// @nodoc
abstract mixin class $CustomerModelCopyWith<$Res>  {
  factory $CustomerModelCopyWith(CustomerModel value, $Res Function(CustomerModel) _then) = _$CustomerModelCopyWithImpl;
@useResult
$Res call({
 String name, String accountCode, String division, String status
});




}
/// @nodoc
class _$CustomerModelCopyWithImpl<$Res>
    implements $CustomerModelCopyWith<$Res> {
  _$CustomerModelCopyWithImpl(this._self, this._then);

  final CustomerModel _self;
  final $Res Function(CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? accountCode = null,Object? division = null,Object? status = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerModel].
extension CustomerModelPatterns on CustomerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String accountCode,  String division,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.name,_that.accountCode,_that.division,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String accountCode,  String division,  String status)  $default,) {final _that = this;
switch (_that) {
case _CustomerModel():
return $default(_that.name,_that.accountCode,_that.division,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String accountCode,  String division,  String status)?  $default,) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.name,_that.accountCode,_that.division,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerModel implements CustomerModel {
  const _CustomerModel({required this.name, required this.accountCode, required this.division, required this.status});
  

@override final  String name;
@override final  String accountCode;
@override final  String division;
@override final  String status;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerModelCopyWith<_CustomerModel> get copyWith => __$CustomerModelCopyWithImpl<_CustomerModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerModel&&(identical(other.name, name) || other.name == name)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.division, division) || other.division == division)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,name,accountCode,division,status);

@override
String toString() {
  return 'CustomerModel(name: $name, accountCode: $accountCode, division: $division, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CustomerModelCopyWith<$Res> implements $CustomerModelCopyWith<$Res> {
  factory _$CustomerModelCopyWith(_CustomerModel value, $Res Function(_CustomerModel) _then) = __$CustomerModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String accountCode, String division, String status
});




}
/// @nodoc
class __$CustomerModelCopyWithImpl<$Res>
    implements _$CustomerModelCopyWith<$Res> {
  __$CustomerModelCopyWithImpl(this._self, this._then);

  final _CustomerModel _self;
  final $Res Function(_CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? accountCode = null,Object? division = null,Object? status = null,}) {
  return _then(_CustomerModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
