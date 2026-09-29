// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isSent: json['isSent'] as bool? ?? false,
      jobId: json['jobID'] as String?,
      jobNumber: json['jobNumber'] as String?,
      jobStatus: json['jobStatus'] as String?,
      customerId: json['customerID'] as String?,
      customerName: json['customerName'] as String?,
      siteId: json['siteID'] as String?,
      siteName: json['siteName'] as String?,
      notificationType: json['notificationType'] as String?,
      rawData: json['rawData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'isSent': instance.isSent,
      'jobID': instance.jobId,
      'jobNumber': instance.jobNumber,
      'jobStatus': instance.jobStatus,
      'customerID': instance.customerId,
      'customerName': instance.customerName,
      'siteID': instance.siteId,
      'siteName': instance.siteName,
      'notificationType': instance.notificationType,
      'rawData': instance.rawData,
    };
