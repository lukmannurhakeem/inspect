import 'package:flutter/material.dart';
import 'package:inspect/core/extension/date_time_extension.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_report_type_model/get_report_type_model.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:provider/provider.dart';

class ReportTypesDetails extends StatefulWidget {
  final String? reportTypeID;

  const ReportTypesDetails({super.key, this.reportTypeID});

  @override
  State<ReportTypesDetails> createState() => _ReportTypesDetailsState();
}

class _ReportTypesDetailsState extends State<ReportTypesDetails>
    with SingleTickerProviderStateMixin {
  static const _tabLabels = [
    'Overview',
    'Fields',
    'Status Rules',
    'Dates',
    'Document Template',
    'Label Template',
    'Actions',
    'Competency',
  ];

  late final TabController _tabController = TabController(
    length: _tabLabels.length,
    vsync: this,
  );

  ReportTypeItem? _report;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReportType());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TextTheme get _textTheme => context.topology.textTheme;

  Color _fade([double opacity = 1]) => context.colors.primary.withOpacity(opacity);

  String _orNA(String? value) => value ?? 'N/A';

  String _yesNo(bool? value) => value == true ? 'Yes' : 'No';

  String _date(DateTime? value) => value?.formatShortDate ?? 'N/A';

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _resolveReportTypeId() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey('reportTypeID')) {
      return args['reportTypeID'] as String;
    }
    if (args is String) return args;
    return widget.reportTypeID;
  }

  ReportTypeItem? _findReport(GetReportTypeModel? model, String reportTypeId) {
    final items = model?.data;
    if (items == null || items.isEmpty) return null;

    for (final item in items) {
      final type = item.reportType;
      if (type?.reportTypeId == reportTypeId ||
          type?.categoryId == reportTypeId ||
          type?.jobId == reportTypeId) {
        return item;
      }
    }
    return items.first;
  }

  Future<void> _loadReportType() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reportTypeId = _resolveReportTypeId();
      if (reportTypeId == null) throw Exception('Report Type ID not provided');

      final provider = context.read<SystemProvider>();
      if (!provider.hasReport) await provider.fetchReportType();

      final report = _findReport(provider.getReportTypeModel, reportTypeId);
      if (report == null) {
        throw Exception('Report not found with ID: $reportTypeId');
      }

      if (!mounted) return;
      setState(() {
        _report = report;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _fieldTypeColor(String fieldType) {
    switch (fieldType.toLowerCase()) {
      case 'text':
        return Colors.blue;
      case 'decimal':
      case 'number':
        return Colors.green;
      case 'date':
        return Colors.orange;
      case 'boolean':
        return Colors.purple;
      case 'select':
      case 'dropdown':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return Colors.green;
      case 'pending':
      case 'draft':
        return Colors.orange;
      case 'rejected':
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _report?.reportType?.reportName ?? 'Report Type Details',
          style: _textTheme.titleSmall?.copyWith(color: context.colors.primary),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        leading: IconButton(
          onPressed: NavigationService().goBack,
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: Consumer<SystemProvider>(
        builder: (context, provider, _) {
          if (_isLoading || (provider.isLoading && _report == null)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_errorMessage != null || provider.hasError) {
            return _buildErrorState(
              _errorMessage ?? provider.errorMessage ?? 'Unknown error',
            );
          }
          if (_report == null) {
            return Center(
              child: Text(
                'No report data found',
                style: _textTheme.bodyMedium?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            );
          }
          return _buildBody(_report!);
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: context.colors.error),
          const SizedBox(height: 16),
          Text(
            'Error loading report data',
            style: _textTheme.titleMedium?.copyWith(color: context.colors.error),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: _textTheme.bodySmall?.copyWith(color: context.colors.error),
          ),
          const SizedBox(height: 16),
          CommonButton(text: 'Retry', onPressed: _loadReportType),
        ],
      ),
    );
  }

  Widget _buildBody(ReportTypeItem report) {
    final reportType = report.reportType!;

    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: [for (final label in _tabLabels) Tab(text: label)],
              labelColor: context.colors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: context.colors.primary,
              indicatorWeight: 3,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(report),
                _buildFieldsTab(report),
                _buildStatusRulesTab(report),
                _buildDatesTab(report),
                _buildTemplateTab(
                  title: 'Document Template Configuration',
                  reportType: reportType,
                  templateId: reportType.documentTemplate,
                  editLabel: 'Edit Template',
                  previewLabel: 'Preview',
                  editMessage: 'Template editor not implemented',
                  previewMessage: 'Template preview not implemented',
                ),
                _buildTemplateTab(
                  title: 'Label Template Configuration',
                  reportType: reportType,
                  templateId: reportType.labelTemplate,
                  editLabel: 'Edit Label Template',
                  previewLabel: 'Preview Label',
                  editMessage: 'Label template editor not implemented',
                  previewMessage: 'Label template preview not implemented',
                ),
                _buildActionsTab(report),
                _buildCompetencyTab(report),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(ReportTypeItem report) {
    final type = report.reportType!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(
            children: [
              _buildCardTitle('Report Type Information'),
              const SizedBox(height: 16),
              ..._buildInfoRows({
                'Report Name': _orNA(type.reportName),
                'Description': _orNA(type.description),
                'Document Code': _orNA(type.documentCode),
                'Report Type ID': _orNA(type.reportTypeId),
                'Job ID': _orNA(type.jobId),
                'Batch Type': _orNA(type.batchReportType),
                'External Report': _yesNo(type.isExternalReport),
                'Default as Draft': _yesNo(type.defaultAsDraft),
                'Status Required': _yesNo(type.isStatusRequired),
                'Update Item Status': _yesNo(type.updateItemStatus),
                'Update Item Dates': _yesNo(type.updateItemDates),
                'Archived': _yesNo(type.archived),
                'Created': _date(type.createdAt),
                'Updated': _date(type.updatedAt),
              }),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Fields',
                  report.reportFields?.length ?? 0,
                  Icons.list_alt,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Status Rules',
                  report.statusRuleReports?.length ?? 0,
                  Icons.rule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Actions',
                  report.actionReports?.length ?? 0,
                  Icons.settings,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Competencies',
                  report.competencyReports?.length ?? 0,
                  Icons.psychology,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsTab(ReportTypeItem report) {
    return _buildListTab<ReportField>(
      items: report.reportFields ?? const [],
      emptyMessage: 'No fields found',
      emptyIcon: Icons.list_alt,
      itemBuilder: (field) {
        final fieldType = field.fieldType ?? 'text';

        return _buildCard(
          children: [
            _buildTitleRow(
              field.labelText ?? 'N/A',
              _buildBadge(fieldType, _fieldTypeColor(fieldType)),
            ),
            const SizedBox(height: 8),
            ..._buildInfoRows({
              'Field Name': _orNA(field.name),
              'Section': _orNA(field.section),
              'Available To': _orNA(field.onlyAvailable),
              'Permissions': _orNA(field.permissionField),
              'Required': _yesNo(field.isRequired),
              if (field.infoText?.isNotEmpty == true)
                'Info Text': field.infoText!,
            }),
          ],
        );
      },
    );
  }

  Widget _buildStatusRulesTab(ReportTypeItem report) {
    return _buildListTab<StatusRuleReport>(
      items: report.statusRuleReports ?? const [],
      emptyMessage: 'No status rules found',
      emptyIcon: Icons.rule,
      itemBuilder: (rule) {
        final status = rule.status ?? 'draft';

        return _buildCard(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _buildBadge(
                status.toUpperCase(),
                _statusColor(status),
                bold: true,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Rule: ${_orNA(rule.field)} ${rule.statusRuleReportOperator ?? '=='} ${_orNA(rule.value)}',
              style: _textTheme.titleSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._buildInfoRows({
              'Field': _orNA(rule.field),
              'Operator': _orNA(rule.statusRuleReportOperator),
              'Value': _orNA(rule.value),
              'Created': _date(rule.createdAt),
            }),
          ],
        );
      },
    );
  }

  Widget _buildDatesTab(ReportTypeItem report) {
    return _buildListTab<ReportTypeDate>(
      items: report.reportTypeDates ?? const [],
      emptyMessage: 'No date configurations found',
      emptyIcon: Icons.date_range,
      itemBuilder:
          (date) => _buildCard(
        children: [
          _buildCardTitle(date.name ?? 'N/A', small: true),
          const SizedBox(height: 12),
          ..._buildInfoRows({
            'Apply Cycle': _orNA(date.applyCycle),
            'Required': _yesNo(date.isRequired),
            'Disable Free Type': _yesNo(date.disableFreeType),
            'Created': _date(date.createdAt),
          }),
        ],
      ),
    );
  }

  Widget _buildTemplateTab({
    required String title,
    required ReportType reportType,
    required String? templateId,
    required String editLabel,
    required String previewLabel,
    required String editMessage,
    required String previewMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildCard(
        children: [
          _buildCardTitle(title),
          const SizedBox(height: 16),
          ..._buildInfoRows({
            'Template ID': _orNA(templateId),
            'Report Name': _orNA(reportType.reportName),
            'Document Code': _orNA(reportType.documentCode),
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  text: editLabel,
                  onPressed: () => _showMessage(editMessage),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CommonButton(
                  text: previewLabel,
                  onPressed: () => _showMessage(previewMessage),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsTab(ReportTypeItem report) {
    return _buildListTab<ActionReport>(
      items: report.actionReports ?? const [],
      emptyMessage: 'No actions found',
      emptyIcon: Icons.settings,
      itemBuilder: (action) {
        final archived = action.isArchive == true;

        return _buildCard(
          children: [
            _buildTitleRow(
              action.description ?? 'N/A',
              _buildBadge(
                archived ? 'Archived' : 'Active',
                archived ? Colors.grey : Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildInfoRows({
              'Action Type': _orNA(action.actionType),
              'Apply Action': _orNA(action.applyAction),
              'Match Field': _orNA(action.match),
            }),
            _buildSubheader('Source Configuration'),
            ..._buildInfoRows({
              'Table': _orNA(action.sourceTable),
              'Field': _orNA(action.sourceField),
            }),
            _buildSubheader('Destination Configuration'),
            ..._buildInfoRows({
              'Table': _orNA(action.destinationTable),
              'Field': _orNA(action.destinationField),
            }),
            const SizedBox(height: 8),
            ..._buildInfoRows({'Created': _date(action.createdAt)}),
          ],
        );
      },
    );
  }

  Widget _buildCompetencyTab(ReportTypeItem report) {
    return _buildListTab<CompetencyReport>(
      items: report.competencyReports ?? const [],
      emptyMessage: 'No competency reports found',
      emptyIcon: Icons.psychology,
      itemBuilder: (competency) {
        final kind = competency.internalExternal ?? 'internal';

        return _buildCard(
          children: [
            _buildTitleRow(
              competency.name ?? 'N/A',
              _buildBadge(
                kind.toUpperCase(),
                kind == 'internal' ? Colors.blue : Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildInfoRows({
              'Can Create': _yesNo(competency.canCreate),
              'Competency ID': _orNA(competency.competencyReportId),
              'Created': _date(competency.createdAt),
              'Updated': _date(competency.updatedAt),
            }),
            if (competency.canCreate == true) ...[
              const SizedBox(height: 12),
              CommonButton(
                text: 'Create Assessment',
                onPressed:
                    () => _showMessage(
                  'Create ${competency.name ?? 'assessment'} assessment',
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildListTab<T>({
    required List<T> items,
    required String emptyMessage,
    required IconData emptyIcon,
    required Widget Function(T item) itemBuilder,
  }) {
    if (items.isEmpty) return _buildEmptyState(emptyMessage, emptyIcon);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => itemBuilder(items[index]),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildCardTitle(String text, {bool small = false}) {
    return Text(
      text,
      style: (small ? _textTheme.titleSmall : _textTheme.titleMedium)?.copyWith(
        color: context.colors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTitleRow(String title, Widget badge) {
    return Row(
      children: [
        Expanded(child: _buildCardTitle(title, small: true)),
        badge,
      ],
    );
  }

  Widget _buildSubheader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: _textTheme.bodyMedium?.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color, {bool bold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: _textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: bold ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: _fade(0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: _textTheme.bodyMedium?.copyWith(color: _fade(0.7)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInfoRows(Map<String, String> rows) {
    return [
      for (final entry in rows.entries) _buildInfoRow(entry.key, entry.value),
    ];
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: _textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _fade(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: _textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _fade(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.colors.primary, size: 32),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: _textTheme.titleLarge?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: _textTheme.bodySmall?.copyWith(color: _fade(0.7)),
          ),
        ],
      ),
    );
  }
}