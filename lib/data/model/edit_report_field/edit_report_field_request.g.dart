// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_report_field_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditReportFieldRequest _$EditReportFieldRequestFromJson(
  Map<String, dynamic> json,
) => _EditReportFieldRequest(
  reportTypeID: json['reportTypeID'] as String?,
  labelText: json['labelText'] as String?,
  name: json['name'] as String?,
  fieldType: json['fieldType'] as String?,
  defaultValue: json['defaultValue'] == null
      ? null
      : ReportFieldDefaultValue.fromJson(
          json['defaultValue'] as Map<String, dynamic>,
        ),
  onlyAvailable: json['onlyAvailable'] as String?,
  isRequired: json['isRequired'] as bool?,
  doNotCopy: json['doNotCopy'] as bool?,
  isArchive: json['isArchive'] as bool?,
);

Map<String, dynamic> _$EditReportFieldRequestToJson(
  _EditReportFieldRequest instance,
) => <String, dynamic>{
  'reportTypeID': ?instance.reportTypeID,
  'labelText': ?instance.labelText,
  'name': ?instance.name,
  'fieldType': ?instance.fieldType,
  'defaultValue': ?instance.defaultValue,
  'onlyAvailable': ?instance.onlyAvailable,
  'isRequired': ?instance.isRequired,
  'doNotCopy': ?instance.doNotCopy,
  'isArchive': ?instance.isArchive,
};
