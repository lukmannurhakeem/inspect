
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
const NotificationModel._();

const factory NotificationModel({
required String id,
required String type,
required String title,
required String message,
required DateTime timestamp,
@Default(false) bool isRead,
@Default(false) bool isSent,

@JsonKey(name: 'jobID') String? jobId,
String? jobNumber,
String? jobStatus,
@JsonKey(name: 'customerID') String? customerId,
String? customerName,
@JsonKey(name: 'siteID') String? siteId,
String? siteName,
String? notificationType,

Map<String, dynamic>? rawData,
}) = _NotificationModel;

factory NotificationModel.fromJson(Map<String, dynamic> json) =>
_$NotificationModelFromJson(json);

factory NotificationModel.fromWebSocket(Map<String, dynamic> json) {
final data = json['data'] as Map<String, dynamic>? ?? {};

final timestamp = json['timestamp'] != null
? DateTime.parse(json['timestamp'] as String)
    : DateTime.now();

final id =
'${timestamp.millisecondsSinceEpoch}_${data['jobNumber'] ?? ''}';

return NotificationModel(
id: id,
type: json['type'] ?? 'notification',
title: data['title'] ?? 'Notification',
message: data['message'] ?? '',
timestamp: timestamp,
isRead: data['isRead'] ?? false,
isSent: data['isSent'] ?? false,
jobId: data['jobID'],
jobNumber: data['jobNumber'],
jobStatus: data['jobStatus'],
customerId: data['customerID'],
customerName: data['customerName'],
siteId: data['siteID'],
siteName: data['siteName'],
notificationType: data['notificationType'],
rawData: data,
);
}

String get priority {
switch (notificationType?.toLowerCase()) {
case 'job_created':
case 'job_updated':
return 'medium';
case 'job_completed':
return 'low';
case 'job_cancelled':
case 'urgent':
return 'high';
default:
return 'medium';
}
}

String get iconType {
switch (notificationType?.toLowerCase()) {
case 'job_created':
return 'work_outline';
case 'job_updated':
return 'update';
case 'job_completed':
return 'check_circle_outline';
case 'job_cancelled':
return 'cancel_outlined';
default:
return 'notifications_outlined';
}
}
}
