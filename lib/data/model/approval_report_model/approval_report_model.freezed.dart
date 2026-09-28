// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApprovalReportModel {

 List<ApprovalReport>? get data; String? get message;
/// Create a copy of ApprovalReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalReportModelCopyWith<ApprovalReportModel> get copyWith => _$ApprovalReportModelCopyWithImpl<ApprovalReportModel>(this as ApprovalReportModel, _$identity);

  /// Serializes this ApprovalReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalReportModel&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'ApprovalReportModel(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $ApprovalReportModelCopyWith<$Res>  {
  factory $ApprovalReportModelCopyWith(ApprovalReportModel value, $Res Function(ApprovalReportModel) _then) = _$ApprovalReportModelCopyWithImpl;
@useResult
$Res call({
 List<ApprovalReport>? data, String? message
});




}
/// @nodoc
class _$ApprovalReportModelCopyWithImpl<$Res>
    implements $ApprovalReportModelCopyWith<$Res> {
  _$ApprovalReportModelCopyWithImpl(this._self, this._then);

  final ApprovalReportModel _self;
  final $Res Function(ApprovalReportModel) _then;

/// Create a copy of ApprovalReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ApprovalReport>?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalReportModel].
extension ApprovalReportModelPatterns on ApprovalReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ApprovalReport>? data,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalReportModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ApprovalReport>? data,  String? message)  $default,) {final _that = this;
switch (_that) {
case _ApprovalReportModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ApprovalReport>? data,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalReportModel() when $default != null:
return $default(_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApprovalReportModel implements ApprovalReportModel {
  const _ApprovalReportModel({final  List<ApprovalReport>? data, this.message}): _data = data;
  factory _ApprovalReportModel.fromJson(Map<String, dynamic> json) => _$ApprovalReportModelFromJson(json);

 final  List<ApprovalReport>? _data;
@override List<ApprovalReport>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? message;

/// Create a copy of ApprovalReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalReportModelCopyWith<_ApprovalReportModel> get copyWith => __$ApprovalReportModelCopyWithImpl<_ApprovalReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovalReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalReportModel&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),message);

@override
String toString() {
  return 'ApprovalReportModel(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ApprovalReportModelCopyWith<$Res> implements $ApprovalReportModelCopyWith<$Res> {
  factory _$ApprovalReportModelCopyWith(_ApprovalReportModel value, $Res Function(_ApprovalReportModel) _then) = __$ApprovalReportModelCopyWithImpl;
@override @useResult
$Res call({
 List<ApprovalReport>? data, String? message
});




}
/// @nodoc
class __$ApprovalReportModelCopyWithImpl<$Res>
    implements _$ApprovalReportModelCopyWith<$Res> {
  __$ApprovalReportModelCopyWithImpl(this._self, this._then);

  final _ApprovalReportModel _self;
  final $Res Function(_ApprovalReportModel) _then;

/// Create a copy of ApprovalReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? message = freezed,}) {
  return _then(_ApprovalReportModel(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ApprovalReport>?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ApprovalReport {

 String? get reportID; String? get reportTypeID; String? get reportName; String? get itemID; String? get itemNo; String? get status; String? get inspectedBy;@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get reportDate; String? get regulation; dynamic get reportData;@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get updatedAt; String? get approvalStatus;@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? get inspectedOn; String? get inspectStatus;
/// Create a copy of ApprovalReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalReportCopyWith<ApprovalReport> get copyWith => _$ApprovalReportCopyWithImpl<ApprovalReport>(this as ApprovalReport, _$identity);

  /// Serializes this ApprovalReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalReport&&(identical(other.reportID, reportID) || other.reportID == reportID)&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.itemID, itemID) || other.itemID == itemID)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&const DeepCollectionEquality().equals(other.reportData, reportData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.inspectedOn, inspectedOn) || other.inspectedOn == inspectedOn)&&(identical(other.inspectStatus, inspectStatus) || other.inspectStatus == inspectStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportID,reportTypeID,reportName,itemID,itemNo,status,inspectedBy,reportDate,regulation,const DeepCollectionEquality().hash(reportData),createdAt,updatedAt,approvalStatus,inspectedOn,inspectStatus);

@override
String toString() {
  return 'ApprovalReport(reportID: $reportID, reportTypeID: $reportTypeID, reportName: $reportName, itemID: $itemID, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, reportDate: $reportDate, regulation: $regulation, reportData: $reportData, createdAt: $createdAt, updatedAt: $updatedAt, approvalStatus: $approvalStatus, inspectedOn: $inspectedOn, inspectStatus: $inspectStatus)';
}


}

/// @nodoc
abstract mixin class $ApprovalReportCopyWith<$Res>  {
  factory $ApprovalReportCopyWith(ApprovalReport value, $Res Function(ApprovalReport) _then) = _$ApprovalReportCopyWithImpl;
@useResult
$Res call({
 String? reportID, String? reportTypeID, String? reportName, String? itemID, String? itemNo, String? status, String? inspectedBy,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? reportDate, String? regulation, dynamic reportData,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt, String? approvalStatus,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? inspectedOn, String? inspectStatus
});




}
/// @nodoc
class _$ApprovalReportCopyWithImpl<$Res>
    implements $ApprovalReportCopyWith<$Res> {
  _$ApprovalReportCopyWithImpl(this._self, this._then);

  final ApprovalReport _self;
  final $Res Function(ApprovalReport) _then;

/// Create a copy of ApprovalReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportID = freezed,Object? reportTypeID = freezed,Object? reportName = freezed,Object? itemID = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? reportData = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? approvalStatus = freezed,Object? inspectedOn = freezed,Object? inspectStatus = freezed,}) {
  return _then(_self.copyWith(
reportID: freezed == reportID ? _self.reportID : reportID // ignore: cast_nullable_to_non_nullable
as String?,reportTypeID: freezed == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,itemID: freezed == itemID ? _self.itemID : itemID // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,reportData: freezed == reportData ? _self.reportData : reportData // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,inspectedOn: freezed == inspectedOn ? _self.inspectedOn : inspectedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,inspectStatus: freezed == inspectStatus ? _self.inspectStatus : inspectStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalReport].
extension ApprovalReportPatterns on ApprovalReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalReport value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalReport value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reportID,  String? reportTypeID,  String? reportName,  String? itemID,  String? itemNo,  String? status,  String? inspectedBy, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? reportDate,  String? regulation,  dynamic reportData, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt,  String? approvalStatus, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? inspectedOn,  String? inspectStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalReport() when $default != null:
return $default(_that.reportID,_that.reportTypeID,_that.reportName,_that.itemID,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reportID,  String? reportTypeID,  String? reportName,  String? itemID,  String? itemNo,  String? status,  String? inspectedBy, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? reportDate,  String? regulation,  dynamic reportData, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt,  String? approvalStatus, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? inspectedOn,  String? inspectStatus)  $default,) {final _that = this;
switch (_that) {
case _ApprovalReport():
return $default(_that.reportID,_that.reportTypeID,_that.reportName,_that.itemID,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reportID,  String? reportTypeID,  String? reportName,  String? itemID,  String? itemNo,  String? status,  String? inspectedBy, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? reportDate,  String? regulation,  dynamic reportData, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? updatedAt,  String? approvalStatus, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime? inspectedOn,  String? inspectStatus)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalReport() when $default != null:
return $default(_that.reportID,_that.reportTypeID,_that.reportName,_that.itemID,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApprovalReport implements ApprovalReport {
  const _ApprovalReport({this.reportID, this.reportTypeID, this.reportName, this.itemID, this.itemNo, this.status, this.inspectedBy, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.reportDate, this.regulation, this.reportData, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.createdAt, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.updatedAt, this.approvalStatus, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) this.inspectedOn, this.inspectStatus});
  factory _ApprovalReport.fromJson(Map<String, dynamic> json) => _$ApprovalReportFromJson(json);

@override final  String? reportID;
@override final  String? reportTypeID;
@override final  String? reportName;
@override final  String? itemID;
@override final  String? itemNo;
@override final  String? status;
@override final  String? inspectedBy;
@override@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? reportDate;
@override final  String? regulation;
@override final  dynamic reportData;
@override@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? updatedAt;
@override final  String? approvalStatus;
@override@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime? inspectedOn;
@override final  String? inspectStatus;

/// Create a copy of ApprovalReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalReportCopyWith<_ApprovalReport> get copyWith => __$ApprovalReportCopyWithImpl<_ApprovalReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovalReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalReport&&(identical(other.reportID, reportID) || other.reportID == reportID)&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.itemID, itemID) || other.itemID == itemID)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&const DeepCollectionEquality().equals(other.reportData, reportData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.inspectedOn, inspectedOn) || other.inspectedOn == inspectedOn)&&(identical(other.inspectStatus, inspectStatus) || other.inspectStatus == inspectStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportID,reportTypeID,reportName,itemID,itemNo,status,inspectedBy,reportDate,regulation,const DeepCollectionEquality().hash(reportData),createdAt,updatedAt,approvalStatus,inspectedOn,inspectStatus);

@override
String toString() {
  return 'ApprovalReport(reportID: $reportID, reportTypeID: $reportTypeID, reportName: $reportName, itemID: $itemID, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, reportDate: $reportDate, regulation: $regulation, reportData: $reportData, createdAt: $createdAt, updatedAt: $updatedAt, approvalStatus: $approvalStatus, inspectedOn: $inspectedOn, inspectStatus: $inspectStatus)';
}


}

/// @nodoc
abstract mixin class _$ApprovalReportCopyWith<$Res> implements $ApprovalReportCopyWith<$Res> {
  factory _$ApprovalReportCopyWith(_ApprovalReport value, $Res Function(_ApprovalReport) _then) = __$ApprovalReportCopyWithImpl;
@override @useResult
$Res call({
 String? reportID, String? reportTypeID, String? reportName, String? itemID, String? itemNo, String? status, String? inspectedBy,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? reportDate, String? regulation, dynamic reportData,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? updatedAt, String? approvalStatus,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime? inspectedOn, String? inspectStatus
});




}
/// @nodoc
class __$ApprovalReportCopyWithImpl<$Res>
    implements _$ApprovalReportCopyWith<$Res> {
  __$ApprovalReportCopyWithImpl(this._self, this._then);

  final _ApprovalReport _self;
  final $Res Function(_ApprovalReport) _then;

/// Create a copy of ApprovalReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportID = freezed,Object? reportTypeID = freezed,Object? reportName = freezed,Object? itemID = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? reportData = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? approvalStatus = freezed,Object? inspectedOn = freezed,Object? inspectStatus = freezed,}) {
  return _then(_ApprovalReport(
reportID: freezed == reportID ? _self.reportID : reportID // ignore: cast_nullable_to_non_nullable
as String?,reportTypeID: freezed == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,itemID: freezed == itemID ? _self.itemID : itemID // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,reportData: freezed == reportData ? _self.reportData : reportData // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,inspectedOn: freezed == inspectedOn ? _self.inspectedOn : inspectedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,inspectStatus: freezed == inspectStatus ? _self.inspectStatus : inspectStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
