// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CycleModel {

 List<CycleData>? get data; String? get message; int? get page; int? get pageSize; int? get totalCount;
/// Create a copy of CycleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleModelCopyWith<CycleModel> get copyWith => _$CycleModelCopyWithImpl<CycleModel>(this as CycleModel, _$identity);

  /// Serializes this CycleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleModel&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),message,page,pageSize,totalCount);

@override
String toString() {
  return 'CycleModel(data: $data, message: $message, page: $page, pageSize: $pageSize, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class $CycleModelCopyWith<$Res>  {
  factory $CycleModelCopyWith(CycleModel value, $Res Function(CycleModel) _then) = _$CycleModelCopyWithImpl;
@useResult
$Res call({
 List<CycleData>? data, String? message, int? page, int? pageSize, int? totalCount
});




}
/// @nodoc
class _$CycleModelCopyWithImpl<$Res>
    implements $CycleModelCopyWith<$Res> {
  _$CycleModelCopyWithImpl(this._self, this._then);

  final CycleModel _self;
  final $Res Function(CycleModel) _then;

/// Create a copy of CycleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? message = freezed,Object? page = freezed,Object? pageSize = freezed,Object? totalCount = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<CycleData>?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,pageSize: freezed == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int?,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CycleModel].
extension CycleModelPatterns on CycleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleModel value)  $default,){
final _that = this;
switch (_that) {
case _CycleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleModel value)?  $default,){
final _that = this;
switch (_that) {
case _CycleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CycleData>? data,  String? message,  int? page,  int? pageSize,  int? totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleModel() when $default != null:
return $default(_that.data,_that.message,_that.page,_that.pageSize,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CycleData>? data,  String? message,  int? page,  int? pageSize,  int? totalCount)  $default,) {final _that = this;
switch (_that) {
case _CycleModel():
return $default(_that.data,_that.message,_that.page,_that.pageSize,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CycleData>? data,  String? message,  int? page,  int? pageSize,  int? totalCount)?  $default,) {final _that = this;
switch (_that) {
case _CycleModel() when $default != null:
return $default(_that.data,_that.message,_that.page,_that.pageSize,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CycleModel extends CycleModel {
  const _CycleModel({final  List<CycleData>? data, this.message, this.page, this.pageSize, this.totalCount}): _data = data,super._();
  factory _CycleModel.fromJson(Map<String, dynamic> json) => _$CycleModelFromJson(json);

 final  List<CycleData>? _data;
@override List<CycleData>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? message;
@override final  int? page;
@override final  int? pageSize;
@override final  int? totalCount;

/// Create a copy of CycleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleModelCopyWith<_CycleModel> get copyWith => __$CycleModelCopyWithImpl<_CycleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CycleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleModel&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),message,page,pageSize,totalCount);

@override
String toString() {
  return 'CycleModel(data: $data, message: $message, page: $page, pageSize: $pageSize, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$CycleModelCopyWith<$Res> implements $CycleModelCopyWith<$Res> {
  factory _$CycleModelCopyWith(_CycleModel value, $Res Function(_CycleModel) _then) = __$CycleModelCopyWithImpl;
@override @useResult
$Res call({
 List<CycleData>? data, String? message, int? page, int? pageSize, int? totalCount
});




}
/// @nodoc
class __$CycleModelCopyWithImpl<$Res>
    implements _$CycleModelCopyWith<$Res> {
  __$CycleModelCopyWithImpl(this._self, this._then);

  final _CycleModel _self;
  final $Res Function(_CycleModel) _then;

/// Create a copy of CycleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? message = freezed,Object? page = freezed,Object? pageSize = freezed,Object? totalCount = freezed,}) {
  return _then(_CycleModel(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<CycleData>?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,pageSize: freezed == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int?,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CycleData {

@JsonKey(name: 'cycleID') String? get cycleId;@JsonKey(name: 'reportTypeID') String? get reportTypeId; String? get reportTypeName;@JsonKey(name: 'categoryID') String? get categoryId;@JsonKey(name: 'customerID') String? get customerId; String? get customerName;@JsonKey(name: 'siteID') String? get siteId; String? get unit; int? get length; int? get minLength; int? get maxLength; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of CycleData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleDataCopyWith<CycleData> get copyWith => _$CycleDataCopyWithImpl<CycleData>(this as CycleData, _$identity);

  /// Serializes this CycleData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleData&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.reportTypeName, reportTypeName) || other.reportTypeName == reportTypeName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.length, length) || other.length == length)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,reportTypeId,reportTypeName,categoryId,customerId,customerName,siteId,unit,length,minLength,maxLength,createdAt,updatedAt);

@override
String toString() {
  return 'CycleData(cycleId: $cycleId, reportTypeId: $reportTypeId, reportTypeName: $reportTypeName, categoryId: $categoryId, customerId: $customerId, customerName: $customerName, siteId: $siteId, unit: $unit, length: $length, minLength: $minLength, maxLength: $maxLength, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CycleDataCopyWith<$Res>  {
  factory $CycleDataCopyWith(CycleData value, $Res Function(CycleData) _then) = _$CycleDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'cycleID') String? cycleId,@JsonKey(name: 'reportTypeID') String? reportTypeId, String? reportTypeName,@JsonKey(name: 'categoryID') String? categoryId,@JsonKey(name: 'customerID') String? customerId, String? customerName,@JsonKey(name: 'siteID') String? siteId, String? unit, int? length, int? minLength, int? maxLength, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$CycleDataCopyWithImpl<$Res>
    implements $CycleDataCopyWith<$Res> {
  _$CycleDataCopyWithImpl(this._self, this._then);

  final CycleData _self;
  final $Res Function(CycleData) _then;

/// Create a copy of CycleData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = freezed,Object? reportTypeId = freezed,Object? reportTypeName = freezed,Object? categoryId = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? siteId = freezed,Object? unit = freezed,Object? length = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeName: freezed == reportTypeName ? _self.reportTypeName : reportTypeName // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CycleData].
extension CycleDataPatterns on CycleData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleData value)  $default,){
final _that = this;
switch (_that) {
case _CycleData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleData value)?  $default,){
final _that = this;
switch (_that) {
case _CycleData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'cycleID')  String? cycleId, @JsonKey(name: 'reportTypeID')  String? reportTypeId,  String? reportTypeName, @JsonKey(name: 'categoryID')  String? categoryId, @JsonKey(name: 'customerID')  String? customerId,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? unit,  int? length,  int? minLength,  int? maxLength,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleData() when $default != null:
return $default(_that.cycleId,_that.reportTypeId,_that.reportTypeName,_that.categoryId,_that.customerId,_that.customerName,_that.siteId,_that.unit,_that.length,_that.minLength,_that.maxLength,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'cycleID')  String? cycleId, @JsonKey(name: 'reportTypeID')  String? reportTypeId,  String? reportTypeName, @JsonKey(name: 'categoryID')  String? categoryId, @JsonKey(name: 'customerID')  String? customerId,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? unit,  int? length,  int? minLength,  int? maxLength,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CycleData():
return $default(_that.cycleId,_that.reportTypeId,_that.reportTypeName,_that.categoryId,_that.customerId,_that.customerName,_that.siteId,_that.unit,_that.length,_that.minLength,_that.maxLength,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'cycleID')  String? cycleId, @JsonKey(name: 'reportTypeID')  String? reportTypeId,  String? reportTypeName, @JsonKey(name: 'categoryID')  String? categoryId, @JsonKey(name: 'customerID')  String? customerId,  String? customerName, @JsonKey(name: 'siteID')  String? siteId,  String? unit,  int? length,  int? minLength,  int? maxLength,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CycleData() when $default != null:
return $default(_that.cycleId,_that.reportTypeId,_that.reportTypeName,_that.categoryId,_that.customerId,_that.customerName,_that.siteId,_that.unit,_that.length,_that.minLength,_that.maxLength,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CycleData extends CycleData {
  const _CycleData({@JsonKey(name: 'cycleID') this.cycleId, @JsonKey(name: 'reportTypeID') this.reportTypeId, this.reportTypeName, @JsonKey(name: 'categoryID') this.categoryId, @JsonKey(name: 'customerID') this.customerId, this.customerName, @JsonKey(name: 'siteID') this.siteId, this.unit, this.length, this.minLength, this.maxLength, this.createdAt, this.updatedAt}): super._();
  factory _CycleData.fromJson(Map<String, dynamic> json) => _$CycleDataFromJson(json);

@override@JsonKey(name: 'cycleID') final  String? cycleId;
@override@JsonKey(name: 'reportTypeID') final  String? reportTypeId;
@override final  String? reportTypeName;
@override@JsonKey(name: 'categoryID') final  String? categoryId;
@override@JsonKey(name: 'customerID') final  String? customerId;
@override final  String? customerName;
@override@JsonKey(name: 'siteID') final  String? siteId;
@override final  String? unit;
@override final  int? length;
@override final  int? minLength;
@override final  int? maxLength;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of CycleData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleDataCopyWith<_CycleData> get copyWith => __$CycleDataCopyWithImpl<_CycleData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CycleDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleData&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.reportTypeName, reportTypeName) || other.reportTypeName == reportTypeName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.length, length) || other.length == length)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cycleId,reportTypeId,reportTypeName,categoryId,customerId,customerName,siteId,unit,length,minLength,maxLength,createdAt,updatedAt);

@override
String toString() {
  return 'CycleData(cycleId: $cycleId, reportTypeId: $reportTypeId, reportTypeName: $reportTypeName, categoryId: $categoryId, customerId: $customerId, customerName: $customerName, siteId: $siteId, unit: $unit, length: $length, minLength: $minLength, maxLength: $maxLength, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CycleDataCopyWith<$Res> implements $CycleDataCopyWith<$Res> {
  factory _$CycleDataCopyWith(_CycleData value, $Res Function(_CycleData) _then) = __$CycleDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'cycleID') String? cycleId,@JsonKey(name: 'reportTypeID') String? reportTypeId, String? reportTypeName,@JsonKey(name: 'categoryID') String? categoryId,@JsonKey(name: 'customerID') String? customerId, String? customerName,@JsonKey(name: 'siteID') String? siteId, String? unit, int? length, int? minLength, int? maxLength, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$CycleDataCopyWithImpl<$Res>
    implements _$CycleDataCopyWith<$Res> {
  __$CycleDataCopyWithImpl(this._self, this._then);

  final _CycleData _self;
  final $Res Function(_CycleData) _then;

/// Create a copy of CycleData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = freezed,Object? reportTypeId = freezed,Object? reportTypeName = freezed,Object? categoryId = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? siteId = freezed,Object? unit = freezed,Object? length = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CycleData(
cycleId: freezed == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeName: freezed == reportTypeName ? _self.reportTypeName : reportTypeName // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
