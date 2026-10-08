import 'package:flutter/material.dart';
import 'package:inspect/core/extension/date_time_extension.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/job_sync_manager_provider.dart';
import 'package:inspect/screen/job/job_register/pending_jobs_widget.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_confirm_dialog.dart';
import 'package:inspect/widget/common_dialog.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

enum SearchColumn {
  customer('Customer'),
  jobNo('Job No'),
  site('Site'),
  status('Status');

  const SearchColumn(this.label);

  final String label;
}

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final _searchController = TextEditingController();
  Map<SearchColumn, dynamic> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchJobModel(context);
      context.read<JobSyncManagerProvider>()
        ..initialize(context)
        ..syncJobs(context, silent: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasSearchOrFilter =>
      _searchController.text.isNotEmpty || _activeFilters.isNotEmpty;

  String _formatDate(dynamic date) {
    if (date is String) {
      return date.tryParseDateTime()?.formatShortDate ?? date;
    }
    if (date is DateTime) return date.formatShortDate;
    return '-';
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _orDash(String? value) =>
      (value == null || value.isEmpty) ? '-' : value;

  String _customerName(dynamic job) => job.customerName ?? job.clientName ?? '';

  String _jobNumber(dynamic job) => job.jobNo ?? job.jobId ?? '';

  String _siteName(dynamic job) => job.siteName ?? '';

  bool _isStarted(dynamic job) => job.startJobNow ?? false;

  String _statusText(bool started) => started ? 'Started' : 'Not Started';

  Color _statusColor(bool started) => started ? Colors.green : Colors.grey;

  String _valueLabel(SearchColumn column, dynamic value) =>
      column == SearchColumn.status
      ? _statusText(value == true)
      : value.toString();

  List<dynamic> _jobs(JobProvider provider) =>
      provider.jobModel?.data ?? const [];

  List<String> _sortedUnique(Iterable<String> values) =>
      values.where((v) => v.isNotEmpty).toSet().toList()..sort();

  List<dynamic> _columnValues(JobProvider provider, SearchColumn column) {
    final jobs = _jobs(provider);
    switch (column) {
      case SearchColumn.customer:
        return _sortedUnique(jobs.map((j) => _customerName(j) as String));
      case SearchColumn.jobNo:
        return _sortedUnique(jobs.map((j) => _jobNumber(j) as String));
      case SearchColumn.site:
        return _sortedUnique(jobs.map((j) => _siteName(j) as String));
      case SearchColumn.status:
        return jobs.isEmpty ? [] : [true, false];
    }
  }

  bool _matchesFilter(dynamic job, SearchColumn column, dynamic value) {
    switch (column) {
      case SearchColumn.customer:
        return _customerName(job) == value;
      case SearchColumn.jobNo:
        return _jobNumber(job) == value;
      case SearchColumn.site:
        return _siteName(job) == value;
      case SearchColumn.status:
        return _isStarted(job) == value;
    }
  }

  bool _matchesSearch(dynamic job, String query) =>
      _jobNumber(job).toLowerCase().contains(query) ||
      _customerName(job).toLowerCase().contains(query) ||
      _siteName(job).toLowerCase().contains(query);

  List<dynamic> _filteredJobs(JobProvider provider) {
    final query = _searchController.text.toLowerCase();
    return _jobs(provider).where((job) {
      if (query.isNotEmpty && !_matchesSearch(job, query)) return false;
      return _activeFilters.entries.every(
        (e) => e.value == null || _matchesFilter(job, e.key, e.value),
      );
    }).toList();
  }

  Color _fade(BuildContext context, [double opacity = 1]) =>
      context.colors.primary.withOpacity(opacity);

  TextStyle? _bodySmall(
    BuildContext context, {
    double opacity = 1,
    double? fontSize,
  }) => context.topology.textTheme.bodySmall?.copyWith(
    color: _fade(context, opacity),
    fontSize: fontSize,
  );

  void _openJob(dynamic job) {
    NavigationService().navigateTo(
      NavigationRoutes.jobRegister,
      arguments: {'jobId': job.jobId, 'job': job},
    );
  }

  void _editJob(dynamic job) {
    NavigationService().navigateTo(
      NavigationRoutes.jobAddNewDetailsScreen,
      arguments: {
        'customerId': job.customerId ?? job.clientId ?? '',
        'customerName': _customerName(job),
        'siteId': job.siteId ?? '',
        'siteName': _siteName(job),
        'jobId': job.jobId,
        'job': job,
        'isEditMode': true,
      },
    );
  }

  void _confirmDelete(BuildContext context, dynamic job) {
    final customer = _customerName(job);

    CommonConfirmDialog.show(
      context: context,
      title: 'Delete Job',
      message:
          'Are you sure you want to delete job "${_jobNumber(job)}"? This action cannot be undone.',
      warningNote: 'All items and reports linked to this job will be removed.',
      confirmText: 'Delete',
      isDestructive: true,
      previewWidget: Row(
        children: [
          Icon(Icons.work_outline, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _jobNumber(job),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (customer.isNotEmpty)
                  Text(
                    customer,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
        ],
      ),
      onConfirm: () =>
          context.read<JobProvider>().deleteJobFromList(context, job.jobId),
    );
  }

  void _showFilterDialog(BuildContext context, JobProvider provider) {
    final tempFilters = Map<SearchColumn, dynamic>.from(_activeFilters);

    CommonDialog.show(
      context,
      widget: StatefulBuilder(
        builder: (context, setDialogState) {
          return SizedBox(
            height: context.screenHeight * 0.6,
            child: Column(
              children: [
                if (tempFilters.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final entry in tempFilters.entries)
                          Chip(
                            label: Text(
                              '${entry.key.label}: ${_valueLabel(entry.key, entry.value)}',
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(
                                    color: context.colors.onPrimary,
                                    fontSize: 11,
                                  ),
                            ),
                            backgroundColor: context.colors.primary,
                            deleteIcon: Icon(
                              Icons.close,
                              size: 16,
                              color: context.colors.onPrimary,
                            ),
                            onDeleted: () => setDialogState(
                              () => tempFilters.remove(entry.key),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView(
                    children: [
                      for (final column in SearchColumn.values)
                        _buildFilterCard(
                          context,
                          provider,
                          column,
                          tempFilters[column],
                          (value) => setDialogState(() {
                            if (value == null) {
                              tempFilters.remove(column);
                            } else {
                              tempFilters[column] = value;
                            }
                          }),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        text: 'Clear All',
                        onPressed: () {
                          setState(() => _activeFilters.clear());
                          NavigationService().goBack();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonButton(
                        text: 'Apply',
                        onPressed: () {
                          setState(
                            () => _activeFilters = Map.from(tempFilters),
                          );
                          NavigationService().goBack();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterCard(
    BuildContext context,
    JobProvider provider,
    SearchColumn column,
    dynamic currentValue,
    ValueChanged<dynamic> onChanged,
  ) {
    final values = _columnValues(provider, column);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              column.label,
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (values.isEmpty)
              Text(
                'No values available',
                style: _bodySmall(context, opacity: 0.5),
              )
            else
              CommonDropdown<dynamic>(
                value: currentValue,
                items: [
                  DropdownMenuItem<dynamic>(
                    value: null,
                    child: Text(
                      'All',
                      style: _bodySmall(context, opacity: 0.6),
                    ),
                  ),
                  for (final value in values)
                    DropdownMenuItem<dynamic>(
                      value: value,
                      child: Text(
                        _valueLabel(column, value),
                        style: _bodySmall(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncButton(BuildContext context, JobProvider provider) {
    final lastSync = provider.lastSyncTime;

    return Container(
      decoration: BoxDecoration(
        color: _fade(context, 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lastSync != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Icon(
                    provider.isLoadedFromCache
                        ? Icons.offline_pin
                        : Icons.cloud_done,
                    size: 16,
                    color: _fade(context, 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.isLoadedFromCache
                        ? 'Offline'
                        : _formatTime(lastSync),
                    style: _bodySmall(context, opacity: 0.7, fontSize: 12),
                  ),
                ],
              ),
            ),
          IconButton(
            tooltip: 'Sync jobs',
            icon: provider.isSyncing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colors.primary,
                      ),
                    ),
                  )
                : Icon(Icons.sync, color: context.colors.primary),
            onPressed: provider.isSyncing
                ? null
                : () => _syncWithFeedback(provider),
          ),
        ],
      ),
    );
  }

  Future<void> _syncWithFeedback(JobProvider provider) async {
    await provider.syncJobs(context);
    if (!mounted || provider.isSyncing) return;

    final lastSync = provider.lastSyncTime;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lastSync != null
              ? 'Synced at ${_formatTime(lastSync)}'
              : 'Sync completed',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context, dynamic job) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Edit job',
          icon: Icon(Icons.edit_outlined, size: 18, color: _fade(context, 0.7)),
          onPressed: () => _editJob(job),
        ),
        IconButton(
          tooltip: 'Delete job',
          icon: Icon(
            Icons.delete_outline,
            size: 18,
            color: Colors.red.shade400,
          ),
          onPressed: () => _confirmDelete(context, job),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context, JobProvider provider) {
    return CommonTextField(
      controller: _searchController,
      hintText: 'Search by job no, customer, or site...',
      style: _bodySmall(context),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: context.colors.primary),
              onPressed: _searchController.clear,
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _fade(context, _activeFilters.isNotEmpty ? 1 : 0.5),
            ),
            onPressed: () => _showFilterDialog(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final entry in _activeFilters.entries)
            GestureDetector(
              onTap: () => setState(() => _activeFilters.remove(entry.key)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _fade(context, 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _fade(context, 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${entry.key.label}: ${_valueLabel(entry.key, entry.value)}',
                      style: _bodySmall(context, fontSize: 11),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.close, size: 14, color: context.colors.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count job${count != 1 ? 's' : ''} found',
            style: _bodySmall(context),
          ),
          if (_activeFilters.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _activeFilters.clear()),
              child: Text(
                'Clear all filters',
                style: _bodySmall(context, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  DataColumn _dataColumn(
    BuildContext context,
    JobProvider provider,
    String label, {
    int flex = 1,
    bool sortable = true,
  }) {
    return DataColumn(
      label: Expanded(
        flex: flex,
        child: Text(
          label,
          style: context.topology.textTheme.titleSmall?.copyWith(
            color: context.colors.primary,
          ),
        ),
      ),
      onSort: sortable
          ? (index, _) => setState(() => provider.sortColumnIndex = index)
          : null,
    );
  }

  DataCell _dataCell(BuildContext context, String text, {bool wrap = false}) {
    return DataCell(
      SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: _bodySmall(context),
          overflow: wrap ? TextOverflow.ellipsis : null,
          maxLines: wrap ? 2 : null,
        ),
      ),
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    JobProvider provider,
    List<dynamic> jobs,
    bool isAdmin,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                sortColumnIndex: provider.sortColumnIndex,
                showCheckboxColumn: false,
                columnSpacing: 20,
                dataRowMinHeight: 56,
                dataRowMaxHeight: 56,
                columns: [
                  _dataColumn(context, provider, 'Customer', flex: 2),
                  _dataColumn(context, provider, 'Job No'),
                  _dataColumn(context, provider, 'Site', flex: 2),
                  _dataColumn(context, provider, 'Status'),
                  _dataColumn(context, provider, 'Start Date'),
                  _dataColumn(context, provider, 'End Date'),
                  if (isAdmin)
                    _dataColumn(context, provider, 'Actions', sortable: false),
                ],
                rows: [
                  for (var i = 0; i < jobs.length; i++)
                    DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (_) => i.isEven ? _fade(context, 0.05) : null,
                      ),
                      onSelectChanged: (selected) {
                        if (selected == true) _openJob(jobs[i]);
                      },
                      cells: [
                        _dataCell(
                          context,
                          _orDash(_customerName(jobs[i])),
                          wrap: true,
                        ),
                        _dataCell(context, _orDash(_jobNumber(jobs[i]))),
                        _dataCell(
                          context,
                          _orDash(_siteName(jobs[i])),
                          wrap: true,
                        ),
                        _dataCell(
                          context,
                          _statusText(_isStarted(jobs[i])),
                          wrap: true,
                        ),
                        _dataCell(
                          context,
                          _formatDate(jobs[i].estimatedStartDate),
                        ),
                        _dataCell(
                          context,
                          _formatDate(jobs[i].estimatedEndDate),
                        ),
                        if (isAdmin)
                          DataCell(_buildAdminActions(context, jobs[i])),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job, bool isAdmin) {
    final started = _isStarted(job);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openJob(job),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _orDash(job.jobId),
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(started),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _statusText(started),
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: context.colors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Customer: ${_orDash(_customerName(job))}',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Site: ${_orDash(_siteName(job))}',
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: _fade(context, 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: _fade(context, 0.6),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${_formatDate(job.estimatedStartDate)} - ${_formatDate(job.estimatedEndDate)}',
                      style: _bodySmall(context, opacity: 0.6),
                    ),
                  ),
                ],
              ),
              if (isAdmin)
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildAdminActions(context, job),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList(
    BuildContext context,
    List<dynamic> jobs,
    bool isAdmin,
  ) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: jobs.length,
      itemBuilder: (context, index) =>
          _buildJobCard(context, jobs[index], isAdmin),
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: _fade(context, 0.3)),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: context.topology.textTheme.titleMedium?.copyWith(
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: _bodySmall(context, opacity: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            'assets/images/bg_2.png',
            fit: BoxFit.contain,
            alignment: Alignment.bottomRight,
            height: context.screenHeight * 0.70,
          ),
        ),
        Container(
          width: double.infinity,
          height: context.screenHeight - kToolbarHeight * 2,
          padding: context.paddingAll,
          child: Column(
            children: [
              context.vXxl,
              Text(
                _hasSearchOrFilter
                    ? 'No jobs found'
                    : 'You have no job created',
                textAlign: TextAlign.center,
                style: context.topology.textTheme.titleMedium?.copyWith(
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _hasSearchOrFilter
                    ? 'Try adjusting your search or filter'
                    : 'Add your first job',
                textAlign: TextAlign.center,
                style: _bodySmall(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobList(
    BuildContext context,
    JobProvider provider,
    JobSyncManagerProvider syncManager,
    List<dynamic> jobs,
    bool isAdmin,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await provider.syncJobs(context);
        syncManager.refresh();
      },
      child: context.isTablet
          ? _buildDataTable(context, provider, jobs, isAdmin)
          : _buildMobileList(context, jobs, isAdmin),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<JobProvider, JobSyncManagerProvider, AuthenticateProvider>(
      builder: (context, provider, syncManager, auth, _) {
        final hasPending = syncManager.pendingCount > 0;

        if (provider.jobModel?.data?.isEmpty == true) {
          return Column(
            children: [
              if (hasPending) const PendingJobsWidget(),
              Expanded(child: _buildEmptyState(context)),
            ],
          );
        }

        final jobs = _filteredJobs(provider);

        return SizedBox(
          width: context.screenWidth,
          height: context.screenHeight - (kToolbarHeight * 1.25),
          child: Padding(
            padding: context.paddingAll,
            child: Column(
              children: [
                if (hasPending) const PendingJobsWidget(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildSyncButton(context, provider)],
                ),
                const SizedBox(height: 12),
                _buildSearchField(context, provider),
                context.vM,
                if (_activeFilters.isNotEmpty) _buildActiveFilterChips(context),
                _buildResultsHeader(context, jobs.length),
                Expanded(
                  child: jobs.isEmpty
                      ? _buildNoResults(context)
                      : _buildJobList(
                          context,
                          provider,
                          syncManager,
                          jobs,
                          auth.isAdmin,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
