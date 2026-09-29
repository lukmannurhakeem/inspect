// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemReportModel {

@JsonKey(name: 'reportID') String? get reportId;@JsonKey(name: 'reportTypeID') String? get reportTypeId; String? get reportName;@JsonKey(name: 'itemID') String? get itemId; String? get itemNo; String? get status; String? get inspectedBy; DateTime? get reportDate; String? get regulation; ReportData? get reportData; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of ItemReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemReportModelCopyWith<ItemReportModel> get copyWith => _$ItemReportModelCopyWithImpl<ItemReportModel>(this as ItemReportModel, _$identity);

  /// Serializes this ItemReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemReportModel&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&(identical(other.reportData, reportData) || other.reportData == reportData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportId,reportTypeId,reportName,itemId,itemNo,status,inspectedBy,reportDate,regulation,reportData,createdAt,updatedAt);

@override
String toString() {
  return 'ItemReportModel(reportId: $reportId, reportTypeId: $reportTypeId, reportName: $reportName, itemId: $itemId, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, reportDate: $reportDate, regulation: $regulation, reportData: $reportData, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ItemReportModelCopyWith<$Res>  {
  factory $ItemReportModelCopyWith(ItemReportModel value, $Res Function(ItemReportModel) _then) = _$ItemReportModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reportID') String? reportId,@JsonKey(name: 'reportTypeID') String? reportTypeId, String? reportName,@JsonKey(name: 'itemID') String? itemId, String? itemNo, String? status, String? inspectedBy, DateTime? reportDate, String? regulation, ReportData? reportData, DateTime? createdAt, DateTime? updatedAt
});


$ReportDataCopyWith<$Res>? get reportData;

}
/// @nodoc
class _$ItemReportModelCopyWithImpl<$Res>
    implements $ItemReportModelCopyWith<$Res> {
  _$ItemReportModelCopyWithImpl(this._self, this._then);

  final ItemReportModel _self;
  final $Res Function(ItemReportModel) _then;

/// Create a copy of ItemReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportId = freezed,Object? reportTypeId = freezed,Object? reportName = freezed,Object? itemId = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? reportData = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,reportData: freezed == reportData ? _self.reportData : reportData // ignore: cast_nullable_to_non_nullable
as ReportData?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ItemReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportDataCopyWith<$Res>? get reportData {
    if (_self.reportData == null) {
    return null;
  }

  return $ReportDataCopyWith<$Res>(_self.reportData!, (value) {
    return _then(_self.copyWith(reportData: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItemReportModel].
extension ItemReportModelPatterns on ItemReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ItemReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ItemReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportID')  String? reportId, @JsonKey(name: 'reportTypeID')  String? reportTypeId,  String? reportName, @JsonKey(name: 'itemID')  String? itemId,  String? itemNo,  String? status,  String? inspectedBy,  DateTime? reportDate,  String? regulation,  ReportData? reportData,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemReportModel() when $default != null:
return $default(_that.reportId,_that.reportTypeId,_that.reportName,_that.itemId,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportID')  String? reportId, @JsonKey(name: 'reportTypeID')  String? reportTypeId,  String? reportName, @JsonKey(name: 'itemID')  String? itemId,  String? itemNo,  String? status,  String? inspectedBy,  DateTime? reportDate,  String? regulation,  ReportData? reportData,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ItemReportModel():
return $default(_that.reportId,_that.reportTypeId,_that.reportName,_that.itemId,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reportID')  String? reportId, @JsonKey(name: 'reportTypeID')  String? reportTypeId,  String? reportName, @JsonKey(name: 'itemID')  String? itemId,  String? itemNo,  String? status,  String? inspectedBy,  DateTime? reportDate,  String? regulation,  ReportData? reportData,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemReportModel() when $default != null:
return $default(_that.reportId,_that.reportTypeId,_that.reportName,_that.itemId,_that.itemNo,_that.status,_that.inspectedBy,_that.reportDate,_that.regulation,_that.reportData,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemReportModel implements ItemReportModel {
  const _ItemReportModel({@JsonKey(name: 'reportID') this.reportId, @JsonKey(name: 'reportTypeID') this.reportTypeId, this.reportName, @JsonKey(name: 'itemID') this.itemId, this.itemNo, this.status, this.inspectedBy, this.reportDate, this.regulation, this.reportData, this.createdAt, this.updatedAt});
  factory _ItemReportModel.fromJson(Map<String, dynamic> json) => _$ItemReportModelFromJson(json);

@override@JsonKey(name: 'reportID') final  String? reportId;
@override@JsonKey(name: 'reportTypeID') final  String? reportTypeId;
@override final  String? reportName;
@override@JsonKey(name: 'itemID') final  String? itemId;
@override final  String? itemNo;
@override final  String? status;
@override final  String? inspectedBy;
@override final  DateTime? reportDate;
@override final  String? regulation;
@override final  ReportData? reportData;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ItemReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemReportModelCopyWith<_ItemReportModel> get copyWith => __$ItemReportModelCopyWithImpl<_ItemReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemReportModel&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectedBy, inspectedBy) || other.inspectedBy == inspectedBy)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.regulation, regulation) || other.regulation == regulation)&&(identical(other.reportData, reportData) || other.reportData == reportData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportId,reportTypeId,reportName,itemId,itemNo,status,inspectedBy,reportDate,regulation,reportData,createdAt,updatedAt);

@override
String toString() {
  return 'ItemReportModel(reportId: $reportId, reportTypeId: $reportTypeId, reportName: $reportName, itemId: $itemId, itemNo: $itemNo, status: $status, inspectedBy: $inspectedBy, reportDate: $reportDate, regulation: $regulation, reportData: $reportData, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ItemReportModelCopyWith<$Res> implements $ItemReportModelCopyWith<$Res> {
  factory _$ItemReportModelCopyWith(_ItemReportModel value, $Res Function(_ItemReportModel) _then) = __$ItemReportModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reportID') String? reportId,@JsonKey(name: 'reportTypeID') String? reportTypeId, String? reportName,@JsonKey(name: 'itemID') String? itemId, String? itemNo, String? status, String? inspectedBy, DateTime? reportDate, String? regulation, ReportData? reportData, DateTime? createdAt, DateTime? updatedAt
});


@override $ReportDataCopyWith<$Res>? get reportData;

}
/// @nodoc
class __$ItemReportModelCopyWithImpl<$Res>
    implements _$ItemReportModelCopyWith<$Res> {
  __$ItemReportModelCopyWithImpl(this._self, this._then);

  final _ItemReportModel _self;
  final $Res Function(_ItemReportModel) _then;

/// Create a copy of ItemReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportId = freezed,Object? reportTypeId = freezed,Object? reportName = freezed,Object? itemId = freezed,Object? itemNo = freezed,Object? status = freezed,Object? inspectedBy = freezed,Object? reportDate = freezed,Object? regulation = freezed,Object? reportData = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ItemReportModel(
reportId: freezed == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,inspectedBy: freezed == inspectedBy ? _self.inspectedBy : inspectedBy // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as DateTime?,regulation: freezed == regulation ? _self.regulation : regulation // ignore: cast_nullable_to_non_nullable
as String?,reportData: freezed == reportData ? _self.reportData : reportData // ignore: cast_nullable_to_non_nullable
as ReportData?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ItemReportModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportDataCopyWith<$Res>? get reportData {
    if (_self.reportData == null) {
    return null;
  }

  return $ReportDataCopyWith<$Res>(_self.reportData!, (value) {
    return _then(_self.copyWith(reportData: value));
  });
}
}


/// @nodoc
mixin _$ReportData {

 Field? get field1; Field? get field2;
/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportDataCopyWith<ReportData> get copyWith => _$ReportDataCopyWithImpl<ReportData>(this as ReportData, _$identity);

  /// Serializes this ReportData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportData&&(identical(other.field1, field1) || other.field1 == field1)&&(identical(other.field2, field2) || other.field2 == field2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field1,field2);

@override
String toString() {
  return 'ReportData(field1: $field1, field2: $field2)';
}


}

/// @nodoc
abstract mixin class $ReportDataCopyWith<$Res>  {
  factory $ReportDataCopyWith(ReportData value, $Res Function(ReportData) _then) = _$ReportDataCopyWithImpl;
@useResult
$Res call({
 Field? field1, Field? field2
});


$FieldCopyWith<$Res>? get field1;$FieldCopyWith<$Res>? get field2;

}
/// @nodoc
class _$ReportDataCopyWithImpl<$Res>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._self, this._then);

  final ReportData _self;
  final $Res Function(ReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field1 = freezed,Object? field2 = freezed,}) {
  return _then(_self.copyWith(
field1: freezed == field1 ? _self.field1 : field1 // ignore: cast_nullable_to_non_nullable
as Field?,field2: freezed == field2 ? _self.field2 : field2 // ignore: cast_nullable_to_non_nullable
as Field?,
  ));
}
/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldCopyWith<$Res>? get field1 {
    if (_self.field1 == null) {
    return null;
  }

  return $FieldCopyWith<$Res>(_self.field1!, (value) {
    return _then(_self.copyWith(field1: value));
  });
}/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldCopyWith<$Res>? get field2 {
    if (_self.field2 == null) {
    return null;
  }

  return $FieldCopyWith<$Res>(_self.field2!, (value) {
    return _then(_self.copyWith(field2: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportData].
extension ReportDataPatterns on ReportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportData value)  $default,){
final _that = this;
switch (_that) {
case _ReportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportData value)?  $default,){
final _that = this;
switch (_that) {
case _ReportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Field? field1,  Field? field2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportData() when $default != null:
return $default(_that.field1,_that.field2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Field? field1,  Field? field2)  $default,) {final _that = this;
switch (_that) {
case _ReportData():
return $default(_that.field1,_that.field2);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Field? field1,  Field? field2)?  $default,) {final _that = this;
switch (_that) {
case _ReportData() when $default != null:
return $default(_that.field1,_that.field2);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportData implements ReportData {
  const _ReportData({this.field1, this.field2});
  factory _ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);

@override final  Field? field1;
@override final  Field? field2;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportDataCopyWith<_ReportData> get copyWith => __$ReportDataCopyWithImpl<_ReportData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportData&&(identical(other.field1, field1) || other.field1 == field1)&&(identical(other.field2, field2) || other.field2 == field2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field1,field2);

@override
String toString() {
  return 'ReportData(field1: $field1, field2: $field2)';
}


}

/// @nodoc
abstract mixin class _$ReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory _$ReportDataCopyWith(_ReportData value, $Res Function(_ReportData) _then) = __$ReportDataCopyWithImpl;
@override @useResult
$Res call({
 Field? field1, Field? field2
});


@override $FieldCopyWith<$Res>? get field1;@override $FieldCopyWith<$Res>? get field2;

}
/// @nodoc
class __$ReportDataCopyWithImpl<$Res>
    implements _$ReportDataCopyWith<$Res> {
  __$ReportDataCopyWithImpl(this._self, this._then);

  final _ReportData _self;
  final $Res Function(_ReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field1 = freezed,Object? field2 = freezed,}) {
  return _then(_ReportData(
field1: freezed == field1 ? _self.field1 : field1 // ignore: cast_nullable_to_non_nullable
as Field?,field2: freezed == field2 ? _self.field2 : field2 // ignore: cast_nullable_to_non_nullable
as Field?,
  ));
}

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldCopyWith<$Res>? get field1 {
    if (_self.field1 == null) {
    return null;
  }

  return $FieldCopyWith<$Res>(_self.field1!, (value) {
    return _then(_self.copyWith(field1: value));
  });
}/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FieldCopyWith<$Res>? get field2 {
    if (_self.field2 == null) {
    return null;
  }

  return $FieldCopyWith<$Res>(_self.field2!, (value) {
    return _then(_self.copyWith(field2: value));
  });
}
}


/// @nodoc
mixin _$Field {

 String? get value;
/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldCopyWith<Field> get copyWith => _$FieldCopyWithImpl<Field>(this as Field, _$identity);

  /// Serializes this Field to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Field&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'Field(value: $value)';
}


}

/// @nodoc
abstract mixin class $FieldCopyWith<$Res>  {
  factory $FieldCopyWith(Field value, $Res Function(Field) _then) = _$FieldCopyWithImpl;
@useResult
$Res call({
 String? value
});




}
/// @nodoc
class _$FieldCopyWithImpl<$Res>
    implements $FieldCopyWith<$Res> {
  _$FieldCopyWithImpl(this._self, this._then);

  final Field _self;
  final $Res Function(Field) _then;

/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,}) {
  return _then(_self.copyWith(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Field].
extension FieldPatterns on Field {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Field value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Field() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Field value)  $default,){
final _that = this;
switch (_that) {
case _Field():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Field value)?  $default,){
final _that = this;
switch (_that) {
case _Field() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Field() when $default != null:
return $default(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? value)  $default,) {final _that = this;
switch (_that) {
case _Field():
return $default(_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? value)?  $default,) {final _that = this;
switch (_that) {
case _Field() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Field implements Field {
  const _Field({this.value});
  factory _Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

@override final  String? value;

/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldCopyWith<_Field> get copyWith => __$FieldCopyWithImpl<_Field>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Field&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'Field(value: $value)';
}


}

/// @nodoc
abstract mixin class _$FieldCopyWith<$Res> implements $FieldCopyWith<$Res> {
  factory _$FieldCopyWith(_Field value, $Res Function(_Field) _then) = __$FieldCopyWithImpl;
@override @useResult
$Res call({
 String? value
});




}
/// @nodoc
class __$FieldCopyWithImpl<$Res>
    implements _$FieldCopyWith<$Res> {
  __$FieldCopyWithImpl(this._self, this._then);

  final _Field _self;
  final $Res Function(_Field) _then;

/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,}) {
  return _then(_Field(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
