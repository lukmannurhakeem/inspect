class ApiEndpoint {
  static const String login = '/auth/login';
  static const String verifyToken = '/auth/verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String userRegister = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String users = '/auth/users';

  // PATCH /auth/users/:id
  static String userUpdate(String userId) => '/auth/users/$userId';

  // DELETE /auth/users/:id
  static String userDelete(String userId) => '/auth/users/$userId';

  //customer
  static const String customer = '/customer';
  static const String createCustomer = '/customer/create';

  static String getCustomerDetails(String customerId) {
    return '/customer/$customerId';
  }

  static String updateCustomer(String customerId) {
    return '/customer/update/$customerId';
  }

  static String deleteCustomer(String customerId) {
    return '/customer/delete/$customerId';
  }

  static String archiveCustomer(String customerId) {
    return '/customer/archive/$customerId';
  }

  // PATCH /division/update/:id
  static String divisionUpdate(String divisionId) =>
      '/division/update/$divisionId';

  // DELETE /division/delete/:id
  static String divisionDelete(String divisionId) =>
      '/division/delete/$divisionId';

  // PUT /report/update/:id
  static String reportUpdate(String reportId) => '/report/update/$reportId';

  // GET /report/reportbyid/:reporttypeid
  static String reportById(String reportTypeId) =>
      '/report/reportbyid/$reportTypeId';

  // site
  static const String site = '/site/view';
  static const String createSite = '/site/createSite';
  static const String deleteSite = '/site';

  //system
  static const String companyDivision = '/division/view';
  static const String createDivision = '/division/create';
  static const String updateDivision = '/division/update';
  static const String deleteDivision = '/division/delete';
  static const String reportType = '/report/view';
  static const String deleteReportType = '/report/delete';
  static const String createReport = '/report/create';

  // POST /api/v1/cycles/create
  static const String createCycle = '/cycles/create';

  // GET /api/v1/cycles/details
  static const String getCycleDetails = '/cycles/details';

  static String getInspectionRegister(String jobId) {
    return '/reportData/inspectionregister/$jobId';
  }

  static String getApprovalReport(String jobId, String status) {
    return '/reportData/approval/$jobId/$status';
  }

  static String getReportField(String reportTypeId) {
    return '/reportData/fields/$reportTypeId';
  }

  static String fetchPdfReportById(String reportTypeId) {
    return '/reportData/$reportTypeId/view-pdf';
  }

  static String getItemReport(String reportTypeId) {
    return '/reportData/itemreport/$reportTypeId';
  }

  static const String createReportData = '/reportData/create';

  // PUT /reportData/update/:reportId
  static String updateReportData(String reportId) =>
      '/reportData/update/$reportId';

  //job
  static const String jobView = '/job/view';

  static String jobRegister({String? jobId}) {
    if (jobId == null) return '/jobitems/job';
    return '/jobitems/job?jobid=$jobId';
  }

  static const String jobItemCreate = '/jobitems/create';
  static const String personnelMembersView = '/personnelmembers/team';
  static const String personnelMembersAdd = '/personnelmembers/add-member';
  static const String personnelMembersDelete = '/personnelmembers';
  static const String personnelMembersUpdate = '/personnelmembers';
  static const String jobCreate = '/job/create';

  /// PATCH /job/update/:id
  static String jobUpdate(String jobId) => '/job/update/$jobId';

  /// DELETE /job/delete/:id
  static String jobDelete(String jobId) => '/job/delete/$jobId';

  //category
  static const String categoryView = '/category/view';
  static const String categoryCreate = '/category/create';

  //personnel
  static const String personnelView = '/personnel/view';
  static const String personnelCreate = '/personnel/create';
  static const String personnelTeamView = '/teampersonnel/view';
  static const String personnelTeamCreate = '/teampersonnel/create';

  //Agent
  static const String agent = '/agent/view';
  static const String createAgent = '/agent/create';

  static String categoryViewById({String? categoryId}) {
    return categoryId != null ? '/category/$categoryId' : '/category';
  }

  static String getSiteByCustomerId(String customerId) {
    return '/site/customer/$customerId';
  }

  // Inspection Plans
  static const String inspectionPlansView = '/inspectionplans/view';
  static const String inspectionPlansCreate = '/inspectionplans/create';
  static const String inspectionPlansUpdate = '/inspectionplans';
  static const String inspectionPlansDelete = '/inspectionplans/delete';

  static String getInspectionPlanById(String planId) {
    return '/inspectionplans/$planId';
  }

  static String getInspectionPlansByJob(String jobId) {
    return '/inspectionplans/job/$jobId';
  }

  static String getInspectionPlansByAssignee(String assigneeId) {
    return '/inspectionplans/assignee/$assigneeId';
  }

  /// PATCH /inspectionplans/:planId/status
  static String updateInspectionPlanStatus(String planId) {
    return '/inspectionplans/$planId/status';
  }

  /// Legacy — kept for any existing usages (PUT /jobitems/update/{jobId})
  static String updateReportApproval(String jobId) {
    return '/jobitems/update/$jobId';
  }

  /// PATCH /reportData/update/{reportId}/approvalstatus
  static String updateReportApprovalStatus(String reportId) {
    return '/reportData/update/$reportId/approvalstatus';
  }

  static String getReportApprovalDataFalse(String jobId) {
    return '/reportData/approval/$jobId/false';
  }

  static String getReportApprovalDataTrue(String jobId) {
    return '/reportData/approval/$jobId/true';
  }

  ///// Dashboard

  static String getDashboardCustomer(String customerId) {
    return '/custdashboard/$customerId/dashboard';
  }

  static String getDashboardSite(String customerId) {
    return '/custdashboard/$customerId/sites';
  }

  static String getDashboardStatistic(String customerId) {
    return '/custdashboard/$customerId/statistics';
  }

  static String getDashboardReports(String customerId) {
    return '/custdashboard/$customerId/reports';
  }

  static String getDashboardItems(String customerId) {
    return '/custdashboard/$customerId/items';
  }

  static String getDashboardJobs(String customerId) {
    return '/custdashboard/$customerId/jobs';
  }

  // ── Regulation ────────────────────────────────────────────────────────────

  static const String regulationView = '/regulation/view';
  static const String regulationCreate = '/regulation/create';

  /// PUT /regulation/update/:id
  static String regulationUpdate(String regulationId) {
    return '/regulation/update/$regulationId';
  }

  /// DELETE /regulation/delete/:id
  static String regulationDelete(String regulationId) {
    return '/regulation/delete/$regulationId';
  }

  static const area = '/area/view';
  static const createArea = '/area/create';

  static const String jobLocationView = '/joblocationitems/view';
  static const String jobLocationCreate = '/joblocationitems/create';

  static String jobLocationDelete(String id) => '/joblocationitems/delete/$id';

  static String jobItemUpdate(String itemId) => '/jobitems/update/$itemId';

  static String jobItemDelete(String itemId) => '/jobitems/delete/$itemId';

  static const String personnelUpdate = '/personnel/update';
  static const String personnelDelete = '/personnel/delete';
  static const String personnelTeamUpdate = '/teampersonnel/update';
  static const String personnelTeamDelete = '/teampersonnel/delete';

  static String categoryDelete({required String categoryId}) =>
      '/category/delete/$categoryId';

  static String categoryUpdate({required String categoryId}) =>
      '/category/$categoryId';

  // POST /api/v1/category/:categoryId/createFields
  static String categoryCreateField({required String categoryId}) =>
      '/category/$categoryId/createFields';

  // GET/PATCH/DELETE /api/v1/cycles/:cycleId
  static String cycleById(String cycleId) => '/cycles/$cycleId';

  // PATCH /api/v1/agent/update/:id
  static String agentUpdate(String agentId) => '/agent/update/$agentId';

  // DELETE /api/v1/agent/delete/:id
  static String agentDelete(String agentId) => '/agent/delete/$agentId';

  // GET /api/v1/category/:categoryId/getfields
  static String categoryGetFields({required String categoryId}) =>
      '/category/$categoryId/getfields';

  // PATCH /api/v1/category/:categoryId/fields/:fieldId
  static String categoryUpdateField({
    required String categoryId,
    required String fieldId,
  }) => '/category/$categoryId/fields/$fieldId';

  // DELETE /api/v1/category/:categoryId/fields/:fieldId
  static String categoryDeleteField({
    required String categoryId,
    required String fieldId,
  }) => '/category/fields/$fieldId';

  static String viewPdfReport(String reportId) =>
      '/reportData/$reportId/view-pdf';

  static String downloadPdfReport(String reportId) =>
      '/reportData/$reportId/pdf-download';

  static String jobItemDetail(String itemId) => '/jobitems/detail/$itemId';

  static String getReportDataByReportId(String reportId) =>
      '/reportData/$reportId';
}
