import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_report_model.freezed.dart';
part 'approval_report_model.g.dart';

@freezed
abstract class ApprovalReportModel with _$ApprovalReportModel {
  const factory ApprovalReportModel({
    List<ApprovalReport>? data,
    String? message,
  }) = _ApprovalReportModel;

  factory ApprovalReportModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalReportModelFromJson(json);
}

@freezed
abstract class ApprovalReport with _$ApprovalReport {
  const factory ApprovalReport({
    String? reportID,
    String? reportTypeID,
    String? reportName,
    String? itemID,
    String? itemNo,
    String? status,
    String? inspectedBy,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? reportDate,
    String? regulation,
    dynamic reportData,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? updatedAt,
    String? approvalStatus,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? inspectedOn,
    String? inspectStatus,
  }) = _ApprovalReport;

  factory ApprovalReport.fromJson(Map<String, dynamic> json) =>
      _$ApprovalReportFromJson(json);
}

/// Converts the API's date string to DateTime.
///
/// Returns null for null or the default .NET date.
DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null ||
      value == '0001-01-01T00:00:00Z') {
    return null;
  }

  if (value is DateTime) {
    return value;
  }

  return DateTime.parse(value as String);
}

/// Converts DateTime to an ISO 8601 string.
String? _dateTimeToJson(DateTime? value) {
  return value?.toIso8601String();
}
