import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/job_model/job_model.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:provider/provider.dart';
import 'inspection_register_tab.dart';
import 'item_register_tab.dart';
import 'report_approvals_tab.dart';

class JobRegisterScreen extends StatefulWidget {
  final String jobId;
  final JobItem? job;

  const JobRegisterScreen({super.key, required this.jobId, this.job});

  @override
  State<JobRegisterScreen> createState() => _JobRegisterScreenState();
}

class _JobRegisterScreenState extends State<JobRegisterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  bool _isFirstLoad = true;

  final List<Tab> tabs = const [
    Tab(text: 'Item Register'),
    Tab(text: 'Inspection Register'),
    Tab(text: 'Report Approvals'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _sync(BuildContext context, JobProvider provider) async {
    if (provider.isSyncing) return;

    provider.clearJobRegisterError();

    try {
      await provider.fetchJobRegisterModel(context, widget.jobId);

      provider
          .fetchReportApprovals(context, widget.jobId)
          .catchError((e) => debugPrint('ℹ️ fetchReportApprovals: $e'));

      if (mounted) {
        setState(() => _isFirstLoad = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.lastSyncTime != null
                  ? 'Synced at ${_formatTime(provider.lastSyncTime!)}'
                  : 'Sync completed',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('ℹ️ JobRegisterScreen._sync error: $e');
      if (mounted && !_isFirstLoad) {
        _showSyncErrorDialog(context, provider, e.toString());
      }
    } finally {
      if (mounted) provider.clearJobRegisterError();
    }
  }

  void _showSyncErrorDialog(
    BuildContext context,
    JobProvider provider,
    String detail,
  ) {
    showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Sync Failed'),
            content: Text('Could not sync with the server.\n\n$detail'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _sync(context, provider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
    );
  }

  // ── Job Header (simplified) ────────────────────────────────────────────────

  Widget _buildJobHeader(BuildContext context) {
    return Container(
      color: context.colors.onPrimary,
      padding: context.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.jobId,
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.job?.customerName ?? '-',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
              Text(
                ' | ',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.job?.siteName ?? '-',
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: context.colors.primary),
            backgroundColor: context.colors.onPrimary,
            elevation: 0,
            leading: IconButton(
              onPressed: () => NavigationService().goBack(),
              icon: const Icon(Icons.chevron_left),
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Job ID + status badge ──────────────────────────
                        _buildJobHeader(context),

                        // ── Tab bar ───────────────────────────────────────
                        Container(
                          color: Colors.white,
                          child: TabBar(
                            controller: _tabController,
                            tabs: tabs,
                            labelColor: context.colors.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: context.colors.primary,
                            indicatorWeight: 3,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
            body: Padding(
              padding: context.paddingHorizontal,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ItemRegisterTab(jobId: widget.jobId),
                  InspectionRegisterTab(jobId: widget.jobId),
                  ReportApprovalsTab(jobId: widget.jobId),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
