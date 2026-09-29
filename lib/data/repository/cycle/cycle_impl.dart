import 'package:inspect/data/model/cycle_model/cycle_model.dart';
import 'package:inspect/data/repository/cycle/cycle_repository.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';

class CycleImpl implements CycleRepository {
  final ApiClient _api;

  CycleImpl(this._api);

  @override
  Future<CycleModel> fetchCycles() => _api.get(
    ApiEndpoint.getCycleDetails,
    parser: (data) => CycleModel.fromJson(data as Map<String, dynamic>),
  );

  @override
  Future<void> createCycle({
    required String reportTypeId,
    String? categoryId,
    String? customerId,
    String? siteId,
    required String unit,
    required int length,
    int? minLength,
    int? maxLength,
  }) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.createCycle,
      data: {
        'report_type_id': reportTypeId,
        if (categoryId != null) 'category_id': categoryId,
        if (customerId != null) 'customer_id': customerId,
        if (siteId != null) 'site_id': siteId,
        'unit': unit,
        'length': length,
        if (minLength != null) 'min_length': minLength,
        if (maxLength != null) 'max_length': maxLength,
      },
    );

    if (data is Map && data['queued'] == true) {
      throw Exception('Cycle saved locally. Will sync when online.');
    }
  }

  @override
  Future<void> updateCycle({
    required String cycleId,
    required String reportTypeId,
    String? categoryId,
    String? customerId,
    String? siteId,
    required String unit,
    required int length,
    int? minLength,
    int? maxLength,
  }) =>
      _api.patch<dynamic>(
        ApiEndpoint.cycleById(cycleId),
        data: {
          'report_type_id': reportTypeId,
          if (categoryId != null) 'category_id': categoryId,
          if (customerId != null) 'customer_id': customerId,
          if (siteId != null) 'site_id': siteId,
          'unit': unit,
          'length': length,
          if (minLength != null) 'min_length': minLength,
          if (maxLength != null) 'max_length': maxLength,
        },
      );

  @override
  Future<void> deleteCycle(String cycleId) =>
      _api.delete<dynamic>(ApiEndpoint.cycleById(cycleId));

  @override
  Future<Map<String, dynamic>?> getCycleDetails(String cycleId) =>
      _api.get<Map<String, dynamic>?>(
        ApiEndpoint.cycleById(cycleId),
        parser: (data) => data as Map<String, dynamic>?,
      );
}