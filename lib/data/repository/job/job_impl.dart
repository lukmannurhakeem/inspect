
import 'package:inspect/data/model/approval_report_model/approval_report_model.dart';
import 'package:inspect/data/model/job_location_item_model/job_location_item_model.dart';
import 'package:inspect/data/model/job_model/job_model.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/data/model/report_approval_model/report_approval_model.dart';
import 'package:inspect/data/repository/job/job_repository.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';


class JobImpl implements JobRepository {
final ApiClient _api;

JobImpl(this._api);

@override
Future<JobModel> fetchJobModel() => _api.get(
ApiEndpoint.jobView,
parser: (data) => JobModel.fromJson(data as Map<String, dynamic>),
);

@override
Future<dynamic> createJob(Map<String, dynamic> jobData) => _mutate(
_api.post<dynamic>(ApiEndpoint.jobCreate, data: jobData),
'Job saved locally. Will sync when online.',
);

@override
Future<dynamic> updateJob(String jobId, Map<String, dynamic> jobData) =>
_mutate(
_api.patch<dynamic>(ApiEndpoint.jobUpdate(jobId), data: jobData),
'Update queued locally. Will sync when online.',
);

@override
Future<Map<String, dynamic>> deleteJob(String jobId) => _mutate(
_api.delete<dynamic>(ApiEndpoint.jobDelete(jobId)),
'Delete queued locally. Will sync when online.',
);

@override
Future<JobRegisterModel> fetchJobRegisterModel(String jobId) => _api.get(
ApiEndpoint.jobRegister(jobId: jobId),
parser: (data) =>
JobRegisterModel.fromJson(data as Map<String, dynamic>),
);

@override
Future<Map<String, dynamic>> fetchJobItemDetail(String itemId) => _api.get(
ApiEndpoint.jobItemDetail(itemId),
parser: (data) {
final map = data as Map<String, dynamic>;
final item = map['item'];
return item is Map<String, dynamic> ? item : map;
},
);

@override
Future<ApprovalReportModel> fetchApprovalReport(String jobId) => _api.get(
ApiEndpoint.getInspectionRegister(jobId),
parser: (data) =>
ApprovalReportModel.fromJson(data as Map<String, dynamic>),
);

@override
Future<dynamic> createJobItem(Map<String, dynamic> jobItemData) =>
submitJobItemFromMap(
(jobItemData['jobID'] ?? jobItemData['jobId'] ?? '') as String,
jobItemData,
);

@override
Future<dynamic> submitJobItem(String jobId, Item item) =>
submitJobItemFromMap(jobId, {
'itemId': item.itemId ?? '',
'itemNo': item.itemNo ?? '',
'description': item.description ?? '',
'categoryID': item.categoryId ?? '',
'locationId': item.locationId ?? '',
'detailedLocation': item.detailedLocation ?? '',
'rfidNo': item.rfidNo ?? '',
'manufacturer': item.manufacturer ?? '',
'swl': item.swl ?? '',
'status': item.status ?? 'submitted',
});

@override
Future<dynamic> submitJobItemFromMap(
String jobId,
Map<String, dynamic> itemMap,
) => _mutate(
_api.post<dynamic>(
ApiEndpoint.jobItemCreate,
data: _buildItemPayload(jobId, itemMap),
),
'Job item saved locally. Will sync when online.',
);

@override
Future<dynamic> updateJobItem(
String itemId,
Map<String, dynamic> updates,
) => _mutate(
_api.patch<dynamic>(ApiEndpoint.jobItemUpdate(itemId), data: updates),
'Update saved locally. Will sync when online.',
);

@override
Future<Map<String, dynamic>> deleteJobItem(String itemId) => _mutate(
_api.delete<dynamic>(ApiEndpoint.jobItemDelete(itemId)),
'Delete queued locally. Will sync when online.',
);

@override
Future<dynamic> updateApprovalStatus(
String reportId,
String approvalStatus,
) {
final cleanId = reportId.startsWith('report_')
? reportId.substring('report_'.length)
    : reportId;

return _mutate(
_api.patch<dynamic>(
ApiEndpoint.updateReportApprovalStatus(cleanId),
data: {'approval_status': approvalStatus},
),
'Saved locally. Will sync when online.',
);
}

@override
Future<ReportApprovalModel?> fetchReportApprovals(
String jobId,
bool isApproved,
) => _api.get(
isApproved
? ApiEndpoint.getReportApprovalDataTrue(jobId)
    : ApiEndpoint.getReportApprovalDataFalse(jobId),
parser: (data) => data == null
? null
    : ReportApprovalModel.fromJson(data as Map<String, dynamic>),
);

@override
Future<JobLocationItemModel> fetchJobLocations() => _api.get(
ApiEndpoint.jobLocationView,
parser: (data) =>
JobLocationItemModel.fromJson(data as Map<String, dynamic>),
);

@override
Future<Map<String, dynamic>> createJobLocation({
required String itemId,
required String name,
required String code,
String? parentId,
}) => _mutate(
_api.post<dynamic>(
ApiEndpoint.jobLocationCreate,
data: {
'itemID': null,
'name': name,
'code': code,
'parentID': parentId,
},
),
'Location saved locally. Will sync when online.',
);

@override
Future<Map<String, dynamic>> deleteJobLocation(String locationId) =>
_mutate(_api.delete<dynamic>(ApiEndpoint.jobLocationDelete(locationId)));

bool _isQueued(dynamic data) => data is Map && data['queued'] == true;

Future<Map<String, dynamic>> _mutate(
Future<dynamic> request, [
String? queuedMessage,
]) async {
final data = await request;

if (queuedMessage != null && _isQueued(data)) {
return {
'message': queuedMessage,
'queued': true,
'requestId': data['requestId'],
};
}
return Map<String, dynamic>.from(data as Map);
}

static String _str(Map<String, dynamic> map, List<String> keys) {
for (final k in keys) {
final v = map[k]?.toString().trim() ?? '';
if (v.isNotEmpty) return v;
}
return '';
}

static bool _hasValue(dynamic value) =>
value != null && value.toString().trim().isNotEmpty;

static String _toServerStatus(String localStatus) {
switch (localStatus.toLowerCase()) {
case 'pending_submission':
case 'pending':
case 'draft':
return 'submitted';
default:
return localStatus;
}
}

static final _uuidRegex = RegExp(
r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
caseSensitive: false,
);

static const _reservedKeys = <String>{
'itemData',
'job_id',
'item_no',
'description',
'category_id',
'location_id',
'detailed_location',
'rfid_no',
'manufacturer',
'manufacturer_address',
'manufacturer_date',
'swl',
'serial_number',
'photo_reference',
'standard_reference',
'notes',
'inspection_status',
'status',
'expiry_date',
'first_use_date',
'out_of_service_date',
'generate_item_no',
'item_id',
'customer_name',
'site_name',
'applicable_code',
'jobId',
'jobID',
'itemNo',
'ItemDescription',
'categoryId',
'categoryID',
'categoryName',
'locationId',
'locationID',
'detailedLocation',
'DetailedLocation',
'ItemLocation',
'rfidNo',
'RFIDNo',
'Manufacturer',
'manufacturerAddress',
'manufacturerDate',
'SWL',
'serialNumber',
'SerialNumber',
'photoReference',
'standardReference',
'Notes',
'inspectionStatus',
'expiryDateTimeStamp',
'ExpiryDate',
'firstUseDate',
'outOfServiceDate',
'archived',
'canInspectItem',
'isActive',
'isApproved',
'generateItemNo',
'itemId',
'itemID',
'customerName',
'Customer',
'siteName',
'SiteID',
'applicableCode',
'ApplicableCode',
'isPending',
'submittedAt',
'errorMessage',
'dimension',
'Dimension',
'tareWeight',
'tare_weight',
'TareWeight',
'payLoad',
'payload',
'PayLoad',
'maxGrossWeight',
'max_gross_weight',
'MaxGrossWeight',
};

Map<String, dynamic> _buildItemPayload(
String jobId,
Map<String, dynamic> itemMap,
) {
final payload = <String, dynamic>{
'jobID': jobId.isNotEmpty
? jobId
    : _str(itemMap, ['job_id', 'jobId', 'jobID']),
'itemNo': _str(itemMap, ['item_no', 'itemNo']),
'description': _str(itemMap, ['description', 'ItemDescription']),
'categoryID': _str(itemMap, ['category_id', 'categoryId', 'categoryID']),
'categoryName': _str(itemMap, ['categoryName', 'category_name']),
'locationID': _str(itemMap, ['location_id', 'locationId', 'locationID']),
'detailedLocation': _str(itemMap, [
'detailed_location',
'detailedLocation',
'DetailedLocation',
'ItemLocation',
]),
'rfidNo': _str(itemMap, ['rfid_no', 'rfidNo', 'RFIDNo']),
'manufacturer': _str(itemMap, ['manufacturer', 'Manufacturer']),
'manufacturerAddress': _str(itemMap, [
'manufacturerAddress',
'manufacturer_address',
]),
'manufacturerDate': _str(itemMap, [
'manufacturerDate',
'manufacturer_date',
]),
'swl': _str(itemMap, ['swl', 'SWL']),
'serialNumber': _str(itemMap, [
'serialNumber',
'serial_number',
'SerialNumber',
]),
'photoReference': _str(itemMap, ['photoReference', 'photo_reference']),
'standardReference': _str(itemMap, [
'standardReference',
'standard_reference',
]),
'notes': _str(itemMap, ['notes', 'Notes']),
'inspectionStatus': _str(itemMap, [
'inspectionStatus',
'inspection_status',
]),
'status': _toServerStatus(_str(itemMap, ['status'])),
'expiryDateTimeStamp': _str(itemMap, [
'expiryDateTimeStamp',
'expiry_date',
'ExpiryDate',
]),
'firstUseDate': _str(itemMap, ['firstUseDate', 'first_use_date']),
'outOfServiceDate': _str(itemMap, [
'outOfServiceDate',
'out_of_service_date',
]),
'archived': itemMap['archived'],
'canInspectItem':
itemMap['canInspectItem'] ?? itemMap['can_inspect_item'],
'isActive': itemMap['isActive'] ?? itemMap['is_active'],
'isApproved': itemMap['isApproved'] ?? itemMap['is_approved'],
'generateItemNo':
itemMap['generateItemNo'] ?? itemMap['generate_item_no'] ?? false,
'customerName': _str(itemMap, [
'customerName',
'customer_name',
'Customer',
]),
'siteName': _str(itemMap, ['siteName', 'site_name', 'SiteID']),
'applicableCode': _str(itemMap, [
'applicableCode',
'applicable_code',
'ApplicableCode',
]),
};

final itemId = _str(itemMap, ['itemId', 'itemID', 'item_id']);
if (_uuidRegex.hasMatch(itemId)) payload['itemID'] = itemId;

payload.removeWhere((_, v) => v == null || (v is String && v.isEmpty));

final itemData = <String, dynamic>{};

final callerItemData = itemMap['itemData'];
if (callerItemData is Map<String, dynamic>) {
for (final entry in callerItemData.entries) {
if (_hasValue(entry.value)) itemData[entry.key] = entry.value;
}
}

void addField(String key, List<String> aliases) {
if (itemData.containsKey(key)) return;
for (final alias in aliases) {
final v = itemMap[alias];
if (v != null) {
itemData[key] = v;
return;
}
}
}

addField('dimension', ['dimension', 'Dimension']);
addField('tareWeight', ['tareWeight', 'TareWeight', 'tare_weight']);
addField('payLoad', ['payLoad', 'PayLoad', 'payload']);
addField('maxGrossWeight', [
'maxGrossWeight',
'MaxGrossWeight',
'max_gross_weight',
]);

for (final entry in itemMap.entries) {
if (_reservedKeys.contains(entry.key)) continue;
if (_hasValue(entry.value)) itemData[entry.key] = entry.value;
}

if (itemData.isNotEmpty) payload['itemData'] = itemData;

return payload;
}
}
