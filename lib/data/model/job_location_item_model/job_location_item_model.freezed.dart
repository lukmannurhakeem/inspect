// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_location_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobLocationItemModel {

 int? get count; List<JobLocationItem>? get items;
/// Create a copy of JobLocationItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobLocationItemModelCopyWith<JobLocationItemModel> get copyWith => _$JobLocationItemModelCopyWithImpl<JobLocationItemModel>(this as JobLocationItemModel, _$identity);

  /// Serializes this JobLocationItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobLocationItemModel&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'JobLocationItemModel(count: $count, items: $items)';
}


}

/// @nodoc
abstract mixin class $JobLocationItemModelCopyWith<$Res>  {
  factory $JobLocationItemModelCopyWith(JobLocationItemModel value, $Res Function(JobLocationItemModel) _then) = _$JobLocationItemModelCopyWithImpl;
@useResult
$Res call({
 int? count, List<JobLocationItem>? items
});




}
/// @nodoc
class _$JobLocationItemModelCopyWithImpl<$Res>
    implements $JobLocationItemModelCopyWith<$Res> {
  _$JobLocationItemModelCopyWithImpl(this._self, this._then);

  final JobLocationItemModel _self;
  final $Res Function(JobLocationItemModel) _then;

/// Create a copy of JobLocationItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = freezed,Object? items = freezed,}) {
  return _then(_self.copyWith(
count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<JobLocationItem>?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobLocationItemModel].
extension JobLocationItemModelPatterns on JobLocationItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobLocationItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobLocationItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobLocationItemModel value)  $default,){
final _that = this;
switch (_that) {
case _JobLocationItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobLocationItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobLocationItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? count,  List<JobLocationItem>? items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobLocationItemModel() when $default != null:
return $default(_that.count,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? count,  List<JobLocationItem>? items)  $default,) {final _that = this;
switch (_that) {
case _JobLocationItemModel():
return $default(_that.count,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? count,  List<JobLocationItem>? items)?  $default,) {final _that = this;
switch (_that) {
case _JobLocationItemModel() when $default != null:
return $default(_that.count,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobLocationItemModel implements JobLocationItemModel {
  const _JobLocationItemModel({this.count, final  List<JobLocationItem>? items}): _items = items;
  factory _JobLocationItemModel.fromJson(Map<String, dynamic> json) => _$JobLocationItemModelFromJson(json);

@override final  int? count;
 final  List<JobLocationItem>? _items;
@override List<JobLocationItem>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of JobLocationItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobLocationItemModelCopyWith<_JobLocationItemModel> get copyWith => __$JobLocationItemModelCopyWithImpl<_JobLocationItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobLocationItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobLocationItemModel&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'JobLocationItemModel(count: $count, items: $items)';
}


}

/// @nodoc
abstract mixin class _$JobLocationItemModelCopyWith<$Res> implements $JobLocationItemModelCopyWith<$Res> {
  factory _$JobLocationItemModelCopyWith(_JobLocationItemModel value, $Res Function(_JobLocationItemModel) _then) = __$JobLocationItemModelCopyWithImpl;
@override @useResult
$Res call({
 int? count, List<JobLocationItem>? items
});




}
/// @nodoc
class __$JobLocationItemModelCopyWithImpl<$Res>
    implements _$JobLocationItemModelCopyWith<$Res> {
  __$JobLocationItemModelCopyWithImpl(this._self, this._then);

  final _JobLocationItemModel _self;
  final $Res Function(_JobLocationItemModel) _then;

/// Create a copy of JobLocationItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = freezed,Object? items = freezed,}) {
  return _then(_JobLocationItemModel(
count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<JobLocationItem>?,
  ));
}


}


/// @nodoc
mixin _$JobLocationItem {

@JsonKey(name: 'locationID') String? get locationId;@JsonKey(name: 'itemID') String? get itemId; String? get name; String? get code;@JsonKey(name: 'parentID') String? get parentId;
/// Create a copy of JobLocationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobLocationItemCopyWith<JobLocationItem> get copyWith => _$JobLocationItemCopyWithImpl<JobLocationItem>(this as JobLocationItem, _$identity);

  /// Serializes this JobLocationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobLocationItem&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locationId,itemId,name,code,parentId);

@override
String toString() {
  return 'JobLocationItem(locationId: $locationId, itemId: $itemId, name: $name, code: $code, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class $JobLocationItemCopyWith<$Res>  {
  factory $JobLocationItemCopyWith(JobLocationItem value, $Res Function(JobLocationItem) _then) = _$JobLocationItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'locationID') String? locationId,@JsonKey(name: 'itemID') String? itemId, String? name, String? code,@JsonKey(name: 'parentID') String? parentId
});




}
/// @nodoc
class _$JobLocationItemCopyWithImpl<$Res>
    implements $JobLocationItemCopyWith<$Res> {
  _$JobLocationItemCopyWithImpl(this._self, this._then);

  final JobLocationItem _self;
  final $Res Function(JobLocationItem) _then;

/// Create a copy of JobLocationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locationId = freezed,Object? itemId = freezed,Object? name = freezed,Object? code = freezed,Object? parentId = freezed,}) {
  return _then(_self.copyWith(
locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobLocationItem].
extension JobLocationItemPatterns on JobLocationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobLocationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobLocationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobLocationItem value)  $default,){
final _that = this;
switch (_that) {
case _JobLocationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobLocationItem value)?  $default,){
final _that = this;
switch (_that) {
case _JobLocationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'locationID')  String? locationId, @JsonKey(name: 'itemID')  String? itemId,  String? name,  String? code, @JsonKey(name: 'parentID')  String? parentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobLocationItem() when $default != null:
return $default(_that.locationId,_that.itemId,_that.name,_that.code,_that.parentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'locationID')  String? locationId, @JsonKey(name: 'itemID')  String? itemId,  String? name,  String? code, @JsonKey(name: 'parentID')  String? parentId)  $default,) {final _that = this;
switch (_that) {
case _JobLocationItem():
return $default(_that.locationId,_that.itemId,_that.name,_that.code,_that.parentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'locationID')  String? locationId, @JsonKey(name: 'itemID')  String? itemId,  String? name,  String? code, @JsonKey(name: 'parentID')  String? parentId)?  $default,) {final _that = this;
switch (_that) {
case _JobLocationItem() when $default != null:
return $default(_that.locationId,_that.itemId,_that.name,_that.code,_that.parentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobLocationItem extends JobLocationItem {
  const _JobLocationItem({@JsonKey(name: 'locationID') this.locationId, @JsonKey(name: 'itemID') this.itemId, this.name, this.code, @JsonKey(name: 'parentID') this.parentId}): super._();
  factory _JobLocationItem.fromJson(Map<String, dynamic> json) => _$JobLocationItemFromJson(json);

@override@JsonKey(name: 'locationID') final  String? locationId;
@override@JsonKey(name: 'itemID') final  String? itemId;
@override final  String? name;
@override final  String? code;
@override@JsonKey(name: 'parentID') final  String? parentId;

/// Create a copy of JobLocationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobLocationItemCopyWith<_JobLocationItem> get copyWith => __$JobLocationItemCopyWithImpl<_JobLocationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobLocationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobLocationItem&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locationId,itemId,name,code,parentId);

@override
String toString() {
  return 'JobLocationItem(locationId: $locationId, itemId: $itemId, name: $name, code: $code, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class _$JobLocationItemCopyWith<$Res> implements $JobLocationItemCopyWith<$Res> {
  factory _$JobLocationItemCopyWith(_JobLocationItem value, $Res Function(_JobLocationItem) _then) = __$JobLocationItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'locationID') String? locationId,@JsonKey(name: 'itemID') String? itemId, String? name, String? code,@JsonKey(name: 'parentID') String? parentId
});




}
/// @nodoc
class __$JobLocationItemCopyWithImpl<$Res>
    implements _$JobLocationItemCopyWith<$Res> {
  __$JobLocationItemCopyWithImpl(this._self, this._then);

  final _JobLocationItem _self;
  final $Res Function(_JobLocationItem) _then;

/// Create a copy of JobLocationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationId = freezed,Object? itemId = freezed,Object? name = freezed,Object? code = freezed,Object? parentId = freezed,}) {
  return _then(_JobLocationItem(
locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
