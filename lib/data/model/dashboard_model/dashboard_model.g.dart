// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    _DashboardModel(
      customer: json['customer'] == null
          ? null
          : CustomerData.fromJson(json['customer'] as Map<String, dynamic>),
      sites: (json['sites'] as List<dynamic>?)
          ?.map((e) => SiteData.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobs: (json['jobs'] as List<dynamic>?)
          ?.map((e) => JobData.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobItems: (json['jobItems'] as List<dynamic>?)
          ?.map((e) => ItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      reports: (json['reports'] as List<dynamic>?)
          ?.map((e) => ReportData.fromJson(e as Map<String, dynamic>))
          .toList(),
      statistics: json['statistics'] == null
          ? null
          : StatisticsData.fromJson(json['statistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardModelToJson(_DashboardModel instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'sites': instance.sites,
      'jobs': instance.jobs,
      'jobItems': instance.jobItems,
      'reports': instance.reports,
      'statistics': instance.statistics,
    };

_CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) =>
    _CustomerData(
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      siteCode: json['siteCode'] as String?,
      accountCode: json['accountCode'] as String?,
      agent: json['agent'] as String?,
      notes: json['notes'] as String?,
      division: json['division'] as String?,
      logo: json['logo'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      archived: json['archived'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomerDataToJson(_CustomerData instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'siteCode': instance.siteCode,
      'accountCode': instance.accountCode,
      'agent': instance.agent,
      'notes': instance.notes,
      'division': instance.division,
      'logo': instance.logo,
      'address': instance.address,
      'email': instance.email,
      'archived': instance.archived,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_SiteData _$SiteDataFromJson(Map<String, dynamic> json) => _SiteData(
  siteId: json['siteId'] as String?,
  siteCode: json['siteCode'] as String?,
  siteName: json['siteName'] as String?,
  customerId: json['customerId'] as String?,
  area: json['area'] as String?,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  division: json['division'] as String?,
  logo: json['logo'] as String?,
  address: json['address'] as String?,
  archived: json['archived'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SiteDataToJson(_SiteData instance) => <String, dynamic>{
  'siteId': instance.siteId,
  'siteCode': instance.siteCode,
  'siteName': instance.siteName,
  'customerId': instance.customerId,
  'area': instance.area,
  'description': instance.description,
  'notes': instance.notes,
  'division': instance.division,
  'logo': instance.logo,
  'address': instance.address,
  'archived': instance.archived,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_JobData _$JobDataFromJson(Map<String, dynamic> json) => _JobData(
  jobId: json['jobId'] as String?,
  jobNo: json['jobNo'] as String?,
  jobName: json['jobName'] as String?,
  customerId: json['customerId'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$JobDataToJson(_JobData instance) => <String, dynamic>{
  'jobId': instance.jobId,
  'jobNo': instance.jobNo,
  'jobName': instance.jobName,
  'customerId': instance.customerId,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_ItemData _$ItemDataFromJson(Map<String, dynamic> json) => _ItemData(
  itemId: json['itemId'] as String?,
  jobId: json['jobId'] as String?,
  jobNo: json['jobNo'] as String?,
  itemNo: json['itemNo'] as String?,
  categoryId: json['categoryId'] as String?,
  categoryName: json['categoryName'] as String?,
  rfidNo: json['rfidNo'] as String?,
  locationId: json['locationId'] as String?,
  detailedLocation: json['detailedLocation'] as String?,
  internalNotes: json['internalNotes'] as String?,
  externalNotes: json['externalNotes'] as String?,
  manufacturer: json['manufacturer'] as String?,
  manufacturerAddress: json['manufacturerAddress'] as String?,
  manufacturerDate: json['manufacturerDate'] == null
      ? null
      : DateTime.parse(json['manufacturerDate'] as String),
  firstUseDate: json['firstUseDate'] == null
      ? null
      : DateTime.parse(json['firstUseDate'] as String),
  outOfServiceDate: json['outOfServiceDate'] == null
      ? null
      : DateTime.parse(json['outOfServiceDate'] as String),
  swl: json['swl'] as String?,
  photoReference: json['photoReference'] as String?,
  standardReference: json['standardReference'] as String?,
  serialNumber: json['serialNumber'] as String?,
  tareWeight: (json['tareWeight'] as num?)?.toDouble(),
  payLoad: (json['payLoad'] as num?)?.toDouble(),
  maxGrossWeight: (json['maxGrossWeight'] as num?)?.toDouble(),
  inspectionStatus: json['inspectionStatus'] as String?,
  description: json['description'] as String?,
  status: json['status'] as String?,
  expiryDateTimeStamp: json['expiryDateTimeStamp'] == null
      ? null
      : DateTime.parse(json['expiryDateTimeStamp'] as String),
  archived: json['archived'] as bool?,
  canInspectItem: json['canInspectItem'] as bool?,
  isActive: json['isActive'] as bool?,
  isApproved: json['isApproved'] as bool?,
);

Map<String, dynamic> _$ItemDataToJson(_ItemData instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'jobId': instance.jobId,
  'jobNo': instance.jobNo,
  'itemNo': instance.itemNo,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'rfidNo': instance.rfidNo,
  'locationId': instance.locationId,
  'detailedLocation': instance.detailedLocation,
  'internalNotes': instance.internalNotes,
  'externalNotes': instance.externalNotes,
  'manufacturer': instance.manufacturer,
  'manufacturerAddress': instance.manufacturerAddress,
  'manufacturerDate': instance.manufacturerDate?.toIso8601String(),
  'firstUseDate': instance.firstUseDate?.toIso8601String(),
  'outOfServiceDate': instance.outOfServiceDate?.toIso8601String(),
  'swl': instance.swl,
  'photoReference': instance.photoReference,
  'standardReference': instance.standardReference,
  'serialNumber': instance.serialNumber,
  'tareWeight': instance.tareWeight,
  'payLoad': instance.payLoad,
  'maxGrossWeight': instance.maxGrossWeight,
  'inspectionStatus': instance.inspectionStatus,
  'description': instance.description,
  'status': instance.status,
  'expiryDateTimeStamp': instance.expiryDateTimeStamp?.toIso8601String(),
  'archived': instance.archived,
  'canInspectItem': instance.canInspectItem,
  'isActive': instance.isActive,
  'isApproved': instance.isApproved,
};

_ReportData _$ReportDataFromJson(Map<String, dynamic> json) => _ReportData(
  reportId: json['reportId'] as String?,
  reportTypeId: json['reportTypeId'] as String?,
  reportTypeName: json['reportTypeName'] as String?,
  itemId: json['itemId'] as String?,
  itemNo: json['itemNo'] as String?,
  status: json['status'] as String?,
  inspectedBy: json['inspectedBy'] as String?,
  inspectorName: json['inspectorName'] as String?,
  reportDate: json['reportDate'] == null
      ? null
      : DateTime.parse(json['reportDate'] as String),
  regulation: json['regulation'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  approvalStatus: json['approvalStatus'] as String?,
  inspectedOn: json['inspectedOn'] == null
      ? null
      : DateTime.parse(json['inspectedOn'] as String),
  inspectStatus: json['inspectStatus'] as String?,
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
);

Map<String, dynamic> _$ReportDataToJson(_ReportData instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'reportTypeId': instance.reportTypeId,
      'reportTypeName': instance.reportTypeName,
      'itemId': instance.itemId,
      'itemNo': instance.itemNo,
      'status': instance.status,
      'inspectedBy': instance.inspectedBy,
      'inspectorName': instance.inspectorName,
      'reportDate': instance.reportDate?.toIso8601String(),
      'regulation': instance.regulation,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'approvalStatus': instance.approvalStatus,
      'inspectedOn': instance.inspectedOn?.toIso8601String(),
      'inspectStatus': instance.inspectStatus,
      'expiryDate': instance.expiryDate?.toIso8601String(),
    };

_StatisticsData _$StatisticsDataFromJson(Map<String, dynamic> json) =>
    _StatisticsData(
      totalSites: (json['totalSites'] as num?)?.toInt(),
      activeSites: (json['activeSites'] as num?)?.toInt(),
      totalJobs: (json['totalJobs'] as num?)?.toInt(),
      activeJobs: (json['activeJobs'] as num?)?.toInt(),
      completedJobs: (json['completedJobs'] as num?)?.toInt(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
      activeItems: (json['activeItems'] as num?)?.toInt(),
      totalReports: (json['totalReports'] as num?)?.toInt(),
      pendingReports: (json['pendingReports'] as num?)?.toInt(),
      approvedReports: (json['approvedReports'] as num?)?.toInt(),
      totalNotifications: (json['totalNotifications'] as num?)?.toInt(),
      unreadNotifications: (json['unreadNotifications'] as num?)?.toInt(),
      jobsByStatus: json['jobsByStatus'] as Map<String, dynamic>?,
      itemsByStatus: json['itemsByStatus'] as Map<String, dynamic>?,
      reportsByStatus: json['reportsByStatus'] as Map<String, dynamic>?,
      notificationsByType: json['notificationsByType'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StatisticsDataToJson(_StatisticsData instance) =>
    <String, dynamic>{
      'totalSites': instance.totalSites,
      'activeSites': instance.activeSites,
      'totalJobs': instance.totalJobs,
      'activeJobs': instance.activeJobs,
      'completedJobs': instance.completedJobs,
      'totalItems': instance.totalItems,
      'activeItems': instance.activeItems,
      'totalReports': instance.totalReports,
      'pendingReports': instance.pendingReports,
      'approvedReports': instance.approvedReports,
      'totalNotifications': instance.totalNotifications,
      'unreadNotifications': instance.unreadNotifications,
      'jobsByStatus': instance.jobsByStatus,
      'itemsByStatus': instance.itemsByStatus,
      'reportsByStatus': instance.reportsByStatus,
      'notificationsByType': instance.notificationsByType,
    };

_DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    _DashboardResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? const DashboardModel()
          : DashboardModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResponseToJson(_DashboardResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_StatisticsResponse _$StatisticsResponseFromJson(Map<String, dynamic> json) =>
    _StatisticsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? const StatisticsData()
          : StatisticsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatisticsResponseToJson(_StatisticsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

_ItemsResponse _$ItemsResponseFromJson(Map<String, dynamic> json) =>
    _ItemsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ItemsResponseToJson(_ItemsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'count': instance.count,
    };
