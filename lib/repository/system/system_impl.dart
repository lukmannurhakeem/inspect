import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:inspect/data/model/get_company_division/get_company_division.dart';
import 'package:inspect/data/model/get_report_type_model/get_report_type_model.dart';
import 'package:inspect/data/model/item_report_model/item_report_model.dart';
import 'package:inspect/data/model/regulation_model/regulation_model.dart';
import 'package:inspect/errors/app_exception.dart';
import 'package:inspect/errors/error_handler.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';
import 'package:inspect/repository/system/system_repository.dart';

typedef DioMediaType = http_parser.MediaType;

class SystemImpl implements SystemRepository {
  final ApiClient _api;

  SystemImpl(this._api);

  @override
  Future<List<GetCompanyDivision>> fetchCompanyDivision() => _api.get(
    ApiEndpoint.companyDivision,
    parser: _parseDivisions,
  );

  @override
  Future<void> createDivision({
    String? customerid,
    String? divisionname,
    String? divisioncode,
    PlatformFile? logoFile,
    String? address,
    String? telephone,
    String? website,
    String? email,
    String? fax,
    String? culture,
    String? timezone,
  }) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.createDivision,
      data: await _buildFormData(
        'divisionData',
        {
          if (customerid != null) 'customerid': customerid,
          'divisionname': divisionname,
          'divisioncode': divisioncode,
          if (address != null) 'address': address,
          if (telephone != null) 'telephone': telephone,
          if (website != null) 'website': website,
          if (email != null) 'email': email,
          if (fax != null) 'fax': fax,
          if (culture != null) 'culture': culture,
          if (timezone != null) 'timezone': timezone,
        },
        {if (logoFile != null) 'logoFile': logoFile},
      ),
    );

    _throwIfQueued(data, 'Division saved locally. Will sync when online.');
  }

  @override
  Future<void> updateDivision({
    required String divisionId,
    String? customerid,
    String? divisionname,
    String? divisioncode,
    PlatformFile? logoFile,
    String? address,
    String? telephone,
    String? website,
    String? email,
    String? fax,
    String? culture,
    String? timezone,
  }) async {
    final data = await _api.patch<dynamic>(
      ApiEndpoint.divisionUpdate(divisionId),
      data: await _buildFormData(
        'divisionData',
        {
          if (customerid != null) 'customerid': customerid,
          if (divisionname != null) 'divisionname': divisionname,
          if (divisioncode != null) 'divisioncode': divisioncode,
          if (address != null) 'address': address,
          if (telephone != null) 'telephone': telephone,
          if (website != null) 'website': website,
          if (email != null) 'email': email,
          if (fax != null) 'fax': fax,
          if (culture != null) 'culture': culture,
          if (timezone != null) 'timezone': timezone,
        },
        {if (logoFile != null) 'logoFile': logoFile},
      ),
    );

    _throwIfQueued(data, 'Division update queued. Will sync when online.');
  }

  @override
  Future<void> deleteDivision(GetCompanyDivision division) async {
    final id = division.divisionid;
    if (id == null) throw UnknownException('Division ID is missing');

    final data = await _api.delete<dynamic>(ApiEndpoint.divisionDelete(id));
    _throwIfQueued(data, 'Division deletion queued. Will sync when online.');
  }

  @override
  Future<GetReportTypeModel> fetchReportTypeModel() => _api.get(
    ApiEndpoint.reportType,
    parser: (data) => data == null
        ? GetReportTypeModel(data: [])
        : GetReportTypeModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<Datum?> fetchReportTypeById(String reportTypeId) => _api.get(
    ApiEndpoint.reportById(reportTypeId),
    parser: _parseDatum,
  );

  @override
  Future<List<dynamic>> fetchReportTypeFieldsRaw(String reportTypeId) async {
    try {
      return await _api.get<List<dynamic>>(
        ApiEndpoint.reportById(reportTypeId),
        parser: _parseReportFields,
      );
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> createReport(
      Map<String, dynamic> requestBody,
      ) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.createReport,
      data: _reportBody(requestBody),
    );
    return _mutationResult(data, 'Report saved locally. Will sync when online.');
  }

  @override
  Future<Map<String, dynamic>?> updateReport(
      String reportId,
      Map<String, dynamic> requestBody,
      ) async {
    final data = await _api.put<dynamic>(
      ApiEndpoint.reportUpdate(reportId),
      data: _reportBody(requestBody),
    );
    return _mutationResult(data, 'Report update queued. Will sync when online.');
  }

  @override
  Future<void> deleteReport(String reportId) async {
    final data = await _api.delete<dynamic>(
      '${ApiEndpoint.deleteReportType}/$reportId',
    );
    _throwIfQueued(data, 'Report deletion queued. Will sync when online.');
  }

  @override
  Future<Map<String, dynamic>?> getReportDetails(String reportId) => _api.get(
    '${ApiEndpoint.reportType}/$reportId',
    parser: _mapOrNull,
  );

  @override
  Future<Map<String, dynamic>?> getReportFields(String reportTypeId) =>
      _api.get(
        ApiEndpoint.getReportField(reportTypeId),
        parser: _mapOrNull,
      );

  @override
  Future<Map<String, dynamic>?> createReportData(
      Map<String, dynamic> requestBody, {
        Map<String, PlatformFile>? files,
      }) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.createReportData,
      data: await _buildFormData('data', _reportDataBody(requestBody), files),
    );
    return _mutationResult(
      data,
      'Report data saved locally. Will sync when online.',
    );
  }

  @override
  Future<Map<String, dynamic>?> updateReportData(
      String reportId,
      Map<String, dynamic> requestBody, {
        Map<String, PlatformFile>? files,
      }) async {
    final data = await _api.put<dynamic>(
      ApiEndpoint.updateReportData(reportId),
      data: await _buildFormData('data', _reportDataBody(requestBody), files),
    );
    return _mutationResult(
      data,
      'Report update saved locally. Will sync when online.',
    );
  }

  @override
  Future<List<ItemReportModel>> fetchReportDataTypeModel(
      String reportTypeId,
      ) async {
    try {
      return await _api.get<List<ItemReportModel>>(
        ApiEndpoint.getItemReport(reportTypeId),
        parser: _parseItemReports,
      );
    } on NotFoundException {
      return [];
    }
  }

  @override
  Future<Uint8List?> fetchPdfReportById(String reportId) async {
    try {
      final response = await _api.raw.get<List<int>>(
        ApiEndpoint.fetchPdfReportById(reportId),
        options: Options(responseType: ResponseType.bytes),
      );

      final data = response.data;
      if (response.statusCode != 200 || data == null) return null;

      final bytes = data is Uint8List ? data : Uint8List.fromList(data);
      final isPdf =
          bytes.length > 4 &&
              bytes[0] == 0x25 &&
              bytes[1] == 0x50 &&
              bytes[2] == 0x44 &&
              bytes[3] == 0x46;

      if (!isPdf) {
        throw DataParsingException(
          'Server response is not a valid PDF file. '
              'First bytes: ${bytes.take(4).toList()}',
        );
      }
      return bytes;
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }

  @override
  Future<Map<String, dynamic>?> createCycle({
    required String reportTypeId,
    String? categoryId,
    String? customerId,
    String? siteId,
    required String unit,
    required int duration,
    int? minLength,
    int? maxLength,
  }) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.createCycle,
      data: {
        'reportTypeId': reportTypeId,
        if (categoryId != null) 'categoryId': categoryId,
        if (customerId != null) 'customerId': customerId,
        if (siteId != null) 'siteId': siteId,
        'unit': unit,
        'duration': duration,
        if (minLength != null) 'minLength': minLength,
        if (maxLength != null) 'maxLength': maxLength,
      },
    );
    return _mutationResult(data, 'Cycle saved locally. Will sync when online.');
  }

  @override
  Future<List<Map<String, dynamic>>> fetchApprovalReports(
      String jobId,
      String status,
      ) async {
    try {
      return await _api.get<List<Map<String, dynamic>>>(
        ApiEndpoint.getApprovalReport(jobId, status),
        parser: _parseApprovalReports,
      );
    } on NotFoundException {
      return [];
    }
  }

  @override
  Future<List<RegulationModel>> fetchRegulations() async {
    try {
      return await _api.get<List<RegulationModel>>(
        ApiEndpoint.regulationView,
        parser: _parseRegulations,
      );
    } on NotFoundException {
      return [];
    }
  }

  @override
  Future<RegulationModel?> createRegulation(String regulationName) async {
    final name = regulationName.trim();
    final data = await _api.post<dynamic>(
      ApiEndpoint.regulationCreate,
      data: {'regulationName': name},
    );

    if (_isQueued(data)) {
      final now = DateTime.now();
      return RegulationModel(
        regulationId: 'pending_${now.millisecondsSinceEpoch}',
        regulationName: name,
        createdAt: now,
        updatedAt: now,
      );
    }
    return _regulationFromResponse(data);
  }

  @override
  Future<RegulationModel?> updateRegulation(
      String regulationId,
      String regulationName,
      ) async {
    final name = regulationName.trim();
    final data = await _api.put<dynamic>(
      ApiEndpoint.regulationUpdate(regulationId),
      data: {'regulationName': name},
    );

    if (_isQueued(data)) {
      return RegulationModel(
        regulationId: regulationId,
        regulationName: name,
        updatedAt: DateTime.now(),
      );
    }
    return _regulationFromResponse(data);
  }

  @override
  Future<void> deleteRegulation(String regulationId) async {
    final data = await _api.delete<dynamic>(
      ApiEndpoint.regulationDelete(regulationId),
    );
    _throwIfQueued(data, 'Regulation deletion queued. Will sync when online.');
  }

  static bool _isQueued(dynamic data) => data is Map && data['queued'] == true;

  static void _throwIfQueued(dynamic data, String message) {
    if (_isQueued(data)) throw NetworkException(message);
  }

  static Map<String, dynamic>? _mutationResult(
      dynamic data,
      String queuedMessage,
      ) {
    if (_isQueued(data)) return {'message': queuedMessage, 'queued': true};
    return _mapOrNull(data);
  }

  static Map<String, dynamic>? _mapOrNull(dynamic data) =>
      data is Map<String, dynamic> ? data : null;

  static RegulationModel? _regulationFromResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final inner = data['data'];
    return inner is Map<String, dynamic> ? RegulationModel.fromJson(inner) : null;
  }

  static Map<String, dynamic> _reportBody(Map<String, dynamic> body) => {
    'reportType': body['reportType'] ?? {},
    'competencyReports': body['competencyReports'] ?? [],
    'reportTypeDates': body['reportTypeDates'] ?? [],
    'statusRuleReports': body['statusRuleReports'] ?? [],
    'reportFields': body['reportFields'] ?? [],
    'actionReports': body['actionReports'] ?? [],
  };

  static Map<String, dynamic> _reportDataBody(Map<String, dynamic> body) => {
    'reportTypeID': body['reportTypeID'] ?? '',
    'itemID': body['itemID'] ?? '',
    'itemNo': body['itemNo'] ?? '',
    'status': body['status'] ?? 'draft',
    'inspectedBy': body['inspectedBy'] ?? '',
    'reportDate': body['reportDate'] ?? '',
    'regulation': body['regulation'] ?? '',
    'reportData': body['reportData'] ?? {},
  };

  static Future<FormData> _buildFormData(
      String jsonField,
      Map<String, dynamic> json,
      Map<String, PlatformFile>? files,
      ) async {
    try {
      final formData = FormData()
        ..fields.add(MapEntry(jsonField, jsonEncode(json)));

      for (final entry in (files ?? const <String, PlatformFile>{}).entries) {
        final file = entry.value;
        final contentType = DioMediaType.parse(_getMimeType(file.name));

        if (kIsWeb && file.bytes != null) {
          formData.files.add(
            MapEntry(
              entry.key,
              MultipartFile.fromBytes(
                file.bytes!,
                filename: file.name,
                contentType: contentType,
              ),
            ),
          );
        } else if (file.path != null) {
          formData.files.add(
            MapEntry(
              entry.key,
              await MultipartFile.fromFile(
                file.path!,
                filename: file.name,
                contentType: contentType,
              ),
            ),
          );
        }
      }

      return formData;
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }

  static List<GetCompanyDivision> _parseDivisions(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data
          .map((e) => GetCompanyDivision.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [GetCompanyDivision.fromJson(data as Map<String, dynamic>)];
  }

  static Map<String, dynamic>? _datumMap(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;

    final inner = raw['data'];
    if (inner is Map<String, dynamic> && inner.containsKey('reportType')) {
      return inner;
    }
    if (raw.containsKey('reportType')) return raw;
    if (inner is List && inner.isNotEmpty && inner.first is Map) {
      return Map<String, dynamic>.from(inner.first as Map);
    }
    return null;
  }

  static Datum? _parseDatum(dynamic data) {
    final map = _datumMap(data);
    return map == null ? null : Datum.fromJson(map);
  }

  static List<dynamic> _parseReportFields(dynamic data) {
    final fields = _datumMap(data)?['reportFields'];
    return fields is List ? List<dynamic>.from(fields) : [];
  }

  static List<ItemReportModel> _parseItemReports(dynamic data) {
    dynamic parsedData = data;

    if (data is String) {
      if (data.trim().isEmpty) return [];
      try {
        parsedData = jsonDecode(data);
      } catch (_) {
        return [];
      }
    }

    final list = parsedData is Map<String, dynamic> ? parsedData['data'] : parsedData;
    if (list is! List) return [];

    return list
        .whereType<Map<String, dynamic>>()
        .map((item) {
      final itemCopy = Map<String, dynamic>.from(item);


      if (itemCopy['reportData'] is Map<String, dynamic>) {
        final rawReportData = itemCopy['reportData'] as Map<String, dynamic>;

        if (!rawReportData.containsKey('fields')) {
          itemCopy['reportData'] = {'fields': rawReportData};
        }
      }

      return ItemReportModel.fromJson(itemCopy);
    })
        .toList();
  }

  static List<Map<String, dynamic>> _parseApprovalReports(dynamic data) {
    final list = data is Map<String, dynamic> ? data['data'] : data;
    if (list is! List) return [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(_normaliseApprovalReport)
        .toList();
  }

  static Map<String, dynamic> _normaliseApprovalReport(
      Map<String, dynamic> r,
      ) => {
    'reportId': r['reportId'] ?? r['report_id'] ?? r['id'] ?? '',
    'reportName': r['reportName'] ?? r['report_name'] ?? '',
    'reportTypeId': r['reportTypeId'] ?? r['report_type_id'] ?? '',
    'reportDate': r['reportDate'] ?? r['report_date'] ?? r['createdAt'] ?? '',
    'createdAt': r['createdAt'] ?? r['created_at'] ?? '',
    'status': r['status'] ?? '',
    'inspectedBy':
    r['inspectedBy'] ?? r['inspected_by'] ?? r['inspectorName'] ?? '',
    'itemId': r['itemId'] ?? r['item_id'] ?? '',
    'itemNo': r['itemNo'] ?? r['item_no'] ?? '',
    'regulation': r['regulation'] ?? '',
    'fieldValues': r['fieldValues'] ?? r['field_values'] ?? {},
    'isPending': false,
  };

  static List<RegulationModel> _parseRegulations(dynamic data) {
    if (data is Map<String, dynamic>) return regulationListFromJson(data);
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(RegulationModel.fromJson)
          .toList();
    }
    return [];
  }

  static String _getMimeType(String fileName) {
    switch (fileName.split('.').last.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        return 'application/octet-stream';
    }
  }
}