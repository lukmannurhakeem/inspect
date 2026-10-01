


import 'package:flutter/material.dart';
import 'package:inspect/core/services/job_sync_service.dart';
import 'package:inspect/storage/job_storage.dart';

class JobSyncManagerProvider extends ChangeNotifier {
  bool _isSyncing = false;
  int _pendingCount = 0;
  String? _lastSyncTime;

  bool get isSyncing => _isSyncing;

  int get pendingCount => _pendingCount;

  String? get lastSyncTime => _lastSyncTime;

  JobSyncManagerProvider() {
    _updatePendingCount();
  }

  void initialize(BuildContext context) {
    JobSyncService().initialize(context);
    _updatePendingCount();
  }

  Future<void> syncJobs(BuildContext context, {bool silent = false}) async {
    if (_isSyncing) return;

    _isSyncing = true;
    notifyListeners();

    try {
      await JobSyncService().syncPendingJobs(context, silent: silent);
      _lastSyncTime = DateTime.now().toIso8601String();
    } finally {
      _isSyncing = false;
      _updatePendingCount();
      notifyListeners();
    }
  }

  void _updatePendingCount() {
    _pendingCount = JobStorage.getPendingJobCount();
    notifyListeners();
  }

  void refresh() {
    _updatePendingCount();
  }
}
