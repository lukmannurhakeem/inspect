// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionPlanModel {

@JsonKey(name: 'planId') String get id; String get eventType; String get jobId; String? get itemId; String? get reportTypeId; String get planTitle; String get description; String get priority; DateTime? get plannedStartDate; DateTime? get plannedEndDate; int? get estimatedDuration; String get status; String get assignedTo; String get assignmentType; ChecklistItems? get checklistItems; Map<String, dynamic>? get attendees; String? get notes; PlanTags? get tags; String? get createdBy; String? get completedBy; DateTime? get completedAt; bool get isQueued; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionPlanModelCopyWith<InspectionPlanModel> get copyWith => _$InspectionPlanModelCopyWithImpl<InspectionPlanModel>(this as InspectionPlanModel, _$identity);

  /// Serializes this InspectionPlanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.planTitle, planTitle) || other.planTitle == planTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.plannedStartDate, plannedStartDate) || other.plannedStartDate == plannedStartDate)&&(identical(other.plannedEndDate, plannedEndDate) || other.plannedEndDate == plannedEndDate)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.assignmentType, assignmentType) || other.assignmentType == assignmentType)&&(identical(other.checklistItems, checklistItems) || other.checklistItems == checklistItems)&&const DeepCollectionEquality().equals(other.attendees, attendees)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.isQueued, isQueued) || other.isQueued == isQueued)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,eventType,jobId,itemId,reportTypeId,planTitle,description,priority,plannedStartDate,plannedEndDate,estimatedDuration,status,assignedTo,assignmentType,checklistItems,const DeepCollectionEquality().hash(attendees),notes,tags,createdBy,completedBy,completedAt,isQueued,createdAt,updatedAt]);

@override
String toString() {
  return 'InspectionPlanModel(id: $id, eventType: $eventType, jobId: $jobId, itemId: $itemId, reportTypeId: $reportTypeId, planTitle: $planTitle, description: $description, priority: $priority, plannedStartDate: $plannedStartDate, plannedEndDate: $plannedEndDate, estimatedDuration: $estimatedDuration, status: $status, assignedTo: $assignedTo, assignmentType: $assignmentType, checklistItems: $checklistItems, attendees: $attendees, notes: $notes, tags: $tags, createdBy: $createdBy, completedBy: $completedBy, completedAt: $completedAt, isQueued: $isQueued, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InspectionPlanModelCopyWith<$Res>  {
  factory $InspectionPlanModelCopyWith(InspectionPlanModel value, $Res Function(InspectionPlanModel) _then) = _$InspectionPlanModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'planId') String id, String eventType, String jobId, String? itemId, String? reportTypeId, String planTitle, String description, String priority, DateTime? plannedStartDate, DateTime? plannedEndDate, int? estimatedDuration, String status, String assignedTo, String assignmentType, ChecklistItems? checklistItems, Map<String, dynamic>? attendees, String? notes, PlanTags? tags, String? createdBy, String? completedBy, DateTime? completedAt, bool isQueued, DateTime? createdAt, DateTime? updatedAt
});


$ChecklistItemsCopyWith<$Res>? get checklistItems;$PlanTagsCopyWith<$Res>? get tags;

}
/// @nodoc
class _$InspectionPlanModelCopyWithImpl<$Res>
    implements $InspectionPlanModelCopyWith<$Res> {
  _$InspectionPlanModelCopyWithImpl(this._self, this._then);

  final InspectionPlanModel _self;
  final $Res Function(InspectionPlanModel) _then;

/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventType = null,Object? jobId = null,Object? itemId = freezed,Object? reportTypeId = freezed,Object? planTitle = null,Object? description = null,Object? priority = null,Object? plannedStartDate = freezed,Object? plannedEndDate = freezed,Object? estimatedDuration = freezed,Object? status = null,Object? assignedTo = null,Object? assignmentType = null,Object? checklistItems = freezed,Object? attendees = freezed,Object? notes = freezed,Object? tags = freezed,Object? createdBy = freezed,Object? completedBy = freezed,Object? completedAt = freezed,Object? isQueued = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,planTitle: null == planTitle ? _self.planTitle : planTitle // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,plannedStartDate: freezed == plannedStartDate ? _self.plannedStartDate : plannedStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedEndDate: freezed == plannedEndDate ? _self.plannedEndDate : plannedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedDuration: freezed == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,assignmentType: null == assignmentType ? _self.assignmentType : assignmentType // ignore: cast_nullable_to_non_nullable
as String,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as ChecklistItems?,attendees: freezed == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as PlanTags?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,completedBy: freezed == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isQueued: null == isQueued ? _self.isQueued : isQueued // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChecklistItemsCopyWith<$Res>? get checklistItems {
    if (_self.checklistItems == null) {
    return null;
  }

  return $ChecklistItemsCopyWith<$Res>(_self.checklistItems!, (value) {
    return _then(_self.copyWith(checklistItems: value));
  });
}/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanTagsCopyWith<$Res>? get tags {
    if (_self.tags == null) {
    return null;
  }

  return $PlanTagsCopyWith<$Res>(_self.tags!, (value) {
    return _then(_self.copyWith(tags: value));
  });
}
}


/// Adds pattern-matching-related methods to [InspectionPlanModel].
extension InspectionPlanModelPatterns on InspectionPlanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionPlanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionPlanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionPlanModel value)  $default,){
final _that = this;
switch (_that) {
case _InspectionPlanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionPlanModel value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionPlanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'planId')  String id,  String eventType,  String jobId,  String? itemId,  String? reportTypeId,  String planTitle,  String description,  String priority,  DateTime? plannedStartDate,  DateTime? plannedEndDate,  int? estimatedDuration,  String status,  String assignedTo,  String assignmentType,  ChecklistItems? checklistItems,  Map<String, dynamic>? attendees,  String? notes,  PlanTags? tags,  String? createdBy,  String? completedBy,  DateTime? completedAt,  bool isQueued,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionPlanModel() when $default != null:
return $default(_that.id,_that.eventType,_that.jobId,_that.itemId,_that.reportTypeId,_that.planTitle,_that.description,_that.priority,_that.plannedStartDate,_that.plannedEndDate,_that.estimatedDuration,_that.status,_that.assignedTo,_that.assignmentType,_that.checklistItems,_that.attendees,_that.notes,_that.tags,_that.createdBy,_that.completedBy,_that.completedAt,_that.isQueued,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'planId')  String id,  String eventType,  String jobId,  String? itemId,  String? reportTypeId,  String planTitle,  String description,  String priority,  DateTime? plannedStartDate,  DateTime? plannedEndDate,  int? estimatedDuration,  String status,  String assignedTo,  String assignmentType,  ChecklistItems? checklistItems,  Map<String, dynamic>? attendees,  String? notes,  PlanTags? tags,  String? createdBy,  String? completedBy,  DateTime? completedAt,  bool isQueued,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InspectionPlanModel():
return $default(_that.id,_that.eventType,_that.jobId,_that.itemId,_that.reportTypeId,_that.planTitle,_that.description,_that.priority,_that.plannedStartDate,_that.plannedEndDate,_that.estimatedDuration,_that.status,_that.assignedTo,_that.assignmentType,_that.checklistItems,_that.attendees,_that.notes,_that.tags,_that.createdBy,_that.completedBy,_that.completedAt,_that.isQueued,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'planId')  String id,  String eventType,  String jobId,  String? itemId,  String? reportTypeId,  String planTitle,  String description,  String priority,  DateTime? plannedStartDate,  DateTime? plannedEndDate,  int? estimatedDuration,  String status,  String assignedTo,  String assignmentType,  ChecklistItems? checklistItems,  Map<String, dynamic>? attendees,  String? notes,  PlanTags? tags,  String? createdBy,  String? completedBy,  DateTime? completedAt,  bool isQueued,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InspectionPlanModel() when $default != null:
return $default(_that.id,_that.eventType,_that.jobId,_that.itemId,_that.reportTypeId,_that.planTitle,_that.description,_that.priority,_that.plannedStartDate,_that.plannedEndDate,_that.estimatedDuration,_that.status,_that.assignedTo,_that.assignmentType,_that.checklistItems,_that.attendees,_that.notes,_that.tags,_that.createdBy,_that.completedBy,_that.completedAt,_that.isQueued,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionPlanModel implements InspectionPlanModel {
  const _InspectionPlanModel({@JsonKey(name: 'planId') this.id = '', this.eventType = 'test', this.jobId = '', this.itemId, this.reportTypeId, this.planTitle = '', this.description = '', this.priority = 'normal', this.plannedStartDate, this.plannedEndDate, this.estimatedDuration, this.status = 'pending', this.assignedTo = '', this.assignmentType = 'personnel', this.checklistItems, final  Map<String, dynamic>? attendees, this.notes, this.tags, this.createdBy, this.completedBy, this.completedAt, this.isQueued = false, this.createdAt, this.updatedAt}): _attendees = attendees;
  factory _InspectionPlanModel.fromJson(Map<String, dynamic> json) => _$InspectionPlanModelFromJson(json);

@override@JsonKey(name: 'planId') final  String id;
@override@JsonKey() final  String eventType;
@override@JsonKey() final  String jobId;
@override final  String? itemId;
@override final  String? reportTypeId;
@override@JsonKey() final  String planTitle;
@override@JsonKey() final  String description;
@override@JsonKey() final  String priority;
@override final  DateTime? plannedStartDate;
@override final  DateTime? plannedEndDate;
@override final  int? estimatedDuration;
@override@JsonKey() final  String status;
@override@JsonKey() final  String assignedTo;
@override@JsonKey() final  String assignmentType;
@override final  ChecklistItems? checklistItems;
 final  Map<String, dynamic>? _attendees;
@override Map<String, dynamic>? get attendees {
  final value = _attendees;
  if (value == null) return null;
  if (_attendees is EqualUnmodifiableMapView) return _attendees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? notes;
@override final  PlanTags? tags;
@override final  String? createdBy;
@override final  String? completedBy;
@override final  DateTime? completedAt;
@override@JsonKey() final  bool isQueued;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionPlanModelCopyWith<_InspectionPlanModel> get copyWith => __$InspectionPlanModelCopyWithImpl<_InspectionPlanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionPlanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.reportTypeId, reportTypeId) || other.reportTypeId == reportTypeId)&&(identical(other.planTitle, planTitle) || other.planTitle == planTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.plannedStartDate, plannedStartDate) || other.plannedStartDate == plannedStartDate)&&(identical(other.plannedEndDate, plannedEndDate) || other.plannedEndDate == plannedEndDate)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.assignmentType, assignmentType) || other.assignmentType == assignmentType)&&(identical(other.checklistItems, checklistItems) || other.checklistItems == checklistItems)&&const DeepCollectionEquality().equals(other._attendees, _attendees)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.isQueued, isQueued) || other.isQueued == isQueued)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,eventType,jobId,itemId,reportTypeId,planTitle,description,priority,plannedStartDate,plannedEndDate,estimatedDuration,status,assignedTo,assignmentType,checklistItems,const DeepCollectionEquality().hash(_attendees),notes,tags,createdBy,completedBy,completedAt,isQueued,createdAt,updatedAt]);

@override
String toString() {
  return 'InspectionPlanModel(id: $id, eventType: $eventType, jobId: $jobId, itemId: $itemId, reportTypeId: $reportTypeId, planTitle: $planTitle, description: $description, priority: $priority, plannedStartDate: $plannedStartDate, plannedEndDate: $plannedEndDate, estimatedDuration: $estimatedDuration, status: $status, assignedTo: $assignedTo, assignmentType: $assignmentType, checklistItems: $checklistItems, attendees: $attendees, notes: $notes, tags: $tags, createdBy: $createdBy, completedBy: $completedBy, completedAt: $completedAt, isQueued: $isQueued, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InspectionPlanModelCopyWith<$Res> implements $InspectionPlanModelCopyWith<$Res> {
  factory _$InspectionPlanModelCopyWith(_InspectionPlanModel value, $Res Function(_InspectionPlanModel) _then) = __$InspectionPlanModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'planId') String id, String eventType, String jobId, String? itemId, String? reportTypeId, String planTitle, String description, String priority, DateTime? plannedStartDate, DateTime? plannedEndDate, int? estimatedDuration, String status, String assignedTo, String assignmentType, ChecklistItems? checklistItems, Map<String, dynamic>? attendees, String? notes, PlanTags? tags, String? createdBy, String? completedBy, DateTime? completedAt, bool isQueued, DateTime? createdAt, DateTime? updatedAt
});


@override $ChecklistItemsCopyWith<$Res>? get checklistItems;@override $PlanTagsCopyWith<$Res>? get tags;

}
/// @nodoc
class __$InspectionPlanModelCopyWithImpl<$Res>
    implements _$InspectionPlanModelCopyWith<$Res> {
  __$InspectionPlanModelCopyWithImpl(this._self, this._then);

  final _InspectionPlanModel _self;
  final $Res Function(_InspectionPlanModel) _then;

/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventType = null,Object? jobId = null,Object? itemId = freezed,Object? reportTypeId = freezed,Object? planTitle = null,Object? description = null,Object? priority = null,Object? plannedStartDate = freezed,Object? plannedEndDate = freezed,Object? estimatedDuration = freezed,Object? status = null,Object? assignedTo = null,Object? assignmentType = null,Object? checklistItems = freezed,Object? attendees = freezed,Object? notes = freezed,Object? tags = freezed,Object? createdBy = freezed,Object? completedBy = freezed,Object? completedAt = freezed,Object? isQueued = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_InspectionPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,reportTypeId: freezed == reportTypeId ? _self.reportTypeId : reportTypeId // ignore: cast_nullable_to_non_nullable
as String?,planTitle: null == planTitle ? _self.planTitle : planTitle // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,plannedStartDate: freezed == plannedStartDate ? _self.plannedStartDate : plannedStartDate // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedEndDate: freezed == plannedEndDate ? _self.plannedEndDate : plannedEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedDuration: freezed == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,assignmentType: null == assignmentType ? _self.assignmentType : assignmentType // ignore: cast_nullable_to_non_nullable
as String,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as ChecklistItems?,attendees: freezed == attendees ? _self._attendees : attendees // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as PlanTags?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,completedBy: freezed == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isQueued: null == isQueued ? _self.isQueued : isQueued // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChecklistItemsCopyWith<$Res>? get checklistItems {
    if (_self.checklistItems == null) {
    return null;
  }

  return $ChecklistItemsCopyWith<$Res>(_self.checklistItems!, (value) {
    return _then(_self.copyWith(checklistItems: value));
  });
}/// Create a copy of InspectionPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanTagsCopyWith<$Res>? get tags {
    if (_self.tags == null) {
    return null;
  }

  return $PlanTagsCopyWith<$Res>(_self.tags!, (value) {
    return _then(_self.copyWith(tags: value));
  });
}
}


/// @nodoc
mixin _$ChecklistItems {

 List<String> get tasks;
/// Create a copy of ChecklistItems
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemsCopyWith<ChecklistItems> get copyWith => _$ChecklistItemsCopyWithImpl<ChecklistItems>(this as ChecklistItems, _$identity);

  /// Serializes this ChecklistItems to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItems&&const DeepCollectionEquality().equals(other.tasks, tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks));

@override
String toString() {
  return 'ChecklistItems(tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemsCopyWith<$Res>  {
  factory $ChecklistItemsCopyWith(ChecklistItems value, $Res Function(ChecklistItems) _then) = _$ChecklistItemsCopyWithImpl;
@useResult
$Res call({
 List<String> tasks
});




}
/// @nodoc
class _$ChecklistItemsCopyWithImpl<$Res>
    implements $ChecklistItemsCopyWith<$Res> {
  _$ChecklistItemsCopyWithImpl(this._self, this._then);

  final ChecklistItems _self;
  final $Res Function(ChecklistItems) _then;

/// Create a copy of ChecklistItems
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,}) {
  return _then(_self.copyWith(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistItems].
extension ChecklistItemsPatterns on ChecklistItems {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistItems value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistItems() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistItems value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistItems():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistItems value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistItems() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> tasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItems() when $default != null:
return $default(_that.tasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> tasks)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItems():
return $default(_that.tasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> tasks)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItems() when $default != null:
return $default(_that.tasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistItems implements ChecklistItems {
  const _ChecklistItems({final  List<String> tasks = const []}): _tasks = tasks;
  factory _ChecklistItems.fromJson(Map<String, dynamic> json) => _$ChecklistItemsFromJson(json);

 final  List<String> _tasks;
@override@JsonKey() List<String> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}


/// Create a copy of ChecklistItems
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistItemsCopyWith<_ChecklistItems> get copyWith => __$ChecklistItemsCopyWithImpl<_ChecklistItems>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistItemsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItems&&const DeepCollectionEquality().equals(other._tasks, _tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks));

@override
String toString() {
  return 'ChecklistItems(tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemsCopyWith<$Res> implements $ChecklistItemsCopyWith<$Res> {
  factory _$ChecklistItemsCopyWith(_ChecklistItems value, $Res Function(_ChecklistItems) _then) = __$ChecklistItemsCopyWithImpl;
@override @useResult
$Res call({
 List<String> tasks
});




}
/// @nodoc
class __$ChecklistItemsCopyWithImpl<$Res>
    implements _$ChecklistItemsCopyWith<$Res> {
  __$ChecklistItemsCopyWithImpl(this._self, this._then);

  final _ChecklistItems _self;
  final $Res Function(_ChecklistItems) _then;

/// Create a copy of ChecklistItems
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,}) {
  return _then(_ChecklistItems(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PlanTags {

 List<String> get categories;
/// Create a copy of PlanTags
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanTagsCopyWith<PlanTags> get copyWith => _$PlanTagsCopyWithImpl<PlanTags>(this as PlanTags, _$identity);

  /// Serializes this PlanTags to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanTags&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'PlanTags(categories: $categories)';
}


}

/// @nodoc
abstract mixin class $PlanTagsCopyWith<$Res>  {
  factory $PlanTagsCopyWith(PlanTags value, $Res Function(PlanTags) _then) = _$PlanTagsCopyWithImpl;
@useResult
$Res call({
 List<String> categories
});




}
/// @nodoc
class _$PlanTagsCopyWithImpl<$Res>
    implements $PlanTagsCopyWith<$Res> {
  _$PlanTagsCopyWithImpl(this._self, this._then);

  final PlanTags _self;
  final $Res Function(PlanTags) _then;

/// Create a copy of PlanTags
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanTags].
extension PlanTagsPatterns on PlanTags {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanTags value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanTags() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanTags value)  $default,){
final _that = this;
switch (_that) {
case _PlanTags():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanTags value)?  $default,){
final _that = this;
switch (_that) {
case _PlanTags() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanTags() when $default != null:
return $default(_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> categories)  $default,) {final _that = this;
switch (_that) {
case _PlanTags():
return $default(_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> categories)?  $default,) {final _that = this;
switch (_that) {
case _PlanTags() when $default != null:
return $default(_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanTags implements PlanTags {
  const _PlanTags({final  List<String> categories = const []}): _categories = categories;
  factory _PlanTags.fromJson(Map<String, dynamic> json) => _$PlanTagsFromJson(json);

 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of PlanTags
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanTagsCopyWith<_PlanTags> get copyWith => __$PlanTagsCopyWithImpl<_PlanTags>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanTagsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanTags&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'PlanTags(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$PlanTagsCopyWith<$Res> implements $PlanTagsCopyWith<$Res> {
  factory _$PlanTagsCopyWith(_PlanTags value, $Res Function(_PlanTags) _then) = __$PlanTagsCopyWithImpl;
@override @useResult
$Res call({
 List<String> categories
});




}
/// @nodoc
class __$PlanTagsCopyWithImpl<$Res>
    implements _$PlanTagsCopyWith<$Res> {
  __$PlanTagsCopyWithImpl(this._self, this._then);

  final _PlanTags _self;
  final $Res Function(_PlanTags) _then;

/// Create a copy of PlanTags
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_PlanTags(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
