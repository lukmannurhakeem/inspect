import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
abstract class DashboardModel with _$DashboardModel {
  const factory DashboardModel({
    CustomerData? customer,
    List<SiteData>? sites,
    List<JobData>? jobs,
    List<ItemData>? jobItems,
    List<ReportData>? reports,
    StatisticsData? statistics,
  }) = _DashboardModel;

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);
}

@freezed
abstract class CustomerData with _$CustomerData {
  const factory CustomerData({
    String? customerId,
    String? customerName,
    String? siteCode,
    String? accountCode,
    String? agent,
    String? notes,
    String? division,
    String? logo,
    String? address,
    String? email,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CustomerData;

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);
}

@freezed
abstract class SiteData with _$SiteData {
  const factory SiteData({
    String? siteId,
    String? siteCode,
    String? siteName,
    String? customerId,
    String? area,
    String? description,
    String? notes,
    String? division,
    String? logo,
    String? address,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SiteData;

  factory SiteData.fromJson(Map<String, dynamic> json) =>
      _$SiteDataFromJson(json);
}

@freezed
abstract class JobData with _$JobData {
  const factory JobData({
    String? jobId,
    String? jobNo,
    String? jobName,
    String? customerId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JobData;

  factory JobData.fromJson(Map<String, dynamic> json) =>
      _$JobDataFromJson(json);
}

@freezed
abstract class ItemData with _$ItemData {
  const factory ItemData({
    String? itemId,
    String? jobId,
    String? jobNo,
    String? itemNo,
    String? categoryId,
    String? categoryName,
    String? rfidNo,
    String? locationId,
    String? detailedLocation,
    String? internalNotes,
    String? externalNotes,
    String? manufacturer,
    String? manufacturerAddress,
    DateTime? manufacturerDate,
    DateTime? firstUseDate,
    DateTime? outOfServiceDate,
    String? swl,
    String? photoReference,
    String? standardReference,
    String? serialNumber,
    double? tareWeight,
    double? payLoad,
    double? maxGrossWeight,
    String? inspectionStatus,
    String? description,
    String? status,
    DateTime? expiryDateTimeStamp,
    bool? archived,
    bool? canInspectItem,
    bool? isActive,
    bool? isApproved,
  }) = _ItemData;

  factory ItemData.fromJson(Map<String, dynamic> json) =>
      _$ItemDataFromJson(json);
}

@freezed
abstract class ReportData with _$ReportData {
  const factory ReportData({
    String? reportId,
    String? reportTypeId,
    String? reportTypeName,
    String? itemId,
    String? itemNo,
    String? status,
    String? inspectedBy,
    String? inspectorName,
    DateTime? reportDate,
    String? regulation,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? approvalStatus,
    DateTime? inspectedOn,
    String? inspectStatus,
    DateTime? expiryDate,
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);
}

@freezed
abstract class StatisticsData with _$StatisticsData {
  const factory StatisticsData({
    int? totalSites,
    int? activeSites,
    int? totalJobs,
    int? activeJobs,
    int? completedJobs,
    int? totalItems,
    int? activeItems,
    int? totalReports,
    int? pendingReports,
    int? approvedReports,
    int? totalNotifications,
    int? unreadNotifications,
    Map<String, dynamic>? jobsByStatus,
    Map<String, dynamic>? itemsByStatus,
    Map<String, dynamic>? reportsByStatus,
    Map<String, dynamic>? notificationsByType,
  }) = _StatisticsData;

  factory StatisticsData.fromJson(Map<String, dynamic> json) =>
      _$StatisticsDataFromJson(json);
}

@freezed
abstract class DashboardResponse with _$DashboardResponse {
  const factory DashboardResponse({
    @Default(false) bool success,
    @Default('') String message,
    @Default(DashboardModel()) DashboardModel data,
  }) = _DashboardResponse;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);
}

@freezed
abstract class StatisticsResponse with _$StatisticsResponse {
  const factory StatisticsResponse({
    @Default(false) bool success,
    @Default('') String message,
    @Default(StatisticsData()) StatisticsData data,
  }) = _StatisticsResponse;

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$StatisticsResponseFromJson(json);
}

@freezed
abstract class ItemsResponse with _$ItemsResponse {
  const factory ItemsResponse({
    @Default(false) bool success,
    @Default('') String message,
    @Default([]) List<ItemData> data,
    @Default(0) int count,
  }) = _ItemsResponse;

  factory ItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemsResponseFromJson(json);
}