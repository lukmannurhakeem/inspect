// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionPlanModel _$InspectionPlanModelFromJson(Map<String, dynamic> json) =>
    _InspectionPlanModel(
      id: json['planId'] as String? ?? '',
      eventType: json['eventType'] as String? ?? 'test',
      jobId: json['jobId'] as String? ?? '',
      itemId: json['itemId'] as String?,
      reportTypeId: json['reportTypeId'] as String?,
      planTitle: json['planTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'normal',
      plannedStartDate: json['plannedStartDate'] == null
          ? null
          : DateTime.parse(json['plannedStartDate'] as String),
      plannedEndDate: json['plannedEndDate'] == null
          ? null
          : DateTime.parse(json['plannedEndDate'] as String),
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'pending',
      assignedTo: json['assignedTo'] as String? ?? '',
      assignmentType: json['assignmentType'] as String? ?? 'personnel',
      checklistItems: json['checklistItems'] == null
          ? null
          : ChecklistItems.fromJson(
              json['checklistItems'] as Map<String, dynamic>,
            ),
      attendees: json['attendees'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
      tags: json['tags'] == null
          ? null
          : PlanTags.fromJson(json['tags'] as Map<String, dynamic>),
      createdBy: json['createdBy'] as String?,
      completedBy: json['completedBy'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isQueued: json['isQueued'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InspectionPlanModelToJson(
  _InspectionPlanModel instance,
) => <String, dynamic>{
  'planId': instance.id,
  'eventType': instance.eventType,
  'jobId': instance.jobId,
  'itemId': instance.itemId,
  'reportTypeId': instance.reportTypeId,
  'planTitle': instance.planTitle,
  'description': instance.description,
  'priority': instance.priority,
  'plannedStartDate': instance.plannedStartDate?.toIso8601String(),
  'plannedEndDate': instance.plannedEndDate?.toIso8601String(),
  'estimatedDuration': instance.estimatedDuration,
  'status': instance.status,
  'assignedTo': instance.assignedTo,
  'assignmentType': instance.assignmentType,
  'checklistItems': instance.checklistItems,
  'attendees': instance.attendees,
  'notes': instance.notes,
  'tags': instance.tags,
  'createdBy': instance.createdBy,
  'completedBy': instance.completedBy,
  'completedAt': instance.completedAt?.toIso8601String(),
  'isQueued': instance.isQueued,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_ChecklistItems _$ChecklistItemsFromJson(Map<String, dynamic> json) =>
    _ChecklistItems(
      tasks:
          (json['tasks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$ChecklistItemsToJson(_ChecklistItems instance) =>
    <String, dynamic>{'tasks': instance.tasks};

_PlanTags _$PlanTagsFromJson(Map<String, dynamic> json) => _PlanTags(
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$PlanTagsToJson(_PlanTags instance) => <String, dynamic>{
  'categories': instance.categories,
};
