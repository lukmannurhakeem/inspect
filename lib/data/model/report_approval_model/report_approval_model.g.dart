// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_approval_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportApprovalModel _$ReportApprovalModelFromJson(Map<String, dynamic> json) =>
    _ReportApprovalModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReportApprovalData.fromJson(e as Map<String, dynamic>))
          .toList(),
      filter: json['filter'] == null
          ? null
          : ApprovalFilter.fromJson(json['filter'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ReportApprovalModelToJson(
  _ReportApprovalModel instance,
) => <String, dynamic>{
  'data': instance.data,
  'filter': instance.filter,
  'message': instance.message,
};

_ReportApprovalData _$ReportApprovalDataFromJson(Map<String, dynamic> json) =>
    _ReportApprovalData(
      reportID: json['reportID'] as String?,
      reportTypeID: json['reportTypeID'] as String?,
      reportName: json['reportName'] as String?,
      itemID: json['itemID'] as String?,
      itemNo: json['itemNo'] as String?,
      status: json['status'] as String?,
      inspectedBy: json['inspectedBy'] as String?,
      reportDate: json['reportDate'] as String?,
      regulation: json['regulation'] as String?,
      reportData: json['reportData'],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      approvalStatus: json['approvalStatus'] as String?,
      inspectedOn: json['inspectedOn'] as String?,
      inspectStatus: json['inspectStatus'] as String?,
      expiryDate: json['expiryDate'] as String?,
      ExpiryDate: json['ExpiryDate'] as String?,
    );

Map<String, dynamic> _$ReportApprovalDataToJson(_ReportApprovalData instance) =>
    <String, dynamic>{
      'reportID': instance.reportID,
      'reportTypeID': instance.reportTypeID,
      'reportName': instance.reportName,
      'itemID': instance.itemID,
      'itemNo': instance.itemNo,
      'status': instance.status,
      'inspectedBy': instance.inspectedBy,
      'reportDate': instance.reportDate,
      'regulation': instance.regulation,
      'reportData': instance.reportData,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'approvalStatus': instance.approvalStatus,
      'inspectedOn': instance.inspectedOn,
      'inspectStatus': instance.inspectStatus,
      'expiryDate': instance.expiryDate,
      'ExpiryDate': instance.ExpiryDate,
    };

_ApprovalFilter _$ApprovalFilterFromJson(Map<String, dynamic> json) =>
    _ApprovalFilter(
      isApproved: json['isApproved'] as bool?,
      jobID: json['jobID'] as String?,
    );

Map<String, dynamic> _$ApprovalFilterToJson(_ApprovalFilter instance) =>
    <String, dynamic>{
      'isApproved': instance.isApproved,
      'jobID': instance.jobID,
    };
