import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/provider/report_sync_manager_provider.dart';
import 'package:provider/provider.dart';

class PendingReportsWidget extends StatelessWidget {
  const PendingReportsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportSyncManagerProvider>(
      builder: (context, syncManager, _) {
        if (!syncManager.hasPending) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: Colors.orange.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child:
                syncManager.isSyncing
                    ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  ),
                )
                    : const Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.orange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),

              // Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      syncManager.isSyncing
                          ? 'Syncing ${syncManager.pendingCount} pending report(s)...'
                          : '${syncManager.pendingCount} report(s) pending sync',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (syncManager.lastError != null && !syncManager.isSyncing)
                      Text(
                        syncManager.lastError!,
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: Colors.orange[700],
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),

              // Manual sync button
              if (!syncManager.isSyncing)
                TextButton.icon(
                  onPressed: () => syncManager.syncReports(context),
                  icon: const Icon(Icons.sync, size: 16, color: Colors.orange),
                  label: Text(
                    'Sync now',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}