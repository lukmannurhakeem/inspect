// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetCategoryModel {

 List<Category> get data; String? get message; Pagination? get pagination; bool? get success;
/// Create a copy of GetCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCategoryModelCopyWith<GetCategoryModel> get copyWith => _$GetCategoryModelCopyWithImpl<GetCategoryModel>(this as GetCategoryModel, _$identity);

  /// Serializes this GetCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCategoryModel&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message)&&(identical(other.pagination, pagination) || other.pagination == pagination)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),message,pagination,success);

@override
String toString() {
  return 'GetCategoryModel(data: $data, message: $message, pagination: $pagination, success: $success)';
}


}

/// @nodoc
abstract mixin class $GetCategoryModelCopyWith<$Res>  {
  factory $GetCategoryModelCopyWith(GetCategoryModel value, $Res Function(GetCategoryModel) _then) = _$GetCategoryModelCopyWithImpl;
@useResult
$Res call({
 List<Category> data, String? message, Pagination? pagination, bool? success
});


$PaginationCopyWith<$Res>? get pagination;

}
/// @nodoc
class _$GetCategoryModelCopyWithImpl<$Res>
    implements $GetCategoryModelCopyWith<$Res> {
  _$GetCategoryModelCopyWithImpl(this._self, this._then);

  final GetCategoryModel _self;
  final $Res Function(GetCategoryModel) _then;

/// Create a copy of GetCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? message = freezed,Object? pagination = freezed,Object? success = freezed,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Category>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as Pagination?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of GetCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [GetCategoryModel].
extension GetCategoryModelPatterns on GetCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _GetCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Category> data,  String? message,  Pagination? pagination,  bool? success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetCategoryModel() when $default != null:
return $default(_that.data,_that.message,_that.pagination,_that.success);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Category> data,  String? message,  Pagination? pagination,  bool? success)  $default,) {final _that = this;
switch (_that) {
case _GetCategoryModel():
return $default(_that.data,_that.message,_that.pagination,_that.success);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Category> data,  String? message,  Pagination? pagination,  bool? success)?  $default,) {final _that = this;
switch (_that) {
case _GetCategoryModel() when $default != null:
return $default(_that.data,_that.message,_that.pagination,_that.success);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetCategoryModel implements GetCategoryModel {
  const _GetCategoryModel({final  List<Category> data = const [], this.message, this.pagination, this.success}): _data = data;
  factory _GetCategoryModel.fromJson(Map<String, dynamic> json) => _$GetCategoryModelFromJson(json);

 final  List<Category> _data;
@override@JsonKey() List<Category> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  String? message;
@override final  Pagination? pagination;
@override final  bool? success;

/// Create a copy of GetCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetCategoryModelCopyWith<_GetCategoryModel> get copyWith => __$GetCategoryModelCopyWithImpl<_GetCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCategoryModel&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message)&&(identical(other.pagination, pagination) || other.pagination == pagination)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),message,pagination,success);

@override
String toString() {
  return 'GetCategoryModel(data: $data, message: $message, pagination: $pagination, success: $success)';
}


}

/// @nodoc
abstract mixin class _$GetCategoryModelCopyWith<$Res> implements $GetCategoryModelCopyWith<$Res> {
  factory _$GetCategoryModelCopyWith(_GetCategoryModel value, $Res Function(_GetCategoryModel) _then) = __$GetCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 List<Category> data, String? message, Pagination? pagination, bool? success
});


@override $PaginationCopyWith<$Res>? get pagination;

}
/// @nodoc
class __$GetCategoryModelCopyWithImpl<$Res>
    implements _$GetCategoryModelCopyWith<$Res> {
  __$GetCategoryModelCopyWithImpl(this._self, this._then);

  final _GetCategoryModel _self;
  final $Res Function(_GetCategoryModel) _then;

/// Create a copy of GetCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? message = freezed,Object? pagination = freezed,Object? success = freezed,}) {
  return _then(_GetCategoryModel(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Category>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as Pagination?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of GetCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$Category {

 String? get categoryId; dynamic get parentId; String? get categoryName; String? get categoryCode; String? get description; String? get descriptionTemplate; int? get replacementPeriod; String? get instructions; String? get notes; bool? get canHaveChildItems; bool? get isWithdrawn; DateTime? get createdAt; DateTime? get updatedAt; String? get siteId; String? get regulationId; String? get checklistId; String? get plannedMaintenanceId;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.parentId, parentId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionTemplate, descriptionTemplate) || other.descriptionTemplate == descriptionTemplate)&&(identical(other.replacementPeriod, replacementPeriod) || other.replacementPeriod == replacementPeriod)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.canHaveChildItems, canHaveChildItems) || other.canHaveChildItems == canHaveChildItems)&&(identical(other.isWithdrawn, isWithdrawn) || other.isWithdrawn == isWithdrawn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.regulationId, regulationId) || other.regulationId == regulationId)&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.plannedMaintenanceId, plannedMaintenanceId) || other.plannedMaintenanceId == plannedMaintenanceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,const DeepCollectionEquality().hash(parentId),categoryName,categoryCode,description,descriptionTemplate,replacementPeriod,instructions,notes,canHaveChildItems,isWithdrawn,createdAt,updatedAt,siteId,regulationId,checklistId,plannedMaintenanceId);

@override
String toString() {
  return 'Category(categoryId: $categoryId, parentId: $parentId, categoryName: $categoryName, categoryCode: $categoryCode, description: $description, descriptionTemplate: $descriptionTemplate, replacementPeriod: $replacementPeriod, instructions: $instructions, notes: $notes, canHaveChildItems: $canHaveChildItems, isWithdrawn: $isWithdrawn, createdAt: $createdAt, updatedAt: $updatedAt, siteId: $siteId, regulationId: $regulationId, checklistId: $checklistId, plannedMaintenanceId: $plannedMaintenanceId)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String? categoryId, dynamic parentId, String? categoryName, String? categoryCode, String? description, String? descriptionTemplate, int? replacementPeriod, String? instructions, String? notes, bool? canHaveChildItems, bool? isWithdrawn, DateTime? createdAt, DateTime? updatedAt, String? siteId, String? regulationId, String? checklistId, String? plannedMaintenanceId
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? parentId = freezed,Object? categoryName = freezed,Object? categoryCode = freezed,Object? description = freezed,Object? descriptionTemplate = freezed,Object? replacementPeriod = freezed,Object? instructions = freezed,Object? notes = freezed,Object? canHaveChildItems = freezed,Object? isWithdrawn = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? siteId = freezed,Object? regulationId = freezed,Object? checklistId = freezed,Object? plannedMaintenanceId = freezed,}) {
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
as DateTime?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,regulationId: freezed == regulationId ? _self.regulationId : regulationId // ignore: cast_nullable_to_non_nullable
as String?,checklistId: freezed == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String?,plannedMaintenanceId: freezed == plannedMaintenanceId ? _self.plannedMaintenanceId : plannedMaintenanceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? categoryId,  dynamic parentId,  String? categoryName,  String? categoryCode,  String? description,  String? descriptionTemplate,  int? replacementPeriod,  String? instructions,  String? notes,  bool? canHaveChildItems,  bool? isWithdrawn,  DateTime? createdAt,  DateTime? updatedAt,  String? siteId,  String? regulationId,  String? checklistId,  String? plannedMaintenanceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.categoryId,_that.parentId,_that.categoryName,_that.categoryCode,_that.description,_that.descriptionTemplate,_that.replacementPeriod,_that.instructions,_that.notes,_that.canHaveChildItems,_that.isWithdrawn,_that.createdAt,_that.updatedAt,_that.siteId,_that.regulationId,_that.checklistId,_that.plannedMaintenanceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? categoryId,  dynamic parentId,  String? categoryName,  String? categoryCode,  String? description,  String? descriptionTemplate,  int? replacementPeriod,  String? instructions,  String? notes,  bool? canHaveChildItems,  bool? isWithdrawn,  DateTime? createdAt,  DateTime? updatedAt,  String? siteId,  String? regulationId,  String? checklistId,  String? plannedMaintenanceId)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.categoryId,_that.parentId,_that.categoryName,_that.categoryCode,_that.description,_that.descriptionTemplate,_that.replacementPeriod,_that.instructions,_that.notes,_that.canHaveChildItems,_that.isWithdrawn,_that.createdAt,_that.updatedAt,_that.siteId,_that.regulationId,_that.checklistId,_that.plannedMaintenanceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? categoryId,  dynamic parentId,  String? categoryName,  String? categoryCode,  String? description,  String? descriptionTemplate,  int? replacementPeriod,  String? instructions,  String? notes,  bool? canHaveChildItems,  bool? isWithdrawn,  DateTime? createdAt,  DateTime? updatedAt,  String? siteId,  String? regulationId,  String? checklistId,  String? plannedMaintenanceId)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.categoryId,_that.parentId,_that.categoryName,_that.categoryCode,_that.description,_that.descriptionTemplate,_that.replacementPeriod,_that.instructions,_that.notes,_that.canHaveChildItems,_that.isWithdrawn,_that.createdAt,_that.updatedAt,_that.siteId,_that.regulationId,_that.checklistId,_that.plannedMaintenanceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({this.categoryId, this.parentId, this.categoryName, this.categoryCode, this.description, this.descriptionTemplate, this.replacementPeriod, this.instructions, this.notes, this.canHaveChildItems, this.isWithdrawn, this.createdAt, this.updatedAt, this.siteId, this.regulationId, this.checklistId, this.plannedMaintenanceId});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

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
@override final  String? siteId;
@override final  String? regulationId;
@override final  String? checklistId;
@override final  String? plannedMaintenanceId;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.parentId, parentId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryCode, categoryCode) || other.categoryCode == categoryCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionTemplate, descriptionTemplate) || other.descriptionTemplate == descriptionTemplate)&&(identical(other.replacementPeriod, replacementPeriod) || other.replacementPeriod == replacementPeriod)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.canHaveChildItems, canHaveChildItems) || other.canHaveChildItems == canHaveChildItems)&&(identical(other.isWithdrawn, isWithdrawn) || other.isWithdrawn == isWithdrawn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.siteId, siteId) || other.siteId == siteId)&&(identical(other.regulationId, regulationId) || other.regulationId == regulationId)&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.plannedMaintenanceId, plannedMaintenanceId) || other.plannedMaintenanceId == plannedMaintenanceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,const DeepCollectionEquality().hash(parentId),categoryName,categoryCode,description,descriptionTemplate,replacementPeriod,instructions,notes,canHaveChildItems,isWithdrawn,createdAt,updatedAt,siteId,regulationId,checklistId,plannedMaintenanceId);

@override
String toString() {
  return 'Category(categoryId: $categoryId, parentId: $parentId, categoryName: $categoryName, categoryCode: $categoryCode, description: $description, descriptionTemplate: $descriptionTemplate, replacementPeriod: $replacementPeriod, instructions: $instructions, notes: $notes, canHaveChildItems: $canHaveChildItems, isWithdrawn: $isWithdrawn, createdAt: $createdAt, updatedAt: $updatedAt, siteId: $siteId, regulationId: $regulationId, checklistId: $checklistId, plannedMaintenanceId: $plannedMaintenanceId)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String? categoryId, dynamic parentId, String? categoryName, String? categoryCode, String? description, String? descriptionTemplate, int? replacementPeriod, String? instructions, String? notes, bool? canHaveChildItems, bool? isWithdrawn, DateTime? createdAt, DateTime? updatedAt, String? siteId, String? regulationId, String? checklistId, String? plannedMaintenanceId
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? parentId = freezed,Object? categoryName = freezed,Object? categoryCode = freezed,Object? description = freezed,Object? descriptionTemplate = freezed,Object? replacementPeriod = freezed,Object? instructions = freezed,Object? notes = freezed,Object? canHaveChildItems = freezed,Object? isWithdrawn = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? siteId = freezed,Object? regulationId = freezed,Object? checklistId = freezed,Object? plannedMaintenanceId = freezed,}) {
  return _then(_Category(
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
as DateTime?,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as String?,regulationId: freezed == regulationId ? _self.regulationId : regulationId // ignore: cast_nullable_to_non_nullable
as String?,checklistId: freezed == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String?,plannedMaintenanceId: freezed == plannedMaintenanceId ? _self.plannedMaintenanceId : plannedMaintenanceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Pagination {

 int? get count; int? get limit; int? get offset; int? get total;
/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationCopyWith<Pagination> get copyWith => _$PaginationCopyWithImpl<Pagination>(this as Pagination, _$identity);

  /// Serializes this Pagination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pagination&&(identical(other.count, count) || other.count == count)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,limit,offset,total);

@override
String toString() {
  return 'Pagination(count: $count, limit: $limit, offset: $offset, total: $total)';
}


}

/// @nodoc
abstract mixin class $PaginationCopyWith<$Res>  {
  factory $PaginationCopyWith(Pagination value, $Res Function(Pagination) _then) = _$PaginationCopyWithImpl;
@useResult
$Res call({
 int? count, int? limit, int? offset, int? total
});




}
/// @nodoc
class _$PaginationCopyWithImpl<$Res>
    implements $PaginationCopyWith<$Res> {
  _$PaginationCopyWithImpl(this._self, this._then);

  final Pagination _self;
  final $Res Function(Pagination) _then;

/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = freezed,Object? limit = freezed,Object? offset = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Pagination].
extension PaginationPatterns on Pagination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pagination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pagination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pagination value)  $default,){
final _that = this;
switch (_that) {
case _Pagination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pagination value)?  $default,){
final _that = this;
switch (_that) {
case _Pagination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? count,  int? limit,  int? offset,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pagination() when $default != null:
return $default(_that.count,_that.limit,_that.offset,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? count,  int? limit,  int? offset,  int? total)  $default,) {final _that = this;
switch (_that) {
case _Pagination():
return $default(_that.count,_that.limit,_that.offset,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? count,  int? limit,  int? offset,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _Pagination() when $default != null:
return $default(_that.count,_that.limit,_that.offset,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pagination implements Pagination {
  const _Pagination({this.count, this.limit, this.offset, this.total});
  factory _Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);

@override final  int? count;
@override final  int? limit;
@override final  int? offset;
@override final  int? total;

/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationCopyWith<_Pagination> get copyWith => __$PaginationCopyWithImpl<_Pagination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pagination&&(identical(other.count, count) || other.count == count)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,limit,offset,total);

@override
String toString() {
  return 'Pagination(count: $count, limit: $limit, offset: $offset, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaginationCopyWith<$Res> implements $PaginationCopyWith<$Res> {
  factory _$PaginationCopyWith(_Pagination value, $Res Function(_Pagination) _then) = __$PaginationCopyWithImpl;
@override @useResult
$Res call({
 int? count, int? limit, int? offset, int? total
});




}
/// @nodoc
class __$PaginationCopyWithImpl<$Res>
    implements _$PaginationCopyWith<$Res> {
  __$PaginationCopyWithImpl(this._self, this._then);

  final _Pagination _self;
  final $Res Function(_Pagination) _then;

/// Create a copy of Pagination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = freezed,Object? limit = freezed,Object? offset = freezed,Object? total = freezed,}) {
  return _then(_Pagination(
count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
