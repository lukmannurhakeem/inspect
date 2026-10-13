// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_report_field_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditReportFieldResponse {

 ReportFieldData get data; String get message;
/// Create a copy of EditReportFieldResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditReportFieldResponseCopyWith<EditReportFieldResponse> get copyWith => _$EditReportFieldResponseCopyWithImpl<EditReportFieldResponse>(this as EditReportFieldResponse, _$identity);

  /// Serializes this EditReportFieldResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditReportFieldResponse&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,message);

@override
String toString() {
  return 'EditReportFieldResponse(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $EditReportFieldResponseCopyWith<$Res>  {
  factory $EditReportFieldResponseCopyWith(EditReportFieldResponse value, $Res Function(EditReportFieldResponse) _then) = _$EditReportFieldResponseCopyWithImpl;
@useResult
$Res call({
 ReportFieldData data, String message
});


$ReportFieldDataCopyWith<$Res> get data;

}
/// @nodoc
class _$EditReportFieldResponseCopyWithImpl<$Res>
    implements $EditReportFieldResponseCopyWith<$Res> {
  _$EditReportFieldResponseCopyWithImpl(this._self, this._then);

  final EditReportFieldResponse _self;
  final $Res Function(EditReportFieldResponse) _then;

/// Create a copy of EditReportFieldResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? message = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ReportFieldData,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of EditReportFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportFieldDataCopyWith<$Res> get data {
  
  return $ReportFieldDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditReportFieldResponse].
extension EditReportFieldResponsePatterns on EditReportFieldResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditReportFieldResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditReportFieldResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditReportFieldResponse value)  $default,){
final _that = this;
switch (_that) {
case _EditReportFieldResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditReportFieldResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EditReportFieldResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportFieldData data,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditReportFieldResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportFieldData data,  String message)  $default,) {final _that = this;
switch (_that) {
case _EditReportFieldResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportFieldData data,  String message)?  $default,) {final _that = this;
switch (_that) {
case _EditReportFieldResponse() when $default != null:
return $default(_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditReportFieldResponse implements EditReportFieldResponse {
  const _EditReportFieldResponse({required this.data, required this.message});
  factory _EditReportFieldResponse.fromJson(Map<String, dynamic> json) => _$EditReportFieldResponseFromJson(json);

@override final  ReportFieldData data;
@override final  String message;

/// Create a copy of EditReportFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditReportFieldResponseCopyWith<_EditReportFieldResponse> get copyWith => __$EditReportFieldResponseCopyWithImpl<_EditReportFieldResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditReportFieldResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditReportFieldResponse&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,message);

@override
String toString() {
  return 'EditReportFieldResponse(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$EditReportFieldResponseCopyWith<$Res> implements $EditReportFieldResponseCopyWith<$Res> {
  factory _$EditReportFieldResponseCopyWith(_EditReportFieldResponse value, $Res Function(_EditReportFieldResponse) _then) = __$EditReportFieldResponseCopyWithImpl;
@override @useResult
$Res call({
 ReportFieldData data, String message
});


@override $ReportFieldDataCopyWith<$Res> get data;

}
/// @nodoc
class __$EditReportFieldResponseCopyWithImpl<$Res>
    implements _$EditReportFieldResponseCopyWith<$Res> {
  __$EditReportFieldResponseCopyWithImpl(this._self, this._then);

  final _EditReportFieldResponse _self;
  final $Res Function(_EditReportFieldResponse) _then;

/// Create a copy of EditReportFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? message = null,}) {
  return _then(_EditReportFieldResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ReportFieldData,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of EditReportFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportFieldDataCopyWith<$Res> get data {
  
  return $ReportFieldDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ReportFieldData {

 String get reportFieldID; String get reportTypeID; String get labelText; String get name; String get fieldType; ReportFieldDefaultValue? get defaultValue; String? get onlyAvailable; bool get isRequired; bool get doNotCopy; bool get isArchive;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ReportFieldData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportFieldDataCopyWith<ReportFieldData> get copyWith => _$ReportFieldDataCopyWithImpl<ReportFieldData>(this as ReportFieldData, _$identity);

  /// Serializes this ReportFieldData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportFieldData&&(identical(other.reportFieldID, reportFieldID) || other.reportFieldID == reportFieldID)&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.doNotCopy, doNotCopy) || other.doNotCopy == doNotCopy)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportFieldID,reportTypeID,labelText,name,fieldType,defaultValue,onlyAvailable,isRequired,doNotCopy,isArchive,createdAt,updatedAt);

@override
String toString() {
  return 'ReportFieldData(reportFieldID: $reportFieldID, reportTypeID: $reportTypeID, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, onlyAvailable: $onlyAvailable, isRequired: $isRequired, doNotCopy: $doNotCopy, isArchive: $isArchive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReportFieldDataCopyWith<$Res>  {
  factory $ReportFieldDataCopyWith(ReportFieldData value, $Res Function(ReportFieldData) _then) = _$ReportFieldDataCopyWithImpl;
@useResult
$Res call({
 String reportFieldID, String reportTypeID, String labelText, String name, String fieldType, ReportFieldDefaultValue? defaultValue, String? onlyAvailable, bool isRequired, bool doNotCopy, bool isArchive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


$ReportFieldDefaultValueCopyWith<$Res>? get defaultValue;

}
/// @nodoc
class _$ReportFieldDataCopyWithImpl<$Res>
    implements $ReportFieldDataCopyWith<$Res> {
  _$ReportFieldDataCopyWithImpl(this._self, this._then);

  final ReportFieldData _self;
  final $Res Function(ReportFieldData) _then;

/// Create a copy of ReportFieldData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportFieldID = null,Object? reportTypeID = null,Object? labelText = null,Object? name = null,Object? fieldType = null,Object? defaultValue = freezed,Object? onlyAvailable = freezed,Object? isRequired = null,Object? doNotCopy = null,Object? isArchive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
reportFieldID: null == reportFieldID ? _self.reportFieldID : reportFieldID // ignore: cast_nullable_to_non_nullable
as String,reportTypeID: null == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String,labelText: null == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as ReportFieldDefaultValue?,onlyAvailable: freezed == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,doNotCopy: null == doNotCopy ? _self.doNotCopy : doNotCopy // ignore: cast_nullable_to_non_nullable
as bool,isArchive: null == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ReportFieldData
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


/// Adds pattern-matching-related methods to [ReportFieldData].
extension ReportFieldDataPatterns on ReportFieldData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportFieldData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportFieldData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportFieldData value)  $default,){
final _that = this;
switch (_that) {
case _ReportFieldData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportFieldData value)?  $default,){
final _that = this;
switch (_that) {
case _ReportFieldData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reportFieldID,  String reportTypeID,  String labelText,  String name,  String fieldType,  ReportFieldDefaultValue? defaultValue,  String? onlyAvailable,  bool isRequired,  bool doNotCopy,  bool isArchive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportFieldData() when $default != null:
return $default(_that.reportFieldID,_that.reportTypeID,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.onlyAvailable,_that.isRequired,_that.doNotCopy,_that.isArchive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reportFieldID,  String reportTypeID,  String labelText,  String name,  String fieldType,  ReportFieldDefaultValue? defaultValue,  String? onlyAvailable,  bool isRequired,  bool doNotCopy,  bool isArchive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReportFieldData():
return $default(_that.reportFieldID,_that.reportTypeID,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.onlyAvailable,_that.isRequired,_that.doNotCopy,_that.isArchive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reportFieldID,  String reportTypeID,  String labelText,  String name,  String fieldType,  ReportFieldDefaultValue? defaultValue,  String? onlyAvailable,  bool isRequired,  bool doNotCopy,  bool isArchive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReportFieldData() when $default != null:
return $default(_that.reportFieldID,_that.reportTypeID,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.onlyAvailable,_that.isRequired,_that.doNotCopy,_that.isArchive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportFieldData implements ReportFieldData {
  const _ReportFieldData({required this.reportFieldID, required this.reportTypeID, required this.labelText, required this.name, required this.fieldType, this.defaultValue, this.onlyAvailable, this.isRequired = false, this.doNotCopy = false, this.isArchive = false, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ReportFieldData.fromJson(Map<String, dynamic> json) => _$ReportFieldDataFromJson(json);

@override final  String reportFieldID;
@override final  String reportTypeID;
@override final  String labelText;
@override final  String name;
@override final  String fieldType;
@override final  ReportFieldDefaultValue? defaultValue;
@override final  String? onlyAvailable;
@override@JsonKey() final  bool isRequired;
@override@JsonKey() final  bool doNotCopy;
@override@JsonKey() final  bool isArchive;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ReportFieldData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportFieldDataCopyWith<_ReportFieldData> get copyWith => __$ReportFieldDataCopyWithImpl<_ReportFieldData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportFieldDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportFieldData&&(identical(other.reportFieldID, reportFieldID) || other.reportFieldID == reportFieldID)&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.doNotCopy, doNotCopy) || other.doNotCopy == doNotCopy)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportFieldID,reportTypeID,labelText,name,fieldType,defaultValue,onlyAvailable,isRequired,doNotCopy,isArchive,createdAt,updatedAt);

@override
String toString() {
  return 'ReportFieldData(reportFieldID: $reportFieldID, reportTypeID: $reportTypeID, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, onlyAvailable: $onlyAvailable, isRequired: $isRequired, doNotCopy: $doNotCopy, isArchive: $isArchive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReportFieldDataCopyWith<$Res> implements $ReportFieldDataCopyWith<$Res> {
  factory _$ReportFieldDataCopyWith(_ReportFieldData value, $Res Function(_ReportFieldData) _then) = __$ReportFieldDataCopyWithImpl;
@override @useResult
$Res call({
 String reportFieldID, String reportTypeID, String labelText, String name, String fieldType, ReportFieldDefaultValue? defaultValue, String? onlyAvailable, bool isRequired, bool doNotCopy, bool isArchive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});


@override $ReportFieldDefaultValueCopyWith<$Res>? get defaultValue;

}
/// @nodoc
class __$ReportFieldDataCopyWithImpl<$Res>
    implements _$ReportFieldDataCopyWith<$Res> {
  __$ReportFieldDataCopyWithImpl(this._self, this._then);

  final _ReportFieldData _self;
  final $Res Function(_ReportFieldData) _then;

/// Create a copy of ReportFieldData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportFieldID = null,Object? reportTypeID = null,Object? labelText = null,Object? name = null,Object? fieldType = null,Object? defaultValue = freezed,Object? onlyAvailable = freezed,Object? isRequired = null,Object? doNotCopy = null,Object? isArchive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ReportFieldData(
reportFieldID: null == reportFieldID ? _self.reportFieldID : reportFieldID // ignore: cast_nullable_to_non_nullable
as String,reportTypeID: null == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String,labelText: null == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as ReportFieldDefaultValue?,onlyAvailable: freezed == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,doNotCopy: null == doNotCopy ? _self.doNotCopy : doNotCopy // ignore: cast_nullable_to_non_nullable
as bool,isArchive: null == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ReportFieldData
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
