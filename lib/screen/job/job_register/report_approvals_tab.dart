import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/network/api_endpoint.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/screen/job/job_item_details/report_field_screen.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:provider/provider.dart';

typedef _Json = Map<String, dynamic>;

enum _ReportStatus {
  pending('Pending', Colors.orange),
  approved('Approved', Colors.green),
  rejected('Rejected', Colors.red);

  const _ReportStatus(this.label, this.color);

  final String label;
  final MaterialColor color;
}

class _Column {
  const _Column(this.label, this.flex, {this.center = false});

  final String label;
  final int flex;
  final bool center;
}

const _columns = [
  _Column('ITEM NO.', 2),
  _Column('REPORT', 4),
  _Column('INSPECTOR', 3),
  _Column('DATE', 3),
  _Column('STATUS', 3, center: true),
  _Column('ACTIONS', 2, center: true),
];

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

class ReportApprovalsTab extends StatefulWidget {
  const ReportApprovalsTab({super.key, required this.jobId});

  final String jobId;

  @override
  State<ReportApprovalsTab> createState() => _ReportApprovalsTabState();
}

class _ReportApprovalsTabState extends State<ReportApprovalsTab> {
  final _searchController = TextEditingController();

  String _searchQuery = '';
  _ReportStatus _currentView = _ReportStatus.pending;
  List<_Json> _allReports = [];
  bool _isLoading = true;
  bool _isSyncing = false;

  Color get _primary => context.colors.primary;
  TextTheme get _text => context.topology.textTheme;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
          () => setState(() => _searchQuery = _searchController.text),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReports());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _firstNonEmpty(_Json r, List<String> keys) {
    for (final key in keys) {
      final value = (r[key] ?? '').toString().trim();
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  String _reportId(_Json r) =>
      _firstNonEmpty(r, ['reportID', 'reportId', 'report_id', 'id']);

  String _itemId(_Json r) =>
      _firstNonEmpty(r, ['_itemId', 'itemID', 'itemId', 'item_id']);

  String _reportTypeId(_Json r) =>
      _firstNonEmpty(r, ['reportTypeID', 'reportTypeId', 'report_type_id']);

  String _val(_Json r, String key) {
    final value = r[key]?.toString() ?? '';
    return value.isEmpty ? '-' : value;
  }

  bool _isServerId(String id) => _uuidPattern.hasMatch(id);

  bool _isOffline(_Json r) => !_isServerId(_reportId(r));

  String _dedupKey(_Json r, String itemId) {
    final id = _reportId(r);
    return id.isNotEmpty ? id : '$itemId-${r.hashCode}';
  }

  _ReportStatus _statusOf(_Json r) {
    final candidates = [
      r['approvalStatus'] ?? r['approval_status'],
      r['status'],
    ];
    for (final candidate in candidates) {
      switch (candidate?.toString().toLowerCase().trim()) {
        case 'approved':
          return _ReportStatus.approved;
        case 'rejected':
          return _ReportStatus.rejected;
      }
    }
    return _ReportStatus.pending;
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (_) {
      return false;
    }
  }

  _Json _buildReportData(_Json report) {
    final raw = report['reportData'] ?? report['fieldValues'];
    if (raw is! Map) return {};

    final result = <String, dynamic>{};
    for (final entry in raw.entries) {
      final key = entry.key?.toString() ?? '';
      if (key.isEmpty) continue;

      final value = entry.value;
      if (value is Map<String, dynamic>) {
        result[key] = {
          'value': value['value'] ?? '',
          'section': value['section'],
        };
      } else if (value is String || value is num || value is bool) {
        result[key] = {'value': value.toString(), 'section': null};
      } else if (value == null) {
        result[key] = {'value': '', 'section': null};
      }
    }
    return result;
  }

  String _normaliseDate(String raw) {
    final fallback = DateTime.now().toUtc().toIso8601String();
    if (raw.isEmpty) return fallback;
    return DateTime.tryParse(raw)?.toUtc().toIso8601String() ?? fallback;
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '-';
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    final day = date.day.toString().padLeft(2, '0');
    return '$day-${_months[date.month - 1]}-${date.year}';
  }

  Future<void> _loadReports() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      if (await _hasInternet()) {
        await _loadFromApi();
      } else {
        await _loadFromStorage();
      }
    } catch (_) {
      await _loadFromStorage();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() => _loadReports();

  Future<void> _loadFromApi() async {
    final items = context.read<JobProvider>().jobItems;
    if (items.isEmpty) {
      await _loadFromStorage();
      return;
    }
    await _fetchFromApi(items, persist: false);
  }

  Future<void> _syncAllItemsFromApi() async {
    if (!mounted) return;
    final items = context.read<JobProvider>().jobItems;
    if (items.isEmpty) return;
    await _fetchFromApi(items, persist: true);
  }

  Future<void> _fetchFromApi(
      List<Item> items, {
        required bool persist,
      }) async {
    final api = ServiceLocator().apiClient;
    final reports = <_Json>[];
    final seen = <String>{};

    void addAll(Iterable<_Json> source, String itemId, String itemNo) {
      for (final r in source) {
        if (seen.add(_dedupKey(r, itemId))) {
          reports.add({...r, '_itemId': itemId, '_itemNo': itemNo});
        }
      }
    }

    for (final item in items) {
      final itemId = item.itemId ?? '';
      final itemNo = item.itemNo ?? '';
      if (itemId.isEmpty) continue;

      try {
        final response = await api.get(ApiEndpoint.getItemReport(itemId));
        final data = response.data;
        if (data is! List) continue;

        final serverReports = data.whereType<_Json>().toList();
        if (!persist) {
          addAll(serverReports.where((r) => _reportId(r).isNotEmpty), itemId, itemNo);
          continue;
        }

        final normalised = serverReports.map(_normaliseServerReport).toList();
        final serverIds = normalised
            .map((r) => r['reportId'].toString())
            .where((id) => id.isNotEmpty)
            .toSet();

        final local = await JobItemStorage.getItemReports(itemId);
        final offlineOnly = local.where((r) {
          final id = r['reportId']?.toString() ?? '';
          return id.isEmpty || !serverIds.contains(id);
        });

        final merged = [...normalised, ...offlineOnly];
        await JobItemStorage.saveItemReports(itemId, merged);
        addAll(merged, itemId, itemNo);
      } catch (_) {
        try {
          addAll(await JobItemStorage.getItemReports(itemId), itemId, itemNo);
        } catch (_) {}
      }
    }

    final offline = await _collectStoredReports(seen);
    if (!mounted) return;
    setState(() => _allReports = [...reports, ...offline]);
  }

  _Json _normaliseServerReport(_Json r) {
    final id = r['reportID'] ?? r['reportId'] ?? '';
    final typeId = r['reportTypeID'] ?? r['reportTypeId'] ?? '';
    final data = r['reportData'] ?? r['fieldValues'] ?? {};

    return {
      'reportID': id,
      'reportId': id,
      'reportName': r['reportName'] ?? '',
      'reportTypeID': typeId,
      'reportTypeId': typeId,
      'reportDate': r['reportDate']?.toString() ?? '',
      'createdAt': r['createdAt']?.toString() ?? '',
      'status': r['status'] ?? '',
      'approvalStatus':
      r['approvalStatus'] ?? r['approval_status'] ?? r['status'] ?? '',
      'inspectedBy': r['inspectedBy'] ?? '',
      'regulation': r['regulation'] ?? '',
      'reportData': data,
      'fieldValues': data,
      'isPending': false,
    };
  }

  Future<List<_Json>> _storedItems() async {
    final lists = await Future.wait([
      JobItemStorage.getJobItems(widget.jobId),
      JobItemStorage.getPendingItems(widget.jobId),
      JobItemStorage.getJobDrafts(widget.jobId),
    ]);

    final seenIds = <String>{};
    return [
      for (final list in lists)
        for (final item in list)
          if (_nonEmptyId(item, seenIds)) item,
    ];
  }

  bool _nonEmptyId(_Json item, Set<String> seenIds) {
    final id = item['itemId']?.toString() ?? '';
    return id.isNotEmpty && seenIds.add(id);
  }

  Future<List<_Json>> _collectStoredReports(
      Set<String> seen, {
        String? skipItemId,
      }) async {
    final result = <_Json>[];
    try {
      for (final item in await _storedItems()) {
        final itemId = item['itemId'].toString();
        if (itemId == skipItemId) continue;
        final itemNo = item['itemNo']?.toString() ?? itemId;
        try {
          for (final r in await JobItemStorage.getItemReports(itemId)) {
            if (seen.add(_dedupKey(r, itemId))) {
              result.add({...r, '_itemId': itemId, '_itemNo': itemNo});
            }
          }
        } catch (_) {}
      }
    } catch (_) {}
    return result;
  }

  Future<void> _loadFromStorage() async {
    final seen = <String>{};
    final reports = <_Json>[];

    try {
      for (final r in await JobItemStorage.getItemReports(widget.jobId)) {
        if (seen.add(_dedupKey(r, widget.jobId))) {
          reports.add({
            ...r,
            '_itemId': widget.jobId,
            '_itemNo': widget.jobId,
          });
        }
      }
    } catch (_) {}

    reports.addAll(await _collectStoredReports(seen, skipItemId: widget.jobId));

    if (!mounted) return;
    setState(() => _allReports = reports);
  }

  Future<void> _pushOfflineReports() async {
    if (_isSyncing) return;

    if (!await _hasInternet()) {
      _showSnack(
        'No internet connection.',
        Colors.orange.shade700,
        icon: Icons.wifi_off,
      );
      return;
    }

    final offlineReports = _allReports.where(_isOffline).toList();
    if (offlineReports.isEmpty) {
      _showSnack(
        'All reports are already synced.',
        Colors.green.shade600,
        icon: Icons.cloud_done,
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSyncing = true);

    var success = 0;
    var failed = 0;
    for (final report in offlineReports) {
      try {
        await _uploadReport(report) ? success++ : failed++;
      } catch (_) {
        failed++;
      }
    }

    await _syncAllItemsFromApi();
    if (!mounted) return;
    setState(() => _isSyncing = false);

    _showSnack(
      failed == 0
          ? 'Synced $success report${success == 1 ? '' : 's'} successfully.'
          : 'Synced $success, failed $failed.',
      failed == 0 ? Colors.green.shade600 : Colors.orange.shade700,
      icon: failed == 0 ? Icons.cloud_done : Icons.warning,
    );
  }

  Future<bool> _uploadReport(_Json report) async {
    final itemId = _itemId(report);
    final reportTypeId = _reportTypeId(report);
    if (!_isServerId(itemId) || reportTypeId.isEmpty) return false;

    final reportData = _buildReportData(report);
    final status = report['status']?.toString() ?? '';

    final payload = <String, dynamic>{
      'reportTypeID': reportTypeId,
      'itemID': itemId,
      'itemNo': (report['_itemNo'] ?? report['itemNo'] ?? '').toString(),
      'status': status.isNotEmpty ? status : 'draft',
      'inspectedBy': (report['inspectedBy'] ?? '').toString(),
      'reportDate': _normaliseDate(
        report['reportDate']?.toString() ??
            report['createdAt']?.toString() ??
            '',
      ),
      'regulation': (report['regulation'] ?? '').toString(),
      'reportData': reportData,
    };

    final response = await ServiceLocator().apiClient.post(
      ApiEndpoint.createReportData,
      data: payload,
    );

    final serverReport = _extractServerReport(response.data);
    if (serverReport == null) return false;

    final newId = _firstNonEmpty(serverReport, ['reportID', 'reportId']);
    if (newId.isNotEmpty) {
      await _replaceLocalOfflineReport(
        itemId: itemId,
        oldReport: report,
        serverReport: serverReport,
        newReportId: newId,
        originalReportData: reportData,
      );
    }
    return true;
  }

  _Json? _extractServerReport(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final nested = data['report'];
    if (nested is Map<String, dynamic>) return nested;
    if (data.containsKey('reportID') || data.containsKey('reportId')) {
      return data;
    }
    return null;
  }

  Future<void> _replaceLocalOfflineReport({
    required String itemId,
    required _Json oldReport,
    required _Json serverReport,
    required String newReportId,
    required _Json originalReportData,
  }) async {
    try {
      final oldId = _reportId(oldReport);
      final oldName = _val(oldReport, 'reportName');
      final oldDate = _firstNonEmpty(oldReport, ['reportDate', 'createdAt']);

      final existing = await JobItemStorage.getItemReports(itemId);
      final kept = existing.where((r) {
        if (oldId.isNotEmpty && _reportId(r) == oldId) return false;
        final isSameReport =
            _val(r, 'reportName') == oldName &&
                _firstNonEmpty(r, ['reportDate', 'createdAt']) == oldDate;
        return !(oldId.isEmpty && isSameReport);
      }).toList();

      final typeId =
          serverReport['reportTypeID'] ??
              serverReport['reportTypeId'] ??
              _reportTypeId(oldReport);
      final data = serverReport['reportData'] ?? originalReportData;

      kept.add({
        'reportID': newReportId,
        'reportId': newReportId,
        'reportName': serverReport['reportName'] ?? oldName,
        'reportTypeID': typeId,
        'reportTypeId': typeId,
        'reportDate':
        serverReport['reportDate']?.toString() ??
            oldReport['reportDate']?.toString() ??
            '',
        'createdAt':
        serverReport['createdAt']?.toString() ??
            oldReport['createdAt']?.toString() ??
            '',
        'status': serverReport['status']?.toString() ?? 'draft',
        'approvalStatus':
        serverReport['approvalStatus']?.toString() ?? 'pending',
        'inspectedBy':
        serverReport['inspectedBy']?.toString() ??
            _val(oldReport, 'inspectedBy'),
        'regulation':
        serverReport['regulation']?.toString() ??
            oldReport['regulation']?.toString() ??
            '',
        'reportData': data,
        'fieldValues': data,
        'isPending': false,
      });

      await JobItemStorage.saveItemReports(itemId, kept);
    } catch (_) {}
  }

  Future<void> _approveReport(_Json report) async {
    if (!context.read<AuthenticateProvider>().isAdmin) {
      _showSnack(
        'Only admins can approve reports.',
        Colors.red.shade600,
        icon: Icons.lock_outline,
      );
      return;
    }

    if (!await _hasInternet()) {
      _showSnack(
        'No internet connection.',
        Colors.orange.shade700,
        icon: Icons.wifi_off,
      );
      return;
    }

    final reportId = _reportId(report);
    if (reportId.isEmpty) {
      _showSnack('No report ID found.', Colors.red.shade600);
      return;
    }
    if (!_isServerId(reportId)) {
      _showSnack(
        'Sync this report first.',
        Colors.orange.shade700,
        icon: Icons.cloud_sync,
      );
      return;
    }
    if (!mounted) return;

    final confirmed = await _confirm(
      title: 'Approve Report',
      message: 'Approve "${_val(report, 'reportName')}"?',
      confirmLabel: 'Approve',
      confirmColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
    if (!confirmed || !mounted) return;

    _showLoadingDialog('Approving…');

    dynamic result;
    try {
      result = await context.read<JobProvider>().updateReportApprovalStatus(
        context,
        reportId,
        'approved',
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _showSnack('Error: $e', Colors.red.shade600);
      return;
    }

    if (mounted) Navigator.of(context).pop();

    if (result?['success'] == true) {
      _showSnack(
        'Report approved.',
        Colors.green.shade600,
        icon: Icons.check_circle,
      );
      await _updateLocalStatus(report, _ReportStatus.approved);
      await _syncAllItemsFromApi();
    } else {
      _showSnack(result?['error'] ?? 'Failed to approve.', Colors.red.shade600);
    }
  }

  Future<void> _updateLocalStatus(_Json report, _ReportStatus status) async {
    final itemId = _itemId(report);
    if (itemId.isEmpty) return;

    final reportId = _reportId(report);
    _Json withStatus(_Json r) => {
      ...r,
      'status': status.name,
      'approvalStatus': status.name,
      'isPending': false,
    };

    try {
      final existing = await JobItemStorage.getItemReports(itemId);
      await JobItemStorage.saveItemReports(
        itemId,
        existing.map((r) => _reportId(r) == reportId ? withStatus(r) : r).toList(),
      );

      final index = _allReports.indexWhere((r) => _reportId(r) == reportId);
      if (index != -1 && mounted) {
        setState(() => _allReports[index] = withStatus(_allReports[index]));
      }
    } catch (_) {}
  }

  void _viewReportDetails(_Json report) {
    final reportTypeId = _reportTypeId(report);
    final reportName = _val(report, 'reportName');
    final itemId = _itemId(report);

    final existing =
    itemId.isEmpty
        ? null
        : context
        .read<JobProvider>()
        .jobItems
        .where((i) => i.itemId == itemId)
        .firstOrNull;

    final item =
        existing ??
            Item(
              itemId: itemId,
              itemNo: _firstNonEmpty(report, ['_itemNo', 'itemNo', 'item_no']),
              description: _firstNonEmpty(report, ['description', 'ItemDescription']),
              categoryId: _firstNonEmpty(report, ['categoryId', 'categoryID', 'category_id']),
              locationId: _firstNonEmpty(report, ['locationId', 'locationID', 'location_id']),
              detailedLocation: _firstNonEmpty(report, ['detailedLocation', 'detailed_location']),
              status: _firstNonEmpty(report, ['status']),
              rfidNo: _firstNonEmpty(report, ['rfidNo', 'RFIDNo', 'rfid_no']),
              manufacturer: _firstNonEmpty(report, ['manufacturer']),
              swl: _firstNonEmpty(report, ['swl']),
            );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ReportFieldsScreen(
          reportTypeId: reportTypeId,
          reportName: reportName != '-' ? reportName : 'Report Details',
          item: item,
          reportData: report,
          isViewMode: true,
        ),
      ),
    );
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required IconData icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(icon, color: confirmColor, size: 22),
            const SizedBox(width: 10),
            Text(
              title,
              style: ctx.topology.textTheme.titleMedium?.copyWith(
                color: ctx.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: ctx.topology.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: ctx.colors.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              confirmLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: ctx.colors.primary,
                  strokeWidth: 2.5,
                ),
                const SizedBox(height: 18),
                Text(
                  message,
                  style: ctx.topology.textTheme.bodyMedium?.copyWith(
                    color: ctx.colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(String message, Color color, {IconData? icon}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Map<_ReportStatus, int> _countByStatus() {
    final counts = {for (final s in _ReportStatus.values) s: 0};
    for (final r in _allReports) {
      counts.update(_statusOf(r), (v) => v + 1);
    }
    return counts;
  }

  List<_Json> _filteredReports() {
    final query = _searchQuery.toLowerCase();
    return _allReports.where((r) {
      if (_statusOf(r) != _currentView) return false;
      if (query.isEmpty) return true;
      return _val(r, 'reportName').toLowerCase().contains(query) ||
          (r['_itemNo']?.toString().toLowerCase().contains(query) ?? false) ||
          _val(r, 'inspectedBy').toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: _primary, strokeWidth: 2),
      );
    }

    final counts = _countByStatus();
    final filtered = _filteredReports();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(counts),
        Expanded(
          child:
          _allReports.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
            onRefresh: _refresh,
            color: _primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              children: [
                const SizedBox(height: 16),
                filtered.isEmpty
                    ? _buildNoData()
                    : _buildTable(filtered),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Map<_ReportStatus, int> counts) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsRow(counts),
          const SizedBox(height: 16),
          _buildFilterAndSearch(counts),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Map<_ReportStatus, int> counts) {
    final stats = [
      ('${_allReports.length}', 'TOTAL', _primary),
      for (final s in _ReportStatus.values)
        ('${counts[s]}', s.label.toUpperCase(), s.color.shade600),
    ];

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          _statCard(stats[i].$1, stats[i].$2, stats[i].$3),
        ],
      ],
    );
  }

  BoxDecoration _cardDecoration({double shadowOpacity = 0.03}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(shadowOpacity),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: color,
                height: 1.0,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: _text.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSearch(Map<_ReportStatus, int> counts) {
    return Row(
      children: [
        for (final status in _ReportStatus.values) ...[
          _filterTab(status, counts[status] ?? 0),
          const SizedBox(width: 8),
        ],
        const SizedBox(width: 4),
        Expanded(child: _buildSearchField()),
      ],
    );
  }

  Widget _filterTab(_ReportStatus status, int count) {
    final active = _currentView == status;
    final color = status.color.shade600;

    return GestureDetector(
      onTap: () => setState(() => _currentView = status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.1) : _primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: active ? color.withOpacity(0.5) : Colors.grey.shade200,
            width: active ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: active ? color : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              status.label,
              style: _text.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: active ? color : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: _text.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: active ? color : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      decoration: _cardDecoration(shadowOpacity: 0.02).copyWith(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        style: _text.bodyMedium?.copyWith(color: _primary),
        cursorColor: _primary,
        decoration: InputDecoration(
          hintText: 'Search reports, items, inspector…',
          hintStyle: _text.bodySmall?.copyWith(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _primary.withOpacity(0.5),
            size: 18,
          ),
          suffixIcon:
          _searchQuery.isEmpty
              ? null
              : GestureDetector(
            onTap: _searchController.clear,
            child: Icon(
              Icons.close,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(List<_Json> reports) {
    return Container(
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            _tableHeader(),
            for (final r in reports) ...[
              Divider(height: 1, color: Colors.grey.shade100),
              _tableRow(r),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: _primary.withOpacity(0.04),
      child: Row(
        children: [
          for (final c in _columns)
            Expanded(
              flex: c.flex,
              child: Text(
                c.label,
                textAlign: c.center ? TextAlign.center : TextAlign.left,
                style: _text.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.8,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tableRow(_Json r) {
    final isAdmin = context.read<AuthenticateProvider>().isAdmin;
    final isOffline = _isOffline(r);
    final status = _statusOf(r);
    final reportId = _reportId(r);

    final itemNo = r['_itemNo']?.toString() ?? r['itemNo']?.toString() ?? '-';
    final date = _formatDate(
      r['createdAt']?.toString() ?? r['reportDate']?.toString() ?? '',
    );

    final Widget action;
    if (isOffline) {
      action = _actionBtn(
        'Upload',
        Icons.cloud_upload_outlined,
        _pushOfflineReports,
      );
    } else if (status == _ReportStatus.pending && isAdmin) {
      action = _actionBtn(
        'Approve',
        Icons.check_circle_outline,
            () => _approveReport(r),
      );
    } else {
      action = Text(
        '—',
        textAlign: TextAlign.center,
        style: _text.bodyMedium?.copyWith(color: Colors.grey.shade400),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              itemNo,
              style: _text.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: _primary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: _reportNameCell(r, reportId, isOffline),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _val(r, 'inspectedBy'),
              style: _text.bodySmall?.copyWith(color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: _text.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child:
              isOffline
                  ? _pill('● Not synced', Colors.orange)
                  : _pill('● ${status.label}', status.color),
            ),
          ),
          Expanded(flex: 2, child: Center(child: action)),
        ],
      ),
    );
  }

  Widget _reportNameCell(_Json r, String reportId, bool isOffline) {
    final shortId =
    reportId.length > 18 ? '${reportId.substring(0, 18)}…' : reportId;

    return GestureDetector(
      onTap: isOffline ? null : () => _viewReportDetails(r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  _val(r, 'reportName'),
                  style: _text.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isOffline ? Colors.grey.shade500 : _primary,
                    decoration: isOffline ? null : TextDecoration.underline,
                    decorationColor: _primary.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isOffline) ...[
                const SizedBox(width: 4),
                Icon(Icons.open_in_new, size: 11, color: _primary),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(
            isOffline ? 'local draft' : shortId,
            style: _text.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontSize: 10,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: _text.bodySmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color.shade700,
        ),
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _primary.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: _primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: _text.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: _primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    final (label, icon) = switch (_currentView) {
      _ReportStatus.approved => (
      'No approved reports',
      Icons.check_circle_outline,
      ),
      _ReportStatus.rejected => ('No rejected reports', Icons.cancel_outlined),
      _ReportStatus.pending when _searchQuery.isNotEmpty => (
      'No reports found for "$_searchQuery"',
      Icons.search_off,
      ),
      _ReportStatus.pending => ('No pending reports', Icons.pending_actions),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primary.withOpacity(0.08),
                    _primary.withOpacity(0.04),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: _primary.withOpacity(0.4)),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: _text.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _refresh,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _primary.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 15, color: _primary),
                    const SizedBox(width: 6),
                    Text(
                      'Refresh',
                      style: _text.bodySmall?.copyWith(
                        color: _primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primary.withOpacity(0.1),
                    _primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 44,
                color: _primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'No Reports Yet',
              style: _text.titleLarge?.copyWith(
                color: _primary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Reports submitted for this job will\nappear here for review and approval.',
              textAlign: TextAlign.center,
              style: _text.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}