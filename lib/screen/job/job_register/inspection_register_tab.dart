import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/utils/file_export_stub.dart'
if (dart.library.html) 'package:inspect/core/utils/file_export_web.dart'
if (dart.library.io) 'package:inspect/core/utils/file_export_mobile.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/inspection_register_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/screen/job/job_register/inspection_register_widget.dart';
import 'package:inspect/screen/job/job_register/item_register_widget.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:provider/provider.dart';

typedef _Report = Map<String, dynamic>;

class InspectionRegisterTab extends StatelessWidget {
  final String jobId;

  const InspectionRegisterTab({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (ctx) => InspectionRegisterProvider(jobId, ctx.read<JobProvider>()),
    child: const _InspectionRegisterView(),
  );
}

class _InspectionRegisterView extends StatefulWidget {
  const _InspectionRegisterView();

  @override
  State<_InspectionRegisterView> createState() =>
      _InspectionRegisterViewState();
}

class _InspectionRegisterViewState extends State<_InspectionRegisterView> {
  final _searchController = TextEditingController();

  InspectionRegisterProvider get _provider =>
      context.read<InspectionRegisterProvider>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
          () => _provider.setQuery(_searchController.text),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _provider.init());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startInspection() => NavigationService().navigateTo(
    NavigationRoutes.reportCreate,
    arguments: {'jobId': _provider.jobId},
  );

  Future<void> _export() async {
    try {
      await exportCSV(_provider.buildCsv(), context);
      if (mounted) CommonSnackbar.showSuccess(context, 'CSV exported successfully!');
    } catch (e) {
      if (mounted) CommonSnackbar.showError(context, 'Export error: $e');
    }
  }

  void _showExportDialog() {
    final provider = _provider;
    final primary = context.colors.primary;
    final text = context.topology.textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: dialogShape,
        title: Text(
          'Export Data',
          style: text.titleSmall?.copyWith(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Export ${provider.exportCount} row(s) to CSV?',
          style: text.bodySmall?.copyWith(color: primary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel', style: TextStyle(color: primary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _export();
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Export'),
            style: filledStyle(primary),
          ),
        ],
      ),
    );
  }

  void _showColumnDialog() {
    final provider = _provider;
    final primary = context.colors.primary;

    showDialog(
      context: context,
      builder: (dialogContext) => ListenableBuilder(
        listenable: provider,
        builder: (_, __) => AlertDialog(
          shape: dialogShape,
          title: Text(
            'Column Visibility',
            style: context.topology.textTheme.titleSmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final e in InspectionRegisterProvider.columnLabels.entries)
                    CheckboxListTile(
                      title: Text(e.value),
                      value: provider.isColumnVisible(e.key),
                      activeColor: primary,
                      onChanged: (v) =>
                          provider.setColumnVisible(e.key, v ?? false),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: filledStyle(primary),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InspectionRegisterProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && !provider.hasReports) {
      return ItemStateMessage(
        icon: Icons.error_outline,
        color: Colors.red,
        titleColor: Colors.red,
        title: 'Failed to load reports',
        subtitle: provider.error,
        action: ElevatedButton.icon(
          onPressed: provider.load,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          style: filledStyle(context.colors.primary),
        ),
      );
    }

    final reports = provider.filtered;

    if (reports.isEmpty) {
      return provider.query.isEmpty
          ? InspectionEmptyState(onStart: _startInspection)
          : _buildSearchEmpty(context, provider.query);
    }

    return _buildBody(context, provider, reports);
  }

  Widget _buildSearchEmpty(BuildContext context, String query) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ItemSearchBar(
          controller: _searchController,
          hint: 'Search inspections...',
        ),
      ),
      Expanded(
        child: ItemStateMessage(
          icon: Icons.search_off_rounded,
          color: Colors.grey,
          title: 'No inspections found',
          subtitle: 'for "$query"',
          action: ElevatedButton.icon(
            onPressed: _searchController.clear,
            icon: const Icon(Icons.clear_all_rounded, size: 16),
            label: const Text('Clear Search'),
            style: filledStyle(
              context.colors.primary,
              radius: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildBody(
      BuildContext context,
      InspectionRegisterProvider provider,
      List<_Report> reports,
      ) {
    final tablet = context.isTablet;
    final columns = tablet
        ? provider.activeColumns
        : InspectionRegisterProvider.mobileColumns;

    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          ItemSearchBar(
            controller: _searchController,
            hint: tablet
                ? 'Search by item, report name, status...'
                : 'Search inspections...',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ItemActionButton(
                    label: 'Refresh',
                    icon: Icons.refresh,
                    color: Colors.teal,
                    onPressed: provider.load,
                  ),
                  if (tablet) ...[
                    const SizedBox(width: 8),
                    ItemActionButton(
                      label: 'Export Grid',
                      icon: Icons.download,
                      color: Colors.blue,
                      onPressed: _showExportDialog,
                    ),
                    const SizedBox(width: 8),
                    ItemActionButton(
                      label: 'Column Visibility',
                      icon: Icons.view_column,
                      color: Colors.indigo,
                      onPressed: _showColumnDialog,
                    ),
                  ],
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: _buildTable(context, provider, reports, columns),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
      BuildContext context,
      InspectionRegisterProvider provider,
      List<_Report> reports,
      List<String> columns,
      ) {
    final primary = context.colors.primary;

    return DataTable(
      showCheckboxColumn: true,
      columnSpacing: 20,
      dataRowMinHeight: 52,
      dataRowMaxHeight: 64,
      headingRowColor: WidgetStatePropertyAll(primary.withValues(alpha: 0.07)),
      onSelectAll: (v) => provider.toggleAll(v ?? false, reports.length),
      columns: [
        for (final k in columns)
          DataColumn(
            label: Text(
              InspectionRegisterProvider.columnLabels[k]!,
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
      ],
      rows: [
        for (var i = 0; i < reports.length; i++)
          DataRow(
            selected: provider.selectedRows.contains(i),
            onSelectChanged: (v) => provider.toggleRow(i, v ?? false),
            color: WidgetStateProperty.resolveWith<Color?>(
                  (s) => s.contains(WidgetState.selected)
                  ? primary.withValues(alpha: 0.10)
                  : i.isEven
                  ? primary.withValues(alpha: 0.03)
                  : null,
            ),
            cells: [
              for (final k in columns)
                DataCell(_buildCell(context, k, reports[i])),
            ],
          ),
      ],
    );
  }

  Widget _buildCell(BuildContext context, String key, _Report report) {
    final style = context.topology.textTheme.bodySmall?.copyWith(
      color: context.colors.primary,
    );
    final value = InspectionRegisterProvider.cellValue(report, key);

    return switch (key) {
      'status' => InspectionStatusBadge(status: value),
      'pdf' => InspectionPdfButton(report: report),
      'reportName' => InspectionReportName(name: value),
      'description' => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180),
        child: Text(
          value,
          style: style,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      _ => Text(value, style: style),
    };
  }
}