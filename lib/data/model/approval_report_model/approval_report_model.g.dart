// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApprovalReportModel _$ApprovalReportModelFromJson(Map<String, dynamic> json) =>
    _ApprovalReportModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ApprovalReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ApprovalReportModelToJson(
  _ApprovalReportModel instance,
) => <String, dynamic>{'data': instance.data, 'message': instance.message};

_ApprovalReport _$ApprovalReportFromJson(Map<String, dynamic> json) =>
    _ApprovalReport(
      reportID: json['reportID'] as String?,
      reportTypeID: json['reportTypeID'] as String?,
      reportName: json['reportName'] as String?,
      itemID: json['itemID'] as String?,
      itemNo: json['itemNo'] as String?,
      status: json['status'] as String?,
      inspectedBy: json['inspectedBy'] as String?,
      reportDate: _dateTimeFromJson(json['reportDate']),
      regulation: json['regulation'] as String?,
      reportData: json['reportData'],
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
      approvalStatus: json['approvalStatus'] as String?,
      inspectedOn: _dateTimeFromJson(json['inspectedOn']),
      inspectStatus: json['inspectStatus'] as String?,
    );

Map<String, dynamic> _$ApprovalReportToJson(_ApprovalReport instance) =>
    <String, dynamic>{
      'reportID': instance.reportID,
      'reportTypeID': instance.reportTypeID,
      'reportName': instance.reportName,
      'itemID': instance.itemID,
      'itemNo': instance.itemNo,
      'status': instance.status,
      'inspectedBy': instance.inspectedBy,
      'reportDate': _dateTimeToJson(instance.reportDate),
      'regulation': instance.regulation,
      'reportData': instance.reportData,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedAt': _dateTimeToJson(instance.updatedAt),
      'approvalStatus': instance.approvalStatus,
      'inspectedOn': _dateTimeToJson(instance.inspectedOn),
      'inspectStatus': instance.inspectStatus,
    };
