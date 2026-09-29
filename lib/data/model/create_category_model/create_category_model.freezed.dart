// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateCategoryModel {

 Data? get data; String? get message; bool? get success;
/// Create a copy of CreateCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCategoryModelCopyWith<CreateCategoryModel> get copyWith => _$CreateCategoryModelCopyWithImpl<CreateCategoryModel>(this as CreateCategoryModel, _$identity);

  /// Serializes this CreateCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCategoryModel&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,message,success);

@override
String toString() {
  return 'CreateCategoryModel(data: $data, message: $message, success: $success)';
}


}

/// @nodoc
abstract mixin class $CreateCategoryModelCopyWith<$Res>  {
  factory $CreateCategoryModelCopyWith(CreateCategoryModel value, $Res Function(CreateCategoryModel) _then) = _$CreateCategoryModelCopyWithImpl;
@useResult
$Res call({
 Data? data, String? message, bool? success
});


$DataCopyWith<$Res>? get data;

}
/// @nodoc
class _$CreateCategoryModelCopyWithImpl<$Res>
    implements $CreateCategoryModelCopyWith<$Res> {
  _$CreateCategoryModelCopyWithImpl(this._self, this._then);

  final CreateCategoryModel _self;
  final $Res Function(CreateCategoryModel) _then;

/// Create a copy of CreateCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? message = freezed,Object? success = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Data?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of CreateCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateCategoryModel].
extension CreateCategoryModelPatterns on CreateCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CreateCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Data? data,  String? message,  bool? success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCategoryModel() when $default != null:
return $default(_that.data,_that.message,_that.success);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Data? data,  String? message,  bool? success)  $default,) {final _that = this;
switch (_that) {
case _CreateCategoryModel():
return $default(_that.data,_that.message,_that.success);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Data? data,  String? message,  bool? success)?  $default,) {final _that = this;
switch (_that) {
case _CreateCategoryModel() when $default != null:
return $default(_that.data,_that.message,_that.success);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCategoryModel extends CreateCategoryModel {
  const _CreateCategoryModel({this.data, this.message, this.success}): super._();
  factory _CreateCategoryModel.fromJson(Map<String, dynamic> json) => _$CreateCategoryModelFromJson(json);

@override final  Data? data;
@override final  String? message;
@override final  bool? success;

/// Create a copy of CreateCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCategoryModelCopyWith<_CreateCategoryModel> get copyWith => __$CreateCategoryModelCopyWithImpl<_CreateCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCategoryModel&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,message,success);

@override
String toString() {
  return 'CreateCategoryModel(data: $data, message: $message, success: $success)';
}


}

/// @nodoc
abstract mixin class _$CreateCategoryModelCopyWith<$Res> implements $CreateCategoryModelCopyWith<$Res> {
  factory _$CreateCategoryModelCopyWith(_CreateCategoryModel value, $Res Function(_CreateCategoryModel) _then) = __$CreateCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 Data? data, String? message, bool? success
});


@override $DataCopyWith<$Res>? get data;

}
/// @nodoc
class __$CreateCategoryModelCopyWithImpl<$Res>
    implements _$CreateCategoryModelCopyWith<$Res> {
  __$CreateCategoryModelCopyWithImpl(this._self, this._then);

  final _CreateCategoryModel _self;
  final $Res Function(_CreateCategoryModel) _then;

/// Create a copy of CreateCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? message = freezed,Object? success = freezed,}) {
  return _then(_CreateCategoryModel(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Data?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of CreateCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$Data {

 String? get categoryId; dynamic get parentId; String? get categoryName; String? get categoryCode; String? get description; String? get descriptionTemplate; int? get replacementPeriod; String? get instructions; String? get notes; bool? get canHaveChildItems; bool? get isWithdrawn; DateTime? get createdAt; DateTime? get updatedAt; String? get regulationId; String? get checklistId; String? get plannedMaintenanceId;
/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataCopyWith<Data> get copyWith => _$DataCopyWithImpl<Data>(this as Data, _$identity);

  /// Serializes this Data to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Data&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.parentId, parentId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionTemplate, descriptionTemplate) || other.descriptionTemplate == descriptionTemplate)&&(identical(other.replacementPeriod, replacementPeriod) || other.replacementPeriod == replacementPeriod)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.canHaveChildItems, canHaveChildItems) || other.canHaveChildItems == canHaveChildItems)&&(identical(other.isWithdrawn, isWithdrawn) || other.isWithdrawn == isWithdrawn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.regulationId, regulationId) || other.regulationId == regulationId)&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.plannedMaintenanceId, plannedMaintenanceId) || other.plannedMaintenanceId == plannedMaintenanceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,const DeepCollectionEquality().hash(parentId),categoryName,categoryCode,description,descriptionTemplate,replacementPeriod,instructions,notes,canHaveChildItems,isWithdrawn,createdAt,updatedAt,regulationId,checklistId,plannedMaintenanceId);

@override
String toString() {
  return 'Data(categoryId: $categoryId, parentId: $parentId, categoryName: $categoryName, categoryCode: $categoryCode, description: $description, descriptionTemplate: $descriptionTemplate, replacementPeriod: $replacementPeriod, instructions: $instructions, notes: $notes, canHaveChildItems: $canHaveChildItems, isWithdrawn: $isWithdrawn, createdAt: $createdAt, updatedAt: $updatedAt, regulationId: $regulationId, checklistId: $checklistId, plannedMaintenanceId: $plannedMaintenanceId)';
}


}

/// @nodoc
abstract mixin class $DataCopyWith<$Res>  {
  factory $DataCopyWith(Data value, $Res Function(Data) _then) = _$DataCopyWithImpl;
@useResult
$Res call({
 String? categoryId, dynamic parentId, String? categoryName, String? categoryCode, String? description, String? descriptionTemplate, int? replacementPeriod, String? instructions, String? notes, bool? canHaveChildItems, bool? isWithdrawn, DateTime? createdAt, DateTime? updatedAt, String? regulationId, String? checklistId, String? plannedMaintenanceId
});




}
/// @nodoc
class _$DataCopyWithImpl<$Res>
    implements $DataCopyWith<$Res> {
  _$DataCopyWithImpl(this._self, this._then);

  final Data _self;
  final $Res Function(Data) _then;

/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? parentId = freezed,Object? categoryName = freezed,Object? categoryCode = freezed,Object? description = freezed,Object? descriptionTemplate = freezed,Object? replacementPeriod = freezed,Object? instructions = freezed,Object? notes = freezed,Object? canHaveChildItems = freezed,Object? isWithdrawn = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? regulationId = freezed,Object? checklistId = freezed,Object? plannedMaintenanceId = freezed,}) {
  return _then(_self.copyWith(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as dynamic,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categoryCode: freezed == categoryCode ? _self.categoryCode : categoryCode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionTemplate: freezed == descriptionTemplate ? _self.descriptionTemplate : descriptionTemplate // ignore: cast_nullable_to_non_nullable
as String?,replacementPeriod: freezed == replacementPeriod ? _self.replacementPeriod : replacementPeriod // ignore: cast_nullable_to_non_nullable
as int?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,canHaveChildItems: freezed == canHaveChildItems ? _self.canHaveChildItems : canHaveChildItems // ignore: cast_nullable_to_non_nullable
as bool?,isWithdrawn: freezed == isWithdrawn ? _self.isWithdrawn : isWithdrawn // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,regulationId: freezed == regulationId ? _self.regulationId : regulationId // ignore: cast_nullable_to_non_nullable
as String?,checklistId: freezed == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String?,plannedMaintenanceId: freezed == plannedMaintenanceId ? _self.plannedMaintenanceId : plannedMaintenanceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Data].
extension DataPatterns on Data {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Data value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Data() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Data value)  $default,){
final _that = this;
switch (_that) {
case _Data():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Data value)?  $default,){
final _that = this;
switch (_that) {
case _Data() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? categoryId,  dynamic parentId,  String? categoryName,  String? categoryCode,  String? description,  String? descriptionTemplate,  int? replacementPeriod,  String? instructions,  String? notes,  bool? canHaveChildItems,  bool? isWithdrawn,  DateTime? createdAt,  DateTime? updatedAt,  String? regulationId,  String? checklistId,  String? plannedMaintenanceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Data() when $default != null:
return $default(_that.categoryId,_that.parentId,_that.categoryName,_that.categoryCode,_that.description,_that.descriptionTemplate,_that.replacementPeriod,_that.instructions,_that.notes,_that.canHaveChildItems,_that.isWithdrawn,_that.createdAt,_that.updatedAt,_that.regulationId,_that.checklistId,_that.plannedMaintenanceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? categoryId,  dynamic parentId,  String? categoryName,  String? categoryCode,  String? description,  String? descriptionTemplate,  int? replacementPeriod,  String? instructions,  String? notes,  bool? canHaveChildItems,  bool? isWithdrawn,  DateTime? createdAt,  DateTime? updatedAt,  String? regulationId,  String? checklistId,  String? plannedMaintenanceId)  $default,) {final _that = this;
switch (_that) {
case _Data():
return $default(_that.categoryId,_that.parentId,_that.categoryName,_that.categoryCode,_that.description,_that.descriptionTemplate,_that.replacementPeriod,_that.instructions,_that.notes,_that.canHaveChildItems,_that.isWithdrawn,_that.createdAt,_that.updatedAt,_that.regulationId,_that.checklistId,_that.plannedMaintenanceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? categoryId,  dynamic parentId,  String? categoryName,  String? categoryCode,  String? description,  String? descriptionTemplate,  int? replacementPeriod,  String? instructions,  String? notes,  bool? canHaveChildItems,  bool? isWithdrawn,  DateTime? createdAt,  DateTime? updatedAt,  String? regulationId,  String? checklistId,  String? plannedMaintenanceId)?  $default,) {final _that = this;
switch (_that) {
case _Data() when $default != null:
return $default(_that.categoryId,_that.parentId,_that.categoryName,_that.categoryCode,_that.description,_that.descriptionTemplate,_that.replacementPeriod,_that.instructions,_that.notes,_that.canHaveChildItems,_that.isWithdrawn,_that.createdAt,_that.updatedAt,_that.regulationId,_that.checklistId,_that.plannedMaintenanceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Data extends Data {
  const _Data({this.categoryId, this.parentId, this.categoryName, this.categoryCode, this.description, this.descriptionTemplate, this.replacementPeriod, this.instructions, this.notes, this.canHaveChildItems, this.isWithdrawn, this.createdAt, this.updatedAt, this.regulationId, this.checklistId, this.plannedMaintenanceId}): super._();
  factory _Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

@override final  String? categoryId;
@override final  dynamic parentId;
@override final  String? categoryName;
@override final  String? categoryCode;
@override final  String? description;
@override final  String? descriptionTemplate;
@override final  int? replacementPeriod;
@override final  String? instructions;
@override final  String? notes;
@override final  bool? canHaveChildItems;
@override final  bool? isWithdrawn;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? regulationId;
@override final  String? checklistId;
@override final  String? plannedMaintenanceId;

/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataCopyWith<_Data> get copyWith => __$DataCopyWithImpl<_Data>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Data&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.parentId, parentId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionTemplate, descriptionTemplate) || other.descriptionTemplate == descriptionTemplate)&&(identical(other.replacementPeriod, replacementPeriod) || other.replacementPeriod == replacementPeriod)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.canHaveChildItems, canHaveChildItems) || other.canHaveChildItems == canHaveChildItems)&&(identical(other.isWithdrawn, isWithdrawn) || other.isWithdrawn == isWithdrawn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.regulationId, regulationId) || other.regulationId == regulationId)&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.plannedMaintenanceId, plannedMaintenanceId) || other.plannedMaintenanceId == plannedMaintenanceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,const DeepCollectionEquality().hash(parentId),categoryName,categoryCode,description,descriptionTemplate,replacementPeriod,instructions,notes,canHaveChildItems,isWithdrawn,createdAt,updatedAt,regulationId,checklistId,plannedMaintenanceId);

@override
String toString() {
  return 'Data(categoryId: $categoryId, parentId: $parentId, categoryName: $categoryName, categoryCode: $categoryCode, description: $description, descriptionTemplate: $descriptionTemplate, replacementPeriod: $replacementPeriod, instructions: $instructions, notes: $notes, canHaveChildItems: $canHaveChildItems, isWithdrawn: $isWithdrawn, createdAt: $createdAt, updatedAt: $updatedAt, regulationId: $regulationId, checklistId: $checklistId, plannedMaintenanceId: $plannedMaintenanceId)';
}


}

/// @nodoc
abstract mixin class _$DataCopyWith<$Res> implements $DataCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) _then) = __$DataCopyWithImpl;
@override @useResult
$Res call({
 String? categoryId, dynamic parentId, String? categoryName, String? categoryCode, String? description, String? descriptionTemplate, int? replacementPeriod, String? instructions, String? notes, bool? canHaveChildItems, bool? isWithdrawn, DateTime? createdAt, DateTime? updatedAt, String? regulationId, String? checklistId, String? plannedMaintenanceId
});




}
/// @nodoc
class __$DataCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(this._self, this._then);

  final _Data _self;
  final $Res Function(_Data) _then;

/// Create a copy of Data
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? parentId = freezed,Object? categoryName = freezed,Object? categoryCode = freezed,Object? description = freezed,Object? descriptionTemplate = freezed,Object? replacementPeriod = freezed,Object? instructions = freezed,Object? notes = freezed,Object? canHaveChildItems = freezed,Object? isWithdrawn = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? regulationId = freezed,Object? checklistId = freezed,Object? plannedMaintenanceId = freezed,}) {
  return _then(_Data(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as dynamic,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,categoryCode: freezed == categoryCode ? _self.categoryCode : categoryCode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionTemplate: freezed == descriptionTemplate ? _self.descriptionTemplate : descriptionTemplate // ignore: cast_nullable_to_non_nullable
as String?,replacementPeriod: freezed == replacementPeriod ? _self.replacementPeriod : replacementPeriod // ignore: cast_nullable_to_non_nullable
as int?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,canHaveChildItems: freezed == canHaveChildItems ? _self.canHaveChildItems : canHaveChildItems // ignore: cast_nullable_to_non_nullable
as bool?,isWithdrawn: freezed == isWithdrawn ? _self.isWithdrawn : isWithdrawn // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,regulationId: freezed == regulationId ? _self.regulationId : regulationId // ignore: cast_nullable_to_non_nullable
as String?,checklistId: freezed == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String?,plannedMaintenanceId: freezed == plannedMaintenanceId ? _self.plannedMaintenanceId : plannedMaintenanceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
