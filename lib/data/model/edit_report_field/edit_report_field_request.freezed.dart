// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_report_field_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditReportFieldRequest {

 String? get reportTypeID; String? get labelText; String? get name; String? get fieldType; ReportFieldDefaultValue? get defaultValue; String? get onlyAvailable; bool? get isRequired; bool? get doNotCopy; bool? get isArchive;
/// Create a copy of EditReportFieldRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditReportFieldRequestCopyWith<EditReportFieldRequest> get copyWith => _$EditReportFieldRequestCopyWithImpl<EditReportFieldRequest>(this as EditReportFieldRequest, _$identity);

  /// Serializes this EditReportFieldRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditReportFieldRequest&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.doNotCopy, doNotCopy) || other.doNotCopy == doNotCopy)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportTypeID,labelText,name,fieldType,defaultValue,onlyAvailable,isRequired,doNotCopy,isArchive);

@override
String toString() {
  return 'EditReportFieldRequest(reportTypeID: $reportTypeID, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, onlyAvailable: $onlyAvailable, isRequired: $isRequired, doNotCopy: $doNotCopy, isArchive: $isArchive)';
}


}

/// @nodoc
abstract mixin class $EditReportFieldRequestCopyWith<$Res>  {
  factory $EditReportFieldRequestCopyWith(EditReportFieldRequest value, $Res Function(EditReportFieldRequest) _then) = _$EditReportFieldRequestCopyWithImpl;
@useResult
$Res call({
 String? reportTypeID, String? labelText, String? name, String? fieldType, ReportFieldDefaultValue? defaultValue, String? onlyAvailable, bool? isRequired, bool? doNotCopy, bool? isArchive
});


$ReportFieldDefaultValueCopyWith<$Res>? get defaultValue;

}
/// @nodoc
class _$EditReportFieldRequestCopyWithImpl<$Res>
    implements $EditReportFieldRequestCopyWith<$Res> {
  _$EditReportFieldRequestCopyWithImpl(this._self, this._then);

  final EditReportFieldRequest _self;
  final $Res Function(EditReportFieldRequest) _then;

/// Create a copy of EditReportFieldRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportTypeID = freezed,Object? labelText = freezed,Object? name = freezed,Object? fieldType = freezed,Object? defaultValue = freezed,Object? onlyAvailable = freezed,Object? isRequired = freezed,Object? doNotCopy = freezed,Object? isArchive = freezed,}) {
  return _then(_self.copyWith(
reportTypeID: freezed == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String?,labelText: freezed == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,fieldType: freezed == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as ReportFieldDefaultValue?,onlyAvailable: freezed == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,doNotCopy: freezed == doNotCopy ? _self.doNotCopy : doNotCopy // ignore: cast_nullable_to_non_nullable
as bool?,isArchive: freezed == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of EditReportFieldRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportFieldDefaultValueCopyWith<$Res>? get defaultValue {
    if (_self.defaultValue == null) {
    return null;
  }

  return $ReportFieldDefaultValueCopyWith<$Res>(_self.defaultValue!, (value) {
    return _then(_self.copyWith(defaultValue: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditReportFieldRequest].
extension EditReportFieldRequestPatterns on EditReportFieldRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditReportFieldRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditReportFieldRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditReportFieldRequest value)  $default,){
final _that = this;
switch (_that) {
case _EditReportFieldRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditReportFieldRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EditReportFieldRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reportTypeID,  String? labelText,  String? name,  String? fieldType,  ReportFieldDefaultValue? defaultValue,  String? onlyAvailable,  bool? isRequired,  bool? doNotCopy,  bool? isArchive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditReportFieldRequest() when $default != null:
return $default(_that.reportTypeID,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.onlyAvailable,_that.isRequired,_that.doNotCopy,_that.isArchive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reportTypeID,  String? labelText,  String? name,  String? fieldType,  ReportFieldDefaultValue? defaultValue,  String? onlyAvailable,  bool? isRequired,  bool? doNotCopy,  bool? isArchive)  $default,) {final _that = this;
switch (_that) {
case _EditReportFieldRequest():
return $default(_that.reportTypeID,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.onlyAvailable,_that.isRequired,_that.doNotCopy,_that.isArchive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reportTypeID,  String? labelText,  String? name,  String? fieldType,  ReportFieldDefaultValue? defaultValue,  String? onlyAvailable,  bool? isRequired,  bool? doNotCopy,  bool? isArchive)?  $default,) {final _that = this;
switch (_that) {
case _EditReportFieldRequest() when $default != null:
return $default(_that.reportTypeID,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.onlyAvailable,_that.isRequired,_that.doNotCopy,_that.isArchive);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _EditReportFieldRequest implements EditReportFieldRequest {
  const _EditReportFieldRequest({this.reportTypeID, this.labelText, this.name, this.fieldType, this.defaultValue, this.onlyAvailable, this.isRequired, this.doNotCopy, this.isArchive});
  factory _EditReportFieldRequest.fromJson(Map<String, dynamic> json) => _$EditReportFieldRequestFromJson(json);

@override final  String? reportTypeID;
@override final  String? labelText;
@override final  String? name;
@override final  String? fieldType;
@override final  ReportFieldDefaultValue? defaultValue;
@override final  String? onlyAvailable;
@override final  bool? isRequired;
@override final  bool? doNotCopy;
@override final  bool? isArchive;

/// Create a copy of EditReportFieldRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditReportFieldRequestCopyWith<_EditReportFieldRequest> get copyWith => __$EditReportFieldRequestCopyWithImpl<_EditReportFieldRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditReportFieldRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditReportFieldRequest&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.doNotCopy, doNotCopy) || other.doNotCopy == doNotCopy)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportTypeID,labelText,name,fieldType,defaultValue,onlyAvailable,isRequired,doNotCopy,isArchive);

@override
String toString() {
  return 'EditReportFieldRequest(reportTypeID: $reportTypeID, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, onlyAvailable: $onlyAvailable, isRequired: $isRequired, doNotCopy: $doNotCopy, isArchive: $isArchive)';
}


}

/// @nodoc
abstract mixin class _$EditReportFieldRequestCopyWith<$Res> implements $EditReportFieldRequestCopyWith<$Res> {
  factory _$EditReportFieldRequestCopyWith(_EditReportFieldRequest value, $Res Function(_EditReportFieldRequest) _then) = __$EditReportFieldRequestCopyWithImpl;
@override @useResult
$Res call({
 String? reportTypeID, String? labelText, String? name, String? fieldType, ReportFieldDefaultValue? defaultValue, String? onlyAvailable, bool? isRequired, bool? doNotCopy, bool? isArchive
});


@override $ReportFieldDefaultValueCopyWith<$Res>? get defaultValue;

}
/// @nodoc
class __$EditReportFieldRequestCopyWithImpl<$Res>
    implements _$EditReportFieldRequestCopyWith<$Res> {
  __$EditReportFieldRequestCopyWithImpl(this._self, this._then);

  final _EditReportFieldRequest _self;
  final $Res Function(_EditReportFieldRequest) _then;

/// Create a copy of EditReportFieldRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportTypeID = freezed,Object? labelText = freezed,Object? name = freezed,Object? fieldType = freezed,Object? defaultValue = freezed,Object? onlyAvailable = freezed,Object? isRequired = freezed,Object? doNotCopy = freezed,Object? isArchive = freezed,}) {
  return _then(_EditReportFieldRequest(
reportTypeID: freezed == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String?,labelText: freezed == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,fieldType: freezed == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as ReportFieldDefaultValue?,onlyAvailable: freezed == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,doNotCopy: freezed == doNotCopy ? _self.doNotCopy : doNotCopy // ignore: cast_nullable_to_non_nullable
as bool?,isArchive: freezed == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of EditReportFieldRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportFieldDefaultValueCopyWith<$Res>? get defaultValue {
    if (_self.defaultValue == null) {
    return null;
  }

  return $ReportFieldDefaultValueCopyWith<$Res>(_self.defaultValue!, (value) {
    return _then(_self.copyWith(defaultValue: value));
  });
}
}

// dart format on
