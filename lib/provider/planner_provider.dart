import 'package:flutter/material.dart';
import 'package:inspect/data/model/inspection_plan_model/inspection_plan_model.dart';
import 'package:inspect/data/repository/planner/planner_repository.dart';
import 'package:inspect/locator/locator.dart';

enum PlannerStatus { idle, loading, success, error }

class PlannerProvider extends ChangeNotifier {
  final PlannerRepository _repository = ServiceLocator().plannerRepository;

  PlannerStatus _status = PlannerStatus.idle;
  String? _errorMessage;
  List<InspectionPlanModel> _plans = [];
  InspectionPlanModel? _selectedPlan;
  int _pendingSyncCount = 0;
  String? _updatingPlanId;

  PlannerStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<InspectionPlanModel> get plans => _plans;
  InspectionPlanModel? get selectedPlan => _selectedPlan;
  int get pendingSyncCount => _pendingSyncCount;
  String? get updatingPlanId => _updatingPlanId;
  bool get isLoading => _status == PlannerStatus.loading;
  bool get hasError => _status == PlannerStatus.error;

  Future<T?> _run<T>(
      Future<T> Function() action, {
        required String errorPrefix,
      }) async {
    _setStatus(PlannerStatus.loading);
    try {
      final result = await action();
      _setStatus(PlannerStatus.success);
      notifyListeners();
      return result;
    } catch (e) {
      _setError('$errorPrefix: $e');
      return null;
    }
  }

  Future<void> _loadPlans(
      Future<List<InspectionPlanModel>> Function() loader,
      String errorPrefix,
      ) async {
    await _run<void>(
          () async => _plans = await loader(),
      errorPrefix: errorPrefix,
    );
  }

  Future<bool> createInspectionPlan(Map<String, dynamic> planData) async {
    final ok = await _run<bool>(() async {
      final plan = await _repository.createInspectionPlan(planData);
      _plans.insert(0, plan);
      _refreshPendingCount();
      return true;
    }, errorPrefix: 'Failed to create plan');
    return ok ?? false;
  }

  Future<void> fetchInspectionPlans() =>
      _loadPlans(_repository.getInspectionPlans, 'Failed to fetch plans');

  Future<void> fetchInspectionPlanById(String planId) async {
    await _run<void>(
          () async =>
      _selectedPlan = await _repository.getInspectionPlanById(planId),
      errorPrefix: 'Failed to fetch plan',
    );
  }

  Future<void> fetchPlansByJob(String jobId) => _loadPlans(
        () => _repository.getInspectionPlansByJob(jobId),
    'Failed to fetch job plans',
  );

  Future<void> fetchPlansByAssignee(String assigneeId) => _loadPlans(
        () => _repository.getInspectionPlansByAssignee(assigneeId),
    'Failed to fetch assignee plans',
  );

  Future<bool> updateInspectionPlan(
      String planId,
      Map<String, dynamic> planData,
      ) async {
    final ok = await _run<bool>(() async {
      final updated = await _repository.updateInspectionPlan(planId, planData);
      final index = _indexOf(planId);
      if (index != -1) _plans[index] = updated;
      _refreshPendingCount();
      return true;
    }, errorPrefix: 'Failed to update plan');
    return ok ?? false;
  }

  Future<bool> updatePlanStatus(String planId, String newStatus) async {
    _updatingPlanId = planId;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.updateInspectionPlanStatus(planId, newStatus);
      final index = _indexOf(planId);
      if (index != -1) {
        _plans[index] = _plans[index].copyWith(status: newStatus);
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update status: $e';
      return false;
    } finally {
      _updatingPlanId = null;
      notifyListeners();
    }
  }

  Future<bool> deleteInspectionPlan(String planId) async {
    final ok = await _run<bool>(() async {
      final success = await _repository.deleteInspectionPlan(planId);
      if (success) _plans.removeWhere((p) => p.id == planId);
      _refreshPendingCount();
      return success;
    }, errorPrefix: 'Failed to delete plan');
    return ok ?? false;
  }

  Future<bool> syncPendingPlans() async {
    try {
      await _repository.syncPendingPlans();
      _refreshPendingCount();
      await fetchInspectionPlans();
      return true;
    } catch (e) {
      _setError('Failed to sync: $e');
      return false;
    }
  }

  List<InspectionPlanModel> getPlansByStatus(String status) =>
      _plans.where((p) => p.status == status).toList();

  List<InspectionPlanModel> getPlansByPriority(String priority) =>
      _plans.where((p) => p.priority == priority).toList();

  List<InspectionPlanModel> getUpcomingPlans() {
    final now = DateTime.now();
    return _plans
        .where((p) => p.plannedStartDate?.isAfter(now) ?? false)
        .toList();
  }

  List<InspectionPlanModel> getOverduePlans() {
    final now = DateTime.now();
    return _plans.where((p) {
      final end = p.plannedEndDate;
      if (end == null || p.status.toLowerCase() == 'completed') return false;
      return end.isBefore(now);
    }).toList();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == PlannerStatus.error) _status = PlannerStatus.idle;
    notifyListeners();
  }

  int _indexOf(String planId) => _plans.indexWhere((p) => p.id == planId);

  void _refreshPendingCount() {
    _pendingSyncCount = _repository.getPendingSyncCount();
  }

  void _setStatus(PlannerStatus status) {
    _status = status;
    if (status != PlannerStatus.error) _errorMessage = null;
  }

  void _setError(String message) {
    _status = PlannerStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}