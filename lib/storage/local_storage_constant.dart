class LocalStorageConstant {
  // Token
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // User
  static const String userFirstName = 'user_first_name';
  static const String userLastName = 'user_last_name';
  static const String userEmail = 'user_email';
  static const String userGroup = 'user_group';
  static const String userId = 'userId';

  // Job drafts and offline queue
  static const String jobDrafts = 'job_drafts';
  static const String pendingJobsQueue = 'pending_jobs_queue';
  static const String lastJobDraftTimestamp = 'last_job_draft_timestamp';

  // Job cache and sync
  static const String cachedJobs = 'cached_jobs';
  static const String lastJobSyncTimestamp = 'last_job_sync_timestamp';

  // Report drafts
  static const String reportDraft = 'report_draft';
  static const String lastReportDraftTimestamp = 'last_report_draft_timestamp';

  // Report type cache and sync  ← mirrors job cache pattern
  static const String cachedReportTypes = 'cached_report_types';
  static const String lastReportTypeSyncTimestamp =
      'last_report_type_sync_timestamp';

  // Offline cache — customers & sites (for offline create flow)
  static const String cachedCustomers = 'cached_customers';
  static const String lastCustomerSyncTimestamp =
      'last_customer_sync_timestamp';
  static const String cachedSites = 'cached_sites';
  static const String lastSiteSyncTimestamp = 'last_site_sync_timestamp';
}
