

import 'package:inspect/data/model/approval_report_model/approval_report_model.dart';
import 'package:inspect/data/model/job_location_item_model/job_location_item_model.dart';
import 'package:inspect/data/model/job_model/job_model.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/data/model/report_approval_model/report_approval_model.dart';

abstract class JobRepository {
  Future<JobModel> fetchJobModel();

  Future<JobRegisterModel> fetchJobRegisterModel(String jobId);

  Future<ApprovalReportModel> fetchApprovalReport(String jobId);

  Future<Map<String, dynamic>> fetchJobItemDetail(String itemId);

  Future<dynamic> createJobItem(Map<String, dynamic> jobItemData);

  Future<dynamic> createJob(Map<String, dynamic> jobData);

  Future<dynamic> updateJob(String jobId, Map<String, dynamic> jobData);

  Future<Map<String, dynamic>> deleteJob(String jobId);

  Future<dynamic> submitJobItem(String jobId, Item item);

  Future<dynamic> submitJobItemFromMap(
    String jobId,
    Map<String, dynamic> itemMap,
  );

  Future<dynamic> updateApprovalStatus(String reportId, String approvalStatus);

  Future<ReportApprovalModel?> fetchReportApprovals(
    String jobId,
    bool isApproved,
  );

  Future<JobLocationItemModel> fetchJobLocations();

  Future<Map<String, dynamic>> createJobLocation({
    required String itemId,
    required String name,
    required String code,
    String? parentId,
  });

  Future<Map<String, dynamic>> deleteJobLocation(String locationId);

  Future<dynamic> updateJobItem(String itemId, Map<String, dynamic> updates);
  
  Future<Map<String, dynamic>> deleteJobItem(String itemId);
}
