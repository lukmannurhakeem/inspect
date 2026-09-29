// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetCategoryModel _$GetCategoryModelFromJson(Map<String, dynamic> json) =>
    _GetCategoryModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      message: json['message'] as String?,
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$GetCategoryModelToJson(_GetCategoryModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'pagination': instance.pagination,
      'success': instance.success,
    };

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
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
  siteId: json['siteId'] as String?,
  regulationId: json['regulationId'] as String?,
  checklistId: json['checklistId'] as String?,
  plannedMaintenanceId: json['plannedMaintenanceId'] as String?,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
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
  'siteId': instance.siteId,
  'regulationId': instance.regulationId,
  'checklistId': instance.checklistId,
  'plannedMaintenanceId': instance.plannedMaintenanceId,
};

_Pagination _$PaginationFromJson(Map<String, dynamic> json) => _Pagination(
  count: (json['count'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationToJson(_Pagination instance) =>
    <String, dynamic>{
      'count': instance.count,
      'limit': instance.limit,
      'offset': instance.offset,
      'total': instance.total,
    };
