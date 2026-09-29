
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_approval_model.freezed.dart';
part 'report_approval_model.g.dart';

@freezed
abstract class ReportApprovalModel with _$ReportApprovalModel {
const factory ReportApprovalModel({
List<ReportApprovalData>? data,
ApprovalFilter? filter,
String? message,
}) = _ReportApprovalModel;

factory ReportApprovalModel.fromJson(Map<String, dynamic> json) =>
_$ReportApprovalModelFromJson(json);
}

@freezed
abstract class ReportApprovalData with _$ReportApprovalData {
const ReportApprovalData._();

const factory ReportApprovalData({
@JsonKey(name: 'reportID') String? reportID,
@JsonKey(name: 'reportTypeID') String? reportTypeID,
String? reportName,
@JsonKey(name: 'itemID') String? itemID,
String? itemNo,
String? status,
String? inspectedBy,
String? reportDate,
String? regulation,
dynamic reportData,
String? createdAt,
String? updatedAt,
String? approvalStatus,
String? inspectedOn,
String? inspectStatus,
String? expiryDate,
@JsonKey(name: 'ExpiryDate') String? ExpiryDate,
}) = _ReportApprovalData;

factory ReportApprovalData.fromJson(Map<String, dynamic> json) =>
_$ReportApprovalDataFromJson(json);

DateTime? get reportDateTime {
if (reportDate == null) return null;

try {
return DateTime.parse(reportDate!);
} catch (_) {
return null;
}
}

DateTime? get expiryDateTime {
if (ExpiryDate == null) return null;

try {
return DateTime.parse(ExpiryDate!);
} catch (_) {
return null;
}
}

String get displayInspector {
if (inspectedBy != null && inspectedBy!.isNotEmpty) {
return inspectedBy!;
}

return 'Not Assigned';
}
}

@freezed
abstract class ApprovalFilter with _$ApprovalFilter {
const factory ApprovalFilter({
bool? isApproved,
@JsonKey(name: 'jobID') String? jobID,
}) = _ApprovalFilter;

factory ApprovalFilter.fromJson(Map<String, dynamic> json) =>
_$ApprovalFilterFromJson(json);
}
