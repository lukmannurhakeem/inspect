import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:inspect/data/model/get_customer_model/get_customer_model.dart';
import 'package:inspect/data/repository/customer/customer_repository.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';

class CustomerImpl implements CustomerRepository {
  final ApiClient _api;

  CustomerImpl(this._api);

  @override
  Future<GetCustomerModel> fetchCustomer() => _api.get(
    ApiEndpoint.customer,
    parser: (data) =>
        GetCustomerModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<void> createCustomer({
    required String customerId,
    required String customerName,
    required String siteCode,
    required String accountCode,
    required String divisionId,
    String? agent,
    String? notes,
    String? logo,
    String? address,
    PlatformFile? logoFile,
  }) async {
    final formData = await _buildFormData(
      {
        'customerid': customerId,
        'customername': customerName,
        'sitecode': siteCode,
        'account_code': accountCode,
        'divisionid': divisionId,
        if (agent != null) 'agent': agent,
        if (notes != null) 'notes': notes,
        if (logo != null) 'logo': logo,
        if (address != null) 'address': address,
      },
      logoFile,
    );

    final data = await _api.post<dynamic>(
      ApiEndpoint.createCustomer,
      data: formData,
    );

    if (_isQueued(data)) {
      throw Exception('Customer saved locally. Will sync when online.');
    }
  }

  @override
  Future<void> updateCustomer({
    required String customerId,
    String? customerName,
    String? siteCode,
    String? accountCode,
    String? divisionId,
    String? agent,
    String? notes,
    String? logo,
    String? address,
    PlatformFile? logoFile,
  }) async {
    final fields = <String, dynamic>{
      if (customerName != null) 'customername': customerName,
      if (siteCode != null) 'sitecode': siteCode,
      if (accountCode != null) 'account_code': accountCode,
      if (divisionId != null) 'divisionid': divisionId,
      if (agent != null) 'agent': agent,
      if (notes != null) 'notes': notes,
      if (logo != null) 'logo': logo,
      if (address != null) 'address': address,
    };

    final data = await _api.patch<dynamic>(
      '${ApiEndpoint.customer}/$customerId',
      data: logoFile != null ? await _buildFormData(fields, logoFile) : fields,
    );

    if (_isQueued(data)) {
      throw Exception('Customer update saved locally. Will sync when online.');
    }
  }

  @override
  Future<void> deleteCustomer({required String customerId}) =>
      _api.delete<dynamic>('${ApiEndpoint.customer}/$customerId');

  @override
  Future<Map<String, dynamic>> getDashboardCustomer(String customerId) =>
      _getMap(ApiEndpoint.getDashboardCustomer(customerId));

  @override
  Future<Map<String, dynamic>> getDashboardSite(String customerId) =>
      _getMap(ApiEndpoint.getDashboardSite(customerId));

  @override
  Future<Map<String, dynamic>> getDashboardStatistic(String customerId) =>
      _getMap(ApiEndpoint.getDashboardStatistic(customerId));

  @override
  Future<Map<String, dynamic>> getDashboardReports(String customerId) =>
      _getMap(ApiEndpoint.getDashboardReports(customerId));

  @override
  Future<Map<String, dynamic>> getDashboardItems(String customerId) =>
      _getMap(ApiEndpoint.getDashboardItems(customerId));

  @override
  Future<Map<String, dynamic>> getDashboardJobs(String customerId) =>
      _getMap(ApiEndpoint.getDashboardJobs(customerId));

  Future<Map<String, dynamic>> _getMap(String path) => _api.get(
    path,
    parser: (data) => data as Map<String, dynamic>,
  );

  bool _isQueued(dynamic data) => data is Map && data['queued'] == true;

  Future<FormData> _buildFormData(
      Map<String, dynamic> customerData,
      PlatformFile? logoFile,
      ) async {
    final formData = FormData();
    formData.fields.add(MapEntry('customerData', jsonEncode(customerData)));

    if (logoFile != null) {
      if (kIsWeb && logoFile.bytes != null) {
        formData.files.add(
          MapEntry(
            'logoFile',
            MultipartFile.fromBytes(logoFile.bytes!, filename: logoFile.name),
          ),
        );
      } else if (logoFile.path != null) {
        formData.files.add(
          MapEntry(
            'logoFile',
            await MultipartFile.fromFile(
              logoFile.path!,
              filename: logoFile.name,
            ),
          ),
        );
      }
    }

    return formData;
  }
}