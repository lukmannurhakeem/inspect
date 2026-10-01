import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/get_company_division/get_company_division.dart';
import 'package:inspect/data/model/get_report_type_model/get_report_type_model.dart';
import 'package:inspect/data/model/item_report_model/item_report_model.dart';
import 'package:inspect/data/model/regulation_model/regulation_model.dart';
import 'package:inspect/data/repository/system/system_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/storage/local_storage.dart';

class SystemProvider extends ChangeNotifier {
  static const _regulationsKey = 'cached_regulations';

  static String _reportFieldsKey(String reportTypeId) =>
      'cached_report_fields_$reportTypeId';

  final SystemRepository _systemRepository = ServiceLocator().systemRepository;

  List<GetCompanyDivision> _division = [];
  List<RegulationModel> _regulations = [];
  List<ItemReportModel>? _itemReportModel;
  List<dynamic> _currentReportTypeRawFields = [];

  GetReportTypeModel? _getReportTypeModel;
  Datum? _currentReportTypeDetail;
  Uint8List? _pdfData;

  bool _isLoading = false;
  bool _isCreatingCycle = false;
  bool _isFetchingPdf = false;
  String? _errorMessage;

  List<GetCompanyDivision> get divisions => _division;
  List<RegulationModel> get regulations => List.unmodifiable(_regulations);
  List<ItemReportModel>? get itemReportModel => _itemReportModel;
  List<dynamic> get currentReportTypeRawFields => _currentReportTypeRawFields;

  GetReportTypeModel? get getReportTypeModel => _getReportTypeModel;
  Datum? get currentReportTypeDetail => _currentReportTypeDetail;
  Uint8List? get pdfData => _pdfData;

  bool get isLoading => _isLoading;
  bool get isCreatingCycle => _isCreatingCycle;
  bool get isFetchingPdf => _isFetchingPdf;
  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;
  bool get hasData => _division.isNotEmpty;
  bool get hasRegulations => _regulations.isNotEmpty;
  bool get hasReport => _getReportTypeModel?.data?.isNotEmpty ?? false;
  bool get hasItemReport => _itemReportModel?.isNotEmpty ?? false;

  Future<T?> _run<T>(
      Future<T> Function() action, {
        bool rethrowError = false,
        bool showLoading = true,
      }) async {
    if (showLoading) _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await action();
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      if (rethrowError) rethrow;
      return null;
    }
  }

  Future<bool> _isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  void loadReportTypesFromCache(List<Map<String, dynamic>> cached) {
    if (cached.isEmpty) return;
    try {
      _getReportTypeModel = GetReportTypeModel.fromJson({'data': cached});
      notifyListeners();
    } catch (e) {
      debugPrint('loadReportTypesFromCache error: $e');
    }
  }

  Future<void> fetchDivision() => _run(() async {
    _division = await _systemRepository.fetchCompanyDivision();
  });

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
  }) => _run(() async {
    await _systemRepository.createDivision(
      customerid: customerid,
      divisionname: divisionname,
      divisioncode: divisioncode,
      logoFile: logoFile,
      address: address,
      telephone: telephone,
      website: website,
      email: email,
      fax: fax,
      culture: culture,
      timezone: timezone,
    );
    await fetchDivision();
  }, rethrowError: true);

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
  }) => _run(() async {
    await _systemRepository.updateDivision(
      divisionId: divisionId,
      customerid: customerid,
      divisionname: divisionname,
      divisioncode: divisioncode,
      logoFile: logoFile,
      address: address,
      telephone: telephone,
      website: website,
      email: email,
      fax: fax,
      culture: culture,
      timezone: timezone,
    );
    await fetchDivision();
  }, rethrowError: true);

  Future<bool> deleteDivision(GetCompanyDivision division) async {
    final deleted = await _run(() async {
      await _systemRepository.deleteDivision(division);
      _division.removeWhere((d) => d.divisionid == division.divisionid);
      return true;
    });
    return deleted ?? false;
  }

  Future<bool> deleteDivisionById(String divisionId) async {
    final division =
        _division.where((d) => d.divisionid == divisionId).firstOrNull;
    if (division == null) {
      _errorMessage = 'Division not found';
      notifyListeners();
      return false;
    }
    return deleteDivision(division);
  }

  Future<void> fetchReportType() => _run(() async {
    _getReportTypeModel = await _systemRepository.fetchReportTypeModel();
  }, showLoading: !hasReport);

  Future<void> _cacheReportFields(
      String reportTypeId,
      List<dynamic> fields,
      ) async {
    try {
      await LocalStorage.setString(
        _reportFieldsKey(reportTypeId),
        jsonEncode(fields),
      );
    } catch (e) {
      debugPrint('SystemProvider: failed to cache report fields: $e');
    }
  }

  List<dynamic> _loadReportFieldsFromCache(String reportTypeId) {
    try {
      final raw = LocalStorage.getString(_reportFieldsKey(reportTypeId));
      return raw.isEmpty ? [] : jsonDecode(raw) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  Future<Datum?> fetchReportTypeById(String reportTypeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Datum? result;
    try {
      if (await _isOnline()) {
        _currentReportTypeRawFields = await _systemRepository
            .fetchReportTypeFieldsRaw(reportTypeId);
        await _cacheReportFields(reportTypeId, _currentReportTypeRawFields);
        result = await _systemRepository.fetchReportTypeById(reportTypeId);
        _currentReportTypeDetail = result;
      } else {
        _currentReportTypeRawFields = _loadReportFieldsFromCache(reportTypeId);
      }
    } catch (e) {
      final cached = _loadReportFieldsFromCache(reportTypeId);
      if (cached.isNotEmpty) {
        _currentReportTypeRawFields = cached;
      } else {
        _errorMessage = e.toString();
      }
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> fetchReportDataType(String reportTypeId) async {
    _isLoading = true;
    _errorMessage = null;
    _itemReportModel = null;
    notifyListeners();

    try {
      _itemReportModel =
      reportTypeId.isEmpty
          ? []
          : await _systemRepository.fetchReportDataTypeModel(reportTypeId);
    } catch (e) {
      if (_isNotFoundError(e)) {
        _itemReportModel = [];
      } else {
        _errorMessage = e.toString();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  static bool _isNotFoundError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('not found') ||
        message.contains('no data') ||
        message.contains('404');
  }

  Map<String, dynamic> _reportBody({
    required Map<String, dynamic> reportType,
    required List<Map<String, dynamic>> competencyReports,
    required List<Map<String, dynamic>> reportTypeDates,
    required List<Map<String, dynamic>> statusRuleReports,
    required List<Map<String, dynamic>> reportFields,
    required List<Map<String, dynamic>> actionReports,
  }) => {
    'reportType': reportType,
    'competencyReports': competencyReports,
    'reportTypeDates': reportTypeDates,
    'statusRuleReports': statusRuleReports,
    'reportFields': reportFields,
    'actionReports': actionReports,
  };

  Future<Map<String, dynamic>?> createReport({
    required Map<String, dynamic> reportType,
    required List<Map<String, dynamic>> competencyReports,
    required List<Map<String, dynamic>> reportTypeDates,
    required List<Map<String, dynamic>> statusRuleReports,
    required List<Map<String, dynamic>> reportFields,
    required List<Map<String, dynamic>> actionReports,
  }) => _run<Map<String, dynamic>?>(() async {
    final result = await _systemRepository.createReport(
      _reportBody(
        reportType: reportType,
        competencyReports: competencyReports,
        reportTypeDates: reportTypeDates,
        statusRuleReports: statusRuleReports,
        reportFields: reportFields,
        actionReports: actionReports,
      ),
    );
    await fetchReportType();
    return result;
  }, rethrowError: true);

  Future<Map<String, dynamic>?> updateReport({
    required String reportId,
    required Map<String, dynamic> reportType,
    required List<Map<String, dynamic>> competencyReports,
    required List<Map<String, dynamic>> reportTypeDates,
    required List<Map<String, dynamic>> statusRuleReports,
    required List<Map<String, dynamic>> reportFields,
    required List<Map<String, dynamic>> actionReports,
  }) => _run<Map<String, dynamic>?>(() async {
    final result = await _systemRepository.updateReport(
      reportId,
      _reportBody(
        reportType: reportType,
        competencyReports: competencyReports,
        reportTypeDates: reportTypeDates,
        statusRuleReports: statusRuleReports,
        reportFields: reportFields,
        actionReports: actionReports,
      ),
    );
    await fetchReportType();
    return result;
  }, rethrowError: true);

  Future<void> deleteReport(String reportId) => _run(() async {
    await _systemRepository.deleteReport(reportId);
    await fetchReportType();
  }, rethrowError: true);

  Future<Map<String, dynamic>?> getReportDetails(String reportId) =>
      _run<Map<String, dynamic>?>(
            () => _systemRepository.getReportDetails(reportId),
      );

  Future<Map<String, dynamic>?> getReportFields(String reportTypeId) =>
      _run<Map<String, dynamic>?>(
            () => _systemRepository.getReportFields(reportTypeId),
      );

  Future<Uint8List?> fetchPdfReportById(String reportId) async {
    _isFetchingPdf = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _pdfData = await _systemRepository.fetchPdfReportById(reportId);
      return _pdfData;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('SystemProvider.fetchPdfReportById error: $e');
      rethrow;
    } finally {
      _isFetchingPdf = false;
      notifyListeners();
    }
  }

  void clearPdfData() {
    _pdfData = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> createReportData({
    required String reportTypeId,
    required String itemId,
    required String itemNo,
    required String status,
    required String inspectedBy,
    required String reportDate,
    required String regulation,
    required Map<String, dynamic> reportData,
    Map<String, PlatformFile>? files,
  }) => _run<Map<String, dynamic>?>(
        () => _systemRepository.createReportData({
      'reportTypeID': reportTypeId,
      'itemID': itemId,
      'itemNo': itemNo,
      'status': status,
      'inspectedBy': inspectedBy,
      'reportDate': reportDate,
      'regulation': regulation,
      'reportData': reportData,
    }, files: files),
    rethrowError: true,
  );

  Future<Map<String, dynamic>?> pushReportPayload(
      Map<String, dynamic> payload, {
        Map<String, PlatformFile>? files,
      }) => _systemRepository.createReportData(payload, files: files);

  Future<Map<String, dynamic>?> updateReportPayload(
      String reportId,
      Map<String, dynamic> payload, {
        Map<String, PlatformFile>? files,
      }) => _systemRepository.updateReportData(reportId, payload, files: files);

  Future<List<Map<String, dynamic>>> fetchApprovalReports(
      String jobId,
      String status,
      ) async {
    try {
      return await _systemRepository.fetchApprovalReports(jobId, status);
    } catch (e) {
      debugPrint('SystemProvider.fetchApprovalReports error: $e');
      return [];
    }
  }

  Future<void> fetchRegulations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (await _isOnline()) {
        _regulations = await _systemRepository.fetchRegulations();
        await LocalStorage.setString(
          _regulationsKey,
          jsonEncode(_regulations.map((r) => r.toJson()).toList()),
        );
      } else {
        _loadRegulationsFromCache();
      }
    } catch (_) {
      _loadRegulationsFromCache();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadRegulationsFromCache() {
    try {
      final raw = LocalStorage.getString(_regulationsKey);
      if (raw.isEmpty) return;
      _regulations =
          (jsonDecode(raw) as List<dynamic>)
              .map((e) => RegulationModel.fromJson(e as Map<String, dynamic>))
              .toList();
    } catch (e) {
      debugPrint('SystemProvider: failed to load regulations cache: $e');
    }
  }

  Future<RegulationModel?> createRegulation(String regulationName) =>
      _run<RegulationModel?>(() async {
        final created = await _systemRepository.createRegulation(
          regulationName,
        );
        if (created != null) _regulations = [..._regulations, created];
        return created;
      }, rethrowError: true);

  Future<RegulationModel?> updateRegulation(
      String regulationId,
      String newName,
      ) => _run<RegulationModel?>(() async {
    final updated = await _systemRepository.updateRegulation(
      regulationId,
      newName,
    );
    if (updated != null) {
      _regulations = [
        for (final r in _regulations)
          if (r.regulationId == regulationId) updated else r,
      ];
    }
    return updated;
  }, rethrowError: true);

  Future<bool> deleteRegulation(String regulationId) async {
    final deleted = await _run(() async {
      await _systemRepository.deleteRegulation(regulationId);
      _regulations = [
        for (final r in _regulations)
          if (r.regulationId != regulationId) r,
      ];
      return true;
    });
    return deleted ?? false;
  }

  void clearRegulations() {
    _regulations = [];
    notifyListeners();
  }

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
    _isCreatingCycle = true;
    notifyListeners();
    try {
      return await _systemRepository.createCycle(
        reportTypeId: reportTypeId,
        categoryId: categoryId,
        customerId: customerId,
        siteId: siteId,
        unit: unit,
        duration: duration,
        minLength: minLength,
        maxLength: maxLength,
      );
    } finally {
      _isCreatingCycle = false;
      notifyListeners();
    }
  }

  void clearData() {
    _division = [];
    _regulations = [];
    _getReportTypeModel = null;
    _itemReportModel = null;
    _currentReportTypeDetail = null;
    _errorMessage = null;
    _isLoading = false;
    _isFetchingPdf = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearReportData() {
    _getReportTypeModel = null;
    notifyListeners();
  }

  void clearItemReportData() {
    _itemReportModel = null;
    notifyListeners();
  }

  void clearDivisionData() {
    _division = [];
    notifyListeners();
  }

  void clearCurrentReportTypeDetail() {
    _currentReportTypeDetail = null;
    _currentReportTypeRawFields = [];
    notifyListeners();
  }
}