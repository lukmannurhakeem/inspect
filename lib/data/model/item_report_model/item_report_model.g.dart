// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemReportModel _$ItemReportModelFromJson(Map<String, dynamic> json) =>
    _ItemReportModel(
      reportId: json['reportID'] as String?,
      reportTypeId: json['reportTypeID'] as String?,
      reportName: json['reportName'] as String?,
      itemId: json['itemID'] as String?,
      itemNo: json['itemNo'] as String?,
      status: json['status'] as String?,
      inspectedBy: json['inspectedBy'] as String?,
      reportDate: json['reportDate'] == null
          ? null
          : DateTime.parse(json['reportDate'] as String),
      regulation: json['regulation'] as String?,
      reportData: json['reportData'] == null
          ? null
          : ReportData.fromJson(json['reportData'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ItemReportModelToJson(_ItemReportModel instance) =>
    <String, dynamic>{
      'reportID': instance.reportId,
      'reportTypeID': instance.reportTypeId,
      'reportName': instance.reportName,
      'itemID': instance.itemId,
      'itemNo': instance.itemNo,
      'status': instance.status,
      'inspectedBy': instance.inspectedBy,
      'reportDate': instance.reportDate?.toIso8601String(),
      'regulation': instance.regulation,
      'reportData': instance.reportData,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_ReportData _$ReportDataFromJson(Map<String, dynamic> json) => _ReportData(
  field1: json['field1'] == null
      ? null
      : Field.fromJson(json['field1'] as Map<String, dynamic>),
  field2: json['field2'] == null
      ? null
      : Field.fromJson(json['field2'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReportDataToJson(_ReportData instance) =>
    <String, dynamic>{'field1': instance.field1, 'field2': instance.field2};

_Field _$FieldFromJson(Map<String, dynamic> json) =>
    _Field(value: json['value'] as String?);

Map<String, dynamic> _$FieldToJson(_Field instance) => <String, dynamic>{
  'value': instance.value,
};
