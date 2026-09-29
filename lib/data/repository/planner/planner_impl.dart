import 'package:inspect/data/model/inspection_plan_model/inspection_plan_model.dart';
import 'package:inspect/data/repository/planner/planner_repository.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/network/api_endpoint.dart';

class PlannerImpl implements PlannerRepository {
  final ApiClient _api;

  PlannerImpl(this._api);

  @override
  Future<InspectionPlanModel> createInspectionPlan(
      Map<String, dynamic> planData,
      ) async {
    final data = await _api.post<dynamic>(
      ApiEndpoint.inspectionPlansCreate,
      data: planData,
    );

    if (_isQueued(data)) {
      return InspectionPlanModel.fromJson({
        ...planData,
        'id': data['requestId'],
        'isQueued': true,
      });
    }
    return InspectionPlanModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<InspectionPlanModel>> getInspectionPlans() => _api.get(
    ApiEndpoint.inspectionPlansView,
    parser: _parsePlans,
  );

  @override
  Future<InspectionPlanModel> getInspectionPlanById(String planId) => _api.get(
    ApiEndpoint.getInspectionPlanById(planId),
    parser: _parsePlan,
  );

  @override
  Future<List<InspectionPlanModel>> getInspectionPlansByJob(String jobId) =>
      _api.get(
        ApiEndpoint.getInspectionPlansByJob(jobId),
        parser: _parsePlans,
      );

  @override
  Future<List<InspectionPlanModel>> getInspectionPlansByAssignee(
      String assigneeId,
      ) => _api.get(
    ApiEndpoint.getInspectionPlansByAssignee(assigneeId),
    parser: _parsePlans,
  );

  @override
  Future<InspectionPlanModel> updateInspectionPlan(
      String planId,
      Map<String, dynamic> planData,
      ) async {
    final data = await _api.put<dynamic>(
      '${ApiEndpoint.inspectionPlansUpdate}/$planId',
      data: planData,
    );

    if (_isQueued(data)) {
      return InspectionPlanModel.fromJson({
        ...planData,
        'id': planId,
        'isQueued': true,
      });
    }
    return _parsePlan(data);
  }

  @override
  Future<void> updateInspectionPlanStatus(String planId, String status) =>
      _api.patch<dynamic>(
        ApiEndpoint.updateInspectionPlanStatus(planId),
        data: {'status': status},
      );

  @override
  Future<bool> deleteInspectionPlan(String planId) async {
    await _api.delete<dynamic>(
      '${ApiEndpoint.inspectionPlansDelete}/$planId',
    );
    return true;
  }

  @override
  int getPendingSyncCount() => 0;

  @override
  Future<void> syncPendingPlans() async {}

  static bool _isQueued(dynamic data) => data is Map && data['queued'] == true;

  static InspectionPlanModel _parsePlan(dynamic data) {
    final map = data as Map<String, dynamic>;
    final inner = map['data'];
    return InspectionPlanModel.fromJson(
      inner is Map<String, dynamic> ? inner : map,
    );
  }

  static List<InspectionPlanModel> _parsePlans(dynamic data) {
    final list = data is Map<String, dynamic> ? data['data'] : data;
    if (list is! List) return [];
    return list
        .map((e) => InspectionPlanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}