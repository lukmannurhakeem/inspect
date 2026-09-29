// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobModel _$JobModelFromJson(Map<String, dynamic> json) => _JobModel(
  count: (json['count'] as num?)?.toInt(),
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => JobItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  success: json['success'] as bool?,
);

Map<String, dynamic> _$JobModelToJson(_JobModel instance) => <String, dynamic>{
  'count': instance.count,
  'data': instance.data,
  'success': instance.success,
};

_JobItem _$JobItemFromJson(Map<String, dynamic> json) => _JobItem(
  jobId: json['jobID'] as String?,
  jobNo: json['jobNo'] as String?,
  customerid: json['customerid'] as String?,
  customerName: json['customerName'] as String?,
  siteId: json['siteID'] as String?,
  siteName: json['siteName'] as String?,
  createdDate: json['createdDate'] == null
      ? null
      : DateTime.parse(json['createdDate'] as String),
  purchaseOrderNo: json['purchaseOrderNo'] as String?,
  procedureNo: json['procedureNo'] as String?,
  divisionId: json['divisionID'] as String?,
  allocatedDuration: (json['allocatedDuration'] as num?)?.toInt(),
  estimatedStartDate: json['estimatedStartDate'] == null
      ? null
      : DateTime.parse(json['estimatedStartDate'] as String),
  estimatedEndDate: json['estimatedEndDate'] == null
      ? null
      : DateTime.parse(json['estimatedEndDate'] as String),
  isEngineerComplete: json['isEngineerComplete'] as bool?,
  offshoreLocation: json['offshoreLocation'] as String?,
  authenticator: json['authenticator'] as String?,
  issuingAuthName: json['issuingAuthName'] as String?,
  issuingAuthSignature: json['issuingAuthSignature'] as String?,
  clientName: json['clientName'] as String?,
  clientSignature: json['clientSignature'] as String?,
  startJobNow: json['startJobNow'] as bool?,
);

Map<String, dynamic> _$JobItemToJson(_JobItem instance) => <String, dynamic>{
  'jobID': instance.jobId,
  'jobNo': instance.jobNo,
  'customerid': instance.customerid,
  'customerName': instance.customerName,
  'siteID': instance.siteId,
  'siteName': instance.siteName,
  'createdDate': instance.createdDate?.toIso8601String(),
  'purchaseOrderNo': instance.purchaseOrderNo,
  'procedureNo': instance.procedureNo,
  'divisionID': instance.divisionId,
  'allocatedDuration': instance.allocatedDuration,
  'estimatedStartDate': instance.estimatedStartDate?.toIso8601String(),
  'estimatedEndDate': instance.estimatedEndDate?.toIso8601String(),
  'isEngineerComplete': instance.isEngineerComplete,
  'offshoreLocation': instance.offshoreLocation,
  'authenticator': instance.authenticator,
  'issuingAuthName': instance.issuingAuthName,
  'issuingAuthSignature': instance.issuingAuthSignature,
  'clientName': instance.clientName,
  'clientSignature': instance.clientSignature,
  'startJobNow': instance.startJobNow,
};
