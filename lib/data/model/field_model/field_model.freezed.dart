// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FieldModel {

 String get id; String get labelText; String get name; String get fieldType; String get defaultValue; bool get isReadOnly; String get section; bool get required; bool get isArchived; Map<String, String> get permissions;// Additional properties for different field types
 List<String>? get dropdownOptions; String? get fileExtension; String? get conditionalSource; String? get conditionalOperator; String? get conditionalValue; double? get minValue; double? get maxValue; double? get stepValue; int? get decimalPlaces;
/// Create a copy of FieldModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldModelCopyWith<FieldModel> get copyWith => _$FieldModelCopyWithImpl<FieldModel>(this as FieldModel, _$identity);

  /// Serializes this FieldModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldModel&&(identical(other.id, id) || other.id == id)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.section, section) || other.section == section)&&(identical(other.required, required) || other.required == required)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&const DeepCollectionEquality().equals(other.dropdownOptions, dropdownOptions)&&(identical(other.fileExtension, fileExtension) || other.fileExtension == fileExtension)&&(identical(other.conditionalSource, conditionalSource) || other.conditionalSource == conditionalSource)&&(identical(other.conditionalOperator, conditionalOperator) || other.conditionalOperator == conditionalOperator)&&(identical(other.conditionalValue, conditionalValue) || other.conditionalValue == conditionalValue)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.stepValue, stepValue) || other.stepValue == stepValue)&&(identical(other.decimalPlaces, decimalPlaces) || other.decimalPlaces == decimalPlaces));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,labelText,name,fieldType,defaultValue,isReadOnly,section,required,isArchived,const DeepCollectionEquality().hash(permissions),const DeepCollectionEquality().hash(dropdownOptions),fileExtension,conditionalSource,conditionalOperator,conditionalValue,minValue,maxValue,stepValue,decimalPlaces]);

@override
String toString() {
  return 'FieldModel(id: $id, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, isReadOnly: $isReadOnly, section: $section, required: $required, isArchived: $isArchived, permissions: $permissions, dropdownOptions: $dropdownOptions, fileExtension: $fileExtension, conditionalSource: $conditionalSource, conditionalOperator: $conditionalOperator, conditionalValue: $conditionalValue, minValue: $minValue, maxValue: $maxValue, stepValue: $stepValue, decimalPlaces: $decimalPlaces)';
}


}

/// @nodoc
abstract mixin class $FieldModelCopyWith<$Res>  {
  factory $FieldModelCopyWith(FieldModel value, $Res Function(FieldModel) _then) = _$FieldModelCopyWithImpl;
@useResult
$Res call({
 String id, String labelText, String name, String fieldType, String defaultValue, bool isReadOnly, String section, bool required, bool isArchived, Map<String, String> permissions, List<String>? dropdownOptions, String? fileExtension, String? conditionalSource, String? conditionalOperator, String? conditionalValue, double? minValue, double? maxValue, double? stepValue, int? decimalPlaces
});




}
/// @nodoc
class _$FieldModelCopyWithImpl<$Res>
    implements $FieldModelCopyWith<$Res> {
  _$FieldModelCopyWithImpl(this._self, this._then);

  final FieldModel _self;
  final $Res Function(FieldModel) _then;

/// Create a copy of FieldModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? labelText = null,Object? name = null,Object? fieldType = null,Object? defaultValue = null,Object? isReadOnly = null,Object? section = null,Object? required = null,Object? isArchived = null,Object? permissions = null,Object? dropdownOptions = freezed,Object? fileExtension = freezed,Object? conditionalSource = freezed,Object? conditionalOperator = freezed,Object? conditionalValue = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? stepValue = freezed,Object? decimalPlaces = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,labelText: null == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,dropdownOptions: freezed == dropdownOptions ? _self.dropdownOptions : dropdownOptions // ignore: cast_nullable_to_non_nullable
as List<String>?,fileExtension: freezed == fileExtension ? _self.fileExtension : fileExtension // ignore: cast_nullable_to_non_nullable
as String?,conditionalSource: freezed == conditionalSource ? _self.conditionalSource : conditionalSource // ignore: cast_nullable_to_non_nullable
as String?,conditionalOperator: freezed == conditionalOperator ? _self.conditionalOperator : conditionalOperator // ignore: cast_nullable_to_non_nullable
as String?,conditionalValue: freezed == conditionalValue ? _self.conditionalValue : conditionalValue // ignore: cast_nullable_to_non_nullable
as String?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as double?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double?,stepValue: freezed == stepValue ? _self.stepValue : stepValue // ignore: cast_nullable_to_non_nullable
as double?,decimalPlaces: freezed == decimalPlaces ? _self.decimalPlaces : decimalPlaces // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldModel].
extension FieldModelPatterns on FieldModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldModel value)  $default,){
final _that = this;
switch (_that) {
case _FieldModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldModel value)?  $default,){
final _that = this;
switch (_that) {
case _FieldModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String labelText,  String name,  String fieldType,  String defaultValue,  bool isReadOnly,  String section,  bool required,  bool isArchived,  Map<String, String> permissions,  List<String>? dropdownOptions,  String? fileExtension,  String? conditionalSource,  String? conditionalOperator,  String? conditionalValue,  double? minValue,  double? maxValue,  double? stepValue,  int? decimalPlaces)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldModel() when $default != null:
return $default(_that.id,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.isReadOnly,_that.section,_that.required,_that.isArchived,_that.permissions,_that.dropdownOptions,_that.fileExtension,_that.conditionalSource,_that.conditionalOperator,_that.conditionalValue,_that.minValue,_that.maxValue,_that.stepValue,_that.decimalPlaces);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String labelText,  String name,  String fieldType,  String defaultValue,  bool isReadOnly,  String section,  bool required,  bool isArchived,  Map<String, String> permissions,  List<String>? dropdownOptions,  String? fileExtension,  String? conditionalSource,  String? conditionalOperator,  String? conditionalValue,  double? minValue,  double? maxValue,  double? stepValue,  int? decimalPlaces)  $default,) {final _that = this;
switch (_that) {
case _FieldModel():
return $default(_that.id,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.isReadOnly,_that.section,_that.required,_that.isArchived,_that.permissions,_that.dropdownOptions,_that.fileExtension,_that.conditionalSource,_that.conditionalOperator,_that.conditionalValue,_that.minValue,_that.maxValue,_that.stepValue,_that.decimalPlaces);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String labelText,  String name,  String fieldType,  String defaultValue,  bool isReadOnly,  String section,  bool required,  bool isArchived,  Map<String, String> permissions,  List<String>? dropdownOptions,  String? fileExtension,  String? conditionalSource,  String? conditionalOperator,  String? conditionalValue,  double? minValue,  double? maxValue,  double? stepValue,  int? decimalPlaces)?  $default,) {final _that = this;
switch (_that) {
case _FieldModel() when $default != null:
return $default(_that.id,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.isReadOnly,_that.section,_that.required,_that.isArchived,_that.permissions,_that.dropdownOptions,_that.fileExtension,_that.conditionalSource,_that.conditionalOperator,_that.conditionalValue,_that.minValue,_that.maxValue,_that.stepValue,_that.decimalPlaces);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldModel implements FieldModel {
  const _FieldModel({required this.id, required this.labelText, required this.name, required this.fieldType, this.defaultValue = '', this.isReadOnly = false, this.section = '', this.required = false, this.isArchived = false, final  Map<String, String> permissions = const {'create' : 'Any', 'view' : 'Any'}, final  List<String>? dropdownOptions, this.fileExtension, this.conditionalSource, this.conditionalOperator, this.conditionalValue, this.minValue, this.maxValue, this.stepValue, this.decimalPlaces}): _permissions = permissions,_dropdownOptions = dropdownOptions;
  factory _FieldModel.fromJson(Map<String, dynamic> json) => _$FieldModelFromJson(json);

@override final  String id;
@override final  String labelText;
@override final  String name;
@override final  String fieldType;
@override@JsonKey() final  String defaultValue;
@override@JsonKey() final  bool isReadOnly;
@override@JsonKey() final  String section;
@override@JsonKey() final  bool required;
@override@JsonKey() final  bool isArchived;
 final  Map<String, String> _permissions;
@override@JsonKey() Map<String, String> get permissions {
  if (_permissions is EqualUnmodifiableMapView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_permissions);
}

// Additional properties for different field types
 final  List<String>? _dropdownOptions;
// Additional properties for different field types
@override List<String>? get dropdownOptions {
  final value = _dropdownOptions;
  if (value == null) return null;
  if (_dropdownOptions is EqualUnmodifiableListView) return _dropdownOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? fileExtension;
@override final  String? conditionalSource;
@override final  String? conditionalOperator;
@override final  String? conditionalValue;
@override final  double? minValue;
@override final  double? maxValue;
@override final  double? stepValue;
@override final  int? decimalPlaces;

/// Create a copy of FieldModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldModelCopyWith<_FieldModel> get copyWith => __$FieldModelCopyWithImpl<_FieldModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldModel&&(identical(other.id, id) || other.id == id)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.section, section) || other.section == section)&&(identical(other.required, required) || other.required == required)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&const DeepCollectionEquality().equals(other._dropdownOptions, _dropdownOptions)&&(identical(other.fileExtension, fileExtension) || other.fileExtension == fileExtension)&&(identical(other.conditionalSource, conditionalSource) || other.conditionalSource == conditionalSource)&&(identical(other.conditionalOperator, conditionalOperator) || other.conditionalOperator == conditionalOperator)&&(identical(other.conditionalValue, conditionalValue) || other.conditionalValue == conditionalValue)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.stepValue, stepValue) || other.stepValue == stepValue)&&(identical(other.decimalPlaces, decimalPlaces) || other.decimalPlaces == decimalPlaces));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,labelText,name,fieldType,defaultValue,isReadOnly,section,required,isArchived,const DeepCollectionEquality().hash(_permissions),const DeepCollectionEquality().hash(_dropdownOptions),fileExtension,conditionalSource,conditionalOperator,conditionalValue,minValue,maxValue,stepValue,decimalPlaces]);

@override
String toString() {
  return 'FieldModel(id: $id, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, isReadOnly: $isReadOnly, section: $section, required: $required, isArchived: $isArchived, permissions: $permissions, dropdownOptions: $dropdownOptions, fileExtension: $fileExtension, conditionalSource: $conditionalSource, conditionalOperator: $conditionalOperator, conditionalValue: $conditionalValue, minValue: $minValue, maxValue: $maxValue, stepValue: $stepValue, decimalPlaces: $decimalPlaces)';
}


}

/// @nodoc
abstract mixin class _$FieldModelCopyWith<$Res> implements $FieldModelCopyWith<$Res> {
  factory _$FieldModelCopyWith(_FieldModel value, $Res Function(_FieldModel) _then) = __$FieldModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String labelText, String name, String fieldType, String defaultValue, bool isReadOnly, String section, bool required, bool isArchived, Map<String, String> permissions, List<String>? dropdownOptions, String? fileExtension, String? conditionalSource, String? conditionalOperator, String? conditionalValue, double? minValue, double? maxValue, double? stepValue, int? decimalPlaces
});




}
/// @nodoc
class __$FieldModelCopyWithImpl<$Res>
    implements _$FieldModelCopyWith<$Res> {
  __$FieldModelCopyWithImpl(this._self, this._then);

  final _FieldModel _self;
  final $Res Function(_FieldModel) _then;

/// Create a copy of FieldModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? labelText = null,Object? name = null,Object? fieldType = null,Object? defaultValue = null,Object? isReadOnly = null,Object? section = null,Object? required = null,Object? isArchived = null,Object? permissions = null,Object? dropdownOptions = freezed,Object? fileExtension = freezed,Object? conditionalSource = freezed,Object? conditionalOperator = freezed,Object? conditionalValue = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? stepValue = freezed,Object? decimalPlaces = freezed,}) {
  return _then(_FieldModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,labelText: null == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Map<String, String>,dropdownOptions: freezed == dropdownOptions ? _self._dropdownOptions : dropdownOptions // ignore: cast_nullable_to_non_nullable
as List<String>?,fileExtension: freezed == fileExtension ? _self.fileExtension : fileExtension // ignore: cast_nullable_to_non_nullable
as String?,conditionalSource: freezed == conditionalSource ? _self.conditionalSource : conditionalSource // ignore: cast_nullable_to_non_nullable
as String?,conditionalOperator: freezed == conditionalOperator ? _self.conditionalOperator : conditionalOperator // ignore: cast_nullable_to_non_nullable
as String?,conditionalValue: freezed == conditionalValue ? _self.conditionalValue : conditionalValue // ignore: cast_nullable_to_non_nullable
as String?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as double?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double?,stepValue: freezed == stepValue ? _self.stepValue : stepValue // ignore: cast_nullable_to_non_nullable
as double?,decimalPlaces: freezed == decimalPlaces ? _self.decimalPlaces : decimalPlaces // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
