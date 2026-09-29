import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
abstract class JobModel with _$JobModel {
  const factory JobModel({
    int? count,
    @Default([]) List<JobItem> data,
    bool? success,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
}

@freezed
abstract class JobItem with _$JobItem {
  const factory JobItem({
    @JsonKey(name: 'jobID') String? jobId,
    String? jobNo,
    String? customerid,
    String? customerName,
    @JsonKey(name: 'siteID') String? siteId,
    String? siteName,
    DateTime? createdDate,
    String? purchaseOrderNo,
    String? procedureNo,
    @JsonKey(name: 'divisionID') String? divisionId,
    int? allocatedDuration,
    DateTime? estimatedStartDate,
    DateTime? estimatedEndDate,
    bool? isEngineerComplete,
    String? offshoreLocation,
    String? authenticator,
    String? issuingAuthName,
    String? issuingAuthSignature,
    String? clientName,
    String? clientSignature,
    bool? startJobNow,
  }) = _JobItem;

  factory JobItem.fromJson(Map<String, dynamic> json) =>
      _$JobItemFromJson(json);
}