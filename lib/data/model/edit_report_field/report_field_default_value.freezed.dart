// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_field_default_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportFieldDefaultValue {

 dynamic get value; bool get isReadOnly;
/// Create a copy of ReportFieldDefaultValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportFieldDefaultValueCopyWith<ReportFieldDefaultValue> get copyWith => _$ReportFieldDefaultValueCopyWithImpl<ReportFieldDefaultValue>(this as ReportFieldDefaultValue, _$identity);

  /// Serializes this ReportFieldDefaultValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportFieldDefaultValue&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value),isReadOnly);

@override
String toString() {
  return 'ReportFieldDefaultValue(value: $value, isReadOnly: $isReadOnly)';
}


}

/// @nodoc
abstract mixin class $ReportFieldDefaultValueCopyWith<$Res>  {
  factory $ReportFieldDefaultValueCopyWith(ReportFieldDefaultValue value, $Res Function(ReportFieldDefaultValue) _then) = _$ReportFieldDefaultValueCopyWithImpl;
@useResult
$Res call({
 dynamic value, bool isReadOnly
});




}
/// @nodoc
class _$ReportFieldDefaultValueCopyWithImpl<$Res>
    implements $ReportFieldDefaultValueCopyWith<$Res> {
  _$ReportFieldDefaultValueCopyWithImpl(this._self, this._then);

  final ReportFieldDefaultValue _self;
  final $Res Function(ReportFieldDefaultValue) _then;

/// Create a copy of ReportFieldDefaultValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,Object? isReadOnly = null,}) {
  return _then(_self.copyWith(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportFieldDefaultValue].
extension ReportFieldDefaultValuePatterns on ReportFieldDefaultValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportFieldDefaultValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportFieldDefaultValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportFieldDefaultValue value)  $default,){
final _that = this;
switch (_that) {
case _ReportFieldDefaultValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportFieldDefaultValue value)?  $default,){
final _that = this;
switch (_that) {
case _ReportFieldDefaultValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( dynamic value,  bool isReadOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportFieldDefaultValue() when $default != null:
return $default(_that.value,_that.isReadOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( dynamic value,  bool isReadOnly)  $default,) {final _that = this;
switch (_that) {
case _ReportFieldDefaultValue():
return $default(_that.value,_that.isReadOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( dynamic value,  bool isReadOnly)?  $default,) {final _that = this;
switch (_that) {
case _ReportFieldDefaultValue() when $default != null:
return $default(_that.value,_that.isReadOnly);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: true)
class _ReportFieldDefaultValue implements ReportFieldDefaultValue {
  const _ReportFieldDefaultValue({this.value, this.isReadOnly = false});
  factory _ReportFieldDefaultValue.fromJson(Map<String, dynamic> json) => _$ReportFieldDefaultValueFromJson(json);

@override final  dynamic value;
@override@JsonKey() final  bool isReadOnly;

/// Create a copy of ReportFieldDefaultValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportFieldDefaultValueCopyWith<_ReportFieldDefaultValue> get copyWith => __$ReportFieldDefaultValueCopyWithImpl<_ReportFieldDefaultValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportFieldDefaultValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportFieldDefaultValue&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value),isReadOnly);

@override
String toString() {
  return 'ReportFieldDefaultValue(value: $value, isReadOnly: $isReadOnly)';
}


}

/// @nodoc
abstract mixin class _$ReportFieldDefaultValueCopyWith<$Res> implements $ReportFieldDefaultValueCopyWith<$Res> {
  factory _$ReportFieldDefaultValueCopyWith(_ReportFieldDefaultValue value, $Res Function(_ReportFieldDefaultValue) _then) = __$ReportFieldDefaultValueCopyWithImpl;
@override @useResult
$Res call({
 dynamic value, bool isReadOnly
});




}
/// @nodoc
class __$ReportFieldDefaultValueCopyWithImpl<$Res>
    implements _$ReportFieldDefaultValueCopyWith<$Res> {
  __$ReportFieldDefaultValueCopyWithImpl(this._self, this._then);

  final _ReportFieldDefaultValue _self;
  final $Res Function(_ReportFieldDefaultValue) _then;

/// Create a copy of ReportFieldDefaultValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,Object? isReadOnly = null,}) {
  return _then(_ReportFieldDefaultValue(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
