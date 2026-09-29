// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_approval_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportApprovalModel {

 List<ReportApprovalData>? get data; ApprovalFilter? get filter; String? get message;
/// Create a copy of ReportApprovalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportApprovalModelCopyWith<ReportApprovalModel> get copyWith => _$ReportApprovalModelCopyWithImpl<ReportApprovalModel>(this as ReportApprovalModel, _$identity);

  /// Serializes this ReportApprovalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportApprovalModel&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),filter,message);

@override
String toString() {
  return 'ReportApprovalModel(data: $data, filter: $filter, message: $message)';
}


}

/// @nodoc
abstract mixin class $ReportApprovalModelCopyWith<$Res>  {
  factory $ReportApprovalModelCopyWith(ReportApprovalModel value, $Res Function(ReportApprovalModel) _then) = _$ReportApprovalModelCopyWithImpl;
@useResult
$Res call({
 List<ReportApprovalData>? data, ApprovalFilter? filter, String? message
});


$ApprovalFilterCopyWith<$Res>? get filter;

}
/// @nodoc
class _$ReportApprovalModelCopyWithImpl<$Res>
    implements $ReportApprovalModelCopyWith<$Res> {
  _$ReportApprovalModelCopyWithImpl(this._self, this._then);

  final ReportApprovalModel _self;
  final $Res Function(ReportApprovalModel) _then;

/// Create a copy of ReportApprovalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? filter = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ReportApprovalData>?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ApprovalFilter?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ReportApprovalModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApprovalFilterCopyWith<$Res>? get filter {
    if (_self.filter == null) {
    return null;
  }

  return $ApprovalFilterCopyWith<$Res>(_self.filter!, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportApprovalModel].
extension ReportApprovalModelPatterns on ReportApprovalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportApprovalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportApprovalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportApprovalModel value)  $default,){
final _that = this;
switch (_that) {
case _ReportApprovalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportApprovalModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReportApprovalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReportApprovalData>? data,  ApprovalFilter? filter,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportApprovalModel() when $default != null:
return $default(_that.data,_that.filter,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReportApprovalData>? data,  ApprovalFilter? filter,  String? message)  $default,) {final _that = this;
switch (_that) {
case _ReportApprovalModel():
return $default(_that.data,_that.filter,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReportApprovalData>? data,  ApprovalFilter? filter,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ReportApprovalModel() when $default != null:
return $default(_that.data,_that.filter,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportApprovalModel implements ReportApprovalModel {
  const _ReportApprovalModel({final  List<ReportApprovalData>? data, this.filter, this.message}): _data = data;
  factory _ReportApprovalModel.fromJson(Map<String, dynamic> json) => _$ReportApprovalModelFromJson(json);

 final  List<ReportApprovalData>? _data;
@override List<ReportApprovalData>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  ApprovalFilter? filter;
@override final  String? message;

/// Create a copy of ReportApprovalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportApprovalModelCopyWith<_ReportApprovalModel> get copyWith => __$ReportApprovalModelCopyWithImpl<_ReportApprovalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportApprovalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportApprovalModel&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),filter,message);

@override
String toString() {
  return 'ReportApprovalModel(data: $data, filter: $filter, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ReportApprovalModelCopyWith<$Res> implements $ReportApprovalModelCopyWith<$Res> {
  factory _$ReportApprovalModelCopyWith(_ReportApprovalModel value, $Res Function(_ReportApprovalModel) _then) = __$ReportApprovalModelCopyWithImpl;
@override @useResult
$Res call({
 List<ReportApprovalData>? data, ApprovalFilter? filter, String? message
});


@override $ApprovalFilterCopyWith<$Res>? get filter;

}
/// @nodoc
class __$ReportApprovalModelCopyWithImpl<$Res>
    implements _$ReportApprovalModelCopyWith<$Res> {
  __$ReportApprovalModelCopyWithImpl(this._self, this._then);

  final _ReportApprovalModel _self;
  final $Res Function(_ReportApprovalModel) _then;

/// Create a copy of ReportApprovalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? filter = freezed,Object? message = freezed,}) {
  return _then(_ReportApprovalModel(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ReportApprovalData>?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ApprovalFilter?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ReportApprovalModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApprovalFilterCopyWith<$Res>? get filter {
    if (_self.filter == null) {
    return null;
  }

  return $ApprovalFilterCopyWith<$Res>(_self.filter!, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// @nodoc
mixin _$ReportApprovalData {

@JsonKey(name: 'reportID') String? get reportID;@JsonKey(name: 'reportTypeID') String? get reportTypeID; String? get reportName;@JsonKey(name: 'itemID') String? get itemID; String? get itemNo; String? get status; String? get inspectedBy; String? get reportDate; String? get regulation; dynamic get reportData; String? get createdAt; String? get updatedAt; String? get approvalStatus; String? get inspectedOn; String? get inspectStatus; String? get expiryDate;@JsonKey(name: 'ExpiryDate') String? get ExpiryDate;
/// Create a copy of ReportApprovalData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportApprovalDataCopyWith<ReportApprovalData> get copyWith => _$ReportApprovalDataCopyWithImpl<ReportApprovalData>(this as ReportApprovalData, _$identity);

  /// Serializes this ReportApprovalData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportApprovalData&&(identical(other.reportID, reportID) || other.reportID == reportID)&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.itemID, itemID) || other.itemID == itemID)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&const DeepCollectionEquality().equals(other.reportData, reportData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.inspectedOn, inspectedOn) || other.inspectedOn == inspectedOn)&&(identical(other.inspectStatus, inspectStatus) || other.inspectStatus == inspectStatus)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.ExpiryDate, ExpiryDate) || other.ExpiryDate == ExpiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportID,reportTypeID,reportName,itemID,itemNo,status,inspectedBy,reportDate,regulation,const DeepCollectionEquality().hash(reportData),createdAt,updatedAt,approvalStatus,inspectedOn,inspectStatus,expiryDate,ExpiryDate);

@override
String toString() {
  return 'ReportApprovalData(reportID: $reportID, reportTypeID: $reportTypeID, reportName: $reportName, itemID: $itemID, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, reportDate: $reportDate, regulation: $regulation, reportData: $reportData, createdAt: $createdAt, updatedAt: $updatedAt, approvalStatus: $approvalStatus, inspectedOn: $inspectedOn, inspectStatus: $inspectStatus, expiryDate: $expiryDate, ExpiryDate: $ExpiryDate)';
}


}

/// @nodoc
abstract mixin class $ReportApprovalDataCopyWith<$Res>  {
  factory $ReportApprovalDataCopyWith(ReportApprovalData value, $Res Function(ReportApprovalData) _then) = _$ReportApprovalDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reportID') String? reportID,@JsonKey(name: 'reportTypeID') String? reportTypeID, String? reportName,@JsonKey(name: 'itemID') String? itemID, String? itemNo, String? status, String? inspectedBy, String? reportDate, String? regulation, dynamic reportData, String? createdAt, String? updatedAt, String? approvalStatus, String? inspectedOn, String? inspectStatus, String? expiryDate,@JsonKey(name: 'ExpiryDate') String? ExpiryDate
});




}
/// @nodoc
class _$ReportApprovalDataCopyWithImpl<$Res>
    implements $ReportApprovalDataCopyWith<$Res> {
  _$ReportApprovalDataCopyWithImpl(this._self, this._then);

  final ReportApprovalData _self;
  final $Res Function(ReportApprovalData) _then;

/// Create a copy of ReportApprovalData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportID = freezed,Object? reportTypeID = freezed,Object? reportName = freezed,Object? itemID = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? reportData = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? approvalStatus = freezed,Object? inspectedOn = freezed,Object? inspectStatus = freezed,Object? expiryDate = freezed,Object? ExpiryDate = freezed,}) {
  return _then(_self.copyWith(
reportID: freezed == reportID ? _self.reportID : reportID // ignore: cast_nullable_to_non_nullable
as String?,reportTypeID: freezed == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,itemID: freezed == itemID ? _self.itemID : itemID // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as String?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,reportData: freezed == reportData ? _self.reportData : reportData // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,inspectedOn: freezed == inspectedOn ? _self.inspectedOn : inspectedOn // ignore: cast_nullable_to_non_nullable
as String?,inspectStatus: freezed == inspectStatus ? _self.inspectStatus : inspectStatus // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,ExpiryDate: freezed == ExpiryDate ? _self.ExpiryDate : ExpiryDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportApprovalData].
extension ReportApprovalDataPatterns on ReportApprovalData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportApprovalData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportApprovalData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportApprovalData value)  $default,){
final _that = this;
switch (_that) {
case _ReportApprovalData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportApprovalData value)?  $default,){
final _that = this;
switch (_that) {
case _ReportApprovalData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportID')  String? reportID, @JsonKey(name: 'reportTypeID')  String? reportTypeID,  String? reportName, @JsonKey(name: 'itemID')  String? itemID,  String? itemNo,  String? status,  String? inspectedBy,  String? reportDate,  String? regulation,  dynamic reportData,  String? createdAt,  String? updatedAt,  String? approvalStatus,  String? inspectedOn,  String? inspectStatus,  String? expiryDate, @JsonKey(name: 'ExpiryDate')  String? ExpiryDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportApprovalData() when $default != null:
return $default(_that.reportID,_that.reportTypeID,_that.reportName,_that.itemID,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus,_that.expiryDate,_that.ExpiryDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportID')  String? reportID, @JsonKey(name: 'reportTypeID')  String? reportTypeID,  String? reportName, @JsonKey(name: 'itemID')  String? itemID,  String? itemNo,  String? status,  String? inspectedBy,  String? reportDate,  String? regulation,  dynamic reportData,  String? createdAt,  String? updatedAt,  String? approvalStatus,  String? inspectedOn,  String? inspectStatus,  String? expiryDate, @JsonKey(name: 'ExpiryDate')  String? ExpiryDate)  $default,) {final _that = this;
switch (_that) {
case _ReportApprovalData():
return $default(_that.reportID,_that.reportTypeID,_that.reportName,_that.itemID,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus,_that.expiryDate,_that.ExpiryDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reportID')  String? reportID, @JsonKey(name: 'reportTypeID')  String? reportTypeID,  String? reportName, @JsonKey(name: 'itemID')  String? itemID,  String? itemNo,  String? status,  String? inspectedBy,  String? reportDate,  String? regulation,  dynamic reportData,  String? createdAt,  String? updatedAt,  String? approvalStatus,  String? inspectedOn,  String? inspectStatus,  String? expiryDate, @JsonKey(name: 'ExpiryDate')  String? ExpiryDate)?  $default,) {final _that = this;
switch (_that) {
case _ReportApprovalData() when $default != null:
return $default(_that.reportID,_that.reportTypeID,_that.reportName,_that.itemID,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt,_that.approvalStatus,_that.inspectedOn,_that.inspectStatus,_that.expiryDate,_that.ExpiryDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportApprovalData extends ReportApprovalData {
  const _ReportApprovalData({@JsonKey(name: 'reportID') this.reportID, @JsonKey(name: 'reportTypeID') this.reportTypeID, this.reportName, @JsonKey(name: 'itemID') this.itemID, this.itemNo, this.status, this.inspectedBy, this.reportDate, this.regulation, this.reportData, this.createdAt, this.updatedAt, this.approvalStatus, this.inspectedOn, this.inspectStatus, this.expiryDate, @JsonKey(name: 'ExpiryDate') this.ExpiryDate}): super._();
  factory _ReportApprovalData.fromJson(Map<String, dynamic> json) => _$ReportApprovalDataFromJson(json);

@override@JsonKey(name: 'reportID') final  String? reportID;
@override@JsonKey(name: 'reportTypeID') final  String? reportTypeID;
@override final  String? reportName;
@override@JsonKey(name: 'itemID') final  String? itemID;
@override final  String? itemNo;
@override final  String? status;
@override final  String? inspectedBy;
@override final  String? reportDate;
@override final  String? regulation;
@override final  dynamic reportData;
@override final  String? createdAt;
@override final  String? updatedAt;
@override final  String? approvalStatus;
@override final  String? inspectedOn;
@override final  String? inspectStatus;
@override final  String? expiryDate;
@override@JsonKey(name: 'ExpiryDate') final  String? ExpiryDate;

/// Create a copy of ReportApprovalData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportApprovalDataCopyWith<_ReportApprovalData> get copyWith => __$ReportApprovalDataCopyWithImpl<_ReportApprovalData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportApprovalDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportApprovalData&&(identical(other.reportID, reportID) || other.reportID == reportID)&&(identical(other.reportTypeID, reportTypeID) || other.reportTypeID == reportTypeID)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.itemID, itemID) || other.itemID == itemID)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&const DeepCollectionEquality().equals(other.reportData, reportData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.inspectedOn, inspectedOn) || other.inspectedOn == inspectedOn)&&(identical(other.inspectStatus, inspectStatus) || other.inspectStatus == inspectStatus)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.ExpiryDate, ExpiryDate) || other.ExpiryDate == ExpiryDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportID,reportTypeID,reportName,itemID,itemNo,status,inspectedBy,reportDate,regulation,const DeepCollectionEquality().hash(reportData),createdAt,updatedAt,approvalStatus,inspectedOn,inspectStatus,expiryDate,ExpiryDate);

@override
String toString() {
  return 'ReportApprovalData(reportID: $reportID, reportTypeID: $reportTypeID, reportName: $reportName, itemID: $itemID, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, reportDate: $reportDate, regulation: $regulation, reportData: $reportData, createdAt: $createdAt, updatedAt: $updatedAt, approvalStatus: $approvalStatus, inspectedOn: $inspectedOn, inspectStatus: $inspectStatus, expiryDate: $expiryDate, ExpiryDate: $ExpiryDate)';
}


}

/// @nodoc
abstract mixin class _$ReportApprovalDataCopyWith<$Res> implements $ReportApprovalDataCopyWith<$Res> {
  factory _$ReportApprovalDataCopyWith(_ReportApprovalData value, $Res Function(_ReportApprovalData) _then) = __$ReportApprovalDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reportID') String? reportID,@JsonKey(name: 'reportTypeID') String? reportTypeID, String? reportName,@JsonKey(name: 'itemID') String? itemID, String? itemNo, String? status, String? inspectedBy, String? reportDate, String? regulation, dynamic reportData, String? createdAt, String? updatedAt, String? approvalStatus, String? inspectedOn, String? inspectStatus, String? expiryDate,@JsonKey(name: 'ExpiryDate') String? ExpiryDate
});




}
/// @nodoc
class __$ReportApprovalDataCopyWithImpl<$Res>
    implements _$ReportApprovalDataCopyWith<$Res> {
  __$ReportApprovalDataCopyWithImpl(this._self, this._then);

  final _ReportApprovalData _self;
  final $Res Function(_ReportApprovalData) _then;

/// Create a copy of ReportApprovalData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportID = freezed,Object? reportTypeID = freezed,Object? reportName = freezed,Object? itemID = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? reportData = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? approvalStatus = freezed,Object? inspectedOn = freezed,Object? inspectStatus = freezed,Object? expiryDate = freezed,Object? ExpiryDate = freezed,}) {
  return _then(_ReportApprovalData(
reportID: freezed == reportID ? _self.reportID : reportID // ignore: cast_nullable_to_non_nullable
as String?,reportTypeID: freezed == reportTypeID ? _self.reportTypeID : reportTypeID // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,itemID: freezed == itemID ? _self.itemID : itemID // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as String?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,reportData: freezed == reportData ? _self.reportData : reportData // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: freezed == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String?,inspectedOn: freezed == inspectedOn ? _self.inspectedOn : inspectedOn // ignore: cast_nullable_to_non_nullable
as String?,inspectStatus: freezed == inspectStatus ? _self.inspectStatus : inspectStatus // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,ExpiryDate: freezed == ExpiryDate ? _self.ExpiryDate : ExpiryDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ApprovalFilter {

 bool? get isApproved;@JsonKey(name: 'jobID') String? get jobID;
/// Create a copy of ApprovalFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalFilterCopyWith<ApprovalFilter> get copyWith => _$ApprovalFilterCopyWithImpl<ApprovalFilter>(this as ApprovalFilter, _$identity);

  /// Serializes this ApprovalFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalFilter&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.jobID, jobID) || other.jobID == jobID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isApproved,jobID);

@override
String toString() {
  return 'ApprovalFilter(isApproved: $isApproved, jobID: $jobID)';
}


}

/// @nodoc
abstract mixin class $ApprovalFilterCopyWith<$Res>  {
  factory $ApprovalFilterCopyWith(ApprovalFilter value, $Res Function(ApprovalFilter) _then) = _$ApprovalFilterCopyWithImpl;
@useResult
$Res call({
 bool? isApproved,@JsonKey(name: 'jobID') String? jobID
});




}
/// @nodoc
class _$ApprovalFilterCopyWithImpl<$Res>
    implements $ApprovalFilterCopyWith<$Res> {
  _$ApprovalFilterCopyWithImpl(this._self, this._then);

  final ApprovalFilter _self;
  final $Res Function(ApprovalFilter) _then;

/// Create a copy of ApprovalFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isApproved = freezed,Object? jobID = freezed,}) {
  return _then(_self.copyWith(
isApproved: freezed == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool?,jobID: freezed == jobID ? _self.jobID : jobID // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalFilter].
extension ApprovalFilterPatterns on ApprovalFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalFilter value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isApproved, @JsonKey(name: 'jobID')  String? jobID)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalFilter() when $default != null:
return $default(_that.isApproved,_that.jobID);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isApproved, @JsonKey(name: 'jobID')  String? jobID)  $default,) {final _that = this;
switch (_that) {
case _ApprovalFilter():
return $default(_that.isApproved,_that.jobID);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isApproved, @JsonKey(name: 'jobID')  String? jobID)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalFilter() when $default != null:
return $default(_that.isApproved,_that.jobID);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApprovalFilter implements ApprovalFilter {
  const _ApprovalFilter({this.isApproved, @JsonKey(name: 'jobID') this.jobID});
  factory _ApprovalFilter.fromJson(Map<String, dynamic> json) => _$ApprovalFilterFromJson(json);

@override final  bool? isApproved;
@override@JsonKey(name: 'jobID') final  String? jobID;

/// Create a copy of ApprovalFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalFilterCopyWith<_ApprovalFilter> get copyWith => __$ApprovalFilterCopyWithImpl<_ApprovalFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovalFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalFilter&&(identical(other.isApproved, isApproved) || other.isApproved == isApproved)&&(identical(other.jobID, jobID) || other.jobID == jobID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isApproved,jobID);

@override
String toString() {
  return 'ApprovalFilter(isApproved: $isApproved, jobID: $jobID)';
}


}

/// @nodoc
abstract mixin class _$ApprovalFilterCopyWith<$Res> implements $ApprovalFilterCopyWith<$Res> {
  factory _$ApprovalFilterCopyWith(_ApprovalFilter value, $Res Function(_ApprovalFilter) _then) = __$ApprovalFilterCopyWithImpl;
@override @useResult
$Res call({
 bool? isApproved,@JsonKey(name: 'jobID') String? jobID
});




}
/// @nodoc
class __$ApprovalFilterCopyWithImpl<$Res>
    implements _$ApprovalFilterCopyWith<$Res> {
  __$ApprovalFilterCopyWithImpl(this._self, this._then);

  final _ApprovalFilter _self;
  final $Res Function(_ApprovalFilter) _then;

/// Create a copy of ApprovalFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isApproved = freezed,Object? jobID = freezed,}) {
  return _then(_ApprovalFilter(
isApproved: freezed == isApproved ? _self.isApproved : isApproved // ignore: cast_nullable_to_non_nullable
as bool?,jobID: freezed == jobID ? _self.jobID : jobID // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
