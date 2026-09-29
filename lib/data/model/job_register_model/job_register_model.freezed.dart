// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_register_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Item {

@JsonKey(name: 'itemId') String? get itemId; String? get itemNo; String? get description; bool? get archived; String? get rfidNo;@JsonKey(name: 'categoryId') String? get categoryId;@JsonKey(name: 'locationId') String? get locationId; String? get detailedLocation; String? get internalNotes; String? get manufacturer; String? get manufacturerAddress; DateTime? get manufacturerDate; DateTime? get firstUseDate; DateTime? get expiryDateTimeStamp; String? get status; String? get swl; String? get photoReference; String? get standardReference; Map<String, dynamic>? get customFields;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.description, description) || other.description == description)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.rfidNo, rfidNo) || other.rfidNo == rfidNo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.detailedLocation, detailedLocation) || other.detailedLocation == detailedLocation)&&(identical(other.internalNotes, internalNotes) || other.internalNotes == internalNotes)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.manufacturerAddress, manufacturerAddress) || other.manufacturerAddress == manufacturerAddress)&&(identical(other.manufacturerDate, manufacturerDate) || other.manufacturerDate == manufacturerDate)&&(identical(other.firstUseDate, firstUseDate) || other.firstUseDate == firstUseDate)&&(identical(other.expiryDateTimeStamp, expiryDateTimeStamp) || other.expiryDateTimeStamp == expiryDateTimeStamp)&&(identical(other.status, status) || other.status == status)&&(identical(other.swl, swl) || other.swl == swl)&&(identical(other.photoReference, photoReference) || other.photoReference == photoReference)&&(identical(other.standardReference, standardReference) || other.standardReference == standardReference)&&const DeepCollectionEquality().equals(other.customFields, customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,itemNo,description,archived,rfidNo,categoryId,locationId,detailedLocation,internalNotes,manufacturer,manufacturerAddress,manufacturerDate,firstUseDate,expiryDateTimeStamp,status,swl,photoReference,standardReference,const DeepCollectionEquality().hash(customFields)]);

@override
String toString() {
  return 'Item(itemId: $itemId, itemNo: $itemNo, description: $description, archived: $archived, rfidNo: $rfidNo, categoryId: $categoryId, locationId: $locationId, detailedLocation: $detailedLocation, internalNotes: $internalNotes, manufacturer: $manufacturer, manufacturerAddress: $manufacturerAddress, manufacturerDate: $manufacturerDate, firstUseDate: $firstUseDate, expiryDateTimeStamp: $expiryDateTimeStamp, status: $status, swl: $swl, photoReference: $photoReference, standardReference: $standardReference, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'itemId') String? itemId, String? itemNo, String? description, bool? archived, String? rfidNo,@JsonKey(name: 'categoryId') String? categoryId,@JsonKey(name: 'locationId') String? locationId, String? detailedLocation, String? internalNotes, String? manufacturer, String? manufacturerAddress, DateTime? manufacturerDate, DateTime? firstUseDate, DateTime? expiryDateTimeStamp, String? status, String? swl, String? photoReference, String? standardReference, Map<String, dynamic>? customFields
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = freezed,Object? itemNo = freezed,Object? description = freezed,Object? archived = freezed,Object? rfidNo = freezed,Object? categoryId = freezed,Object? locationId = freezed,Object? detailedLocation = freezed,Object? internalNotes = freezed,Object? manufacturer = freezed,Object? manufacturerAddress = freezed,Object? manufacturerDate = freezed,Object? firstUseDate = freezed,Object? expiryDateTimeStamp = freezed,Object? status = freezed,Object? swl = freezed,Object? photoReference = freezed,Object? standardReference = freezed,Object? customFields = freezed,}) {
  return _then(_self.copyWith(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,rfidNo: freezed == rfidNo ? _self.rfidNo : rfidNo // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,detailedLocation: freezed == detailedLocation ? _self.detailedLocation : detailedLocation // ignore: cast_nullable_to_non_nullable
as String?,internalNotes: freezed == internalNotes ? _self.internalNotes : internalNotes // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,manufacturerAddress: freezed == manufacturerAddress ? _self.manufacturerAddress : manufacturerAddress // ignore: cast_nullable_to_non_nullable
as String?,manufacturerDate: freezed == manufacturerDate ? _self.manufacturerDate : manufacturerDate // ignore: cast_nullable_to_non_nullable
as DateTime?,firstUseDate: freezed == firstUseDate ? _self.firstUseDate : firstUseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDateTimeStamp: freezed == expiryDateTimeStamp ? _self.expiryDateTimeStamp : expiryDateTimeStamp // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,swl: freezed == swl ? _self.swl : swl // ignore: cast_nullable_to_non_nullable
as String?,photoReference: freezed == photoReference ? _self.photoReference : photoReference // ignore: cast_nullable_to_non_nullable
as String?,standardReference: freezed == standardReference ? _self.standardReference : standardReference // ignore: cast_nullable_to_non_nullable
as String?,customFields: freezed == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'itemId')  String? itemId,  String? itemNo,  String? description,  bool? archived,  String? rfidNo, @JsonKey(name: 'categoryId')  String? categoryId, @JsonKey(name: 'locationId')  String? locationId,  String? detailedLocation,  String? internalNotes,  String? manufacturer,  String? manufacturerAddress,  DateTime? manufacturerDate,  DateTime? firstUseDate,  DateTime? expiryDateTimeStamp,  String? status,  String? swl,  String? photoReference,  String? standardReference,  Map<String, dynamic>? customFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.itemId,_that.itemNo,_that.description,_that.archived,_that.rfidNo,_that.categoryId,_that.locationId,_that.detailedLocation,_that.internalNotes,_that.manufacturer,_that.manufacturerAddress,_that.manufacturerDate,_that.firstUseDate,_that.expiryDateTimeStamp,_that.status,_that.swl,_that.photoReference,_that.standardReference,_that.customFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'itemId')  String? itemId,  String? itemNo,  String? description,  bool? archived,  String? rfidNo, @JsonKey(name: 'categoryId')  String? categoryId, @JsonKey(name: 'locationId')  String? locationId,  String? detailedLocation,  String? internalNotes,  String? manufacturer,  String? manufacturerAddress,  DateTime? manufacturerDate,  DateTime? firstUseDate,  DateTime? expiryDateTimeStamp,  String? status,  String? swl,  String? photoReference,  String? standardReference,  Map<String, dynamic>? customFields)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.itemId,_that.itemNo,_that.description,_that.archived,_that.rfidNo,_that.categoryId,_that.locationId,_that.detailedLocation,_that.internalNotes,_that.manufacturer,_that.manufacturerAddress,_that.manufacturerDate,_that.firstUseDate,_that.expiryDateTimeStamp,_that.status,_that.swl,_that.photoReference,_that.standardReference,_that.customFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'itemId')  String? itemId,  String? itemNo,  String? description,  bool? archived,  String? rfidNo, @JsonKey(name: 'categoryId')  String? categoryId, @JsonKey(name: 'locationId')  String? locationId,  String? detailedLocation,  String? internalNotes,  String? manufacturer,  String? manufacturerAddress,  DateTime? manufacturerDate,  DateTime? firstUseDate,  DateTime? expiryDateTimeStamp,  String? status,  String? swl,  String? photoReference,  String? standardReference,  Map<String, dynamic>? customFields)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.itemId,_that.itemNo,_that.description,_that.archived,_that.rfidNo,_that.categoryId,_that.locationId,_that.detailedLocation,_that.internalNotes,_that.manufacturer,_that.manufacturerAddress,_that.manufacturerDate,_that.firstUseDate,_that.expiryDateTimeStamp,_that.status,_that.swl,_that.photoReference,_that.standardReference,_that.customFields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Item implements Item {
  const _Item({@JsonKey(name: 'itemId') this.itemId, this.itemNo, this.description, this.archived, this.rfidNo, @JsonKey(name: 'categoryId') this.categoryId, @JsonKey(name: 'locationId') this.locationId, this.detailedLocation, this.internalNotes, this.manufacturer, this.manufacturerAddress, this.manufacturerDate, this.firstUseDate, this.expiryDateTimeStamp, this.status, this.swl, this.photoReference, this.standardReference, final  Map<String, dynamic>? customFields}): _customFields = customFields;
  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

@override@JsonKey(name: 'itemId') final  String? itemId;
@override final  String? itemNo;
@override final  String? description;
@override final  bool? archived;
@override final  String? rfidNo;
@override@JsonKey(name: 'categoryId') final  String? categoryId;
@override@JsonKey(name: 'locationId') final  String? locationId;
@override final  String? detailedLocation;
@override final  String? internalNotes;
@override final  String? manufacturer;
@override final  String? manufacturerAddress;
@override final  DateTime? manufacturerDate;
@override final  DateTime? firstUseDate;
@override final  DateTime? expiryDateTimeStamp;
@override final  String? status;
@override final  String? swl;
@override final  String? photoReference;
@override final  String? standardReference;
 final  Map<String, dynamic>? _customFields;
@override Map<String, dynamic>? get customFields {
  final value = _customFields;
  if (value == null) return null;
  if (_customFields is EqualUnmodifiableMapView) return _customFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemNo, itemNo) || other.itemNo == itemNo)&&(identical(other.description, description) || other.description == description)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.rfidNo, rfidNo) || other.rfidNo == rfidNo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.detailedLocation, detailedLocation) || other.detailedLocation == detailedLocation)&&(identical(other.internalNotes, internalNotes) || other.internalNotes == internalNotes)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.manufacturerAddress, manufacturerAddress) || other.manufacturerAddress == manufacturerAddress)&&(identical(other.manufacturerDate, manufacturerDate) || other.manufacturerDate == manufacturerDate)&&(identical(other.firstUseDate, firstUseDate) || other.firstUseDate == firstUseDate)&&(identical(other.expiryDateTimeStamp, expiryDateTimeStamp) || other.expiryDateTimeStamp == expiryDateTimeStamp)&&(identical(other.status, status) || other.status == status)&&(identical(other.swl, swl) || other.swl == swl)&&(identical(other.photoReference, photoReference) || other.photoReference == photoReference)&&(identical(other.standardReference, standardReference) || other.standardReference == standardReference)&&const DeepCollectionEquality().equals(other._customFields, _customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,itemNo,description,archived,rfidNo,categoryId,locationId,detailedLocation,internalNotes,manufacturer,manufacturerAddress,manufacturerDate,firstUseDate,expiryDateTimeStamp,status,swl,photoReference,standardReference,const DeepCollectionEquality().hash(_customFields)]);

@override
String toString() {
  return 'Item(itemId: $itemId, itemNo: $itemNo, description: $description, archived: $archived, rfidNo: $rfidNo, categoryId: $categoryId, locationId: $locationId, detailedLocation: $detailedLocation, internalNotes: $internalNotes, manufacturer: $manufacturer, manufacturerAddress: $manufacturerAddress, manufacturerDate: $manufacturerDate, firstUseDate: $firstUseDate, expiryDateTimeStamp: $expiryDateTimeStamp, status: $status, swl: $swl, photoReference: $photoReference, standardReference: $standardReference, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'itemId') String? itemId, String? itemNo, String? description, bool? archived, String? rfidNo,@JsonKey(name: 'categoryId') String? categoryId,@JsonKey(name: 'locationId') String? locationId, String? detailedLocation, String? internalNotes, String? manufacturer, String? manufacturerAddress, DateTime? manufacturerDate, DateTime? firstUseDate, DateTime? expiryDateTimeStamp, String? status, String? swl, String? photoReference, String? standardReference, Map<String, dynamic>? customFields
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = freezed,Object? itemNo = freezed,Object? description = freezed,Object? archived = freezed,Object? rfidNo = freezed,Object? categoryId = freezed,Object? locationId = freezed,Object? detailedLocation = freezed,Object? internalNotes = freezed,Object? manufacturer = freezed,Object? manufacturerAddress = freezed,Object? manufacturerDate = freezed,Object? firstUseDate = freezed,Object? expiryDateTimeStamp = freezed,Object? status = freezed,Object? swl = freezed,Object? photoReference = freezed,Object? standardReference = freezed,Object? customFields = freezed,}) {
  return _then(_Item(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemNo: freezed == itemNo ? _self.itemNo : itemNo // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,rfidNo: freezed == rfidNo ? _self.rfidNo : rfidNo // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,detailedLocation: freezed == detailedLocation ? _self.detailedLocation : detailedLocation // ignore: cast_nullable_to_non_nullable
as String?,internalNotes: freezed == internalNotes ? _self.internalNotes : internalNotes // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,manufacturerAddress: freezed == manufacturerAddress ? _self.manufacturerAddress : manufacturerAddress // ignore: cast_nullable_to_non_nullable
as String?,manufacturerDate: freezed == manufacturerDate ? _self.manufacturerDate : manufacturerDate // ignore: cast_nullable_to_non_nullable
as DateTime?,firstUseDate: freezed == firstUseDate ? _self.firstUseDate : firstUseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDateTimeStamp: freezed == expiryDateTimeStamp ? _self.expiryDateTimeStamp : expiryDateTimeStamp // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,swl: freezed == swl ? _self.swl : swl // ignore: cast_nullable_to_non_nullable
as String?,photoReference: freezed == photoReference ? _self.photoReference : photoReference // ignore: cast_nullable_to_non_nullable
as String?,standardReference: freezed == standardReference ? _self.standardReference : standardReference // ignore: cast_nullable_to_non_nullable
as String?,customFields: freezed == customFields ? _self._customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$JobRegisterModel {

 List<Item>? get items; String? get jobId; String? get jobName;
/// Create a copy of JobRegisterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobRegisterModelCopyWith<JobRegisterModel> get copyWith => _$JobRegisterModelCopyWithImpl<JobRegisterModel>(this as JobRegisterModel, _$identity);

  /// Serializes this JobRegisterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobRegisterModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobName, jobName) || other.jobName == jobName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),jobId,jobName);

@override
String toString() {
  return 'JobRegisterModel(items: $items, jobId: $jobId, jobName: $jobName)';
}


}

/// @nodoc
abstract mixin class $JobRegisterModelCopyWith<$Res>  {
  factory $JobRegisterModelCopyWith(JobRegisterModel value, $Res Function(JobRegisterModel) _then) = _$JobRegisterModelCopyWithImpl;
@useResult
$Res call({
 List<Item>? items, String? jobId, String? jobName
});




}
/// @nodoc
class _$JobRegisterModelCopyWithImpl<$Res>
    implements $JobRegisterModelCopyWith<$Res> {
  _$JobRegisterModelCopyWithImpl(this._self, this._then);

  final JobRegisterModel _self;
  final $Res Function(JobRegisterModel) _then;

/// Create a copy of JobRegisterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = freezed,Object? jobId = freezed,Object? jobName = freezed,}) {
  return _then(_self.copyWith(
items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Item>?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobName: freezed == jobName ? _self.jobName : jobName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobRegisterModel].
extension JobRegisterModelPatterns on JobRegisterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobRegisterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobRegisterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobRegisterModel value)  $default,){
final _that = this;
switch (_that) {
case _JobRegisterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobRegisterModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobRegisterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Item>? items,  String? jobId,  String? jobName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobRegisterModel() when $default != null:
return $default(_that.items,_that.jobId,_that.jobName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Item>? items,  String? jobId,  String? jobName)  $default,) {final _that = this;
switch (_that) {
case _JobRegisterModel():
return $default(_that.items,_that.jobId,_that.jobName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Item>? items,  String? jobId,  String? jobName)?  $default,) {final _that = this;
switch (_that) {
case _JobRegisterModel() when $default != null:
return $default(_that.items,_that.jobId,_that.jobName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobRegisterModel implements JobRegisterModel {
  const _JobRegisterModel({final  List<Item>? items, this.jobId, this.jobName}): _items = items;
  factory _JobRegisterModel.fromJson(Map<String, dynamic> json) => _$JobRegisterModelFromJson(json);

 final  List<Item>? _items;
@override List<Item>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? jobId;
@override final  String? jobName;

/// Create a copy of JobRegisterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobRegisterModelCopyWith<_JobRegisterModel> get copyWith => __$JobRegisterModelCopyWithImpl<_JobRegisterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobRegisterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobRegisterModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobName, jobName) || other.jobName == jobName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),jobId,jobName);

@override
String toString() {
  return 'JobRegisterModel(items: $items, jobId: $jobId, jobName: $jobName)';
}


}

/// @nodoc
abstract mixin class _$JobRegisterModelCopyWith<$Res> implements $JobRegisterModelCopyWith<$Res> {
  factory _$JobRegisterModelCopyWith(_JobRegisterModel value, $Res Function(_JobRegisterModel) _then) = __$JobRegisterModelCopyWithImpl;
@override @useResult
$Res call({
 List<Item>? items, String? jobId, String? jobName
});




}
/// @nodoc
class __$JobRegisterModelCopyWithImpl<$Res>
    implements _$JobRegisterModelCopyWith<$Res> {
  __$JobRegisterModelCopyWithImpl(this._self, this._then);

  final _JobRegisterModel _self;
  final $Res Function(_JobRegisterModel) _then;

/// Create a copy of JobRegisterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = freezed,Object? jobId = freezed,Object? jobName = freezed,}) {
  return _then(_JobRegisterModel(
items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobName: freezed == jobName ? _self.jobName : jobName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
