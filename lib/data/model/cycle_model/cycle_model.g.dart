// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CycleModel _$CycleModelFromJson(Map<String, dynamic> json) => _CycleModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CycleData.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$CycleModelToJson(_CycleModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
    };

_CycleData _$CycleDataFromJson(Map<String, dynamic> json) => _CycleData(
  cycleId: json['cycleID'] as String?,
  reportTypeId: json['reportTypeID'] as String?,
  reportTypeName: json['reportTypeName'] as String?,
  categoryId: json['categoryID'] as String?,
  customerId: json['customerID'] as String?,
  customerName: json['customerName'] as String?,
  siteId: json['siteID'] as String?,
  unit: json['unit'] as String?,
  length: (json['length'] as num?)?.toInt(),
  minLength: (json['minLength'] as num?)?.toInt(),
  maxLength: (json['maxLength'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CycleDataToJson(_CycleData instance) =>
    <String, dynamic>{
      'cycleID': instance.cycleId,
      'reportTypeID': instance.reportTypeId,
      'reportTypeName': instance.reportTypeName,
      'categoryID': instance.categoryId,
      'customerID': instance.customerId,
      'customerName': instance.customerName,
      'siteID': instance.siteId,
      'unit': instance.unit,
      'length': instance.length,
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
