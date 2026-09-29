// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateCategoryModel _$CreateCategoryModelFromJson(Map<String, dynamic> json) =>
    _CreateCategoryModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$CreateCategoryModelToJson(
  _CreateCategoryModel instance,
) => <String, dynamic>{
  'data': instance.data,
  'message': instance.message,
  'success': instance.success,
};

_Data _$DataFromJson(Map<String, dynamic> json) => _Data(
  categoryId: json['categoryId'] as String?,
  parentId: json['parentId'],
  categoryName: json['categoryName'] as String?,
  categoryCode: json['categoryCode'] as String?,
  description: json['description'] as String?,
  descriptionTemplate: json['descriptionTemplate'] as String?,
  replacementPeriod: (json['replacementPeriod'] as num?)?.toInt(),
  instructions: json['instructions'] as String?,
  notes: json['notes'] as String?,
  canHaveChildItems: json['canHaveChildItems'] as bool?,
  isWithdrawn: json['isWithdrawn'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  regulationId: json['regulationId'] as String?,
  checklistId: json['checklistId'] as String?,
  plannedMaintenanceId: json['plannedMaintenanceId'] as String?,
);

Map<String, dynamic> _$DataToJson(_Data instance) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'parentId': instance.parentId,
  'categoryName': instance.categoryName,
  'categoryCode': instance.categoryCode,
  'description': instance.description,
  'descriptionTemplate': instance.descriptionTemplate,
  'replacementPeriod': instance.replacementPeriod,
  'instructions': instance.instructions,
  'notes': instance.notes,
  'canHaveChildItems': instance.canHaveChildItems,
  'isWithdrawn': instance.isWithdrawn,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'regulationId': instance.regulationId,
  'checklistId': instance.checklistId,
  'plannedMaintenanceId': instance.plannedMaintenanceId,
};
