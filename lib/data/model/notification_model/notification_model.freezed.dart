// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {

 String get id; String get type; String get title; String get message; DateTime get timestamp; bool get isRead; bool get isSent;@JsonKey(name: 'jobID') String? get jobId; String? get jobNumber; String? get jobStatus;@JsonKey(name: 'customerID') String? get customerId; String? get customerName;@JsonKey(name: 'siteID') String? get siteId; String? get siteName; String? get notificationType; Map<String, dynamic>? get rawData;
/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationModelCopyWith<NotificationModel> get copyWith => _$NotificationModelCopyWithImpl<NotificationModel>(this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isSent, isSent) || other.isSent == isSent)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNumber, jobNumber) || other.jobNumber == jobNumber)&&(identical(other.jobStatus, jobStatus) || other.jobStatus == jobStatus)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&const DeepCollectionEquality().equals(other.rawData, rawData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,message,timestamp,isRead,isSent,jobId,jobNumber,jobStatus,customerId,customerName,siteId,siteName,notificationType,const DeepCollectionEquality().hash(rawData));

@override
String toString() {
  return 'NotificationModel(id: $id, type: $type, title: $title, message: $message, timestamp: $timestamp, isRead: $isRead, isSent: $isSent, jobId: $jobId, jobNumber: $jobNumber, jobStatus: $jobStatus, customerId: $customerId, customerName: $customerName, siteId: $siteId, siteName: $siteName, notificationType: $notificationType, rawData: $rawData)';
}


}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res>  {
  factory $NotificationModelCopyWith(NotificationModel value, $Res Function(NotificationModel) _then) = _$NotificationModelCopyWithImpl;
@useResult
$Res call({
 String id, String type, String title, String message, DateTime timestamp, bool isRead, bool isSent,@JsonKey(name: 'jobID') String? jobId, String? jobNumber, String? jobStatus,@JsonKey(name: 'customerID') String? customerId, String? customerName,@JsonKey(name: 'siteID') String? siteId, String? siteName, String? notificationType, Map<String, dynamic>? rawData
});




}
/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? message = null,Object? timestamp = null,Object? isRead = null,Object? isSent = null,Object? jobId = freezed,Object? jobNumber = freezed,Object? jobStatus = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? siteId = freezed,Object? siteName = freezed,Object? notificationType = freezed,Object? rawData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNumber: freezed == jobNumber ? _self.jobNumber : jobNumber // ignore: cast_nullable_to_non_nullable
as String?,jobStatus: freezed == jobStatus ? _self.jobStatus : jobStatus // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,notificationType: freezed == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as String?,rawData: freezed == rawData ? _self.rawData : rawData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String message,  DateTime timestamp,  bool isRead,  bool isSent, @JsonKey(name: 'jobID')  String? jobId,  String? jobNumber,  String? jobStatus, @JsonKey(name: 'customerID')  String? customerId,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? siteName,  String? notificationType,  Map<String, dynamic>? rawData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.message,_that.timestamp,_that.isRead,_that.isSent,_that.jobId,_that.jobNumber,_that.jobStatus,_that.customerId,_that.customerName,_that.siteId,_that.siteName,_that.notificationType,_that.rawData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String message,  DateTime timestamp,  bool isRead,  bool isSent, @JsonKey(name: 'jobID')  String? jobId,  String? jobNumber,  String? jobStatus, @JsonKey(name: 'customerID')  String? customerId,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? siteName,  String? notificationType,  Map<String, dynamic>? rawData)  $default,) {final _that = this;
switch (_that) {
case _NotificationModel():
return $default(_that.id,_that.type,_that.title,_that.message,_that.timestamp,_that.isRead,_that.isSent,_that.jobId,_that.jobNumber,_that.jobStatus,_that.customerId,_that.customerName,_that.siteId,_that.siteName,_that.notificationType,_that.rawData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String title,  String message,  DateTime timestamp,  bool isRead,  bool isSent, @JsonKey(name: 'jobID')  String? jobId,  String? jobNumber,  String? jobStatus, @JsonKey(name: 'customerID')  String? customerId,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? siteName,  String? notificationType,  Map<String, dynamic>? rawData)?  $default,) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.message,_that.timestamp,_that.isRead,_that.isSent,_that.jobId,_that.jobNumber,_that.jobStatus,_that.customerId,_that.customerName,_that.siteId,_that.siteName,_that.notificationType,_that.rawData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationModel extends NotificationModel {
  const _NotificationModel({required this.id, required this.type, required this.title, required this.message, required this.timestamp, this.isRead = false, this.isSent = false, @JsonKey(name: 'jobID') this.jobId, this.jobNumber, this.jobStatus, @JsonKey(name: 'customerID') this.customerId, this.customerName, @JsonKey(name: 'siteID') this.siteId, this.siteName, this.notificationType, final  Map<String, dynamic>? rawData}): _rawData = rawData,super._();
  factory _NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

@override final  String id;
@override final  String type;
@override final  String title;
@override final  String message;
@override final  DateTime timestamp;
@override@JsonKey() final  bool isRead;
@override@JsonKey() final  bool isSent;
@override@JsonKey(name: 'jobID') final  String? jobId;
@override final  String? jobNumber;
@override final  String? jobStatus;
@override@JsonKey(name: 'customerID') final  String? customerId;
@override final  String? customerName;
@override@JsonKey(name: 'siteID') final  String? siteId;
@override final  String? siteName;
@override final  String? notificationType;
 final  Map<String, dynamic>? _rawData;
@override Map<String, dynamic>? get rawData {
  final value = _rawData;
  if (value == null) return null;
  if (_rawData is EqualUnmodifiableMapView) return _rawData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationModelCopyWith<_NotificationModel> get copyWith => __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isSent, isSent) || other.isSent == isSent)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobNumber, jobNumber) || other.jobNumber == jobNumber)&&(identical(other.jobStatus, jobStatus) || other.jobStatus == jobStatus)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&const DeepCollectionEquality().equals(other._rawData, _rawData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,message,timestamp,isRead,isSent,jobId,jobNumber,jobStatus,customerId,customerName,siteId,siteName,notificationType,const DeepCollectionEquality().hash(_rawData));

@override
String toString() {
  return 'NotificationModel(id: $id, type: $type, title: $title, message: $message, timestamp: $timestamp, isRead: $isRead, isSent: $isSent, jobId: $jobId, jobNumber: $jobNumber, jobStatus: $jobStatus, customerId: $customerId, customerName: $customerName, siteId: $siteId, siteName: $siteName, notificationType: $notificationType, rawData: $rawData)';
}


}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res> implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(_NotificationModel value, $Res Function(_NotificationModel) _then) = __$NotificationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String title, String message, DateTime timestamp, bool isRead, bool isSent,@JsonKey(name: 'jobID') String? jobId, String? jobNumber, String? jobStatus,@JsonKey(name: 'customerID') String? customerId, String? customerName,@JsonKey(name: 'siteID') String? siteId, String? siteName, String? notificationType, Map<String, dynamic>? rawData
});




}
/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? message = null,Object? timestamp = null,Object? isRead = null,Object? isSent = null,Object? jobId = freezed,Object? jobNumber = freezed,Object? jobStatus = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? siteId = freezed,Object? siteName = freezed,Object? notificationType = freezed,Object? rawData = freezed,}) {
  return _then(_NotificationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobNumber: freezed == jobNumber ? _self.jobNumber : jobNumber // ignore: cast_nullable_to_non_nullable
as String?,jobStatus: freezed == jobStatus ? _self.jobStatus : jobStatus // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,siteName: freezed == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String?,notificationType: freezed == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as String?,rawData: freezed == rawData ? _self._rawData : rawData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
