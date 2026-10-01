import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/get_customer_model/get_customer_model.dart';
import 'package:inspect/data/model/job_location_item_model/job_location_item_model.dart';
import 'package:inspect/data/model/job_model/job_model.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/data/model/report_approval_model/report_approval_model.dart';
import 'package:inspect/data/repository/customer/customer_repository.dart';
import 'package:inspect/data/repository/job/job_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:uuid/uuid.dart';

enum SearchColumnType { customer, jobNo, site, status }

class JobProvider extends ChangeNotifier {
  static const _jobRegisterKey = 'job_register_data';

  final CustomerRepository _customerRepository =
      ServiceLocator().customerRepository;
  final JobRepository _jobRepository = ServiceLocator().jobRepository;

  final customerIdController = TextEditingController();
  final siteCodeController = TextEditingController();
  final accountCodeController = TextEditingController();
  final divisionController = TextEditingController();
  final customerNameController = TextEditingController();
  final agentController = TextEditingController();
  final notesController = TextEditingController();
  final logoController = TextEditingController();
  final addressController = TextEditingController();

  late final List<TextEditingController> _controllers = [
    customerIdController,
    siteCodeController,
    accountCodeController,
    divisionController,
    customerNameController,
    agentController,
    notesController,
    logoController,
    addressController,
  ];

  final uuid = const Uuid();

  GetCustomerModel? _getCustomerModel;
  List<Customer> _customers = [];

  JobModel? _jobModel;
  JobRegisterModel? _jobRegisterModel;
  String? _currentJobId;
  Item? _currentItem;

  List<JobLocationItem> _jobLocations = [];
  bool _isLoadingLocations = false;
  bool _hasFetchedLocations = false;

  ReportApprovalModel? _pendingReportApprovals;
  ReportApprovalModel? _approvedReportApprovals;
  String _currentApprovalFilter = 'pending';
  bool _hasAttemptedFetch = false;
  bool _isUpdatingApproval = false;
  String? _approvalError;
  int _itemReportRefreshCount = 0;

  SearchColumnType? _selectedSearchColumn;
  dynamic _selectedSearchValue;

  bool _isLoading = false;
  bool _isSyncing = false;
  bool _isLoadedFromCache = false;
  DateTime? _lastSyncTime;
  String? _error;

  int? sortColumnIndex;
  bool sortAscending = true;

  GetCustomerModel? get getCustomerModel => _getCustomerModel;
  List<Customer> get customers => _customers;

  JobModel? get jobModel => _jobModel;
  JobRegisterModel? get jobRegisterModel => _jobRegisterModel;
  List<Item> get jobItems => _jobRegisterModel?.items ?? [];
  Item? get currentItem => _currentItem;

  List<JobLocationItem> get jobLocations => _jobLocations;
  bool get isLoadingLocations => _isLoadingLocations;

  SearchColumnType? get selectedSearchColumn => _selectedSearchColumn;
  dynamic get selectedSearchValue => _selectedSearchValue;

  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  bool get isLoadedFromCache => _isLoadedFromCache;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get error => _error;

  bool get isUpdatingApproval => _isUpdatingApproval;
  String? get approvalError => _approvalError;
  String get currentApprovalFilter => _currentApprovalFilter;
  bool get hasAttemptedFetch => _hasAttemptedFetch;
  int get itemReportRefreshCount => _itemReportRefreshCount;

  bool get hasLoadedApprovals =>
      _pendingReportApprovals != null || _approvedReportApprovals != null;

  List<ReportApprovalData> get pendingReports =>
      _pendingReportApprovals?.data ?? [];

  List<ReportApprovalData> get approvedReports =>
      _approvedReportApprovals?.data ?? [];

  List<ReportApprovalData> get reportApprovals =>
      _approvalsFor(_currentApprovalFilter);

  bool get _hasJobs => _jobModel?.data?.isNotEmpty ?? false;

  bool get _hasRegisterItems => _jobRegisterModel?.items?.isNotEmpty ?? false;

  List<ReportApprovalData> _approvalsFor(String filter) => switch (filter) {
    'approved' => approvedReports,
    'all' => [...pendingReports, ...approvedReports],
    _ => pendingReports,
  };

  Future<void> _withLoading(
      Future<void> Function() action, {
        bool clearError = false,
      }) async {
    _isLoading = true;
    if (clearError) _error = null;
    notifyListeners();
    try {
      await action();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _withSyncing(Future<void> Function() action) async {
    _isSyncing = true;
    notifyListeners();
    try {
      await action();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<bool> _isOnline() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      debugPrint('JobProvider: connectivity check failed: $e');
      return false;
    }
  }

  static bool _wasQueued(dynamic result) =>
      result is Map && result['queued'] == true;

  static bool _isConnectionError(DioException e) => const {
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.connectionError,
  }.contains(e.type);

  String _parseDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final message =
      (data['error'] ?? data['message'] ?? data['detail'])?.toString();
      if (message != null && message.isNotEmpty) return message;
    }

    if (_isConnectionError(e)) return 'No internet connection';

    return switch (e.response?.statusCode) {
      400 => 'Invalid request data',
      401 => 'Unauthorized. Please log in again',
      403 => 'You do not have permission',
      404 => 'Resource not found',
      409 => 'Conflict with existing data',
      422 => 'Invalid data format',
      429 => 'Too many requests. Try again later',
      final int code when code >= 500 => 'Server error. Try again later',
      _ => 'An unexpected error occurred',
    };
  }

  String _describe(Object error) =>
      error is DioException ? _parseDioError(error) : error.toString();

  Map<String, dynamic> _success({
    required bool queued,
    required String queuedMessage,
    required String doneMessage,
  }) => {
    'success': true,
    'queued': queued,
    'message': queued ? queuedMessage : doneMessage,
  };

  Map<String, dynamic> _failure(Object error) => {
    'success': false,
    'error': _describe(error),
  };

  Map<String, dynamic> _submitResult(dynamic result) =>
      _wasQueued(result)
          ? {
        'success': true,
        'queued': true,
        'message': 'Saved locally. Will sync when online.',
      }
          : {'success': true, 'queued': false, 'data': result};

  void _showError(BuildContext context, String message) {
    if (context.mounted) CommonSnackbar.showError(context, message);
  }

  void _showSuccess(BuildContext context, String message) {
    if (context.mounted) CommonSnackbar.showSuccess(context, message);
  }

  void _showInfo(BuildContext context, String message) {
    if (context.mounted) CommonSnackbar.showInfo(context, message);
  }

  void _notifyCacheFallback(
      BuildContext context, {
        required bool hasCache,
        required String emptyMessage,
      }) {
    if (hasCache) {
      _showInfo(context, 'Loaded from cache. Sync to get latest data.');
    } else {
      _showError(context, emptyMessage);
    }
  }

  String? _textOrNull(TextEditingController controller) =>
      controller.text.isEmpty ? null : controller.text;

  void setApprovalFilter(String filter) {
    _currentApprovalFilter = filter;
    notifyListeners();
  }

  void triggerItemReportRefresh() {
    _itemReportRefreshCount++;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchJobItemDetail(
      BuildContext context,
      String itemId,
      ) async {
    try {
      return await _jobRepository.fetchJobItemDetail(itemId);
    } catch (e) {
      debugPrint('JobProvider.fetchJobItemDetail: ${_describe(e)}');
      return null;
    }
  }

  String? _text(Map<String, dynamic> updates, String key, String? fallback) =>
      updates[key]?.toString() ?? fallback;

  Future<void> _applyItemUpdates(
      String itemId,
      Map<String, dynamic> updates,
      ) async {
    final items = _jobRegisterModel?.items;
    final index = items?.indexWhere((item) => item.itemId == itemId) ?? -1;
    if (items == null || index == -1) return;

    final existing = items[index];
    items[index] = Item(
      itemId: existing.itemId,
      itemNo: _text(updates, 'itemNo', existing.itemNo),
      description: _text(updates, 'description', existing.description),
      categoryId: _text(updates, 'categoryID', existing.categoryId),
      locationId: _text(updates, 'locationID', existing.locationId),
      detailedLocation: _text(
        updates,
        'detailedLocation',
        existing.detailedLocation,
      ),
      rfidNo: _text(updates, 'rfidNo', existing.rfidNo),
      manufacturer: _text(updates, 'manufacturer', existing.manufacturer),
      swl: _text(updates, 'swl', existing.swl),
      status: updates['status']?.toString() ?? existing.status,
      archived: existing.archived,
      customFields: existing.customFields,
    );
    await _saveJobRegisterToLocalStorage();
    notifyListeners();
  }

  Future<Map<String, dynamic>> updateJobItem(
      BuildContext context,
      String itemId,
      Map<String, dynamic> updates,
      ) async {
    try {
      final queued = _wasQueued(
        await _jobRepository.updateJobItem(itemId, updates),
      );
      if (!queued) await _applyItemUpdates(itemId, updates);

      return _success(
        queued: queued,
        queuedMessage: 'Update saved locally. Will sync when online.',
        doneMessage: 'Item updated successfully.',
      );
    } catch (e) {
      return _failure(e);
    }
  }

  Future<Map<String, dynamic>> deleteJobItem(
      BuildContext context,
      String itemId,
      ) async {
    try {
      final queued = _wasQueued(await _jobRepository.deleteJobItem(itemId));
      if (!queued && _jobRegisterModel?.items != null) {
        _jobRegisterModel!.items!.removeWhere((item) => item.itemId == itemId);
        await _saveJobRegisterToLocalStorage();
        notifyListeners();
      }

      return _success(
        queued: queued,
        queuedMessage: 'Delete queued locally. Will sync when online.',
        doneMessage: 'Item deleted successfully.',
      );
    } catch (e) {
      return _failure(e);
    }
  }

  Future<void> fetchReportApprovals(
      BuildContext context,
      String jobId, {
        bool fetchBoth = true,
      }) => _withLoading(clearError: true, () async {
    try {
      if (fetchBoth) {
        final results = await Future.wait([
          _jobRepository.fetchReportApprovals(jobId, false),
          _jobRepository.fetchReportApprovals(jobId, true),
        ]);
        _pendingReportApprovals = results[0];
        _approvedReportApprovals = results[1];
      } else if (_currentApprovalFilter == 'pending') {
        _pendingReportApprovals = await _jobRepository.fetchReportApprovals(
          jobId,
          false,
        );
      } else if (_currentApprovalFilter == 'approved') {
        _approvedReportApprovals = await _jobRepository.fetchReportApprovals(
          jobId,
          true,
        );
      }
    } catch (e) {
      _error = _describe(e);
      _showError(context, _error!);
    } finally {
      _hasAttemptedFetch = true;
    }
  });

  Future<List<Map<String, dynamic>>> loadLocalDraftReports() async {
    final drafts = <Map<String, dynamic>>[];

    for (final item in jobItems) {
      final itemId = item.itemId ?? '';
      if (itemId.isEmpty) continue;

      try {
        final reports = await JobItemStorage.getItemReports(itemId);
        for (final report in reports) {
          if (report['isPending'] != true) continue;
          drafts.add({
            ...report,
            '_itemId': itemId,
            '_itemNo': item.itemNo ?? '',
            '_isLocalDraft': true,
          });
        }
      } catch (e) {
        debugPrint('JobProvider.loadLocalDraftReports: $itemId: $e');
      }
    }
    return drafts;
  }

  Map<String, int> getApprovalStats({int localDraftCount = 0}) {
    final pending = pendingReports.length;
    final approved = approvedReports.length;
    return {
      'total': pending + approved + localDraftCount,
      'pending': pending + localDraftCount,
      'approved': approved,
      'rejected': 0,
    };
  }

  bool hasPendingApprovals() => pendingReports.isNotEmpty;

  int getPendingApprovalsCount() => pendingReports.length;

  List<ReportApprovalData> filterReportsByStatus(String status) =>
      switch (status.toLowerCase()) {
        'pending' => pendingReports,
        'approved' => approvedReports,
        'rejected' => [],
        _ => reportApprovals,
      };

  List<ReportApprovalData> searchReports(String query, String view) {
    final source = view == 'pending' ? pendingReports : approvedReports;
    if (query.isEmpty) return source;

    final q = query.toLowerCase();
    return source
        .where(
          (report) =>
      (report.reportName?.toLowerCase().contains(q) ?? false) ||
          (report.itemNo?.toLowerCase().contains(q) ?? false) ||
          report.displayInspector.toLowerCase().contains(q),
    )
        .toList();
  }

  void clearReportApprovals() {
    _pendingReportApprovals = null;
    _approvedReportApprovals = null;
    _currentApprovalFilter = 'pending';
    _hasAttemptedFetch = false;
    notifyListeners();
  }

  void reset() {
    _jobModel = null;
    _jobRegisterModel = null;
    _pendingReportApprovals = null;
    _approvedReportApprovals = null;
    _currentApprovalFilter = 'pending';
    _hasAttemptedFetch = false;
    _getCustomerModel = null;
    _customers = [];
    _isLoading = false;
    _error = null;
    sortColumnIndex = null;
    sortAscending = true;
    _selectedSearchColumn = null;
    _selectedSearchValue = null;
    _currentJobId = null;
    _currentItem = null;
    _isSyncing = false;
    _lastSyncTime = null;
    _isLoadedFromCache = false;
    _jobLocations = [];
    _isLoadingLocations = false;
    _hasFetchedLocations = false;
    notifyListeners();
  }

  String _approvalMessage(String status) => switch (status) {
    'approved' => 'Report approved successfully',
    'rejected' => 'Report rejected',
    _ => 'Status updated to $status',
  };

  Future<Map<String, dynamic>?> updateReportApprovalStatus(
      BuildContext context,
      String reportId,
      String approvalStatus,
      ) async {
    _isUpdatingApproval = true;
    _approvalError = null;
    notifyListeners();

    try {
      final queued = _wasQueued(
        await _jobRepository.updateApprovalStatus(reportId, approvalStatus),
      );
      return _success(
        queued: queued,
        queuedMessage: 'Saved locally. Will sync when online.',
        doneMessage: _approvalMessage(approvalStatus),
      );
    } catch (e) {
      _approvalError = _describe(e);
      return {'success': false, 'error': _approvalError};
    } finally {
      _isUpdatingApproval = false;
      notifyListeners();
    }
  }

  void clearApprovalError() {
    _approvalError = null;
    notifyListeners();
  }

  Item? getItemById(String itemId) =>
      jobItems.where((item) => item.itemId == itemId).firstOrNull;

  void setCurrentItem(String itemId) {
    _currentItem = getItemById(itemId);
    notifyListeners();
  }

  void setCurrentItemDirect(Item item) {
    _currentItem = item;
    notifyListeners();
  }

  void clearCurrentItem() {
    _currentItem = null;
    notifyListeners();
  }

  void setSearch(SearchColumnType? column, dynamic value) {
    _selectedSearchColumn = column;
    _selectedSearchValue = value;
    notifyListeners();
  }

  void clearSearch() => setSearch(null, null);

  void clearFiltersAndSort() {
    sortColumnIndex = null;
    sortAscending = true;
    _selectedSearchColumn = null;
    _selectedSearchValue = null;
    notifyListeners();
  }

  void clearJobRegisterModel() {
    _jobRegisterModel = null;
    _currentJobId = null;
    _currentItem = null;
    notifyListeners();
  }

  void clearJobRegisterError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  Future<void> _queueJob(
      BuildContext context,
      Map<String, dynamic> jobData,
      String message,
      bool silent,
      ) async {
    await JobStorage.addToPendingQueue(jobData);
    if (silent || !context.mounted) return;
    CommonSnackbar.showSuccess(context, message);
    NavigationService().goBack();
  }

  Future<void> createJobFromDetails(
      BuildContext context,
      Map<String, dynamic> jobData, {
        bool silent = false,
      }) => _withLoading(clearError: true, () async {
    try {
      if (!await _isOnline()) {
        await _queueJob(
          context,
          jobData,
          'You are offline. Job saved and will sync when connected.',
          silent,
        );
        return;
      }

      final result = await _jobRepository.createJob(jobData);
      await fetchJobModel(context);

      if (!silent && context.mounted) {
        CommonSnackbar.showSuccess(
          context,
          result['message']?.toString() ?? 'Job created successfully',
        );
        NavigationService().goBack();
      }
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        await _queueJob(
          context,
          jobData,
          'Network error. Job saved and will sync when connected.',
          silent,
        );
        return;
      }
      _error = _parseDioError(e);
      if (!silent) _showError(context, _error!);
      rethrow;
    } catch (_) {
      _error = 'An unexpected error occurred';
      if (!silent) _showError(context, _error!);
      rethrow;
    }
  });

  Future<void> updateJobFromDetails(
      BuildContext context,
      String jobId,
      Map<String, dynamic> jobData, {
        bool silent = false,
      }) => _withLoading(clearError: true, () async {
    try {
      final result = await _jobRepository.updateJob(jobId, jobData);
      final queued = _wasQueued(result);

      await fetchJobModel(context);

      if (!silent && context.mounted) {
        final message =
        queued
            ? 'Job update queued (offline). Will sync when online.'
            : (result is Map ? result['message']?.toString() : null) ??
            'Job updated successfully';
        CommonSnackbar.showSuccess(context, message);
        NavigationService().goBack();
      }
    } on DioException catch (e) {
      _error = _parseDioError(e);
      if (!silent) _showError(context, _error!);
      rethrow;
    } catch (_) {
      _error = 'An unexpected error occurred';
      if (!silent) _showError(context, _error!);
      rethrow;
    }
  });

  Future<void> deleteJobFromList(BuildContext context, String jobId) =>
      _withLoading(() async {
        try {
          final queued = _wasQueued(await _jobRepository.deleteJob(jobId));

          _jobModel?.data?.removeWhere((job) => job.jobId == jobId);
          notifyListeners();
          await _saveJobsToLocalStorage();

          _showSuccess(
            context,
            queued
                ? 'Delete queued (offline). Will sync when online.'
                : 'Job deleted successfully',
          );
        } catch (e) {
          _showError(context, _describe(e));
        }
      });

  List<Datum> getFilteredJobs() {
    final jobs = _jobModel?.data ?? [];
    final column = _selectedSearchColumn;
    final value = _selectedSearchValue;
    if (column == null || value == null) return jobs;

    return jobs
        .where(
          (job) => switch (column) {
        SearchColumnType.customer => job.customerName == value,
        SearchColumnType.jobNo => job.jobId == value,
        SearchColumnType.site => job.siteName == value,
        SearchColumnType.status => job.startJobNow == value,
      },
    )
        .toList();
  }

  Future<void> fetchCustomers(BuildContext context) =>
      _withLoading(() async {
        try {
          final model = await _customerRepository.fetchCustomer();
          _getCustomerModel = model;
          _customers = model.customers ?? [];
          _error = null;
        } catch (e) {
          _error = _describe(e);
          _showError(context, _error!);
        }
      });

  Future<void> createCustomer(BuildContext context) => _withLoading(() async {
    try {
      await _customerRepository.createCustomer(
        customerId: uuid.v4(),
        customerName: customerNameController.text,
        siteCode: siteCodeController.text,
        accountCode: accountCodeController.text,
        divisionId: divisionController.text,
        agent: _textOrNull(agentController),
        notes: _textOrNull(notesController),
        logo: _textOrNull(logoController),
        address: _textOrNull(addressController),
      );

      await fetchCustomers(context);

      if (context.mounted) {
        NavigationService().goBack();
        CommonSnackbar.showSuccess(context, 'Customer created successfully');
      }
      _clearCustomerControllers();
    } catch (e) {
      _showError(context, _describe(e));
    }
  });

  void _clearCustomerControllers() {
    for (final controller in _controllers) {
      controller.clear();
    }
  }

  Future<void> _saveJobsToLocalStorage() async {
    final jobs = _jobModel?.data;
    if (jobs == null) return;

    try {
      await LocalStorage.setJsonList(
        LocalStorageConstant.cachedJobs,
        jobs.map((job) => job.toJson()).toList(),
      );
      _lastSyncTime = DateTime.now();
      await LocalStorage.setString(
        LocalStorageConstant.lastJobSyncTimestamp,
        _lastSyncTime!.toIso8601String(),
      );
    } catch (e) {
      debugPrint('JobProvider: could not save jobs to local storage: $e');
    }
  }

  Future<void> _loadJobsFromLocalStorage() async {
    try {
      final cached = LocalStorage.getJsonList(
        LocalStorageConstant.cachedJobs,
      );
      if (cached.isEmpty) return;

      _jobModel = JobModel(data: cached.map(Datum.fromJson).toList());

      final lastSync = LocalStorage.getString(
        LocalStorageConstant.lastJobSyncTimestamp,
      );
      if (lastSync.isNotEmpty) _lastSyncTime = DateTime.parse(lastSync);
      _isLoadedFromCache = true;
    } catch (e) {
      debugPrint('JobProvider: error loading jobs from cache: $e');
    }
  }

  Future<void> _refreshJobsFromServer() async {
    _jobModel = await _jobRepository.fetchJobModel();
    _error = null;
    _isLoadedFromCache = false;

    if (_hasJobs) sortJobData(0, true);
    if (_jobModel?.data != null) await _saveJobsToLocalStorage();
  }

  Future<void> fetchJobModel(
      BuildContext context, {
        bool forceSync = false,
      }) => _withLoading(() async {
    _isLoadedFromCache = false;
    try {
      if (!await _isOnline() && !forceSync) {
        await _loadJobsFromLocalStorage();
        if (!_hasJobs) {
          _error = 'No cached data available. Please sync when online.';
        }
        return;
      }
      await _refreshJobsFromServer();
    } catch (e) {
      _error = _describe(e);
      await _loadJobsFromLocalStorage();
      _notifyCacheFallback(
        context,
        hasCache: _hasJobs,
        emptyMessage:
        e is DioException
            ? _error!
            : 'Failed to load jobs. No cached data available.',
      );
    }
  });

  Future<void> syncJobs(BuildContext context) => _withSyncing(() async {
    if (!await _isOnline()) {
      _showError(context, 'No internet connection. Cannot sync.');
      return;
    }

    try {
      await _refreshJobsFromServer();
    } catch (e) {
      _error = _describe(e);
      _showError(context, 'Sync failed: $_error');
    }
  });

  Future<void> clearCachedJobs() async {
    try {
      await LocalStorageService.remove(LocalStorageConstant.cachedJobs);
      await LocalStorageService.remove(
        LocalStorageConstant.lastJobSyncTimestamp,
      );
      _lastSyncTime = null;
      _isLoadedFromCache = false;
      notifyListeners();
    } catch (e) {
      debugPrint('JobProvider: error clearing cached jobs: $e');
    }
  }

  static int _compareNullsLast<T extends Comparable<T>>(T? a, T? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  int _compareJobs(Datum a, Datum b, int column) => switch (column) {
    0 => (a.jobId ?? '').compareTo(b.jobId ?? ''),
    1 => (a.customerName ?? '').compareTo(b.customerName ?? ''),
    2 => (a.siteName ?? '').compareTo(b.siteName ?? ''),
    3 => (a.startJobNow ?? false) == (b.startJobNow ?? false)
        ? 0
        : (a.startJobNow ?? false)
        ? 1
        : -1,
    4 => _compareNullsLast(a.estimatedStartDate, b.estimatedStartDate),
    5 => _compareNullsLast(a.estimatedEndDate, b.estimatedEndDate),
    _ => 0,
  };

  void sortJobData(int columnIndex, bool ascending) {
    final jobs = _jobModel?.data;
    if (jobs == null || jobs.isEmpty) return;

    sortColumnIndex = columnIndex;
    sortAscending = ascending;

    jobs.sort((a, b) {
      final compare = _compareJobs(a, b, columnIndex);
      return ascending ? compare : -compare;
    });
    notifyListeners();
  }

  Future<void> fetchJobRegisterModel(
      BuildContext context,
      String jobId, {
        bool forceSync = false,
      }) => _withLoading(clearError: true, () async {
    try {
      if (!await _isOnline() && !forceSync) {
        await _loadJobRegisterFromLocalStorage();
        if (!_hasRegisterItems) {
          _error = 'No cached data available. Please sync when online.';
        }
        return;
      }

      _jobRegisterModel = await _jobRepository.fetchJobRegisterModel(jobId);
      _currentJobId = jobId;
      _error = null;
      await _saveJobRegisterToLocalStorage();
    } catch (e) {
      _error = _describe(e);
      await _loadJobRegisterFromLocalStorage();
      _notifyCacheFallback(
        context,
        hasCache: _hasRegisterItems,
        emptyMessage:
        e is DioException
            ? _error!
            : 'Failed to load job register. No cached data available.',
      );
    }
  });

  Future<void> _saveJobRegisterToLocalStorage() async {
    final model = _jobRegisterModel;
    if (model == null) return;

    try {
      await LocalStorageService.setString(_jobRegisterKey, model.toRawJson());
    } catch (e) {
      debugPrint('JobProvider: could not save job register: $e');
    }
  }

  Future<void> _loadJobRegisterFromLocalStorage() async {
    try {
      final raw = LocalStorageService.getString(_jobRegisterKey);
      if (raw.isEmpty) return;
      _jobRegisterModel = JobRegisterModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('JobProvider: error loading job register from cache: $e');
    }
  }

  Future<void> syncJobRegister(BuildContext context, String jobId) =>
      _withSyncing(() async {
        if (!await _isOnline()) {
          _showError(
            context,
            'No internet connection. Cannot sync job register.',
          );
          return;
        }

        try {
          _jobRegisterModel = await _jobRepository.fetchJobRegisterModel(jobId);
          _error = null;
          await _saveJobRegisterToLocalStorage();
          _showSuccess(context, 'Job register synced successfully');
        } catch (e) {
          _error = _describe(e);
          _showError(context, 'Sync failed: $_error');
        }
      });

  Future<void> clearCachedJobRegister() async {
    try {
      await LocalStorageService.remove(_jobRegisterKey);
      _jobRegisterModel = null;
      _currentJobId = null;
      _currentItem = null;
      notifyListeners();
    } catch (e) {
      debugPrint('JobProvider: error clearing cached job register: $e');
    }
  }

  Future<void> updateItemInRegister(Item updatedItem) async {
    final items = _jobRegisterModel?.items;
    final index = items?.indexWhere((i) => i.itemId == updatedItem.itemId) ?? -1;
    if (items == null || index == -1) return;

    try {
      items[index] = updatedItem;
      await _saveJobRegisterToLocalStorage();
      _currentItem = updatedItem;
      notifyListeners();
    } catch (e) {
      debugPrint('JobProvider: error updating item in register: $e');
    }
  }

  List<Item> getFilteredItems(int tabIndex) => switch (tabIndex) {
    2 =>
        jobItems
            .where(
              (item) =>
          item.status?.toLowerCase() == 'pending' || item.status == null,
        )
            .toList(),
    3 => jobItems.where((item) => item.status == true).toList(),
    _ => jobItems,
  };

  List<Item> searchItems(String query, int tabIndex) {
    final items = getFilteredItems(tabIndex);
    if (query.isEmpty) return items;

    final q = query.toLowerCase();
    return items
        .where(
          (item) =>
      (item.itemNo?.toLowerCase().contains(q) ?? false) ||
          (item.description?.toLowerCase().contains(q) ?? false) ||
          (item.detailedLocation?.toLowerCase().contains(q) ?? false),
    )
        .toList();
  }

  Future<void> _createJobItemAndRefresh(
      BuildContext context,
      Map<String, dynamic> jobItemData,
      String jobId,
      ) async {
    final result = await _jobRepository.createJobItem(jobItemData);
    _showSuccess(
      context,
      result['message']?.toString() ?? 'Job item created successfully',
    );
    await fetchJobRegisterModel(context, jobId);
  }

  Future<void> createJobItemNoNav(
      BuildContext context,
      Map<String, dynamic> jobItemData,
      String jobId,
      ) => _withLoading(() async {
    try {
      await _createJobItemAndRefresh(context, jobItemData, jobId);
    } catch (e) {
      _showError(context, _describe(e));
      rethrow;
    }
  });

  Future<void> createJobItem(
      BuildContext context,
      Map<String, dynamic> jobItemData,
      String jobId,
      ) => _withLoading(() async {
    try {
      await _createJobItemAndRefresh(context, jobItemData, jobId);
      if (context.mounted) NavigationService().goBack();
    } catch (e) {
      _showError(context, _describe(e));
    }
  });

  Future<Map<String, dynamic>> submitJobItem(
      BuildContext context,
      String jobId,
      Item item,
      ) async {
    try {
      return _submitResult(await _jobRepository.submitJobItem(jobId, item));
    } catch (e) {
      return _failure(e);
    }
  }

  Future<Map<String, dynamic>> submitJobItemFromMap(
      BuildContext context,
      String jobId,
      Map<String, dynamic> itemMap,
      ) async {
    try {
      return _submitResult(
        await _jobRepository.submitJobItemFromMap(jobId, itemMap),
      );
    } catch (e) {
      return _failure(e);
    }
  }

  Future<void> syncPendingJobItems(BuildContext context, String jobId) =>
      _withSyncing(() async {
        try {
          final pending = await JobItemStorage.getPendingItems(jobId);
          if (pending.isEmpty) {
            _showInfo(context, 'No pending items');
            return;
          }

          final completed = await JobItemStorage.getJobItems(jobId);
          await _loadJobRegisterFromLocalStorage();
          _showSuccess(
            context,
            'Loaded: ${pending.length} pending, ${completed.length} completed items',
          );
        } catch (e) {
          _showError(context, 'Sync failed: $e');
        }
      });

  Future<T> _orElse<T>(Future<T> Function() action, T fallback) async {
    try {
      return await action();
    } catch (_) {
      return fallback;
    }
  }

  Future<int> getPendingJobItemsCount(String jobId) =>
      _orElse(() => JobItemStorage.getPendingItemCount(jobId), 0);

  Future<List<Map<String, dynamic>>> getPendingJobItems(String jobId) =>
      _orElse(
            () => JobItemStorage.getPendingItems(jobId),
        <Map<String, dynamic>>[],
      );

  Future<List<Map<String, dynamic>>> getCompletedJobItems(String jobId) =>
      _orElse(
            () => JobItemStorage.getJobItems(jobId),
        <Map<String, dynamic>>[],
      );

  Future<List<Map<String, dynamic>>> getDraftJobItems(String jobId) => _orElse(
        () => JobItemStorage.getJobDrafts(jobId),
    <Map<String, dynamic>>[],
  );

  Future<Map<String, dynamic>> getJobItemStorageStats(String jobId) => _orElse(
        () => JobItemStorage.getStorageStats(jobId),
    <String, dynamic>{},
  );

  Future<void> clearProcessedPendingItems(String jobId) async {
    try {
      await JobItemStorage.clearProcessedItems(jobId);
      notifyListeners();
    } catch (e) {
      debugPrint('JobProvider: error clearing processed items: $e');
    }
  }

  Future<void> clearAllJobItemStorage(String jobId) async {
    try {
      await JobItemStorage.clearJobDrafts(jobId);
      await JobItemStorage.clearProcessedItems(jobId);
      await JobItemStorage.clearJobItems(jobId);
      notifyListeners();
    } catch (e) {
      debugPrint('JobProvider: error clearing job item storage: $e');
    }
  }

  Future<void> refresh({BuildContext? context}) async {
    final jobId = _currentJobId;
    if (jobId == null) return;

    if (context != null) {
      await fetchJobRegisterModel(context, jobId);
      return;
    }

    await _withLoading(() async {
      try {
        _jobRegisterModel = await _jobRepository.fetchJobRegisterModel(jobId);
        await _saveJobRegisterToLocalStorage();
      } catch (_) {
        await _loadJobRegisterFromLocalStorage();
      }
    });
  }

  Future<void> fetchJobLocations({bool force = false}) async {
    if (_hasFetchedLocations && !force) return;

    _isLoadingLocations = true;
    notifyListeners();
    try {
      final model = await _jobRepository.fetchJobLocations();
      _jobLocations = model.items ?? [];
      _hasFetchedLocations = true;
    } catch (e) {
      debugPrint('JobProvider.fetchJobLocations: ${_describe(e)}');
    } finally {
      _isLoadingLocations = false;
      notifyListeners();
    }
  }

  Future<JobLocationItem?> createJobLocation({
    required String name,
    required String code,
    required String itemId,
    String? parentId,
  }) async {
    try {
      final result = await _jobRepository.createJobLocation(
        itemId: itemId,
        name: name,
        code: code,
        parentId: parentId,
      );

      final newItem = JobLocationItem(
        locationId: result['locationID']?.toString() ?? uuid.v4(),
        itemId: itemId,
        name: name,
        code: code,
        parentId: parentId,
      );

      _jobLocations = [..._jobLocations, newItem];
      notifyListeners();
      return newItem;
    } catch (e) {
      debugPrint('JobProvider.createJobLocation: $e');
      return null;
    }
  }

  Future<bool> deleteJobLocation(String locationId) async {
    try {
      await _jobRepository.deleteJobLocation(locationId);
      _jobLocations =
          _jobLocations.where((l) => l.locationId != locationId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('JobProvider.deleteJobLocation: $e');
      return false;
    }
  }

  List<JobLocationItem> searchJobLocations(String query) {
    if (query.trim().isEmpty) return _jobLocations;

    final q = query.toLowerCase();
    return _jobLocations
        .where(
          (l) =>
      (l.name?.toLowerCase().contains(q) ?? false) ||
          (l.code?.toLowerCase().contains(q) ?? false),
    )
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}