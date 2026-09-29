import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:inspect/data/model/get_company_division/get_company_division.dart';
import 'package:inspect/data/model/get_report_type_model/get_report_type_model.dart';
import 'package:inspect/data/model/item_report_model/item_report_model.dart';
import 'package:inspect/data/model/regulation_model/regulation_model.dart';

abstract class SystemRepository {
  Future<List<GetCompanyDivision>> fetchCompanyDivision();

  Future<GetReportTypeModel> fetchReportTypeModel();

  Future<List<ItemReportModel>> fetchReportDataTypeModel(String reportTypeId);

  Future<Datum?> fetchReportTypeById(String reportTypeId);

  Future<List<dynamic>> fetchReportTypeFieldsRaw(String reportTypeId);

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
  });

  Future<void> deleteDivision(GetCompanyDivision division);

  Future<Map<String, dynamic>?> createReport(Map<String, dynamic> requestBody);

  Future<Map<String, dynamic>?> updateReport(
    String reportId,
    Map<String, dynamic> requestBody,
  );

  Future<void> deleteReport(String reportId);

  Future<Map<String, dynamic>?> getReportDetails(String reportId);

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
  });

  Future<Map<String, dynamic>?> getReportFields(String reportTypeId);

  Future<Uint8List?> fetchPdfReportById(String reportId);

  Future<Map<String, dynamic>?> createReportData(
    Map<String, dynamic> requestBody, {
    Map<String, PlatformFile>? files,
  });

  Future<Map<String, dynamic>?> updateReportData(
    String reportId,
    Map<String, dynamic> requestBody, {
    Map<String, PlatformFile>? files,
  });

  Future<Map<String, dynamic>?> createCycle({
    required String reportTypeId,
    String? categoryId,
    String? customerId,
    String? siteId,
    required String unit,
    required int duration,
    int? minLength,
    int? maxLength,
  });

  Future<List<Map<String, dynamic>>> fetchApprovalReports(
    String jobId,
    String status,
  );

  Future<List<RegulationModel>> fetchRegulations();

  Future<RegulationModel?> createRegulation(String regulationName);

  Future<RegulationModel?> updateRegulation(
    String regulationId,
    String regulationName,
  );

  Future<void> deleteRegulation(String regulationId);
}
