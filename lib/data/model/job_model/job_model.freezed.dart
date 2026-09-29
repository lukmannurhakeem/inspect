// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobModel {

 int? get count; List<JobItem> get data; bool? get success;
/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobModelCopyWith<JobModel> get copyWith => _$JobModelCopyWithImpl<JobModel>(this as JobModel, _$identity);

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobModel&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(data),success);

@override
String toString() {
  return 'JobModel(count: $count, data: $data, success: $success)';
}


}

/// @nodoc
abstract mixin class $JobModelCopyWith<$Res>  {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) _then) = _$JobModelCopyWithImpl;
@useResult
$Res call({
 int? count, List<JobItem> data, bool? success
});




}
/// @nodoc
class _$JobModelCopyWithImpl<$Res>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._self, this._then);

  final JobModel _self;
  final $Res Function(JobModel) _then;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = freezed,Object? data = null,Object? success = freezed,}) {
  return _then(_self.copyWith(
count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<JobItem>,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobModel].
extension JobModelPatterns on JobModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobModel value)  $default,){
final _that = this;
switch (_that) {
case _JobModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? count,  List<JobItem> data,  bool? success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobModel() when $default != null:
return $default(_that.count,_that.data,_that.success);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? count,  List<JobItem> data,  bool? success)  $default,) {final _that = this;
switch (_that) {
case _JobModel():
return $default(_that.count,_that.data,_that.success);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? count,  List<JobItem> data,  bool? success)?  $default,) {final _that = this;
switch (_that) {
case _JobModel() when $default != null:
return $default(_that.count,_that.data,_that.success);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobModel implements JobModel {
  const _JobModel({this.count, final  List<JobItem> data = const [], this.success}): _data = data;
  factory _JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

@override final  int? count;
 final  List<JobItem> _data;
@override@JsonKey() List<JobItem> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  bool? success;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobModelCopyWith<_JobModel> get copyWith => __$JobModelCopyWithImpl<_JobModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobModel&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(_data),success);

@override
String toString() {
  return 'JobModel(count: $count, data: $data, success: $success)';
}


}

/// @nodoc
abstract mixin class _$JobModelCopyWith<$Res> implements $JobModelCopyWith<$Res> {
  factory _$JobModelCopyWith(_JobModel value, $Res Function(_JobModel) _then) = __$JobModelCopyWithImpl;
@override @useResult
$Res call({
 int? count, List<JobItem> data, bool? success
});




}
/// @nodoc
class __$JobModelCopyWithImpl<$Res>
    implements _$JobModelCopyWith<$Res> {
  __$JobModelCopyWithImpl(this._self, this._then);

  final _JobModel _self;
  final $Res Function(_JobModel) _then;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = freezed,Object? data = null,Object? success = freezed,}) {
  return _then(_JobModel(
count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<JobItem>,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$JobItem {

@JsonKey(name: 'jobID') String? get jobId; String? get jobNo; String? get customerid; String? get customerName;@JsonKey(name: 'siteID') String? get siteId; String? get siteName; DateTime? get createdDate; String? get purchaseOrderNo; String? get procedureNo;@JsonKey(name: 'divisionID') String? get divisionId; int? get allocatedDuration; DateTime? get estimatedStartDate; DateTime? get estimatedEndDate; bool? get isEngineerComplete; String? get offshoreLocation; String? get authenticator; String? get issuingAuthName; String? get issuingAuthSignature; String? get clientName; String? get clientSignature; bool? get startJobNow;
/// Create a copy of JobItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobItemCopyWith<JobItem> get copyWith => _$JobItemCopyWithImpl<JobItem>(this as JobItem, _$identity);

  /// Serializes this JobItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobItem&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNo, jobNo) || other.jobNo == jobNo)&&(identical(other.customerid, customerid) || other.customerid == customerid)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.purchaseOrderNo, purchaseOrderNo) || other.purchaseOrderNo == purchaseOrderNo)&&(identical(other.procedureNo, procedureNo) || other.procedureNo == procedureNo)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.allocatedDuration, allocatedDuration) || other.allocatedDuration == allocatedDuration)&&(identical(other.estimatedStartDate, estimatedStartDate) || other.estimatedStartDate == estimatedStartDate)&&(identical(other.estimatedEndDate, estimatedEndDate) || other.estimatedEndDate == estimatedEndDate)&&(identical(other.isEngineerComplete, isEngineerComplete) || other.isEngineerComplete == isEngineerComplete)&&(identical(other.offshoreLocation, offshoreLocation) || other.offshoreLocation == offshoreLocation)&&(identical(other.authenticator, authenticator) || other.authenticator == authenticator)&&(identical(other.issuingAuthName, issuingAuthName) || other.issuingAuthName == issuingAuthName)&&(identical(other.issuingAuthSignature, issuingAuthSignature) || other.issuingAuthSignature == issuingAuthSignature)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientSignature, clientSignature) || other.clientSignature == clientSignature)&&(identical(other.startJobNow, startJobNow) || other.startJobNow == startJobNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,jobId,jobNo,customerid,customerName,siteId,siteName,createdDate,purchaseOrderNo,procedureNo,divisionId,allocatedDuration,estimatedStartDate,estimatedEndDate,isEngineerComplete,offshoreLocation,authenticator,issuingAuthName,issuingAuthSignature,clientName,clientSignature,startJobNow]);

@override
String toString() {
  return 'JobItem(jobId: $jobId, jobNo: $jobNo, customerid: $customerid, customerName: $customerName, siteId: $siteId, siteName: $siteName, createdDate: $createdDate, purchaseOrderNo: $purchaseOrderNo, procedureNo: $procedureNo, divisionId: $divisionId, allocatedDuration: $allocatedDuration, estimatedStartDate: $estimatedStartDate, estimatedEndDate: $estimatedEndDate, isEngineerComplete: $isEngineerComplete, offshoreLocation: $offshoreLocation, authenticator: $authenticator, issuingAuthName: $issuingAuthName, issuingAuthSignature: $issuingAuthSignature, clientName: $clientName, clientSignature: $clientSignature, startJobNow: $startJobNow)';
}


}

/// @nodoc
abstract mixin class $JobItemCopyWith<$Res>  {
  factory $JobItemCopyWith(JobItem value, $Res Function(JobItem) _then) = _$JobItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'jobID') String? jobId, String? jobNo, String? customerid, String? customerName,@JsonKey(name: 'siteID') String? siteId, String? siteName, DateTime? createdDate, String? purchaseOrderNo, String? procedureNo,@JsonKey(name: 'divisionID') String? divisionId, int? allocatedDuration, DateTime? estimatedStartDate, DateTime? estimatedEndDate, bool? isEngineerComplete, String? offshoreLocation, String? authenticator, String? issuingAuthName, String? issuingAuthSignature, String? clientName, String? clientSignature, bool? startJobNow
});




}
/// @nodoc
class _$JobItemCopyWithImpl<$Res>
    implements $JobItemCopyWith<$Res> {
  _$JobItemCopyWithImpl(this._self, this._then);

  final JobItem _self;
  final $Res Function(JobItem) _then;

/// Create a copy of JobItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = freezed,Object? jobNo = freezed,Object? customerid = freezed,Object? customerName = freezed,Object? siteId = freezed,Object? siteName = freezed,Object? createdDate = freezed,Object? purchaseOrderNo = freezed,Object? procedureNo = freezed,Object? divisionId = freezed,Object? allocatedDuration = freezed,Object? estimatedStartDate = freezed,Object? estimatedEndDate = freezed,Object? isEngineerComplete = freezed,Object? offshoreLocation = freezed,Object? authenticator = freezed,Object? issuingAuthName = freezed,Object? issuingAuthSignature = freezed,Object? clientName = freezed,Object? clientSignature = freezed,Object? startJobNow = freezed,}) {
  return _then(_self.copyWith(
jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNo: freezed == jobNo ? _self.jobNo : jobNo // ignore: cast_nullable_to_non_nullable
as String?,customerid: freezed == customerid ? _self.customerid : customerid // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchaseOrderNo: freezed == purchaseOrderNo ? _self.purchaseOrderNo : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
as String?,procedureNo: freezed == procedureNo ? _self.procedureNo : procedureNo // ignore: cast_nullable_to_non_nullable
as String?,divisionId: freezed == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String?,allocatedDuration: freezed == allocatedDuration ? _self.allocatedDuration : allocatedDuration // ignore: cast_nullable_to_non_nullable
as int?,estimatedStartDate: freezed == estimatedStartDate ? _self.estimatedStartDate : estimatedStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedEndDate: freezed == estimatedEndDate ? _self.estimatedEndDate : estimatedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isEngineerComplete: freezed == isEngineerComplete ? _self.isEngineerComplete : isEngineerComplete // ignore: cast_nullable_to_non_nullable
as bool?,offshoreLocation: freezed == offshoreLocation ? _self.offshoreLocation : offshoreLocation // ignore: cast_nullable_to_non_nullable
as String?,authenticator: freezed == authenticator ? _self.authenticator : authenticator // ignore: cast_nullable_to_non_nullable
as String?,issuingAuthName: freezed == issuingAuthName ? _self.issuingAuthName : issuingAuthName // ignore: cast_nullable_to_non_nullable
as String?,issuingAuthSignature: freezed == issuingAuthSignature ? _self.issuingAuthSignature : issuingAuthSignature // ignore: cast_nullable_to_non_nullable
as String?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,clientSignature: freezed == clientSignature ? _self.clientSignature : clientSignature // ignore: cast_nullable_to_non_nullable
as String?,startJobNow: freezed == startJobNow ? _self.startJobNow : startJobNow // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobItem].
extension JobItemPatterns on JobItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobItem value)  $default,){
final _that = this;
switch (_that) {
case _JobItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobItem value)?  $default,){
final _that = this;
switch (_that) {
case _JobItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'jobID')  String? jobId,  String? jobNo,  String? customerid,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? siteName,  DateTime? createdDate,  String? purchaseOrderNo,  String? procedureNo, @JsonKey(name: 'divisionID')  String? divisionId,  int? allocatedDuration,  DateTime? estimatedStartDate,  DateTime? estimatedEndDate,  bool? isEngineerComplete,  String? offshoreLocation,  String? authenticator,  String? issuingAuthName,  String? issuingAuthSignature,  String? clientName,  String? clientSignature,  bool? startJobNow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobItem() when $default != null:
return $default(_that.jobId,_that.jobNo,_that.customerid,_that.customerName,_that.siteId,_that.siteName,_that.createdDate,_that.purchaseOrderNo,_that.procedureNo,_that.divisionId,_that.allocatedDuration,_that.estimatedStartDate,_that.estimatedEndDate,_that.isEngineerComplete,_that.offshoreLocation,_that.authenticator,_that.issuingAuthName,_that.issuingAuthSignature,_that.clientName,_that.clientSignature,_that.startJobNow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'jobID')  String? jobId,  String? jobNo,  String? customerid,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? siteName,  DateTime? createdDate,  String? purchaseOrderNo,  String? procedureNo, @JsonKey(name: 'divisionID')  String? divisionId,  int? allocatedDuration,  DateTime? estimatedStartDate,  DateTime? estimatedEndDate,  bool? isEngineerComplete,  String? offshoreLocation,  String? authenticator,  String? issuingAuthName,  String? issuingAuthSignature,  String? clientName,  String? clientSignature,  bool? startJobNow)  $default,) {final _that = this;
switch (_that) {
case _JobItem():
return $default(_that.jobId,_that.jobNo,_that.customerid,_that.customerName,_that.siteId,_that.siteName,_that.createdDate,_that.purchaseOrderNo,_that.procedureNo,_that.divisionId,_that.allocatedDuration,_that.estimatedStartDate,_that.estimatedEndDate,_that.isEngineerComplete,_that.offshoreLocation,_that.authenticator,_that.issuingAuthName,_that.issuingAuthSignature,_that.clientName,_that.clientSignature,_that.startJobNow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'jobID')  String? jobId,  String? jobNo,  String? customerid,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? siteName,  DateTime? createdDate,  String? purchaseOrderNo,  String? procedureNo, @JsonKey(name: 'divisionID')  String? divisionId,  int? allocatedDuration,  DateTime? estimatedStartDate,  DateTime? estimatedEndDate,  bool? isEngineerComplete,  String? offshoreLocation,  String? authenticator,  String? issuingAuthName,  String? issuingAuthSignature,  String? clientName,  String? clientSignature,  bool? startJobNow)?  $default,) {final _that = this;
switch (_that) {
case _JobItem() when $default != null:
return $default(_that.jobId,_that.jobNo,_that.customerid,_that.customerName,_that.siteId,_that.siteName,_that.createdDate,_that.purchaseOrderNo,_that.procedureNo,_that.divisionId,_that.allocatedDuration,_that.estimatedStartDate,_that.estimatedEndDate,_that.isEngineerComplete,_that.offshoreLocation,_that.authenticator,_that.issuingAuthName,_that.issuingAuthSignature,_that.clientName,_that.clientSignature,_that.startJobNow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobItem implements JobItem {
  const _JobItem({@JsonKey(name: 'jobID') this.jobId, this.jobNo, this.customerid, this.customerName, @JsonKey(name: 'siteID') this.siteId, this.siteName, this.createdDate, this.purchaseOrderNo, this.procedureNo, @JsonKey(name: 'divisionID') this.divisionId, this.allocatedDuration, this.estimatedStartDate, this.estimatedEndDate, this.isEngineerComplete, this.offshoreLocation, this.authenticator, this.issuingAuthName, this.issuingAuthSignature, this.clientName, this.clientSignature, this.startJobNow});
  factory _JobItem.fromJson(Map<String, dynamic> json) => _$JobItemFromJson(json);

@override@JsonKey(name: 'jobID') final  String? jobId;
@override final  String? jobNo;
@override final  String? customerid;
@override final  String? customerName;
@override@JsonKey(name: 'siteID') final  String? siteId;
@override final  String? siteName;
@override final  DateTime? createdDate;
@override final  String? purchaseOrderNo;
@override final  String? procedureNo;
@override@JsonKey(name: 'divisionID') final  String? divisionId;
@override final  int? allocatedDuration;
@override final  DateTime? estimatedStartDate;
@override final  DateTime? estimatedEndDate;
@override final  bool? isEngineerComplete;
@override final  String? offshoreLocation;
@override final  String? authenticator;
@override final  String? issuingAuthName;
@override final  String? issuingAuthSignature;
@override final  String? clientName;
@override final  String? clientSignature;
@override final  bool? startJobNow;

/// Create a copy of JobItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobItemCopyWith<_JobItem> get copyWith => __$JobItemCopyWithImpl<_JobItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobItem&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNo, jobNo) || other.jobNo == jobNo)&&(identical(other.customerid, customerid) || other.customerid == customerid)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.purchaseOrderNo, purchaseOrderNo) || other.purchaseOrderNo == purchaseOrderNo)&&(identical(other.procedureNo, procedureNo) || other.procedureNo == procedureNo)&&(identical(other.divisionId, divisionId) || other.divisionId == divisionId)&&(identical(other.allocatedDuration, allocatedDuration) || other.allocatedDuration == allocatedDuration)&&(identical(other.estimatedStartDate, estimatedStartDate) || other.estimatedStartDate == estimatedStartDate)&&(identical(other.estimatedEndDate, estimatedEndDate) || other.estimatedEndDate == estimatedEndDate)&&(identical(other.isEngineerComplete, isEngineerComplete) || other.isEngineerComplete == isEngineerComplete)&&(identical(other.offshoreLocation, offshoreLocation) || other.offshoreLocation == offshoreLocation)&&(identical(other.authenticator, authenticator) || other.authenticator == authenticator)&&(identical(other.issuingAuthName, issuingAuthName) || other.issuingAuthName == issuingAuthName)&&(identical(other.issuingAuthSignature, issuingAuthSignature) || other.issuingAuthSignature == issuingAuthSignature)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientSignature, clientSignature) || other.clientSignature == clientSignature)&&(identical(other.startJobNow, startJobNow) || other.startJobNow == startJobNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,jobId,jobNo,customerid,customerName,siteId,siteName,createdDate,purchaseOrderNo,procedureNo,divisionId,allocatedDuration,estimatedStartDate,estimatedEndDate,isEngineerComplete,offshoreLocation,authenticator,issuingAuthName,issuingAuthSignature,clientName,clientSignature,startJobNow]);

@override
String toString() {
  return 'JobItem(jobId: $jobId, jobNo: $jobNo, customerid: $customerid, customerName: $customerName, siteId: $siteId, siteName: $siteName, createdDate: $createdDate, purchaseOrderNo: $purchaseOrderNo, procedureNo: $procedureNo, divisionId: $divisionId, allocatedDuration: $allocatedDuration, estimatedStartDate: $estimatedStartDate, estimatedEndDate: $estimatedEndDate, isEngineerComplete: $isEngineerComplete, offshoreLocation: $offshoreLocation, authenticator: $authenticator, issuingAuthName: $issuingAuthName, issuingAuthSignature: $issuingAuthSignature, clientName: $clientName, clientSignature: $clientSignature, startJobNow: $startJobNow)';
}


}

/// @nodoc
abstract mixin class _$JobItemCopyWith<$Res> implements $JobItemCopyWith<$Res> {
  factory _$JobItemCopyWith(_JobItem value, $Res Function(_JobItem) _then) = __$JobItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'jobID') String? jobId, String? jobNo, String? customerid, String? customerName,@JsonKey(name: 'siteID') String? siteId, String? siteName, DateTime? createdDate, String? purchaseOrderNo, String? procedureNo,@JsonKey(name: 'divisionID') String? divisionId, int? allocatedDuration, DateTime? estimatedStartDate, DateTime? estimatedEndDate, bool? isEngineerComplete, String? offshoreLocation, String? authenticator, String? issuingAuthName, String? issuingAuthSignature, String? clientName, String? clientSignature, bool? startJobNow
});




}
/// @nodoc
class __$JobItemCopyWithImpl<$Res>
    implements _$JobItemCopyWith<$Res> {
  __$JobItemCopyWithImpl(this._self, this._then);

  final _JobItem _self;
  final $Res Function(_JobItem) _then;

/// Create a copy of JobItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = freezed,Object? jobNo = freezed,Object? customerid = freezed,Object? customerName = freezed,Object? siteId = freezed,Object? siteName = freezed,Object? createdDate = freezed,Object? purchaseOrderNo = freezed,Object? procedureNo = freezed,Object? divisionId = freezed,Object? allocatedDuration = freezed,Object? estimatedStartDate = freezed,Object? estimatedEndDate = freezed,Object? isEngineerComplete = freezed,Object? offshoreLocation = freezed,Object? authenticator = freezed,Object? issuingAuthName = freezed,Object? issuingAuthSignature = freezed,Object? clientName = freezed,Object? clientSignature = freezed,Object? startJobNow = freezed,}) {
  return _then(_JobItem(
jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNo: freezed == jobNo ? _self.jobNo : jobNo // ignore: cast_nullable_to_non_nullable
as String?,customerid: freezed == customerid ? _self.customerid : customerid // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,createdDate: freezed == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchaseOrderNo: freezed == purchaseOrderNo ? _self.purchaseOrderNo : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
as String?,procedureNo: freezed == procedureNo ? _self.procedureNo : procedureNo // ignore: cast_nullable_to_non_nullable
as String?,divisionId: freezed == divisionId ? _self.divisionId : divisionId // ignore: cast_nullable_to_non_nullable
as String?,allocatedDuration: freezed == allocatedDuration ? _self.allocatedDuration : allocatedDuration // ignore: cast_nullable_to_non_nullable
as int?,estimatedStartDate: freezed == estimatedStartDate ? _self.estimatedStartDate : estimatedStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedEndDate: freezed == estimatedEndDate ? _self.estimatedEndDate : estimatedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isEngineerComplete: freezed == isEngineerComplete ? _self.isEngineerComplete : isEngineerComplete // ignore: cast_nullable_to_non_nullable
as bool?,offshoreLocation: freezed == offshoreLocation ? _self.offshoreLocation : offshoreLocation // ignore: cast_nullable_to_non_nullable
as String?,authenticator: freezed == authenticator ? _self.authenticator : authenticator // ignore: cast_nullable_to_non_nullable
as String?,issuingAuthName: freezed == issuingAuthName ? _self.issuingAuthName : issuingAuthName // ignore: cast_nullable_to_non_nullable
as String?,issuingAuthSignature: freezed == issuingAuthSignature ? _self.issuingAuthSignature : issuingAuthSignature // ignore: cast_nullable_to_non_nullable
as String?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,clientSignature: freezed == clientSignature ? _self.clientSignature : clientSignature // ignore: cast_nullable_to_non_nullable
as String?,startJobNow: freezed == startJobNow ? _self.startJobNow : startJobNow // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
