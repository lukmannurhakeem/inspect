import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_plan_model.freezed.dart';
part 'inspection_plan_model.g.dart';

@freezed
abstract class InspectionPlanModel with _$InspectionPlanModel {
  const factory InspectionPlanModel({
    @JsonKey(name: 'planId') @Default('') String id,
    @Default('test') String eventType,
    @Default('') String jobId,
    String? itemId,
    String? reportTypeId,
    @Default('') String planTitle,
    @Default('') String description,
    @Default('normal') String priority,
    DateTime? plannedStartDate,
    DateTime? plannedEndDate,
    int? estimatedDuration,
    @Default('pending') String status,
    @Default('') String assignedTo,
    @Default('personnel') String assignmentType,
    ChecklistItems? checklistItems,
    Map<String, dynamic>? attendees,
    String? notes,
    PlanTags? tags,
    String? createdBy,
    String? completedBy,
    DateTime? completedAt,
    @Default(false) bool isQueued,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InspectionPlanModel;

  factory InspectionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionPlanModelFromJson(json);
}

@freezed
abstract class ChecklistItems with _$ChecklistItems {
  const factory ChecklistItems({
    @Default([]) List<String> tasks,
  }) = _ChecklistItems;

  factory ChecklistItems.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemsFromJson(json);
}

@freezed
abstract class PlanTags with _$PlanTags {
  const factory PlanTags({
    @Default([]) List<String> categories,
  }) = _PlanTags;

  factory PlanTags.fromJson(Map<String, dynamic> json) =>
      _$PlanTagsFromJson(json);
}
