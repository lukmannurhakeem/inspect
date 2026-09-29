

import 'package:inspect/data/model/inspection_plan_model/inspection_plan_model.dart';

abstract class PlannerRepository {

  Future<InspectionPlanModel> createInspectionPlan(
    Map<String, dynamic> planData,
  );

  Future<List<InspectionPlanModel>> getInspectionPlans();

  Future<InspectionPlanModel> getInspectionPlanById(String planId);

  Future<List<InspectionPlanModel>> getInspectionPlansByJob(String jobId);

  Future<List<InspectionPlanModel>> getInspectionPlansByAssignee(
    String assigneeId,
  );

  Future<InspectionPlanModel> updateInspectionPlan(
    String planId,
    Map<String, dynamic> planData,
  );

  Future<void> updateInspectionPlanStatus(String planId, String status);

  Future<bool> deleteInspectionPlan(String planId);

  int getPendingSyncCount();

  Future<void> syncPendingPlans();
}
