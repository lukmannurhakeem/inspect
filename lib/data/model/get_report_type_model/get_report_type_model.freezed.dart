// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_report_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetReportTypeModel {

 List<ReportTypeItem>? get data;@SafeStringConverter() String? get message;
/// Create a copy of GetReportTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetReportTypeModelCopyWith<GetReportTypeModel> get copyWith => _$GetReportTypeModelCopyWithImpl<GetReportTypeModel>(this as GetReportTypeModel, _$identity);

  /// Serializes this GetReportTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetReportTypeModel&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'GetReportTypeModel(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $GetReportTypeModelCopyWith<$Res>  {
  factory $GetReportTypeModelCopyWith(GetReportTypeModel value, $Res Function(GetReportTypeModel) _then) = _$GetReportTypeModelCopyWithImpl;
@useResult
$Res call({
 List<ReportTypeItem>? data,@SafeStringConverter() String? message
});




}
/// @nodoc
class _$GetReportTypeModelCopyWithImpl<$Res>
    implements $GetReportTypeModelCopyWith<$Res> {
  _$GetReportTypeModelCopyWithImpl(this._self, this._then);

  final GetReportTypeModel _self;
  final $Res Function(GetReportTypeModel) _then;

/// Create a copy of GetReportTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ReportTypeItem>?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetReportTypeModel].
extension GetReportTypeModelPatterns on GetReportTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetReportTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetReportTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetReportTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _GetReportTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetReportTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _GetReportTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReportTypeItem>? data, @SafeStringConverter()  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetReportTypeModel() when $default != null:
return $default(_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReportTypeItem>? data, @SafeStringConverter()  String? message)  $default,) {final _that = this;
switch (_that) {
case _GetReportTypeModel():
return $default(_that.data,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReportTypeItem>? data, @SafeStringConverter()  String? message)?  $default,) {final _that = this;
switch (_that) {
case _GetReportTypeModel() when $default != null:
return $default(_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetReportTypeModel implements GetReportTypeModel {
  const _GetReportTypeModel({final  List<ReportTypeItem>? data, @SafeStringConverter() this.message}): _data = data;
  factory _GetReportTypeModel.fromJson(Map<String, dynamic> json) => _$GetReportTypeModelFromJson(json);

 final  List<ReportTypeItem>? _data;
@override List<ReportTypeItem>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@SafeStringConverter() final  String? message;

/// Create a copy of GetReportTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetReportTypeModelCopyWith<_GetReportTypeModel> get copyWith => __$GetReportTypeModelCopyWithImpl<_GetReportTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetReportTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetReportTypeModel&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),message);

@override
String toString() {
  return 'GetReportTypeModel(data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$GetReportTypeModelCopyWith<$Res> implements $GetReportTypeModelCopyWith<$Res> {
  factory _$GetReportTypeModelCopyWith(_GetReportTypeModel value, $Res Function(_GetReportTypeModel) _then) = __$GetReportTypeModelCopyWithImpl;
@override @useResult
$Res call({
 List<ReportTypeItem>? data,@SafeStringConverter() String? message
});




}
/// @nodoc
class __$GetReportTypeModelCopyWithImpl<$Res>
    implements _$GetReportTypeModelCopyWith<$Res> {
  __$GetReportTypeModelCopyWithImpl(this._self, this._then);

  final _GetReportTypeModel _self;
  final $Res Function(_GetReportTypeModel) _then;

/// Create a copy of GetReportTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? message = freezed,}) {
  return _then(_GetReportTypeModel(
data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ReportTypeItem>?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReportTypeItem {

 ReportType? get reportType; List<CompetencyReport>? get competencyReports; List<ReportTypeDate>? get reportTypeDates; List<StatusRuleReport>? get statusRuleReports; List<ReportField>? get reportFields; List<ActionReport>? get actionReports;
/// Create a copy of ReportTypeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTypeItemCopyWith<ReportTypeItem> get copyWith => _$ReportTypeItemCopyWithImpl<ReportTypeItem>(this as ReportTypeItem, _$identity);

  /// Serializes this ReportTypeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTypeItem&&(identical(other.reportType, reportType) || other.reportType == reportType)&&const DeepCollectionEquality().equals(other.competencyReports, competencyReports)&&const DeepCollectionEquality().equals(other.reportTypeDates, reportTypeDates)&&const DeepCollectionEquality().equals(other.statusRuleReports, statusRuleReports)&&const DeepCollectionEquality().equals(other.reportFields, reportFields)&&const DeepCollectionEquality().equals(other.actionReports, actionReports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,const DeepCollectionEquality().hash(competencyReports),const DeepCollectionEquality().hash(reportTypeDates),const DeepCollectionEquality().hash(statusRuleReports),const DeepCollectionEquality().hash(reportFields),const DeepCollectionEquality().hash(actionReports));

@override
String toString() {
  return 'ReportTypeItem(reportType: $reportType, competencyReports: $competencyReports, reportTypeDates: $reportTypeDates, statusRuleReports: $statusRuleReports, reportFields: $reportFields, actionReports: $actionReports)';
}


}

/// @nodoc
abstract mixin class $ReportTypeItemCopyWith<$Res>  {
  factory $ReportTypeItemCopyWith(ReportTypeItem value, $Res Function(ReportTypeItem) _then) = _$ReportTypeItemCopyWithImpl;
@useResult
$Res call({
 ReportType? reportType, List<CompetencyReport>? competencyReports, List<ReportTypeDate>? reportTypeDates, List<StatusRuleReport>? statusRuleReports, List<ReportField>? reportFields, List<ActionReport>? actionReports
});


$ReportTypeCopyWith<$Res>? get reportType;

}
/// @nodoc
class _$ReportTypeItemCopyWithImpl<$Res>
    implements $ReportTypeItemCopyWith<$Res> {
  _$ReportTypeItemCopyWithImpl(this._self, this._then);

  final ReportTypeItem _self;
  final $Res Function(ReportTypeItem) _then;

/// Create a copy of ReportTypeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportType = freezed,Object? competencyReports = freezed,Object? reportTypeDates = freezed,Object? statusRuleReports = freezed,Object? reportFields = freezed,Object? actionReports = freezed,}) {
  return _then(_self.copyWith(
reportType: freezed == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as ReportType?,competencyReports: freezed == competencyReports ? _self.competencyReports : competencyReports // ignore: cast_nullable_to_non_nullable
as List<CompetencyReport>?,reportTypeDates: freezed == reportTypeDates ? _self.reportTypeDates : reportTypeDates // ignore: cast_nullable_to_non_nullable
as List<ReportTypeDate>?,statusRuleReports: freezed == statusRuleReports ? _self.statusRuleReports : statusRuleReports // ignore: cast_nullable_to_non_nullable
as List<StatusRuleReport>?,reportFields: freezed == reportFields ? _self.reportFields : reportFields // ignore: cast_nullable_to_non_nullable
as List<ReportField>?,actionReports: freezed == actionReports ? _self.actionReports : actionReports // ignore: cast_nullable_to_non_nullable
as List<ActionReport>?,
  ));
}
/// Create a copy of ReportTypeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTypeCopyWith<$Res>? get reportType {
    if (_self.reportType == null) {
    return null;
  }

  return $ReportTypeCopyWith<$Res>(_self.reportType!, (value) {
    return _then(_self.copyWith(reportType: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReportTypeItem].
extension ReportTypeItemPatterns on ReportTypeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTypeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTypeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTypeItem value)  $default,){
final _that = this;
switch (_that) {
case _ReportTypeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTypeItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTypeItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportType? reportType,  List<CompetencyReport>? competencyReports,  List<ReportTypeDate>? reportTypeDates,  List<StatusRuleReport>? statusRuleReports,  List<ReportField>? reportFields,  List<ActionReport>? actionReports)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTypeItem() when $default != null:
return $default(_that.reportType,_that.competencyReports,_that.reportTypeDates,_that.statusRuleReports,_that.reportFields,_that.actionReports);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportType? reportType,  List<CompetencyReport>? competencyReports,  List<ReportTypeDate>? reportTypeDates,  List<StatusRuleReport>? statusRuleReports,  List<ReportField>? reportFields,  List<ActionReport>? actionReports)  $default,) {final _that = this;
switch (_that) {
case _ReportTypeItem():
return $default(_that.reportType,_that.competencyReports,_that.reportTypeDates,_that.statusRuleReports,_that.reportFields,_that.actionReports);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportType? reportType,  List<CompetencyReport>? competencyReports,  List<ReportTypeDate>? reportTypeDates,  List<StatusRuleReport>? statusRuleReports,  List<ReportField>? reportFields,  List<ActionReport>? actionReports)?  $default,) {final _that = this;
switch (_that) {
case _ReportTypeItem() when $default != null:
return $default(_that.reportType,_that.competencyReports,_that.reportTypeDates,_that.statusRuleReports,_that.reportFields,_that.actionReports);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportTypeItem implements ReportTypeItem {
  const _ReportTypeItem({this.reportType, final  List<CompetencyReport>? competencyReports, final  List<ReportTypeDate>? reportTypeDates, final  List<StatusRuleReport>? statusRuleReports, final  List<ReportField>? reportFields, final  List<ActionReport>? actionReports}): _competencyReports = competencyReports,_reportTypeDates = reportTypeDates,_statusRuleReports = statusRuleReports,_reportFields = reportFields,_actionReports = actionReports;
  factory _ReportTypeItem.fromJson(Map<String, dynamic> json) => _$ReportTypeItemFromJson(json);

@override final  ReportType? reportType;
 final  List<CompetencyReport>? _competencyReports;
@override List<CompetencyReport>? get competencyReports {
  final value = _competencyReports;
  if (value == null) return null;
  if (_competencyReports is EqualUnmodifiableListView) return _competencyReports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ReportTypeDate>? _reportTypeDates;
@override List<ReportTypeDate>? get reportTypeDates {
  final value = _reportTypeDates;
  if (value == null) return null;
  if (_reportTypeDates is EqualUnmodifiableListView) return _reportTypeDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<StatusRuleReport>? _statusRuleReports;
@override List<StatusRuleReport>? get statusRuleReports {
  final value = _statusRuleReports;
  if (value == null) return null;
  if (_statusRuleReports is EqualUnmodifiableListView) return _statusRuleReports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ReportField>? _reportFields;
@override List<ReportField>? get reportFields {
  final value = _reportFields;
  if (value == null) return null;
  if (_reportFields is EqualUnmodifiableListView) return _reportFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ActionReport>? _actionReports;
@override List<ActionReport>? get actionReports {
  final value = _actionReports;
  if (value == null) return null;
  if (_actionReports is EqualUnmodifiableListView) return _actionReports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ReportTypeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTypeItemCopyWith<_ReportTypeItem> get copyWith => __$ReportTypeItemCopyWithImpl<_ReportTypeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTypeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTypeItem&&(identical(other.reportType, reportType) || other.reportType == reportType)&&const DeepCollectionEquality().equals(other._competencyReports, _competencyReports)&&const DeepCollectionEquality().equals(other._reportTypeDates, _reportTypeDates)&&const DeepCollectionEquality().equals(other._statusRuleReports, _statusRuleReports)&&const DeepCollectionEquality().equals(other._reportFields, _reportFields)&&const DeepCollectionEquality().equals(other._actionReports, _actionReports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,const DeepCollectionEquality().hash(_competencyReports),const DeepCollectionEquality().hash(_reportTypeDates),const DeepCollectionEquality().hash(_statusRuleReports),const DeepCollectionEquality().hash(_reportFields),const DeepCollectionEquality().hash(_actionReports));

@override
String toString() {
  return 'ReportTypeItem(reportType: $reportType, competencyReports: $competencyReports, reportTypeDates: $reportTypeDates, statusRuleReports: $statusRuleReports, reportFields: $reportFields, actionReports: $actionReports)';
}


}

/// @nodoc
abstract mixin class _$ReportTypeItemCopyWith<$Res> implements $ReportTypeItemCopyWith<$Res> {
  factory _$ReportTypeItemCopyWith(_ReportTypeItem value, $Res Function(_ReportTypeItem) _then) = __$ReportTypeItemCopyWithImpl;
@override @useResult
$Res call({
 ReportType? reportType, List<CompetencyReport>? competencyReports, List<ReportTypeDate>? reportTypeDates, List<StatusRuleReport>? statusRuleReports, List<ReportField>? reportFields, List<ActionReport>? actionReports
});


@override $ReportTypeCopyWith<$Res>? get reportType;

}
/// @nodoc
class __$ReportTypeItemCopyWithImpl<$Res>
    implements _$ReportTypeItemCopyWith<$Res> {
  __$ReportTypeItemCopyWithImpl(this._self, this._then);

  final _ReportTypeItem _self;
  final $Res Function(_ReportTypeItem) _then;

/// Create a copy of ReportTypeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportType = freezed,Object? competencyReports = freezed,Object? reportTypeDates = freezed,Object? statusRuleReports = freezed,Object? reportFields = freezed,Object? actionReports = freezed,}) {
  return _then(_ReportTypeItem(
reportType: freezed == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as ReportType?,competencyReports: freezed == competencyReports ? _self._competencyReports : competencyReports // ignore: cast_nullable_to_non_nullable
as List<CompetencyReport>?,reportTypeDates: freezed == reportTypeDates ? _self._reportTypeDates : reportTypeDates // ignore: cast_nullable_to_non_nullable
as List<ReportTypeDate>?,statusRuleReports: freezed == statusRuleReports ? _self._statusRuleReports : statusRuleReports // ignore: cast_nullable_to_non_nullable
as List<StatusRuleReport>?,reportFields: freezed == reportFields ? _self._reportFields : reportFields // ignore: cast_nullable_to_non_nullable
as List<ReportField>?,actionReports: freezed == actionReports ? _self._actionReports : actionReports // ignore: cast_nullable_to_non_nullable
as List<ActionReport>?,
  ));
}

/// Create a copy of ReportTypeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTypeCopyWith<$Res>? get reportType {
    if (_self.reportType == null) {
    return null;
  }

  return $ReportTypeCopyWith<$Res>(_self.reportType!, (value) {
    return _then(_self.copyWith(reportType: value));
  });
}
}


/// @nodoc
mixin _$Datum {

 ReportType? get reportType; List<CompetencyReport>? get competencyReports; List<ReportTypeDate>? get reportTypeDates; List<StatusRuleReport>? get statusRuleReports; List<ReportField>? get reportFields; List<ActionReport>? get actionReports;
/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatumCopyWith<Datum> get copyWith => _$DatumCopyWithImpl<Datum>(this as Datum, _$identity);

  /// Serializes this Datum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Datum&&(identical(other.reportType, reportType) || other.reportType == reportType)&&const DeepCollectionEquality().equals(other.competencyReports, competencyReports)&&const DeepCollectionEquality().equals(other.reportTypeDates, reportTypeDates)&&const DeepCollectionEquality().equals(other.statusRuleReports, statusRuleReports)&&const DeepCollectionEquality().equals(other.reportFields, reportFields)&&const DeepCollectionEquality().equals(other.actionReports, actionReports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,const DeepCollectionEquality().hash(competencyReports),const DeepCollectionEquality().hash(reportTypeDates),const DeepCollectionEquality().hash(statusRuleReports),const DeepCollectionEquality().hash(reportFields),const DeepCollectionEquality().hash(actionReports));

@override
String toString() {
  return 'Datum(reportType: $reportType, competencyReports: $competencyReports, reportTypeDates: $reportTypeDates, statusRuleReports: $statusRuleReports, reportFields: $reportFields, actionReports: $actionReports)';
}


}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res>  {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) = _$DatumCopyWithImpl;
@useResult
$Res call({
 ReportType? reportType, List<CompetencyReport>? competencyReports, List<ReportTypeDate>? reportTypeDates, List<StatusRuleReport>? statusRuleReports, List<ReportField>? reportFields, List<ActionReport>? actionReports
});


$ReportTypeCopyWith<$Res>? get reportType;

}
/// @nodoc
class _$DatumCopyWithImpl<$Res>
    implements $DatumCopyWith<$Res> {
  _$DatumCopyWithImpl(this._self, this._then);

  final Datum _self;
  final $Res Function(Datum) _then;

/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportType = freezed,Object? competencyReports = freezed,Object? reportTypeDates = freezed,Object? statusRuleReports = freezed,Object? reportFields = freezed,Object? actionReports = freezed,}) {
  return _then(_self.copyWith(
reportType: freezed == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as ReportType?,competencyReports: freezed == competencyReports ? _self.competencyReports : competencyReports // ignore: cast_nullable_to_non_nullable
as List<CompetencyReport>?,reportTypeDates: freezed == reportTypeDates ? _self.reportTypeDates : reportTypeDates // ignore: cast_nullable_to_non_nullable
as List<ReportTypeDate>?,statusRuleReports: freezed == statusRuleReports ? _self.statusRuleReports : statusRuleReports // ignore: cast_nullable_to_non_nullable
as List<StatusRuleReport>?,reportFields: freezed == reportFields ? _self.reportFields : reportFields // ignore: cast_nullable_to_non_nullable
as List<ReportField>?,actionReports: freezed == actionReports ? _self.actionReports : actionReports // ignore: cast_nullable_to_non_nullable
as List<ActionReport>?,
  ));
}
/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTypeCopyWith<$Res>? get reportType {
    if (_self.reportType == null) {
    return null;
  }

  return $ReportTypeCopyWith<$Res>(_self.reportType!, (value) {
    return _then(_self.copyWith(reportType: value));
  });
}
}


/// Adds pattern-matching-related methods to [Datum].
extension DatumPatterns on Datum {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Datum value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Datum() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Datum value)  $default,){
final _that = this;
switch (_that) {
case _Datum():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Datum value)?  $default,){
final _that = this;
switch (_that) {
case _Datum() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportType? reportType,  List<CompetencyReport>? competencyReports,  List<ReportTypeDate>? reportTypeDates,  List<StatusRuleReport>? statusRuleReports,  List<ReportField>? reportFields,  List<ActionReport>? actionReports)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.reportType,_that.competencyReports,_that.reportTypeDates,_that.statusRuleReports,_that.reportFields,_that.actionReports);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportType? reportType,  List<CompetencyReport>? competencyReports,  List<ReportTypeDate>? reportTypeDates,  List<StatusRuleReport>? statusRuleReports,  List<ReportField>? reportFields,  List<ActionReport>? actionReports)  $default,) {final _that = this;
switch (_that) {
case _Datum():
return $default(_that.reportType,_that.competencyReports,_that.reportTypeDates,_that.statusRuleReports,_that.reportFields,_that.actionReports);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportType? reportType,  List<CompetencyReport>? competencyReports,  List<ReportTypeDate>? reportTypeDates,  List<StatusRuleReport>? statusRuleReports,  List<ReportField>? reportFields,  List<ActionReport>? actionReports)?  $default,) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.reportType,_that.competencyReports,_that.reportTypeDates,_that.statusRuleReports,_that.reportFields,_that.actionReports);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Datum implements Datum {
  const _Datum({this.reportType, final  List<CompetencyReport>? competencyReports, final  List<ReportTypeDate>? reportTypeDates, final  List<StatusRuleReport>? statusRuleReports, final  List<ReportField>? reportFields, final  List<ActionReport>? actionReports}): _competencyReports = competencyReports,_reportTypeDates = reportTypeDates,_statusRuleReports = statusRuleReports,_reportFields = reportFields,_actionReports = actionReports;
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

@override final  ReportType? reportType;
 final  List<CompetencyReport>? _competencyReports;
@override List<CompetencyReport>? get competencyReports {
  final value = _competencyReports;
  if (value == null) return null;
  if (_competencyReports is EqualUnmodifiableListView) return _competencyReports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ReportTypeDate>? _reportTypeDates;
@override List<ReportTypeDate>? get reportTypeDates {
  final value = _reportTypeDates;
  if (value == null) return null;
  if (_reportTypeDates is EqualUnmodifiableListView) return _reportTypeDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<StatusRuleReport>? _statusRuleReports;
@override List<StatusRuleReport>? get statusRuleReports {
  final value = _statusRuleReports;
  if (value == null) return null;
  if (_statusRuleReports is EqualUnmodifiableListView) return _statusRuleReports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ReportField>? _reportFields;
@override List<ReportField>? get reportFields {
  final value = _reportFields;
  if (value == null) return null;
  if (_reportFields is EqualUnmodifiableListView) return _reportFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ActionReport>? _actionReports;
@override List<ActionReport>? get actionReports {
  final value = _actionReports;
  if (value == null) return null;
  if (_actionReports is EqualUnmodifiableListView) return _actionReports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatumCopyWith<_Datum> get copyWith => __$DatumCopyWithImpl<_Datum>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatumToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Datum&&(identical(other.reportType, reportType) || other.reportType == reportType)&&const DeepCollectionEquality().equals(other._competencyReports, _competencyReports)&&const DeepCollectionEquality().equals(other._reportTypeDates, _reportTypeDates)&&const DeepCollectionEquality().equals(other._statusRuleReports, _statusRuleReports)&&const DeepCollectionEquality().equals(other._reportFields, _reportFields)&&const DeepCollectionEquality().equals(other._actionReports, _actionReports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,const DeepCollectionEquality().hash(_competencyReports),const DeepCollectionEquality().hash(_reportTypeDates),const DeepCollectionEquality().hash(_statusRuleReports),const DeepCollectionEquality().hash(_reportFields),const DeepCollectionEquality().hash(_actionReports));

@override
String toString() {
  return 'Datum(reportType: $reportType, competencyReports: $competencyReports, reportTypeDates: $reportTypeDates, statusRuleReports: $statusRuleReports, reportFields: $reportFields, actionReports: $actionReports)';
}


}

/// @nodoc
abstract mixin class _$DatumCopyWith<$Res> implements $DatumCopyWith<$Res> {
  factory _$DatumCopyWith(_Datum value, $Res Function(_Datum) _then) = __$DatumCopyWithImpl;
@override @useResult
$Res call({
 ReportType? reportType, List<CompetencyReport>? competencyReports, List<ReportTypeDate>? reportTypeDates, List<StatusRuleReport>? statusRuleReports, List<ReportField>? reportFields, List<ActionReport>? actionReports
});


@override $ReportTypeCopyWith<$Res>? get reportType;

}
/// @nodoc
class __$DatumCopyWithImpl<$Res>
    implements _$DatumCopyWith<$Res> {
  __$DatumCopyWithImpl(this._self, this._then);

  final _Datum _self;
  final $Res Function(_Datum) _then;

/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportType = freezed,Object? competencyReports = freezed,Object? reportTypeDates = freezed,Object? statusRuleReports = freezed,Object? reportFields = freezed,Object? actionReports = freezed,}) {
  return _then(_Datum(
reportType: freezed == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as ReportType?,competencyReports: freezed == competencyReports ? _self._competencyReports : competencyReports // ignore: cast_nullable_to_non_nullable
as List<CompetencyReport>?,reportTypeDates: freezed == reportTypeDates ? _self._reportTypeDates : reportTypeDates // ignore: cast_nullable_to_non_nullable
as List<ReportTypeDate>?,statusRuleReports: freezed == statusRuleReports ? _self._statusRuleReports : statusRuleReports // ignore: cast_nullable_to_non_nullable
as List<StatusRuleReport>?,reportFields: freezed == reportFields ? _self._reportFields : reportFields // ignore: cast_nullable_to_non_nullable
as List<ReportField>?,actionReports: freezed == actionReports ? _self._actionReports : actionReports // ignore: cast_nullable_to_non_nullable
as List<ActionReport>?,
  ));
}

/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportTypeCopyWith<$Res>? get reportType {
    if (_self.reportType == null) {
    return null;
  }

  return $ReportTypeCopyWith<$Res>(_self.reportType!, (value) {
    return _then(_self.copyWith(reportType: value));
  });
}
}


/// @nodoc
mixin _$ReportType {

@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? get reportTypeId;@JsonKey(name: 'jobID')@SafeStringConverter() String? get jobId;@SafeStringConverter() String? get reportName;@SafeStringConverter() String? get description;@SafeStringConverter() String? get documentCode;@SafeBoolConverter() bool? get isExternalReport;@SafeBoolConverter() bool? get defaultAsDraft;@SafeBoolConverter() bool? get archived;@SafeBoolConverter() bool? get updateItemStatus;@SafeBoolConverter() bool? get updateItemDates;@SafeStringConverter() String? get batchReportType;@SafeBoolConverter() bool? get isStatusRequired;@SafeStringConverter() String? get possibleStatus;@SafeStringConverter() String? get possibleBatchStatus;@SafeStringConverter() String? get permission;@JsonKey(name: 'categoryID')@SafeStringConverter() String? get categoryId;@JsonKey(name: 'fieldsID')@SafeStringConverter() String? get fieldsId;@SafeStringConverter() String? get documentTemplate;@SafeStringConverter() String? get labelTemplate;@JsonKey(name: 'actionReportID')@SafeStringConverter() String? get actionReportId;@JsonKey(name: 'competencyID')@SafeStringConverter() String? get competencyId;@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of ReportType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTypeCopyWith<ReportType> get copyWith => _$ReportTypeCopyWithImpl<ReportType>(this as ReportType, _$identity);

  /// Serializes this ReportType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportType&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentCode, documentCode) || other.documentCode == documentCode)&&(identical(other.isExternalReport, isExternalReport) || other.isExternalReport == isExternalReport)&&(identical(other.defaultAsDraft, defaultAsDraft) || other.defaultAsDraft == defaultAsDraft)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.updateItemStatus, updateItemStatus) || other.updateItemStatus == updateItemStatus)&&(identical(other.updateItemDates, updateItemDates) || other.updateItemDates == updateItemDates)&&(identical(other.batchReportType, batchReportType) || other.batchReportType == batchReportType)&&(identical(other.isStatusRequired, isStatusRequired) || other.isStatusRequired == isStatusRequired)&&(identical(other.possibleStatus, possibleStatus) || other.possibleStatus == possibleStatus)&&(identical(other.possibleBatchStatus, possibleBatchStatus) || other.possibleBatchStatus == possibleBatchStatus)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.fieldsId, fieldsId) || other.fieldsId == fieldsId)&&(identical(other.documentTemplate, documentTemplate) || other.documentTemplate == documentTemplate)&&(identical(other.labelTemplate, labelTemplate) || other.labelTemplate == labelTemplate)&&(identical(other.actionReportId, actionReportId) || other.actionReportId == actionReportId)&&(identical(other.competencyId, competencyId) || other.competencyId == competencyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,reportTypeId,jobId,reportName,description,documentCode,isExternalReport,defaultAsDraft,archived,updateItemStatus,updateItemDates,batchReportType,isStatusRequired,possibleStatus,possibleBatchStatus,permission,categoryId,fieldsId,documentTemplate,labelTemplate,actionReportId,competencyId,createdAt,updatedAt]);

@override
String toString() {
  return 'ReportType(reportTypeId: $reportTypeId, jobId: $jobId, reportName: $reportName, description: $description, documentCode: $documentCode, isExternalReport: $isExternalReport, defaultAsDraft: $defaultAsDraft, archived: $archived, updateItemStatus: $updateItemStatus, updateItemDates: $updateItemDates, batchReportType: $batchReportType, isStatusRequired: $isStatusRequired, possibleStatus: $possibleStatus, possibleBatchStatus: $possibleBatchStatus, permission: $permission, categoryId: $categoryId, fieldsId: $fieldsId, documentTemplate: $documentTemplate, labelTemplate: $labelTemplate, actionReportId: $actionReportId, competencyId: $competencyId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReportTypeCopyWith<$Res>  {
  factory $ReportTypeCopyWith(ReportType value, $Res Function(ReportType) _then) = _$ReportTypeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@JsonKey(name: 'jobID')@SafeStringConverter() String? jobId,@SafeStringConverter() String? reportName,@SafeStringConverter() String? description,@SafeStringConverter() String? documentCode,@SafeBoolConverter() bool? isExternalReport,@SafeBoolConverter() bool? defaultAsDraft,@SafeBoolConverter() bool? archived,@SafeBoolConverter() bool? updateItemStatus,@SafeBoolConverter() bool? updateItemDates,@SafeStringConverter() String? batchReportType,@SafeBoolConverter() bool? isStatusRequired,@SafeStringConverter() String? possibleStatus,@SafeStringConverter() String? possibleBatchStatus,@SafeStringConverter() String? permission,@JsonKey(name: 'categoryID')@SafeStringConverter() String? categoryId,@JsonKey(name: 'fieldsID')@SafeStringConverter() String? fieldsId,@SafeStringConverter() String? documentTemplate,@SafeStringConverter() String? labelTemplate,@JsonKey(name: 'actionReportID')@SafeStringConverter() String? actionReportId,@JsonKey(name: 'competencyID')@SafeStringConverter() String? competencyId,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$ReportTypeCopyWithImpl<$Res>
    implements $ReportTypeCopyWith<$Res> {
  _$ReportTypeCopyWithImpl(this._self, this._then);

  final ReportType _self;
  final $Res Function(ReportType) _then;

/// Create a copy of ReportType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportTypeId = freezed,Object? jobId = freezed,Object? reportName = freezed,Object? description = freezed,Object? documentCode = freezed,Object? isExternalReport = freezed,Object? defaultAsDraft = freezed,Object? archived = freezed,Object? updateItemStatus = freezed,Object? updateItemDates = freezed,Object? batchReportType = freezed,Object? isStatusRequired = freezed,Object? possibleStatus = freezed,Object? possibleBatchStatus = freezed,Object? permission = freezed,Object? categoryId = freezed,Object? fieldsId = freezed,Object? documentTemplate = freezed,Object? labelTemplate = freezed,Object? actionReportId = freezed,Object? competencyId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,documentCode: freezed == documentCode ? _self.documentCode : documentCode // ignore: cast_nullable_to_non_nullable
as String?,isExternalReport: freezed == isExternalReport ? _self.isExternalReport : isExternalReport // ignore: cast_nullable_to_non_nullable
as bool?,defaultAsDraft: freezed == defaultAsDraft ? _self.defaultAsDraft : defaultAsDraft // ignore: cast_nullable_to_non_nullable
as bool?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,updateItemStatus: freezed == updateItemStatus ? _self.updateItemStatus : updateItemStatus // ignore: cast_nullable_to_non_nullable
as bool?,updateItemDates: freezed == updateItemDates ? _self.updateItemDates : updateItemDates // ignore: cast_nullable_to_non_nullable
as bool?,batchReportType: freezed == batchReportType ? _self.batchReportType : batchReportType // ignore: cast_nullable_to_non_nullable
as String?,isStatusRequired: freezed == isStatusRequired ? _self.isStatusRequired : isStatusRequired // ignore: cast_nullable_to_non_nullable
as bool?,possibleStatus: freezed == possibleStatus ? _self.possibleStatus : possibleStatus // ignore: cast_nullable_to_non_nullable
as String?,possibleBatchStatus: freezed == possibleBatchStatus ? _self.possibleBatchStatus : possibleBatchStatus // ignore: cast_nullable_to_non_nullable
as String?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,fieldsId: freezed == fieldsId ? _self.fieldsId : fieldsId // ignore: cast_nullable_to_non_nullable
as String?,documentTemplate: freezed == documentTemplate ? _self.documentTemplate : documentTemplate // ignore: cast_nullable_to_non_nullable
as String?,labelTemplate: freezed == labelTemplate ? _self.labelTemplate : labelTemplate // ignore: cast_nullable_to_non_nullable
as String?,actionReportId: freezed == actionReportId ? _self.actionReportId : actionReportId // ignore: cast_nullable_to_non_nullable
as String?,competencyId: freezed == competencyId ? _self.competencyId : competencyId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportType].
extension ReportTypePatterns on ReportType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportType value)  $default,){
final _that = this;
switch (_that) {
case _ReportType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportType value)?  $default,){
final _that = this;
switch (_that) {
case _ReportType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @JsonKey(name: 'jobID')@SafeStringConverter()  String? jobId, @SafeStringConverter()  String? reportName, @SafeStringConverter()  String? description, @SafeStringConverter()  String? documentCode, @SafeBoolConverter()  bool? isExternalReport, @SafeBoolConverter()  bool? defaultAsDraft, @SafeBoolConverter()  bool? archived, @SafeBoolConverter()  bool? updateItemStatus, @SafeBoolConverter()  bool? updateItemDates, @SafeStringConverter()  String? batchReportType, @SafeBoolConverter()  bool? isStatusRequired, @SafeStringConverter()  String? possibleStatus, @SafeStringConverter()  String? possibleBatchStatus, @SafeStringConverter()  String? permission, @JsonKey(name: 'categoryID')@SafeStringConverter()  String? categoryId, @JsonKey(name: 'fieldsID')@SafeStringConverter()  String? fieldsId, @SafeStringConverter()  String? documentTemplate, @SafeStringConverter()  String? labelTemplate, @JsonKey(name: 'actionReportID')@SafeStringConverter()  String? actionReportId, @JsonKey(name: 'competencyID')@SafeStringConverter()  String? competencyId, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportType() when $default != null:
return $default(_that.reportTypeId,_that.jobId,_that.reportName,_that.description,_that.documentCode,_that.isExternalReport,_that.defaultAsDraft,_that.archived,_that.updateItemStatus,_that.updateItemDates,_that.batchReportType,_that.isStatusRequired,_that.possibleStatus,_that.possibleBatchStatus,_that.permission,_that.categoryId,_that.fieldsId,_that.documentTemplate,_that.labelTemplate,_that.actionReportId,_that.competencyId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @JsonKey(name: 'jobID')@SafeStringConverter()  String? jobId, @SafeStringConverter()  String? reportName, @SafeStringConverter()  String? description, @SafeStringConverter()  String? documentCode, @SafeBoolConverter()  bool? isExternalReport, @SafeBoolConverter()  bool? defaultAsDraft, @SafeBoolConverter()  bool? archived, @SafeBoolConverter()  bool? updateItemStatus, @SafeBoolConverter()  bool? updateItemDates, @SafeStringConverter()  String? batchReportType, @SafeBoolConverter()  bool? isStatusRequired, @SafeStringConverter()  String? possibleStatus, @SafeStringConverter()  String? possibleBatchStatus, @SafeStringConverter()  String? permission, @JsonKey(name: 'categoryID')@SafeStringConverter()  String? categoryId, @JsonKey(name: 'fieldsID')@SafeStringConverter()  String? fieldsId, @SafeStringConverter()  String? documentTemplate, @SafeStringConverter()  String? labelTemplate, @JsonKey(name: 'actionReportID')@SafeStringConverter()  String? actionReportId, @JsonKey(name: 'competencyID')@SafeStringConverter()  String? competencyId, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReportType():
return $default(_that.reportTypeId,_that.jobId,_that.reportName,_that.description,_that.documentCode,_that.isExternalReport,_that.defaultAsDraft,_that.archived,_that.updateItemStatus,_that.updateItemDates,_that.batchReportType,_that.isStatusRequired,_that.possibleStatus,_that.possibleBatchStatus,_that.permission,_that.categoryId,_that.fieldsId,_that.documentTemplate,_that.labelTemplate,_that.actionReportId,_that.competencyId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @JsonKey(name: 'jobID')@SafeStringConverter()  String? jobId, @SafeStringConverter()  String? reportName, @SafeStringConverter()  String? description, @SafeStringConverter()  String? documentCode, @SafeBoolConverter()  bool? isExternalReport, @SafeBoolConverter()  bool? defaultAsDraft, @SafeBoolConverter()  bool? archived, @SafeBoolConverter()  bool? updateItemStatus, @SafeBoolConverter()  bool? updateItemDates, @SafeStringConverter()  String? batchReportType, @SafeBoolConverter()  bool? isStatusRequired, @SafeStringConverter()  String? possibleStatus, @SafeStringConverter()  String? possibleBatchStatus, @SafeStringConverter()  String? permission, @JsonKey(name: 'categoryID')@SafeStringConverter()  String? categoryId, @JsonKey(name: 'fieldsID')@SafeStringConverter()  String? fieldsId, @SafeStringConverter()  String? documentTemplate, @SafeStringConverter()  String? labelTemplate, @JsonKey(name: 'actionReportID')@SafeStringConverter()  String? actionReportId, @JsonKey(name: 'competencyID')@SafeStringConverter()  String? competencyId, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReportType() when $default != null:
return $default(_that.reportTypeId,_that.jobId,_that.reportName,_that.description,_that.documentCode,_that.isExternalReport,_that.defaultAsDraft,_that.archived,_that.updateItemStatus,_that.updateItemDates,_that.batchReportType,_that.isStatusRequired,_that.possibleStatus,_that.possibleBatchStatus,_that.permission,_that.categoryId,_that.fieldsId,_that.documentTemplate,_that.labelTemplate,_that.actionReportId,_that.competencyId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportType implements ReportType {
  const _ReportType({@JsonKey(name: 'reportTypeID')@SafeStringConverter() this.reportTypeId, @JsonKey(name: 'jobID')@SafeStringConverter() this.jobId, @SafeStringConverter() this.reportName, @SafeStringConverter() this.description, @SafeStringConverter() this.documentCode, @SafeBoolConverter() this.isExternalReport, @SafeBoolConverter() this.defaultAsDraft, @SafeBoolConverter() this.archived, @SafeBoolConverter() this.updateItemStatus, @SafeBoolConverter() this.updateItemDates, @SafeStringConverter() this.batchReportType, @SafeBoolConverter() this.isStatusRequired, @SafeStringConverter() this.possibleStatus, @SafeStringConverter() this.possibleBatchStatus, @SafeStringConverter() this.permission, @JsonKey(name: 'categoryID')@SafeStringConverter() this.categoryId, @JsonKey(name: 'fieldsID')@SafeStringConverter() this.fieldsId, @SafeStringConverter() this.documentTemplate, @SafeStringConverter() this.labelTemplate, @JsonKey(name: 'actionReportID')@SafeStringConverter() this.actionReportId, @JsonKey(name: 'competencyID')@SafeStringConverter() this.competencyId, @JsonKey(name: 'created_at')@SafeDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter() this.updatedAt});
  factory _ReportType.fromJson(Map<String, dynamic> json) => _$ReportTypeFromJson(json);

@override@JsonKey(name: 'reportTypeID')@SafeStringConverter() final  String? reportTypeId;
@override@JsonKey(name: 'jobID')@SafeStringConverter() final  String? jobId;
@override@SafeStringConverter() final  String? reportName;
@override@SafeStringConverter() final  String? description;
@override@SafeStringConverter() final  String? documentCode;
@override@SafeBoolConverter() final  bool? isExternalReport;
@override@SafeBoolConverter() final  bool? defaultAsDraft;
@override@SafeBoolConverter() final  bool? archived;
@override@SafeBoolConverter() final  bool? updateItemStatus;
@override@SafeBoolConverter() final  bool? updateItemDates;
@override@SafeStringConverter() final  String? batchReportType;
@override@SafeBoolConverter() final  bool? isStatusRequired;
@override@SafeStringConverter() final  String? possibleStatus;
@override@SafeStringConverter() final  String? possibleBatchStatus;
@override@SafeStringConverter() final  String? permission;
@override@JsonKey(name: 'categoryID')@SafeStringConverter() final  String? categoryId;
@override@JsonKey(name: 'fieldsID')@SafeStringConverter() final  String? fieldsId;
@override@SafeStringConverter() final  String? documentTemplate;
@override@SafeStringConverter() final  String? labelTemplate;
@override@JsonKey(name: 'actionReportID')@SafeStringConverter() final  String? actionReportId;
@override@JsonKey(name: 'competencyID')@SafeStringConverter() final  String? competencyId;
@override@JsonKey(name: 'created_at')@SafeDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@SafeDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of ReportType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTypeCopyWith<_ReportType> get copyWith => __$ReportTypeCopyWithImpl<_ReportType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportType&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.reportName, reportName) || other.reportName == reportName)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentCode, documentCode) || other.documentCode == documentCode)&&(identical(other.isExternalReport, isExternalReport) || other.isExternalReport == isExternalReport)&&(identical(other.defaultAsDraft, defaultAsDraft) || other.defaultAsDraft == defaultAsDraft)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.updateItemStatus, updateItemStatus) || other.updateItemStatus == updateItemStatus)&&(identical(other.updateItemDates, updateItemDates) || other.updateItemDates == updateItemDates)&&(identical(other.batchReportType, batchReportType) || other.batchReportType == batchReportType)&&(identical(other.isStatusRequired, isStatusRequired) || other.isStatusRequired == isStatusRequired)&&(identical(other.possibleStatus, possibleStatus) || other.possibleStatus == possibleStatus)&&(identical(other.possibleBatchStatus, possibleBatchStatus) || other.possibleBatchStatus == possibleBatchStatus)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.fieldsId, fieldsId) || other.fieldsId == fieldsId)&&(identical(other.documentTemplate, documentTemplate) || other.documentTemplate == documentTemplate)&&(identical(other.labelTemplate, labelTemplate) || other.labelTemplate == labelTemplate)&&(identical(other.actionReportId, actionReportId) || other.actionReportId == actionReportId)&&(identical(other.competencyId, competencyId) || other.competencyId == competencyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,reportTypeId,jobId,reportName,description,documentCode,isExternalReport,defaultAsDraft,archived,updateItemStatus,updateItemDates,batchReportType,isStatusRequired,possibleStatus,possibleBatchStatus,permission,categoryId,fieldsId,documentTemplate,labelTemplate,actionReportId,competencyId,createdAt,updatedAt]);

@override
String toString() {
  return 'ReportType(reportTypeId: $reportTypeId, jobId: $jobId, reportName: $reportName, description: $description, documentCode: $documentCode, isExternalReport: $isExternalReport, defaultAsDraft: $defaultAsDraft, archived: $archived, updateItemStatus: $updateItemStatus, updateItemDates: $updateItemDates, batchReportType: $batchReportType, isStatusRequired: $isStatusRequired, possibleStatus: $possibleStatus, possibleBatchStatus: $possibleBatchStatus, permission: $permission, categoryId: $categoryId, fieldsId: $fieldsId, documentTemplate: $documentTemplate, labelTemplate: $labelTemplate, actionReportId: $actionReportId, competencyId: $competencyId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReportTypeCopyWith<$Res> implements $ReportTypeCopyWith<$Res> {
  factory _$ReportTypeCopyWith(_ReportType value, $Res Function(_ReportType) _then) = __$ReportTypeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@JsonKey(name: 'jobID')@SafeStringConverter() String? jobId,@SafeStringConverter() String? reportName,@SafeStringConverter() String? description,@SafeStringConverter() String? documentCode,@SafeBoolConverter() bool? isExternalReport,@SafeBoolConverter() bool? defaultAsDraft,@SafeBoolConverter() bool? archived,@SafeBoolConverter() bool? updateItemStatus,@SafeBoolConverter() bool? updateItemDates,@SafeStringConverter() String? batchReportType,@SafeBoolConverter() bool? isStatusRequired,@SafeStringConverter() String? possibleStatus,@SafeStringConverter() String? possibleBatchStatus,@SafeStringConverter() String? permission,@JsonKey(name: 'categoryID')@SafeStringConverter() String? categoryId,@JsonKey(name: 'fieldsID')@SafeStringConverter() String? fieldsId,@SafeStringConverter() String? documentTemplate,@SafeStringConverter() String? labelTemplate,@JsonKey(name: 'actionReportID')@SafeStringConverter() String? actionReportId,@JsonKey(name: 'competencyID')@SafeStringConverter() String? competencyId,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$ReportTypeCopyWithImpl<$Res>
    implements _$ReportTypeCopyWith<$Res> {
  __$ReportTypeCopyWithImpl(this._self, this._then);

  final _ReportType _self;
  final $Res Function(_ReportType) _then;

/// Create a copy of ReportType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportTypeId = freezed,Object? jobId = freezed,Object? reportName = freezed,Object? description = freezed,Object? documentCode = freezed,Object? isExternalReport = freezed,Object? defaultAsDraft = freezed,Object? archived = freezed,Object? updateItemStatus = freezed,Object? updateItemDates = freezed,Object? batchReportType = freezed,Object? isStatusRequired = freezed,Object? possibleStatus = freezed,Object? possibleBatchStatus = freezed,Object? permission = freezed,Object? categoryId = freezed,Object? fieldsId = freezed,Object? documentTemplate = freezed,Object? labelTemplate = freezed,Object? actionReportId = freezed,Object? competencyId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ReportType(
reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,reportName: freezed == reportName ? _self.reportName : reportName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,documentCode: freezed == documentCode ? _self.documentCode : documentCode // ignore: cast_nullable_to_non_nullable
as String?,isExternalReport: freezed == isExternalReport ? _self.isExternalReport : isExternalReport // ignore: cast_nullable_to_non_nullable
as bool?,defaultAsDraft: freezed == defaultAsDraft ? _self.defaultAsDraft : defaultAsDraft // ignore: cast_nullable_to_non_nullable
as bool?,archived: freezed == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool?,updateItemStatus: freezed == updateItemStatus ? _self.updateItemStatus : updateItemStatus // ignore: cast_nullable_to_non_nullable
as bool?,updateItemDates: freezed == updateItemDates ? _self.updateItemDates : updateItemDates // ignore: cast_nullable_to_non_nullable
as bool?,batchReportType: freezed == batchReportType ? _self.batchReportType : batchReportType // ignore: cast_nullable_to_non_nullable
as String?,isStatusRequired: freezed == isStatusRequired ? _self.isStatusRequired : isStatusRequired // ignore: cast_nullable_to_non_nullable
as bool?,possibleStatus: freezed == possibleStatus ? _self.possibleStatus : possibleStatus // ignore: cast_nullable_to_non_nullable
as String?,possibleBatchStatus: freezed == possibleBatchStatus ? _self.possibleBatchStatus : possibleBatchStatus // ignore: cast_nullable_to_non_nullable
as String?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,fieldsId: freezed == fieldsId ? _self.fieldsId : fieldsId // ignore: cast_nullable_to_non_nullable
as String?,documentTemplate: freezed == documentTemplate ? _self.documentTemplate : documentTemplate // ignore: cast_nullable_to_non_nullable
as String?,labelTemplate: freezed == labelTemplate ? _self.labelTemplate : labelTemplate // ignore: cast_nullable_to_non_nullable
as String?,actionReportId: freezed == actionReportId ? _self.actionReportId : actionReportId // ignore: cast_nullable_to_non_nullable
as String?,competencyId: freezed == competencyId ? _self.competencyId : competencyId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ActionReport {

@JsonKey(name: 'actionReportID')@SafeStringConverter() String? get actionReportId;@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? get reportTypeId;@SafeStringConverter() String? get description;@SafeBoolConverter() bool? get isArchive;@SafeStringConverter() String? get applyAction;@SafeStringConverter() String? get match;@SafeStringConverter() String? get actionType;@SafeStringConverter() String? get sourceTable;@SafeStringConverter() String? get sourceField;@SafeStringConverter() String? get destinationTable;@SafeStringConverter() String? get destinationField;@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of ActionReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionReportCopyWith<ActionReport> get copyWith => _$ActionReportCopyWithImpl<ActionReport>(this as ActionReport, _$identity);

  /// Serializes this ActionReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionReport&&(identical(other.actionReportId, actionReportId) || other.actionReportId == actionReportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive)&&(identical(other.applyAction, applyAction) || other.applyAction == applyAction)&&(identical(other.match, match) || other.match == match)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.sourceTable, sourceTable) || other.sourceTable == sourceTable)&&(identical(other.sourceField, sourceField) || other.sourceField == sourceField)&&(identical(other.destinationTable, destinationTable) || other.destinationTable == destinationTable)&&(identical(other.destinationField, destinationField) || other.destinationField == destinationField)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionReportId,reportTypeId,description,isArchive,applyAction,match,actionType,sourceTable,sourceField,destinationTable,destinationField,createdAt,updatedAt);

@override
String toString() {
  return 'ActionReport(actionReportId: $actionReportId, reportTypeId: $reportTypeId, description: $description, isArchive: $isArchive, applyAction: $applyAction, match: $match, actionType: $actionType, sourceTable: $sourceTable, sourceField: $sourceField, destinationTable: $destinationTable, destinationField: $destinationField, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ActionReportCopyWith<$Res>  {
  factory $ActionReportCopyWith(ActionReport value, $Res Function(ActionReport) _then) = _$ActionReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'actionReportID')@SafeStringConverter() String? actionReportId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? description,@SafeBoolConverter() bool? isArchive,@SafeStringConverter() String? applyAction,@SafeStringConverter() String? match,@SafeStringConverter() String? actionType,@SafeStringConverter() String? sourceTable,@SafeStringConverter() String? sourceField,@SafeStringConverter() String? destinationTable,@SafeStringConverter() String? destinationField,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$ActionReportCopyWithImpl<$Res>
    implements $ActionReportCopyWith<$Res> {
  _$ActionReportCopyWithImpl(this._self, this._then);

  final ActionReport _self;
  final $Res Function(ActionReport) _then;

/// Create a copy of ActionReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionReportId = freezed,Object? reportTypeId = freezed,Object? description = freezed,Object? isArchive = freezed,Object? applyAction = freezed,Object? match = freezed,Object? actionType = freezed,Object? sourceTable = freezed,Object? sourceField = freezed,Object? destinationTable = freezed,Object? destinationField = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
actionReportId: freezed == actionReportId ? _self.actionReportId : actionReportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isArchive: freezed == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool?,applyAction: freezed == applyAction ? _self.applyAction : applyAction // ignore: cast_nullable_to_non_nullable
as String?,match: freezed == match ? _self.match : match // ignore: cast_nullable_to_non_nullable
as String?,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String?,sourceTable: freezed == sourceTable ? _self.sourceTable : sourceTable // ignore: cast_nullable_to_non_nullable
as String?,sourceField: freezed == sourceField ? _self.sourceField : sourceField // ignore: cast_nullable_to_non_nullable
as String?,destinationTable: freezed == destinationTable ? _self.destinationTable : destinationTable // ignore: cast_nullable_to_non_nullable
as String?,destinationField: freezed == destinationField ? _self.destinationField : destinationField // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionReport].
extension ActionReportPatterns on ActionReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionReport value)  $default,){
final _that = this;
switch (_that) {
case _ActionReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionReport value)?  $default,){
final _that = this;
switch (_that) {
case _ActionReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'actionReportID')@SafeStringConverter()  String? actionReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? description, @SafeBoolConverter()  bool? isArchive, @SafeStringConverter()  String? applyAction, @SafeStringConverter()  String? match, @SafeStringConverter()  String? actionType, @SafeStringConverter()  String? sourceTable, @SafeStringConverter()  String? sourceField, @SafeStringConverter()  String? destinationTable, @SafeStringConverter()  String? destinationField, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionReport() when $default != null:
return $default(_that.actionReportId,_that.reportTypeId,_that.description,_that.isArchive,_that.applyAction,_that.match,_that.actionType,_that.sourceTable,_that.sourceField,_that.destinationTable,_that.destinationField,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'actionReportID')@SafeStringConverter()  String? actionReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? description, @SafeBoolConverter()  bool? isArchive, @SafeStringConverter()  String? applyAction, @SafeStringConverter()  String? match, @SafeStringConverter()  String? actionType, @SafeStringConverter()  String? sourceTable, @SafeStringConverter()  String? sourceField, @SafeStringConverter()  String? destinationTable, @SafeStringConverter()  String? destinationField, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ActionReport():
return $default(_that.actionReportId,_that.reportTypeId,_that.description,_that.isArchive,_that.applyAction,_that.match,_that.actionType,_that.sourceTable,_that.sourceField,_that.destinationTable,_that.destinationField,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'actionReportID')@SafeStringConverter()  String? actionReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? description, @SafeBoolConverter()  bool? isArchive, @SafeStringConverter()  String? applyAction, @SafeStringConverter()  String? match, @SafeStringConverter()  String? actionType, @SafeStringConverter()  String? sourceTable, @SafeStringConverter()  String? sourceField, @SafeStringConverter()  String? destinationTable, @SafeStringConverter()  String? destinationField, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ActionReport() when $default != null:
return $default(_that.actionReportId,_that.reportTypeId,_that.description,_that.isArchive,_that.applyAction,_that.match,_that.actionType,_that.sourceTable,_that.sourceField,_that.destinationTable,_that.destinationField,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionReport implements ActionReport {
  const _ActionReport({@JsonKey(name: 'actionReportID')@SafeStringConverter() this.actionReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter() this.reportTypeId, @SafeStringConverter() this.description, @SafeBoolConverter() this.isArchive, @SafeStringConverter() this.applyAction, @SafeStringConverter() this.match, @SafeStringConverter() this.actionType, @SafeStringConverter() this.sourceTable, @SafeStringConverter() this.sourceField, @SafeStringConverter() this.destinationTable, @SafeStringConverter() this.destinationField, @JsonKey(name: 'created_at')@SafeDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter() this.updatedAt});
  factory _ActionReport.fromJson(Map<String, dynamic> json) => _$ActionReportFromJson(json);

@override@JsonKey(name: 'actionReportID')@SafeStringConverter() final  String? actionReportId;
@override@JsonKey(name: 'reportTypeID')@SafeStringConverter() final  String? reportTypeId;
@override@SafeStringConverter() final  String? description;
@override@SafeBoolConverter() final  bool? isArchive;
@override@SafeStringConverter() final  String? applyAction;
@override@SafeStringConverter() final  String? match;
@override@SafeStringConverter() final  String? actionType;
@override@SafeStringConverter() final  String? sourceTable;
@override@SafeStringConverter() final  String? sourceField;
@override@SafeStringConverter() final  String? destinationTable;
@override@SafeStringConverter() final  String? destinationField;
@override@JsonKey(name: 'created_at')@SafeDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@SafeDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of ActionReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionReportCopyWith<_ActionReport> get copyWith => __$ActionReportCopyWithImpl<_ActionReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionReport&&(identical(other.actionReportId, actionReportId) || other.actionReportId == actionReportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive)&&(identical(other.applyAction, applyAction) || other.applyAction == applyAction)&&(identical(other.match, match) || other.match == match)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.sourceTable, sourceTable) || other.sourceTable == sourceTable)&&(identical(other.sourceField, sourceField) || other.sourceField == sourceField)&&(identical(other.destinationTable, destinationTable) || other.destinationTable == destinationTable)&&(identical(other.destinationField, destinationField) || other.destinationField == destinationField)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionReportId,reportTypeId,description,isArchive,applyAction,match,actionType,sourceTable,sourceField,destinationTable,destinationField,createdAt,updatedAt);

@override
String toString() {
  return 'ActionReport(actionReportId: $actionReportId, reportTypeId: $reportTypeId, description: $description, isArchive: $isArchive, applyAction: $applyAction, match: $match, actionType: $actionType, sourceTable: $sourceTable, sourceField: $sourceField, destinationTable: $destinationTable, destinationField: $destinationField, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ActionReportCopyWith<$Res> implements $ActionReportCopyWith<$Res> {
  factory _$ActionReportCopyWith(_ActionReport value, $Res Function(_ActionReport) _then) = __$ActionReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'actionReportID')@SafeStringConverter() String? actionReportId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? description,@SafeBoolConverter() bool? isArchive,@SafeStringConverter() String? applyAction,@SafeStringConverter() String? match,@SafeStringConverter() String? actionType,@SafeStringConverter() String? sourceTable,@SafeStringConverter() String? sourceField,@SafeStringConverter() String? destinationTable,@SafeStringConverter() String? destinationField,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$ActionReportCopyWithImpl<$Res>
    implements _$ActionReportCopyWith<$Res> {
  __$ActionReportCopyWithImpl(this._self, this._then);

  final _ActionReport _self;
  final $Res Function(_ActionReport) _then;

/// Create a copy of ActionReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionReportId = freezed,Object? reportTypeId = freezed,Object? description = freezed,Object? isArchive = freezed,Object? applyAction = freezed,Object? match = freezed,Object? actionType = freezed,Object? sourceTable = freezed,Object? sourceField = freezed,Object? destinationTable = freezed,Object? destinationField = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ActionReport(
actionReportId: freezed == actionReportId ? _self.actionReportId : actionReportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isArchive: freezed == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool?,applyAction: freezed == applyAction ? _self.applyAction : applyAction // ignore: cast_nullable_to_non_nullable
as String?,match: freezed == match ? _self.match : match // ignore: cast_nullable_to_non_nullable
as String?,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String?,sourceTable: freezed == sourceTable ? _self.sourceTable : sourceTable // ignore: cast_nullable_to_non_nullable
as String?,sourceField: freezed == sourceField ? _self.sourceField : sourceField // ignore: cast_nullable_to_non_nullable
as String?,destinationTable: freezed == destinationTable ? _self.destinationTable : destinationTable // ignore: cast_nullable_to_non_nullable
as String?,destinationField: freezed == destinationField ? _self.destinationField : destinationField // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CompetencyReport {

@JsonKey(name: 'competencyReportID')@SafeStringConverter() String? get competencyReportId;@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? get reportTypeId;@SafeStringConverter() String? get internalExternal;@SafeStringConverter() String? get name;@SafeBoolConverter() bool? get canCreate;@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of CompetencyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompetencyReportCopyWith<CompetencyReport> get copyWith => _$CompetencyReportCopyWithImpl<CompetencyReport>(this as CompetencyReport, _$identity);

  /// Serializes this CompetencyReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetencyReport&&(identical(other.competencyReportId, competencyReportId) || other.competencyReportId == competencyReportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.internalExternal, internalExternal) || other.internalExternal == internalExternal)&&(identical(other.name, name) || other.name == name)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,competencyReportId,reportTypeId,internalExternal,name,canCreate,createdAt,updatedAt);

@override
String toString() {
  return 'CompetencyReport(competencyReportId: $competencyReportId, reportTypeId: $reportTypeId, internalExternal: $internalExternal, name: $name, canCreate: $canCreate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CompetencyReportCopyWith<$Res>  {
  factory $CompetencyReportCopyWith(CompetencyReport value, $Res Function(CompetencyReport) _then) = _$CompetencyReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'competencyReportID')@SafeStringConverter() String? competencyReportId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? internalExternal,@SafeStringConverter() String? name,@SafeBoolConverter() bool? canCreate,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$CompetencyReportCopyWithImpl<$Res>
    implements $CompetencyReportCopyWith<$Res> {
  _$CompetencyReportCopyWithImpl(this._self, this._then);

  final CompetencyReport _self;
  final $Res Function(CompetencyReport) _then;

/// Create a copy of CompetencyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? competencyReportId = freezed,Object? reportTypeId = freezed,Object? internalExternal = freezed,Object? name = freezed,Object? canCreate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
competencyReportId: freezed == competencyReportId ? _self.competencyReportId : competencyReportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,internalExternal: freezed == internalExternal ? _self.internalExternal : internalExternal // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,canCreate: freezed == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CompetencyReport].
extension CompetencyReportPatterns on CompetencyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompetencyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompetencyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompetencyReport value)  $default,){
final _that = this;
switch (_that) {
case _CompetencyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompetencyReport value)?  $default,){
final _that = this;
switch (_that) {
case _CompetencyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'competencyReportID')@SafeStringConverter()  String? competencyReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? internalExternal, @SafeStringConverter()  String? name, @SafeBoolConverter()  bool? canCreate, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompetencyReport() when $default != null:
return $default(_that.competencyReportId,_that.reportTypeId,_that.internalExternal,_that.name,_that.canCreate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'competencyReportID')@SafeStringConverter()  String? competencyReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? internalExternal, @SafeStringConverter()  String? name, @SafeBoolConverter()  bool? canCreate, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CompetencyReport():
return $default(_that.competencyReportId,_that.reportTypeId,_that.internalExternal,_that.name,_that.canCreate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'competencyReportID')@SafeStringConverter()  String? competencyReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? internalExternal, @SafeStringConverter()  String? name, @SafeBoolConverter()  bool? canCreate, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CompetencyReport() when $default != null:
return $default(_that.competencyReportId,_that.reportTypeId,_that.internalExternal,_that.name,_that.canCreate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompetencyReport implements CompetencyReport {
  const _CompetencyReport({@JsonKey(name: 'competencyReportID')@SafeStringConverter() this.competencyReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter() this.reportTypeId, @SafeStringConverter() this.internalExternal, @SafeStringConverter() this.name, @SafeBoolConverter() this.canCreate, @JsonKey(name: 'created_at')@SafeDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter() this.updatedAt});
  factory _CompetencyReport.fromJson(Map<String, dynamic> json) => _$CompetencyReportFromJson(json);

@override@JsonKey(name: 'competencyReportID')@SafeStringConverter() final  String? competencyReportId;
@override@JsonKey(name: 'reportTypeID')@SafeStringConverter() final  String? reportTypeId;
@override@SafeStringConverter() final  String? internalExternal;
@override@SafeStringConverter() final  String? name;
@override@SafeBoolConverter() final  bool? canCreate;
@override@JsonKey(name: 'created_at')@SafeDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@SafeDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of CompetencyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompetencyReportCopyWith<_CompetencyReport> get copyWith => __$CompetencyReportCopyWithImpl<_CompetencyReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompetencyReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetencyReport&&(identical(other.competencyReportId, competencyReportId) || other.competencyReportId == competencyReportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.internalExternal, internalExternal) || other.internalExternal == internalExternal)&&(identical(other.name, name) || other.name == name)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,competencyReportId,reportTypeId,internalExternal,name,canCreate,createdAt,updatedAt);

@override
String toString() {
  return 'CompetencyReport(competencyReportId: $competencyReportId, reportTypeId: $reportTypeId, internalExternal: $internalExternal, name: $name, canCreate: $canCreate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CompetencyReportCopyWith<$Res> implements $CompetencyReportCopyWith<$Res> {
  factory _$CompetencyReportCopyWith(_CompetencyReport value, $Res Function(_CompetencyReport) _then) = __$CompetencyReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'competencyReportID')@SafeStringConverter() String? competencyReportId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? internalExternal,@SafeStringConverter() String? name,@SafeBoolConverter() bool? canCreate,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$CompetencyReportCopyWithImpl<$Res>
    implements _$CompetencyReportCopyWith<$Res> {
  __$CompetencyReportCopyWithImpl(this._self, this._then);

  final _CompetencyReport _self;
  final $Res Function(_CompetencyReport) _then;

/// Create a copy of CompetencyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? competencyReportId = freezed,Object? reportTypeId = freezed,Object? internalExternal = freezed,Object? name = freezed,Object? canCreate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CompetencyReport(
competencyReportId: freezed == competencyReportId ? _self.competencyReportId : competencyReportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,internalExternal: freezed == internalExternal ? _self.internalExternal : internalExternal // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,canCreate: freezed == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ReportField {

@JsonKey(name: 'reportFieldID')@SafeStringConverter() String? get reportFieldId;@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? get reportTypeId;@SafeStringConverter() String? get labelText;@SafeStringConverter() String? get name;@SafeStringConverter() String? get fieldType; dynamic get defaultValue;@SafeStringConverter() String? get section;@SafeStringConverter() String? get onlyAvailable;@SafeBoolConverter() bool? get isRequired;@SafeStringConverter() String? get permissionField;@SafeBoolConverter() bool? get doNotCopy;@SafeStringConverter() String? get infoText;@SafeBoolConverter() bool? get isArchive;@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of ReportField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportFieldCopyWith<ReportField> get copyWith => _$ReportFieldCopyWithImpl<ReportField>(this as ReportField, _$identity);

  /// Serializes this ReportField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportField&&(identical(other.reportFieldId, reportFieldId) || other.reportFieldId == reportFieldId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.section, section) || other.section == section)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.permissionField, permissionField) || other.permissionField == permissionField)&&(identical(other.doNotCopy, doNotCopy) || other.doNotCopy == doNotCopy)&&(identical(other.infoText, infoText) || other.infoText == infoText)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportFieldId,reportTypeId,labelText,name,fieldType,const DeepCollectionEquality().hash(defaultValue),section,onlyAvailable,isRequired,permissionField,doNotCopy,infoText,isArchive,createdAt,updatedAt);

@override
String toString() {
  return 'ReportField(reportFieldId: $reportFieldId, reportTypeId: $reportTypeId, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, section: $section, onlyAvailable: $onlyAvailable, isRequired: $isRequired, permissionField: $permissionField, doNotCopy: $doNotCopy, infoText: $infoText, isArchive: $isArchive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReportFieldCopyWith<$Res>  {
  factory $ReportFieldCopyWith(ReportField value, $Res Function(ReportField) _then) = _$ReportFieldCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reportFieldID')@SafeStringConverter() String? reportFieldId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? labelText,@SafeStringConverter() String? name,@SafeStringConverter() String? fieldType, dynamic defaultValue,@SafeStringConverter() String? section,@SafeStringConverter() String? onlyAvailable,@SafeBoolConverter() bool? isRequired,@SafeStringConverter() String? permissionField,@SafeBoolConverter() bool? doNotCopy,@SafeStringConverter() String? infoText,@SafeBoolConverter() bool? isArchive,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$ReportFieldCopyWithImpl<$Res>
    implements $ReportFieldCopyWith<$Res> {
  _$ReportFieldCopyWithImpl(this._self, this._then);

  final ReportField _self;
  final $Res Function(ReportField) _then;

/// Create a copy of ReportField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportFieldId = freezed,Object? reportTypeId = freezed,Object? labelText = freezed,Object? name = freezed,Object? fieldType = freezed,Object? defaultValue = freezed,Object? section = freezed,Object? onlyAvailable = freezed,Object? isRequired = freezed,Object? permissionField = freezed,Object? doNotCopy = freezed,Object? infoText = freezed,Object? isArchive = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
reportFieldId: freezed == reportFieldId ? _self.reportFieldId : reportFieldId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,labelText: freezed == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,fieldType: freezed == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,onlyAvailable: freezed == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,permissionField: freezed == permissionField ? _self.permissionField : permissionField // ignore: cast_nullable_to_non_nullable
as String?,doNotCopy: freezed == doNotCopy ? _self.doNotCopy : doNotCopy // ignore: cast_nullable_to_non_nullable
as bool?,infoText: freezed == infoText ? _self.infoText : infoText // ignore: cast_nullable_to_non_nullable
as String?,isArchive: freezed == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportField].
extension ReportFieldPatterns on ReportField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportField value)  $default,){
final _that = this;
switch (_that) {
case _ReportField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportField value)?  $default,){
final _that = this;
switch (_that) {
case _ReportField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportFieldID')@SafeStringConverter()  String? reportFieldId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? labelText, @SafeStringConverter()  String? name, @SafeStringConverter()  String? fieldType,  dynamic defaultValue, @SafeStringConverter()  String? section, @SafeStringConverter()  String? onlyAvailable, @SafeBoolConverter()  bool? isRequired, @SafeStringConverter()  String? permissionField, @SafeBoolConverter()  bool? doNotCopy, @SafeStringConverter()  String? infoText, @SafeBoolConverter()  bool? isArchive, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportField() when $default != null:
return $default(_that.reportFieldId,_that.reportTypeId,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.section,_that.onlyAvailable,_that.isRequired,_that.permissionField,_that.doNotCopy,_that.infoText,_that.isArchive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportFieldID')@SafeStringConverter()  String? reportFieldId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? labelText, @SafeStringConverter()  String? name, @SafeStringConverter()  String? fieldType,  dynamic defaultValue, @SafeStringConverter()  String? section, @SafeStringConverter()  String? onlyAvailable, @SafeBoolConverter()  bool? isRequired, @SafeStringConverter()  String? permissionField, @SafeBoolConverter()  bool? doNotCopy, @SafeStringConverter()  String? infoText, @SafeBoolConverter()  bool? isArchive, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReportField():
return $default(_that.reportFieldId,_that.reportTypeId,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.section,_that.onlyAvailable,_that.isRequired,_that.permissionField,_that.doNotCopy,_that.infoText,_that.isArchive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reportFieldID')@SafeStringConverter()  String? reportFieldId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? labelText, @SafeStringConverter()  String? name, @SafeStringConverter()  String? fieldType,  dynamic defaultValue, @SafeStringConverter()  String? section, @SafeStringConverter()  String? onlyAvailable, @SafeBoolConverter()  bool? isRequired, @SafeStringConverter()  String? permissionField, @SafeBoolConverter()  bool? doNotCopy, @SafeStringConverter()  String? infoText, @SafeBoolConverter()  bool? isArchive, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReportField() when $default != null:
return $default(_that.reportFieldId,_that.reportTypeId,_that.labelText,_that.name,_that.fieldType,_that.defaultValue,_that.section,_that.onlyAvailable,_that.isRequired,_that.permissionField,_that.doNotCopy,_that.infoText,_that.isArchive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportField implements ReportField {
  const _ReportField({@JsonKey(name: 'reportFieldID')@SafeStringConverter() this.reportFieldId, @JsonKey(name: 'reportTypeID')@SafeStringConverter() this.reportTypeId, @SafeStringConverter() this.labelText, @SafeStringConverter() this.name, @SafeStringConverter() this.fieldType, this.defaultValue, @SafeStringConverter() this.section, @SafeStringConverter() this.onlyAvailable, @SafeBoolConverter() this.isRequired, @SafeStringConverter() this.permissionField, @SafeBoolConverter() this.doNotCopy, @SafeStringConverter() this.infoText, @SafeBoolConverter() this.isArchive, @JsonKey(name: 'created_at')@SafeDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter() this.updatedAt});
  factory _ReportField.fromJson(Map<String, dynamic> json) => _$ReportFieldFromJson(json);

@override@JsonKey(name: 'reportFieldID')@SafeStringConverter() final  String? reportFieldId;
@override@JsonKey(name: 'reportTypeID')@SafeStringConverter() final  String? reportTypeId;
@override@SafeStringConverter() final  String? labelText;
@override@SafeStringConverter() final  String? name;
@override@SafeStringConverter() final  String? fieldType;
@override final  dynamic defaultValue;
@override@SafeStringConverter() final  String? section;
@override@SafeStringConverter() final  String? onlyAvailable;
@override@SafeBoolConverter() final  bool? isRequired;
@override@SafeStringConverter() final  String? permissionField;
@override@SafeBoolConverter() final  bool? doNotCopy;
@override@SafeStringConverter() final  String? infoText;
@override@SafeBoolConverter() final  bool? isArchive;
@override@JsonKey(name: 'created_at')@SafeDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@SafeDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of ReportField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportFieldCopyWith<_ReportField> get copyWith => __$ReportFieldCopyWithImpl<_ReportField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportField&&(identical(other.reportFieldId, reportFieldId) || other.reportFieldId == reportFieldId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.labelText, labelText) || other.labelText == labelText)&&(identical(other.name, name) || other.name == name)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.section, section) || other.section == section)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.permissionField, permissionField) || other.permissionField == permissionField)&&(identical(other.doNotCopy, doNotCopy) || other.doNotCopy == doNotCopy)&&(identical(other.infoText, infoText) || other.infoText == infoText)&&(identical(other.isArchive, isArchive) || other.isArchive == isArchive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportFieldId,reportTypeId,labelText,name,fieldType,const DeepCollectionEquality().hash(defaultValue),section,onlyAvailable,isRequired,permissionField,doNotCopy,infoText,isArchive,createdAt,updatedAt);

@override
String toString() {
  return 'ReportField(reportFieldId: $reportFieldId, reportTypeId: $reportTypeId, labelText: $labelText, name: $name, fieldType: $fieldType, defaultValue: $defaultValue, section: $section, onlyAvailable: $onlyAvailable, isRequired: $isRequired, permissionField: $permissionField, doNotCopy: $doNotCopy, infoText: $infoText, isArchive: $isArchive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReportFieldCopyWith<$Res> implements $ReportFieldCopyWith<$Res> {
  factory _$ReportFieldCopyWith(_ReportField value, $Res Function(_ReportField) _then) = __$ReportFieldCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reportFieldID')@SafeStringConverter() String? reportFieldId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? labelText,@SafeStringConverter() String? name,@SafeStringConverter() String? fieldType, dynamic defaultValue,@SafeStringConverter() String? section,@SafeStringConverter() String? onlyAvailable,@SafeBoolConverter() bool? isRequired,@SafeStringConverter() String? permissionField,@SafeBoolConverter() bool? doNotCopy,@SafeStringConverter() String? infoText,@SafeBoolConverter() bool? isArchive,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$ReportFieldCopyWithImpl<$Res>
    implements _$ReportFieldCopyWith<$Res> {
  __$ReportFieldCopyWithImpl(this._self, this._then);

  final _ReportField _self;
  final $Res Function(_ReportField) _then;

/// Create a copy of ReportField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportFieldId = freezed,Object? reportTypeId = freezed,Object? labelText = freezed,Object? name = freezed,Object? fieldType = freezed,Object? defaultValue = freezed,Object? section = freezed,Object? onlyAvailable = freezed,Object? isRequired = freezed,Object? permissionField = freezed,Object? doNotCopy = freezed,Object? infoText = freezed,Object? isArchive = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ReportField(
reportFieldId: freezed == reportFieldId ? _self.reportFieldId : reportFieldId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,labelText: freezed == labelText ? _self.labelText : labelText // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,fieldType: freezed == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as String?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,onlyAvailable: freezed == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,permissionField: freezed == permissionField ? _self.permissionField : permissionField // ignore: cast_nullable_to_non_nullable
as String?,doNotCopy: freezed == doNotCopy ? _self.doNotCopy : doNotCopy // ignore: cast_nullable_to_non_nullable
as bool?,infoText: freezed == infoText ? _self.infoText : infoText // ignore: cast_nullable_to_non_nullable
as String?,isArchive: freezed == isArchive ? _self.isArchive : isArchive // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DefaultValueClass {

@SafeIntConverter() int? get max;@SafeIntConverter() int? get min;@SafeDoubleConverter() double? get step;@SafeIntConverter() int? get value;@SafeBoolConverter() bool? get isReadOnly;
/// Create a copy of DefaultValueClass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultValueClassCopyWith<DefaultValueClass> get copyWith => _$DefaultValueClassCopyWithImpl<DefaultValueClass>(this as DefaultValueClass, _$identity);

  /// Serializes this DefaultValueClass to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultValueClass&&(identical(other.max, max) || other.max == max)&&(identical(other.min, min) || other.min == min)&&(identical(other.step, step) || other.step == step)&&(identical(other.value, value) || other.value == value)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,max,min,step,value,isReadOnly);

@override
String toString() {
  return 'DefaultValueClass(max: $max, min: $min, step: $step, value: $value, isReadOnly: $isReadOnly)';
}


}

/// @nodoc
abstract mixin class $DefaultValueClassCopyWith<$Res>  {
  factory $DefaultValueClassCopyWith(DefaultValueClass value, $Res Function(DefaultValueClass) _then) = _$DefaultValueClassCopyWithImpl;
@useResult
$Res call({
@SafeIntConverter() int? max,@SafeIntConverter() int? min,@SafeDoubleConverter() double? step,@SafeIntConverter() int? value,@SafeBoolConverter() bool? isReadOnly
});




}
/// @nodoc
class _$DefaultValueClassCopyWithImpl<$Res>
    implements $DefaultValueClassCopyWith<$Res> {
  _$DefaultValueClassCopyWithImpl(this._self, this._then);

  final DefaultValueClass _self;
  final $Res Function(DefaultValueClass) _then;

/// Create a copy of DefaultValueClass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? max = freezed,Object? min = freezed,Object? step = freezed,Object? value = freezed,Object? isReadOnly = freezed,}) {
  return _then(_self.copyWith(
max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int?,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int?,step: freezed == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as double?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int?,isReadOnly: freezed == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [DefaultValueClass].
extension DefaultValueClassPatterns on DefaultValueClass {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DefaultValueClass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DefaultValueClass() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DefaultValueClass value)  $default,){
final _that = this;
switch (_that) {
case _DefaultValueClass():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DefaultValueClass value)?  $default,){
final _that = this;
switch (_that) {
case _DefaultValueClass() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@SafeIntConverter()  int? max, @SafeIntConverter()  int? min, @SafeDoubleConverter()  double? step, @SafeIntConverter()  int? value, @SafeBoolConverter()  bool? isReadOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DefaultValueClass() when $default != null:
return $default(_that.max,_that.min,_that.step,_that.value,_that.isReadOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@SafeIntConverter()  int? max, @SafeIntConverter()  int? min, @SafeDoubleConverter()  double? step, @SafeIntConverter()  int? value, @SafeBoolConverter()  bool? isReadOnly)  $default,) {final _that = this;
switch (_that) {
case _DefaultValueClass():
return $default(_that.max,_that.min,_that.step,_that.value,_that.isReadOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@SafeIntConverter()  int? max, @SafeIntConverter()  int? min, @SafeDoubleConverter()  double? step, @SafeIntConverter()  int? value, @SafeBoolConverter()  bool? isReadOnly)?  $default,) {final _that = this;
switch (_that) {
case _DefaultValueClass() when $default != null:
return $default(_that.max,_that.min,_that.step,_that.value,_that.isReadOnly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DefaultValueClass implements DefaultValueClass {
  const _DefaultValueClass({@SafeIntConverter() this.max, @SafeIntConverter() this.min, @SafeDoubleConverter() this.step, @SafeIntConverter() this.value, @SafeBoolConverter() this.isReadOnly});
  factory _DefaultValueClass.fromJson(Map<String, dynamic> json) => _$DefaultValueClassFromJson(json);

@override@SafeIntConverter() final  int? max;
@override@SafeIntConverter() final  int? min;
@override@SafeDoubleConverter() final  double? step;
@override@SafeIntConverter() final  int? value;
@override@SafeBoolConverter() final  bool? isReadOnly;

/// Create a copy of DefaultValueClass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DefaultValueClassCopyWith<_DefaultValueClass> get copyWith => __$DefaultValueClassCopyWithImpl<_DefaultValueClass>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DefaultValueClassToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DefaultValueClass&&(identical(other.max, max) || other.max == max)&&(identical(other.min, min) || other.min == min)&&(identical(other.step, step) || other.step == step)&&(identical(other.value, value) || other.value == value)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,max,min,step,value,isReadOnly);

@override
String toString() {
  return 'DefaultValueClass(max: $max, min: $min, step: $step, value: $value, isReadOnly: $isReadOnly)';
}


}

/// @nodoc
abstract mixin class _$DefaultValueClassCopyWith<$Res> implements $DefaultValueClassCopyWith<$Res> {
  factory _$DefaultValueClassCopyWith(_DefaultValueClass value, $Res Function(_DefaultValueClass) _then) = __$DefaultValueClassCopyWithImpl;
@override @useResult
$Res call({
@SafeIntConverter() int? max,@SafeIntConverter() int? min,@SafeDoubleConverter() double? step,@SafeIntConverter() int? value,@SafeBoolConverter() bool? isReadOnly
});




}
/// @nodoc
class __$DefaultValueClassCopyWithImpl<$Res>
    implements _$DefaultValueClassCopyWith<$Res> {
  __$DefaultValueClassCopyWithImpl(this._self, this._then);

  final _DefaultValueClass _self;
  final $Res Function(_DefaultValueClass) _then;

/// Create a copy of DefaultValueClass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? max = freezed,Object? min = freezed,Object? step = freezed,Object? value = freezed,Object? isReadOnly = freezed,}) {
  return _then(_DefaultValueClass(
max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int?,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int?,step: freezed == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as double?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int?,isReadOnly: freezed == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$ReportTypeDate {

@JsonKey(name: 'reportTypeDateID')@SafeStringConverter() String? get reportTypeDateId;@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? get reportTypeId;@SafeStringConverter() String? get name;@SafeStringConverter() String? get applyCycle;@SafeBoolConverter() bool? get isRequired;@SafeBoolConverter() bool? get disableFreeType;@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of ReportTypeDate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportTypeDateCopyWith<ReportTypeDate> get copyWith => _$ReportTypeDateCopyWithImpl<ReportTypeDate>(this as ReportTypeDate, _$identity);

  /// Serializes this ReportTypeDate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportTypeDate&&(identical(other.reportTypeDateId, reportTypeDateId) || other.reportTypeDateId == reportTypeDateId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.applyCycle, applyCycle) || other.applyCycle == applyCycle)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.disableFreeType, disableFreeType) || other.disableFreeType == disableFreeType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportTypeDateId,reportTypeId,name,applyCycle,isRequired,disableFreeType,createdAt,updatedAt);

@override
String toString() {
  return 'ReportTypeDate(reportTypeDateId: $reportTypeDateId, reportTypeId: $reportTypeId, name: $name, applyCycle: $applyCycle, isRequired: $isRequired, disableFreeType: $disableFreeType, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReportTypeDateCopyWith<$Res>  {
  factory $ReportTypeDateCopyWith(ReportTypeDate value, $Res Function(ReportTypeDate) _then) = _$ReportTypeDateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reportTypeDateID')@SafeStringConverter() String? reportTypeDateId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? name,@SafeStringConverter() String? applyCycle,@SafeBoolConverter() bool? isRequired,@SafeBoolConverter() bool? disableFreeType,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$ReportTypeDateCopyWithImpl<$Res>
    implements $ReportTypeDateCopyWith<$Res> {
  _$ReportTypeDateCopyWithImpl(this._self, this._then);

  final ReportTypeDate _self;
  final $Res Function(ReportTypeDate) _then;

/// Create a copy of ReportTypeDate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportTypeDateId = freezed,Object? reportTypeId = freezed,Object? name = freezed,Object? applyCycle = freezed,Object? isRequired = freezed,Object? disableFreeType = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
reportTypeDateId: freezed == reportTypeDateId ? _self.reportTypeDateId : reportTypeDateId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,applyCycle: freezed == applyCycle ? _self.applyCycle : applyCycle // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,disableFreeType: freezed == disableFreeType ? _self.disableFreeType : disableFreeType // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportTypeDate].
extension ReportTypeDatePatterns on ReportTypeDate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportTypeDate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportTypeDate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportTypeDate value)  $default,){
final _that = this;
switch (_that) {
case _ReportTypeDate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportTypeDate value)?  $default,){
final _that = this;
switch (_that) {
case _ReportTypeDate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportTypeDateID')@SafeStringConverter()  String? reportTypeDateId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? name, @SafeStringConverter()  String? applyCycle, @SafeBoolConverter()  bool? isRequired, @SafeBoolConverter()  bool? disableFreeType, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportTypeDate() when $default != null:
return $default(_that.reportTypeDateId,_that.reportTypeId,_that.name,_that.applyCycle,_that.isRequired,_that.disableFreeType,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reportTypeDateID')@SafeStringConverter()  String? reportTypeDateId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? name, @SafeStringConverter()  String? applyCycle, @SafeBoolConverter()  bool? isRequired, @SafeBoolConverter()  bool? disableFreeType, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReportTypeDate():
return $default(_that.reportTypeDateId,_that.reportTypeId,_that.name,_that.applyCycle,_that.isRequired,_that.disableFreeType,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reportTypeDateID')@SafeStringConverter()  String? reportTypeDateId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? name, @SafeStringConverter()  String? applyCycle, @SafeBoolConverter()  bool? isRequired, @SafeBoolConverter()  bool? disableFreeType, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReportTypeDate() when $default != null:
return $default(_that.reportTypeDateId,_that.reportTypeId,_that.name,_that.applyCycle,_that.isRequired,_that.disableFreeType,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportTypeDate implements ReportTypeDate {
  const _ReportTypeDate({@JsonKey(name: 'reportTypeDateID')@SafeStringConverter() this.reportTypeDateId, @JsonKey(name: 'reportTypeID')@SafeStringConverter() this.reportTypeId, @SafeStringConverter() this.name, @SafeStringConverter() this.applyCycle, @SafeBoolConverter() this.isRequired, @SafeBoolConverter() this.disableFreeType, @JsonKey(name: 'created_at')@SafeDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter() this.updatedAt});
  factory _ReportTypeDate.fromJson(Map<String, dynamic> json) => _$ReportTypeDateFromJson(json);

@override@JsonKey(name: 'reportTypeDateID')@SafeStringConverter() final  String? reportTypeDateId;
@override@JsonKey(name: 'reportTypeID')@SafeStringConverter() final  String? reportTypeId;
@override@SafeStringConverter() final  String? name;
@override@SafeStringConverter() final  String? applyCycle;
@override@SafeBoolConverter() final  bool? isRequired;
@override@SafeBoolConverter() final  bool? disableFreeType;
@override@JsonKey(name: 'created_at')@SafeDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@SafeDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of ReportTypeDate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportTypeDateCopyWith<_ReportTypeDate> get copyWith => __$ReportTypeDateCopyWithImpl<_ReportTypeDate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportTypeDateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportTypeDate&&(identical(other.reportTypeDateId, reportTypeDateId) || other.reportTypeDateId == reportTypeDateId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.applyCycle, applyCycle) || other.applyCycle == applyCycle)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.disableFreeType, disableFreeType) || other.disableFreeType == disableFreeType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportTypeDateId,reportTypeId,name,applyCycle,isRequired,disableFreeType,createdAt,updatedAt);

@override
String toString() {
  return 'ReportTypeDate(reportTypeDateId: $reportTypeDateId, reportTypeId: $reportTypeId, name: $name, applyCycle: $applyCycle, isRequired: $isRequired, disableFreeType: $disableFreeType, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReportTypeDateCopyWith<$Res> implements $ReportTypeDateCopyWith<$Res> {
  factory _$ReportTypeDateCopyWith(_ReportTypeDate value, $Res Function(_ReportTypeDate) _then) = __$ReportTypeDateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reportTypeDateID')@SafeStringConverter() String? reportTypeDateId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? name,@SafeStringConverter() String? applyCycle,@SafeBoolConverter() bool? isRequired,@SafeBoolConverter() bool? disableFreeType,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$ReportTypeDateCopyWithImpl<$Res>
    implements _$ReportTypeDateCopyWith<$Res> {
  __$ReportTypeDateCopyWithImpl(this._self, this._then);

  final _ReportTypeDate _self;
  final $Res Function(_ReportTypeDate) _then;

/// Create a copy of ReportTypeDate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportTypeDateId = freezed,Object? reportTypeId = freezed,Object? name = freezed,Object? applyCycle = freezed,Object? isRequired = freezed,Object? disableFreeType = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ReportTypeDate(
reportTypeDateId: freezed == reportTypeDateId ? _self.reportTypeDateId : reportTypeDateId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,applyCycle: freezed == applyCycle ? _self.applyCycle : applyCycle // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,disableFreeType: freezed == disableFreeType ? _self.disableFreeType : disableFreeType // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StatusRuleReport {

@JsonKey(name: 'statusRuleReportID')@SafeStringConverter() String? get statusRuleReportId;@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? get reportTypeId;@SafeStringConverter() String? get status;@SafeStringConverter() String? get field;@JsonKey(name: 'operator')@SafeStringConverter() String? get statusRuleReportOperator;@SafeStringConverter() String? get value;@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? get updatedAt;
/// Create a copy of StatusRuleReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusRuleReportCopyWith<StatusRuleReport> get copyWith => _$StatusRuleReportCopyWithImpl<StatusRuleReport>(this as StatusRuleReport, _$identity);

  /// Serializes this StatusRuleReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusRuleReport&&(identical(other.statusRuleReportId, statusRuleReportId) || other.statusRuleReportId == statusRuleReportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.field, field) || other.field == field)&&(identical(other.statusRuleReportOperator, statusRuleReportOperator) || other.statusRuleReportOperator == statusRuleReportOperator)&&(identical(other.value, value) || other.value == value)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusRuleReportId,reportTypeId,status,field,statusRuleReportOperator,value,createdAt,updatedAt);

@override
String toString() {
  return 'StatusRuleReport(statusRuleReportId: $statusRuleReportId, reportTypeId: $reportTypeId, status: $status, field: $field, statusRuleReportOperator: $statusRuleReportOperator, value: $value, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StatusRuleReportCopyWith<$Res>  {
  factory $StatusRuleReportCopyWith(StatusRuleReport value, $Res Function(StatusRuleReport) _then) = _$StatusRuleReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'statusRuleReportID')@SafeStringConverter() String? statusRuleReportId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? status,@SafeStringConverter() String? field,@JsonKey(name: 'operator')@SafeStringConverter() String? statusRuleReportOperator,@SafeStringConverter() String? value,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$StatusRuleReportCopyWithImpl<$Res>
    implements $StatusRuleReportCopyWith<$Res> {
  _$StatusRuleReportCopyWithImpl(this._self, this._then);

  final StatusRuleReport _self;
  final $Res Function(StatusRuleReport) _then;

/// Create a copy of StatusRuleReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusRuleReportId = freezed,Object? reportTypeId = freezed,Object? status = freezed,Object? field = freezed,Object? statusRuleReportOperator = freezed,Object? value = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
statusRuleReportId: freezed == statusRuleReportId ? _self.statusRuleReportId : statusRuleReportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,statusRuleReportOperator: freezed == statusRuleReportOperator ? _self.statusRuleReportOperator : statusRuleReportOperator // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StatusRuleReport].
extension StatusRuleReportPatterns on StatusRuleReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatusRuleReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatusRuleReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatusRuleReport value)  $default,){
final _that = this;
switch (_that) {
case _StatusRuleReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatusRuleReport value)?  $default,){
final _that = this;
switch (_that) {
case _StatusRuleReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'statusRuleReportID')@SafeStringConverter()  String? statusRuleReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? status, @SafeStringConverter()  String? field, @JsonKey(name: 'operator')@SafeStringConverter()  String? statusRuleReportOperator, @SafeStringConverter()  String? value, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatusRuleReport() when $default != null:
return $default(_that.statusRuleReportId,_that.reportTypeId,_that.status,_that.field,_that.statusRuleReportOperator,_that.value,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'statusRuleReportID')@SafeStringConverter()  String? statusRuleReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? status, @SafeStringConverter()  String? field, @JsonKey(name: 'operator')@SafeStringConverter()  String? statusRuleReportOperator, @SafeStringConverter()  String? value, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StatusRuleReport():
return $default(_that.statusRuleReportId,_that.reportTypeId,_that.status,_that.field,_that.statusRuleReportOperator,_that.value,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'statusRuleReportID')@SafeStringConverter()  String? statusRuleReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter()  String? reportTypeId, @SafeStringConverter()  String? status, @SafeStringConverter()  String? field, @JsonKey(name: 'operator')@SafeStringConverter()  String? statusRuleReportOperator, @SafeStringConverter()  String? value, @JsonKey(name: 'created_at')@SafeDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StatusRuleReport() when $default != null:
return $default(_that.statusRuleReportId,_that.reportTypeId,_that.status,_that.field,_that.statusRuleReportOperator,_that.value,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatusRuleReport implements StatusRuleReport {
  const _StatusRuleReport({@JsonKey(name: 'statusRuleReportID')@SafeStringConverter() this.statusRuleReportId, @JsonKey(name: 'reportTypeID')@SafeStringConverter() this.reportTypeId, @SafeStringConverter() this.status, @SafeStringConverter() this.field, @JsonKey(name: 'operator')@SafeStringConverter() this.statusRuleReportOperator, @SafeStringConverter() this.value, @JsonKey(name: 'created_at')@SafeDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@SafeDateTimeConverter() this.updatedAt});
  factory _StatusRuleReport.fromJson(Map<String, dynamic> json) => _$StatusRuleReportFromJson(json);

@override@JsonKey(name: 'statusRuleReportID')@SafeStringConverter() final  String? statusRuleReportId;
@override@JsonKey(name: 'reportTypeID')@SafeStringConverter() final  String? reportTypeId;
@override@SafeStringConverter() final  String? status;
@override@SafeStringConverter() final  String? field;
@override@JsonKey(name: 'operator')@SafeStringConverter() final  String? statusRuleReportOperator;
@override@SafeStringConverter() final  String? value;
@override@JsonKey(name: 'created_at')@SafeDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@SafeDateTimeConverter() final  DateTime? updatedAt;

/// Create a copy of StatusRuleReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusRuleReportCopyWith<_StatusRuleReport> get copyWith => __$StatusRuleReportCopyWithImpl<_StatusRuleReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatusRuleReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusRuleReport&&(identical(other.statusRuleReportId, statusRuleReportId) || other.statusRuleReportId == statusRuleReportId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.field, field) || other.field == field)&&(identical(other.statusRuleReportOperator, statusRuleReportOperator) || other.statusRuleReportOperator == statusRuleReportOperator)&&(identical(other.value, value) || other.value == value)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusRuleReportId,reportTypeId,status,field,statusRuleReportOperator,value,createdAt,updatedAt);

@override
String toString() {
  return 'StatusRuleReport(statusRuleReportId: $statusRuleReportId, reportTypeId: $reportTypeId, status: $status, field: $field, statusRuleReportOperator: $statusRuleReportOperator, value: $value, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StatusRuleReportCopyWith<$Res> implements $StatusRuleReportCopyWith<$Res> {
  factory _$StatusRuleReportCopyWith(_StatusRuleReport value, $Res Function(_StatusRuleReport) _then) = __$StatusRuleReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'statusRuleReportID')@SafeStringConverter() String? statusRuleReportId,@JsonKey(name: 'reportTypeID')@SafeStringConverter() String? reportTypeId,@SafeStringConverter() String? status,@SafeStringConverter() String? field,@JsonKey(name: 'operator')@SafeStringConverter() String? statusRuleReportOperator,@SafeStringConverter() String? value,@JsonKey(name: 'created_at')@SafeDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@SafeDateTimeConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$StatusRuleReportCopyWithImpl<$Res>
    implements _$StatusRuleReportCopyWith<$Res> {
  __$StatusRuleReportCopyWithImpl(this._self, this._then);

  final _StatusRuleReport _self;
  final $Res Function(_StatusRuleReport) _then;

/// Create a copy of StatusRuleReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusRuleReportId = freezed,Object? reportTypeId = freezed,Object? status = freezed,Object? field = freezed,Object? statusRuleReportOperator = freezed,Object? value = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_StatusRuleReport(
statusRuleReportId: freezed == statusRuleReportId ? _self.statusRuleReportId : statusRuleReportId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,statusRuleReportOperator: freezed == statusRuleReportOperator ? _self.statusRuleReportOperator : statusRuleReportOperator // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
