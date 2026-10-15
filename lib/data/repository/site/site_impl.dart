import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:inspect/data/model/area_model/area_model.dart';
import 'package:inspect/data/model/get_site_by_customer_id_model/get_site_by_customer_id_model.dart';
import 'package:inspect/data/model/get_site_model/get_site_model.dart';
import 'package:inspect/data/repository/site/site_repository.dart';
import 'package:inspect/errors/app_exception.dart';
import 'package:inspect/errors/error_handler.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';

class SiteImpl implements SiteRepository {
  final ApiClient _api;

  SiteImpl(this._api);

  @override
  Future<GetSiteModel> fetchSite({int page = 1, int limit = 10}) => _api.get(
    ApiEndpoint.site,
    queryParameters: {'page': page, 'limit': limit},
    parser: (data) => GetSiteModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<void> createSite({
    required String siteCode,
    required String siteName,
    required String division,
    required String customerCode,
    required String customerId,
    required String address,
    required String status,
    String? area,
    String? description,
    String? notes,
    PlatformFile? logoFile,
  }) async {
    final siteData = <String, dynamic>{
      'sitecode': siteCode,
      'sitename': siteName,
      'divisionId': division,
      'customercode': customerCode,
      'customerid': customerId,
      'address': address,
      'status': status,
      if (_hasText(area)) 'area': area,
      if (_hasText(description)) 'description': description,
      if (_hasText(notes)) 'notes': notes,
    };

    final data = await _api.post<dynamic>(
      ApiEndpoint.createSite,
      data: await _buildFormData(siteData, logoFile),
    );

    _throwIfQueued(data, 'Site saved locally. Will sync when online.');
  }

  @override
  Future<GetSiteByCustomerIdModel> fetchSiteByCustomerId({
    required String customerId,
  }) => _api.get(
    ApiEndpoint.getSiteByCustomerId(customerId),
    parser: (data) =>
        GetSiteByCustomerIdModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<void> updateSite({
    required String siteId,
    required String siteName,
    required String siteCode,
    required String customerId,
    String? customerCode,
    String? address,
    String? area,
    String? division,
    String? description,
    String? notes,
    String? status,
    PlatformFile? logoFile,
  }) async {
    final body = <String, dynamic>{
      'sitename': siteName,
      'sitecode': siteCode,
      'customerid': customerId,
      if (_hasText(customerCode)) 'customercode': customerCode,
      if (_hasText(address)) 'address': address,
      if (_hasText(area)) 'area': area,
      if (_hasText(division)) 'divisionId': division,
      if (_hasText(description)) 'description': description,
      if (_hasText(notes)) 'notes': notes,
      if (_hasText(status)) 'status': status,
    };

    final data = await _api.patch<dynamic>(
      '${ApiEndpoint.site}/$siteId',
      data: logoFile != null ? await _buildFormData(body, logoFile) : body,
    );

    _throwIfQueued(data, 'Site update saved locally. Will sync when online.');
  }

  @override
  Future<void> deleteSite({required String siteId}) =>
      _api.delete<dynamic>('${ApiEndpoint.deleteSite}/$siteId');

  @override
  Future<GetAreaModel> fetchAreas() => _api.get(
    ApiEndpoint.area,
    parser: (data) => GetAreaModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<void> createArea({
    required String areaname,
    required String areacode,
    String? personnelid,
  }) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.createArea,
      data: {
        'areaname': areaname,
        'areacode': areacode,
        'personnelid': personnelid ?? '',
      },
    );

    _throwIfQueued(data, 'Area saved locally. Will sync when online.');
  }

  static bool _hasText(String? value) => value != null && value.isNotEmpty;

  static void _throwIfQueued(dynamic data, String message) {
    if (data is Map && data['queued'] == true) {
      throw NetworkException(message);
    }
  }

  static Future<FormData> _buildFormData(
      Map<String, dynamic> siteData,
      PlatformFile? logoFile,
      ) async {
    try {
      final formData = FormData()
        ..fields.add(MapEntry('siteData', jsonEncode(siteData)));

      if (logoFile != null) {
        final MultipartFile? file;
        if (kIsWeb && logoFile.bytes != null) {
          file = MultipartFile.fromBytes(
            logoFile.bytes!,
            filename: logoFile.name,
          );
        } else if (logoFile.path != null) {
          file = await MultipartFile.fromFile(
            logoFile.path!,
            filename: logoFile.name,
          );
        } else {
          file = null;
        }
        if (file != null) formData.files.add(MapEntry('logoFile', file));
      }

      return formData;
    } catch (error, stackTrace) {
      throw ErrorHandler.handle(error, stackTrace);
    }
  }
}