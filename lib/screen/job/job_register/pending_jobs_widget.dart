import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/provider/job_sync_manager_provider.dart';
import 'package:inspect/storage/job_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingJobsWidget extends StatefulWidget {
  const PendingJobsWidget({super.key});

  @override
  State<PendingJobsWidget> createState() => _PendingJobsWidgetState();
}

class _PendingJobsWidgetState extends State<PendingJobsWidget> {
  List<Map<String, dynamic>> _pendingJobs = [];

  @override
  void initState() {
    super.initState();
    _loadPendingJobs();
  }

  void _loadPendingJobs() {
    setState(() {
      _pendingJobs = JobStorage.getPendingQueue();
    });

    // Debug print
    print('Loaded ${_pendingJobs.length} pending jobs');
    for (var job in _pendingJobs) {
      print('- Job: ${job['jobno']}, Status: ${job['status']}');
    }
  }

  Future<void> _syncJobs() async {
    try {
      final syncManager = Provider.of<JobSyncManagerProvider>(context, listen: false);
      await syncManager.syncJobs(context);
      _loadPendingJobs(); // Reload after sync
    } catch (e) {
      print('Error syncing jobs: $e');
    }
  }

  Future<void> _deleteJob(String queueId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
        title: const Text('Delete Pending Job'),
        content: const Text(
          'Are you sure you want to delete this pending job?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await JobStorage.removeFromQueue(queueId);
      _loadPendingJobs();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pending job deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'syncing':
        return Colors.blue;
      case 'failed':
        return Colors.red;
      case 'permanently_failed':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'syncing':
        return Icons.sync;
      case 'failed':
        return Icons.error_outline;
      case 'permanently_failed':
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingJobs.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_done,
                size: 48,
                color: Colors.green.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No pending jobs',
                style: context.topology.textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All jobs are synced',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<JobSyncManagerProvider>(
      builder: (context, syncManager, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.pending_actions, color: context.colors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Pending Jobs (${_pendingJobs.length})',
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: syncManager.isSyncing ? null : _syncJobs,
                      icon:
                      syncManager.isSyncing
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : Icon(Icons.sync, color: context.colors.primary),
                      tooltip: 'Sync all pending jobs',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pendingJobs.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final job = _pendingJobs[index];
                  final status = job['status'] as String? ?? 'pending';
                  final queueId = job['queueId'] as String;
                  final jobNo = job['jobno'] as String? ?? 'Unknown';
                  final queuedAt = job['queuedAt'] as String?;
                  final errorMessage = job['errorMessage'] as String?;
                  final retryCount = job['retryCount'] as int? ?? 0;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(status).withOpacity(0.2),
                      child: Icon(
                        _getStatusIcon(status),
                        color: _getStatusColor(status),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Job: $jobNo',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Queued: ${_formatDate(queuedAt)}',
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        if (errorMessage != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 14,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Error: $errorMessage',
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: Colors.red),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (retryCount > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Retry attempts: $retryCount/3',
                            style: context.topology.textTheme.bodySmall
                                ?.copyWith(color: Colors.orange, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                    trailing:
                    status != 'syncing'
                        ? IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: () => _deleteJob(queueId),
                      tooltip: 'Delete',
                    )
                        : const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
