// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_report_field_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditReportFieldResponse _$EditReportFieldResponseFromJson(
  Map<String, dynamic> json,
) => _EditReportFieldResponse(
  data: ReportFieldData.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String,
);

Map<String, dynamic> _$EditReportFieldResponseToJson(
  _EditReportFieldResponse instance,
) => <String, dynamic>{'data': instance.data, 'message': instance.message};

_ReportFieldData _$ReportFieldDataFromJson(Map<String, dynamic> json) =>
    _ReportFieldData(
      reportFieldID: json['reportFieldID'] as String,
      reportTypeID: json['reportTypeID'] as String,
      labelText: json['labelText'] as String,
      name: json['name'] as String,
      fieldType: json['fieldType'] as String,
      defaultValue: json['defaultValue'] == null
          ? null
          : ReportFieldDefaultValue.fromJson(
              json['defaultValue'] as Map<String, dynamic>,
            ),
      onlyAvailable: json['onlyAvailable'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      doNotCopy: json['doNotCopy'] as bool? ?? false,
      isArchive: json['isArchive'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ReportFieldDataToJson(_ReportFieldData instance) =>
    <String, dynamic>{
      'reportFieldID': instance.reportFieldID,
      'reportTypeID': instance.reportTypeID,
      'labelText': instance.labelText,
      'name': instance.name,
      'fieldType': instance.fieldType,
      'defaultValue': instance.defaultValue,
      'onlyAvailable': instance.onlyAvailable,
      'isRequired': instance.isRequired,
      'doNotCopy': instance.doNotCopy,
      'isArchive': instance.isArchive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
