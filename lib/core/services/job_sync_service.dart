import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/storage/job_storage.dart';
import 'package:provider/provider.dart';

class JobSyncService {
  static final JobSyncService _instance = JobSyncService._internal();

  factory JobSyncService() => _instance;

  JobSyncService._internal();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;
  BuildContext? _context;
  bool _wasOffline = false;

  /// Initialize the sync service with connectivity monitoring
  void initialize(BuildContext context) {
    _context = context;
    _connectivitySubscription?.cancel();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Check if any connection is available
      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );

      print('Connectivity changed: $results, hasConnection: $hasConnection');

      if (hasConnection && _wasOffline) {
        print('Connection restored! Attempting to sync pending jobs...');
        if (_context != null && _context!.mounted) {
          syncPendingJobs(_context!, silent: true);
        }
        _wasOffline = false;
      } else if (!hasConnection) {
        _wasOffline = true;
        print('Connection lost. Will sync when restored.');
      }
    });
  }

  /// Manually trigger sync of pending jobs
  /// [silent] - if true, won't trigger navigation, only shows snackbar notifications
  Future<void> syncPendingJobs(
    BuildContext context, {
    bool silent = false,
  }) async {
    if (_isSyncing) {
      print('Sync already in progress, skipping...');
      return;
    }

    final pendingJobs =
        JobStorage.getPendingQueue()
            .where(
              (job) => job['status'] == 'pending' || job['status'] == 'failed',
            )
            .toList();

    if (pendingJobs.isEmpty) {
      print('No pending jobs to sync');
      return;
    }

    _isSyncing = true;
    print('Starting sync of ${pendingJobs.length} pending jobs...');

    int successCount = 0;
    int failedCount = 0;

    for (var job in pendingJobs) {
      final queueId = job['queueId'] as String;

      try {

        await JobStorage.updateQueueItemStatus(queueId, 'syncing');

        final cleanJobData = Map<String, dynamic>.from(job);
        cleanJobData.remove('queueId');
        cleanJobData.remove('queuedAt');
        cleanJobData.remove('status');
        cleanJobData.remove('retryCount');
        cleanJobData.remove('updatedAt');
        cleanJobData.remove('errorMessage');
        cleanJobData.remove('draftId');
        cleanJobData.remove('savedAt');

        print('Syncing job: ${cleanJobData['jobno']}');

        // Attempt to create the job
        if (context.mounted) {
          final jobProvider = Provider.of<JobProvider>(context, listen: false);

          await jobProvider.createJobFromDetails(
            context,
            cleanJobData,
            silent: silent,
          );

          await JobStorage.removeFromQueue(queueId);
          successCount++;

          print('Successfully synced job: ${cleanJobData['jobno']}');
        }
      } catch (e) {
        print('Failed to sync job $queueId: $e');

        // Get current retry count
        final currentJob = JobStorage.getPendingQueue().firstWhere(
          (j) => j['queueId'] == queueId,
          orElse: () => job,
        );
        final retryCount = (currentJob['retryCount'] ?? 0) + 1;

        // Update status to failed
        await JobStorage.updateQueueItemStatus(
          queueId,
          retryCount >= 3 ? 'permanently_failed' : 'failed',
          errorMessage: e.toString(),
        );

        failedCount++;

        if (retryCount >= 3) {
          print('Job $queueId exceeded retry limit');
        }
      }
    }

    _isSyncing = false;

    // Show notification if there were any syncs
    if (context.mounted && (successCount > 0 || failedCount > 0)) {
      _showSyncNotification(context, successCount, failedCount);
    }

    print('Sync completed: $successCount successful, $failedCount failed');
  }

  void _showSyncNotification(
    BuildContext context,
    int successCount,
    int failedCount,
  ) {
    if (!context.mounted) return;

    final message =
        successCount > 0
            ? 'Synced $successCount job(s) successfully${failedCount > 0 ? ', $failedCount failed' : ''}'
            : 'Failed to sync $failedCount job(s)';

    final color = successCount > 0 ? Colors.green : Colors.red;
    final icon = successCount > 0 ? Icons.cloud_done : Icons.cloud_off;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Check connectivity status
  Future<bool> isOnline() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );
  }

  /// Get sync status
  bool get isSyncing => _isSyncing;

  /// Get pending job count
  int getPendingCount() {
    return JobStorage.getPendingJobCount();
  }

  /// Dispose the service
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
