import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/constant/app_constant.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/core/utils/file_export_mobile.dart';
import 'package:inspect/core/utils/web_window_helper.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/network/api_endpoint.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/job_item_details/pdf_viewer_screen.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

class InspectionRegisterTab extends StatefulWidget {
  final String jobId;

  const InspectionRegisterTab({super.key, required this.jobId});

  @override
  State<InspectionRegisterTab> createState() => _InspectionRegisterTabState();
}

class _InspectionRegisterTabState extends State<InspectionRegisterTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Set<int> selectedRows = <int>{};
  bool selectAll = false;

  List<Map<String, dynamic>> _allReports = [];
  bool _isLoading = false;
  String? _error;
  final Map<int, bool> _pdfLoadingMap = {};

  Map<String, bool> selectedColumns = {
    'item': true,
    'description': true,
    'category': true,
    'location': true,
    'reportNo': true,
    'reportType': true,
    'reportName': true,
    'status': true,
    'inspectedOn': true,
    'expiryDate': true,
    'pdf': true,
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _searchQuery = _searchController.text),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<JobProvider>();
      if (provider.jobItems.isNotEmpty) {
        _fetchAllReports();
      } else {
        provider.addListener(_onJobItemsChanged);
      }
    });
  }

  void _onJobItemsChanged() {
    if (!mounted) return;
    final provider = context.read<JobProvider>();
    if (provider.jobItems.isNotEmpty && _allReports.isEmpty && !_isLoading) {
      provider.removeListener(_onJobItemsChanged);
      _fetchAllReports();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    try {
      context.read<JobProvider>().removeListener(_onJobItemsChanged);
    } catch (_) {}
    super.dispose();
  }

  // ── Fetch: read from cache first, then silently refresh from API ──────────

  Future<void> _fetchAllReports() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final items = context.read<JobProvider>().jobItems;

      // De-duplicate items by itemId to avoid loading the same cache multiple times
      final seen = <String>{};
      final uniqueItems =
          items.where((item) {
            final id = item.itemId ?? '';
            if (id.isEmpty || seen.contains(id)) return false;
            seen.add(id);
            return true;
          }).toList();

      final collected = <Map<String, dynamic>>[];

      for (final item in uniqueItems) {
        final itemId = item.itemId ?? '';
        try {
          final cached = await JobItemStorage.getItemReports(itemId);
          if (cached.isNotEmpty) {
            debugPrint(
              '📂 Loaded ${cached.length} cached reports for item: $itemId',
            );
            for (final entry in cached) {
              if (entry['isPending'] == true) continue;
              collected.add(_normalizeReport(entry, item));
            }
          }
        } catch (e) {
          debugPrint('⚠️ InspectionRegisterTab: cache read failed $itemId: $e');
        }
      }

      debugPrint('✅ Total collected reports: ${collected.length}');

      if (mounted) {
        setState(() {
          _allReports = collected;
          _isLoading = false;
        });
      }

      // Silently refresh from API in background
      _refreshFromApi(uniqueItems);
    } catch (e) {
      debugPrint('❌ InspectionRegisterTab._fetchAllReports: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Background API refresh — pass pre-deduplicated items to avoid
  /// hitting the same endpoint multiple times.
  Future<void> _refreshFromApi(List<dynamic> uniqueItems) async {
    if (!mounted) return;

    try {
      final api = ServiceLocator().apiClient;
      final collected = <Map<String, dynamic>>[];

      for (final item in uniqueItems) {
        final itemId = item.itemId ?? '';
        if (itemId.isEmpty) continue;

        try {
          final response = await api.get(
            ApiEndpoint.getItemReport(itemId),
          );

          final data = response.data;
          if (data is! List) continue;

          final serverMaps =
              data
                  .whereType<Map<String, dynamic>>()
                  .map(
                    (r) => <String, dynamic>{
                      'reportID': r['reportID'] ?? r['reportId'] ?? '',
                      'reportId': r['reportID'] ?? r['reportId'] ?? '',
                      'reportNo': r['reportNo'] ?? '',
                      'reportName': r['reportName'] ?? '',
                      'reportTypeID':
                          r['reportTypeID'] ?? r['reportTypeId'] ?? '',
                      'reportTypeId':
                          r['reportTypeID'] ?? r['reportTypeId'] ?? '',
                      'documentCode': r['documentCode'] ?? '',
                      'reportDate': r['reportDate']?.toString() ?? '',
                      'createdAt': r['createdAt']?.toString() ?? '',
                      'inspectedOn': r['inspectedOn']?.toString() ?? '',
                      'status': r['status'] ?? '',
                      'approvalStatus':
                          r['approvalStatus'] ?? r['status'] ?? '',
                      'inspectedBy': r['inspectedBy'] ?? '',
                      'expiryDate':
                          r['expiryDate']?.toString() ??
                          r['ExpiryDate']?.toString() ??
                          '',
                      // Store as pdfUrlView to match ItemReportScreen convention
                      'pdfUrlView': r['pdfViewUrl'] ?? r['pdfUrlView'] ?? '',
                      'pdfUrl': r['pdfDownloadUrl'] ?? r['pdfUrl'] ?? '',
                      'isPending': false,
                    },
                  )
                  .toList();

          final existingLocal = await JobItemStorage.getItemReports(
            itemId,
          );
          final serverIds =
              serverMaps
                  .map((r) => r['reportId']?.toString() ?? '')
                  .where((id) => id.isNotEmpty)
                  .toSet();
          final offlineOnly =
              existingLocal.where((local) {
                final localId = local['reportId']?.toString() ?? '';
                if (localId.isEmpty) return true;
                return !serverIds.contains(localId);
              }).toList();

          final merged = [...serverMaps, ...offlineOnly];
          await JobItemStorage.saveItemReports(itemId, merged);
          debugPrint('✅ Saved ${merged.length} reports for item: $itemId');

          for (final entry in merged) {
            if (entry['isPending'] == true) continue;
            collected.add(_normalizeReport(entry, item));
          }
        } catch (e) {
          debugPrint(
            '⚠️ InspectionRegisterTab: API refresh failed $itemId: $e',
          );
        }
      }

      if (mounted && collected.isNotEmpty) {
        setState(() => _allReports = collected);
      }
    } catch (e) {
      debugPrint('⚠️ InspectionRegisterTab._refreshFromApi: $e');
    }
  }

  Map<String, dynamic> _normalizeReport(
    Map<String, dynamic> entry,
    dynamic item,
  ) {
    final pdfViewUrl =
        (entry['pdfUrlView']?.toString() ?? '').isNotEmpty
            ? entry['pdfUrlView'].toString()
            : (entry['pdfViewUrl']?.toString() ?? '');

    return {
      'reportId': entry['reportID'] ?? entry['reportId'] ?? '',
      'reportNo': entry['reportNo'] ?? '',
      'reportName': entry['reportName'] ?? '',
      'reportTypeId': entry['reportTypeID'] ?? entry['reportTypeId'] ?? '',
      'documentCode': entry['documentCode'] ?? '',
      'status': entry['status'] ?? '',
      'approvalStatus': entry['approvalStatus'] ?? '',
      'inspectedBy': entry['inspectedBy'] ?? '',
      'inspectedOn': entry['inspectedOn']?.toString() ?? '',
      'reportDate': entry['reportDate']?.toString() ?? '',
      'createdAt': entry['createdAt']?.toString() ?? '',
      'expiryDate': entry['expiryDate']?.toString() ?? '',
      'pdfViewUrl': pdfViewUrl,
      'pdfDownloadUrl':
          (entry['pdfUrl']?.toString() ?? '').isNotEmpty
              ? entry['pdfUrl'].toString()
              : (entry['pdfDownloadUrl']?.toString() ?? ''),
      '_itemId': item.itemId ?? '',
      '_itemNo': item.itemNo ?? '',
      '_description': item.description ?? '',
      '_categoryId': item.categoryId ?? '',
      '_locationId': item.locationId ?? '',
      '_itemExpiryDate': item.expiryDateTimeStamp?.toIso8601String() ?? '',
    };
  }

  // ── Search ────────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _allReports;
    final q = _searchQuery.toLowerCase();
    return _allReports.where((r) {
      return _s(r, '_itemNo').toLowerCase().contains(q) ||
          _s(r, '_description').toLowerCase().contains(q) ||
          _s(r, 'reportName').toLowerCase().contains(q) ||
          _s(r, 'reportNo').toLowerCase().contains(q) ||
          _resolveStatus(r).toLowerCase().contains(q);
    }).toList();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _s(Map<String, dynamic> r, String key) {
    final v = r[key];
    if (v == null || v.toString().trim().isEmpty) return '-';
    return v.toString();
  }

  String _resolveStatus(Map<String, dynamic> r) {
    final a = r['approvalStatus']?.toString() ?? '';
    if (a.isNotEmpty) return a;
    return r['status']?.toString() ?? 'pending';
  }

  String _formatDate(String iso) {
    if (iso.isEmpty || iso == '-' || iso == 'null') return '-';
    try {
      final d = DateTime.parse(iso);
      const months = [
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
      return '${d.day.toString().padLeft(2, '0')}-'
          '${months[d.month - 1]}-${d.year}';
    } catch (_) {
      return iso;
    }
  }

  String _inspectedOn(Map<String, dynamic> r) => _formatDate(
    _s(r, 'inspectedOn') != '-' ? _s(r, 'inspectedOn') : _s(r, 'createdAt'),
  );

  String _expiryDate(Map<String, dynamic> r) {
    final d = _s(r, 'expiryDate');
    if (d != '-') return _formatDate(d);
    return _formatDate(_s(r, '_itemExpiryDate'));
  }

  // ── PDF ───────────────────────────────────────────────────────────────────

  Future<void> _openPdf(
    BuildContext context,
    int rowIndex,
    Map<String, dynamic> report,
  ) async {
    final reportId = _s(report, 'reportId');
    if (reportId == '-' || reportId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report ID missing, cannot open PDF.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (kIsWeb) {
      final url =
          report['pdfViewUrl']?.toString().isNotEmpty == true
              ? report['pdfViewUrl'].toString()
              : '${AppConstants.apiBaseUrl}'
                  '/reportData/$reportId/view-pdf';
      openInNewTab(url);
      return;
    }

    setState(() => _pdfLoadingMap[rowIndex] = true);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text('Loading PDF...'),
            ],
          ),
          duration: Duration(seconds: 60),
        ),
      );
    }

    try {
      final pdfBytes = await context.read<SystemProvider>().fetchPdfReportById(
        reportId,
      );
      if (context.mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (pdfBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'PDF not available. Report may still be processing.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => PdfViewerScreen(
                  pdfData: pdfBytes,
                  reportName: 'Report_$reportId',
                ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load PDF: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _pdfLoadingMap.remove(rowIndex));
    }
  }

  Widget _pdfBtn(BuildContext context, int index, Map<String, dynamic> r) {
    final loading = _pdfLoadingMap[index] == true;
    return ElevatedButton.icon(
      onPressed: loading ? null : () => _openPdf(context, index, r),
      icon:
          loading
              ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : const Icon(Icons.picture_as_pdf, size: 16),
      label: Text(loading ? '...' : 'PDF'),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: context.topology.textTheme.bodySmall,
      ),
    );
  }

  // ── Status badge ──────────────────────────────────────────────────────────

  Widget _statusBadge(BuildContext context, String status) {
    Color color;
    IconData icon;
    switch (status.toLowerCase()) {
      case 'approved':
      case 'accepted':
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'rejected':
      case 'failed':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case 'submitted':
        color = Colors.blue;
        icon = Icons.upload;
        break;
      case 'draft':
        color = Colors.grey;
        icon = Icons.edit_note;
        break;
      case 'pending':
      default:
        color = Colors.orange;
        icon = Icons.pending;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.45), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            status.isEmpty ? 'PENDING' : status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    context.watch<JobProvider>();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _allReports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Failed to load reports',
              style: context.topology.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_error!, style: context.topology.textTheme.bodySmall),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchAllReports,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final reports = _filtered;

    if (reports.isEmpty) {
      return _searchQuery.isNotEmpty
          ? Center(child: Text('No inspections found for "$_searchQuery"'))
          : _buildEmptyState(context);
    }

    return context.isTablet
        ? _buildTabletView(context, reports)
        : _buildMobileView(context, reports);
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.withOpacity(0.15),
                      Colors.green.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fact_check_outlined,
                  size: 70,
                  color: Colors.teal.shade600,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'No Inspections Yet',
                style: context.topology.textTheme.titleLarge?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Begin your inspection journey by\nconducting your first inspection',
                textAlign: TextAlign.center,
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed:
                    () => NavigationService().navigateTo(
                      NavigationRoutes.reportCreate,
                      arguments: {'jobId': widget.jobId},
                    ),
                icon: const Icon(Icons.playlist_add_check, size: 22),
                label: const Text('Start Inspection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tablet view ───────────────────────────────────────────────────────────

  Widget _buildTabletView(
    BuildContext context,
    List<Map<String, dynamic>> reports,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            children: [
              CommonTextField(
                controller: _searchController,
                hintText: 'Search by item, report name, status...',
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        )
                        : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _actionBtn(
                        context,
                        'Refresh',
                        Icons.refresh,
                        Colors.teal,
                        _fetchAllReports,
                      ),
                      const SizedBox(width: 8),
                      _actionBtn(
                        context,
                        'Export Grid',
                        Icons.download,
                        Colors.blue,
                        () => _showExportDialog(context),
                      ),
                      const SizedBox(width: 8),
                      _actionBtn(
                        context,
                        'Column Visibility',
                        Icons.view_column,
                        Colors.indigo,
                        () => _showColumnDialog(context),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ FIX: Use SizedBox + ConstrainedBox instead of
              // IntrinsicWidth inside ListView, which collapses to zero height
              // on tablet and renders a blank DataTable.
              SizedBox(
                width: constraints.maxWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      showCheckboxColumn: true,
                      columnSpacing: 20,
                      dataRowMinHeight: 52,
                      dataRowMaxHeight: 64,
                      headingRowColor: MaterialStateProperty.all(
                        context.colors.primary.withOpacity(0.07),
                      ),
                      onSelectAll:
                          (v) => setState(() {
                            selectAll = v ?? false;
                            selectedRows =
                                selectAll
                                    ? Set<int>.from(
                                      List.generate(reports.length, (i) => i),
                                    )
                                    : {};
                          }),
                      columns: [
                        if (selectedColumns['item'] == true)
                          _col(context, 'Item No'),
                        if (selectedColumns['description'] == true)
                          _col(context, 'Description', flex: 2),
                        if (selectedColumns['category'] == true)
                          _col(context, 'Category'),
                        if (selectedColumns['location'] == true)
                          _col(context, 'Location'),
                        if (selectedColumns['reportNo'] == true)
                          _col(context, 'Report No'),
                        if (selectedColumns['reportType'] == true)
                          _col(context, 'Report Type'),
                        if (selectedColumns['reportName'] == true)
                          _col(context, 'Report Name', flex: 2),
                        if (selectedColumns['status'] == true)
                          _col(context, 'Status', centered: true),
                        if (selectedColumns['inspectedOn'] == true)
                          _col(context, 'Inspected On'),
                        if (selectedColumns['expiryDate'] == true)
                          _col(context, 'Expiry Date'),
                        if (selectedColumns['pdf'] == true)
                          _col(context, 'PDF', centered: true),
                      ],
                      rows: List.generate(reports.length, (i) {
                        final r = reports[i];
                        final isEven = i % 2 == 0;
                        return DataRow(
                          selected: selectedRows.contains(i),
                          onSelectChanged:
                              (v) => setState(() {
                                if (v == true) {
                                  selectedRows.add(i);
                                } else {
                                  selectedRows.remove(i);
                                }
                                selectAll =
                                    selectedRows.length == reports.length;
                              }),
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (s) =>
                                s.contains(MaterialState.selected)
                                    ? context.colors.primary.withOpacity(0.10)
                                    : isEven
                                    ? context.colors.primary.withOpacity(0.03)
                                    : null,
                          ),
                          cells: [
                            if (selectedColumns['item'] == true)
                              DataCell(
                                Text(_s(r, '_itemNo'), style: _ts(context)),
                              ),
                            if (selectedColumns['description'] == true)
                              DataCell(
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    _s(r, '_description'),
                                    style: _ts(context),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            if (selectedColumns['category'] == true)
                              DataCell(
                                Text(_s(r, '_categoryId'), style: _ts(context)),
                              ),
                            if (selectedColumns['location'] == true)
                              DataCell(
                                Text(_s(r, '_locationId'), style: _ts(context)),
                              ),
                            if (selectedColumns['reportNo'] == true)
                              DataCell(
                                Text(_s(r, 'reportNo'), style: _ts(context)),
                              ),
                            if (selectedColumns['reportType'] == true)
                              DataCell(
                                Text(
                                  _s(r, 'documentCode'),
                                  style: _ts(context),
                                ),
                              ),
                            if (selectedColumns['reportName'] == true)
                              DataCell(
                                SizedBox(
                                  width: 200,
                                  child: _reportNameCell(context, r),
                                ),
                              ),
                            if (selectedColumns['status'] == true)
                              DataCell(
                                Center(
                                  child: _statusBadge(
                                    context,
                                    _resolveStatus(r),
                                  ),
                                ),
                              ),
                            if (selectedColumns['inspectedOn'] == true)
                              DataCell(
                                Text(_inspectedOn(r), style: _ts(context)),
                              ),
                            if (selectedColumns['expiryDate'] == true)
                              DataCell(
                                Text(_expiryDate(r), style: _ts(context)),
                              ),
                            if (selectedColumns['pdf'] == true)
                              DataCell(Center(child: _pdfBtn(context, i, r))),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Mobile view ───────────────────────────────────────────────────────────

  Widget _buildMobileView(
    BuildContext context,
    List<Map<String, dynamic>> reports,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: ListView(
        children: [
          CommonTextField(
            controller: _searchController,
            hintText: 'Search inspections...',
            suffixIcon:
                _searchQuery.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    )
                    : null,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                _actionBtn(
                  context,
                  'Refresh',
                  Icons.refresh,
                  Colors.teal,
                  _fetchAllReports,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: true,
              headingRowColor: MaterialStateProperty.all(
                context.colors.primary.withOpacity(0.07),
              ),
              onSelectAll:
                  (v) => setState(() {
                    selectAll = v ?? false;
                    selectedRows =
                        selectAll
                            ? Set<int>.from(
                              List.generate(reports.length, (i) => i),
                            )
                            : {};
                  }),
              columns: [
                _col(context, 'Item No'),
                _col(context, 'Description'),
                _col(context, 'Report No'),
                _col(context, 'Report Name'),
                _col(context, 'Status'),
                _col(context, 'Inspected On'),
                _col(context, 'PDF', centered: true),
              ],
              rows: List.generate(reports.length, (i) {
                final r = reports[i];
                final isEven = i % 2 == 0;
                return DataRow(
                  selected: selectedRows.contains(i),
                  onSelectChanged:
                      (v) => setState(() {
                        if (v == true) {
                          selectedRows.add(i);
                        } else {
                          selectedRows.remove(i);
                        }
                        selectAll = selectedRows.length == reports.length;
                      }),
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (s) =>
                        s.contains(MaterialState.selected)
                            ? context.colors.primary.withOpacity(0.10)
                            : isEven
                            ? context.colors.primary.withOpacity(0.03)
                            : null,
                  ),
                  cells: [
                    DataCell(Text(_s(r, '_itemNo'), style: _ts(context))),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 130),
                        child: Text(
                          _s(r, '_description'),
                          style: _ts(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(_s(r, 'reportNo'), style: _ts(context))),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: _reportNameCell(context, r),
                      ),
                    ),
                    DataCell(_statusBadge(context, _resolveStatus(r))),
                    DataCell(Text(_inspectedOn(r), style: _ts(context))),
                    DataCell(Center(child: _pdfBtn(context, i, r))),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Widget helpers ────────────────────────────────────────────────────────

  TextStyle? _ts(BuildContext context) => context.topology.textTheme.bodySmall
      ?.copyWith(color: context.colors.primary);

  Widget _reportNameCell(BuildContext context, Map<String, dynamic> r) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.description_outlined,
          size: 14,
          color: context.colors.primary.withOpacity(0.5),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            _s(r, 'reportName'),
            style: _ts(context)?.copyWith(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  DataColumn _col(
    BuildContext context,
    String label, {
    int flex = 1,
    bool centered = false,
  }) {
    final text = Text(
      label,
      style: context.topology.textTheme.titleSmall?.copyWith(
        color: context.colors.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
    return DataColumn(
      label: Expanded(flex: flex, child: centered ? Center(child: text) : text),
    );
  }

  Widget _actionBtn(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: context.topology.textTheme.bodySmall,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  // ── Export ────────────────────────────────────────────────────────────────

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Export Data',
              style: context.topology.textTheme.titleSmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            content: Text(
              'Export ${selectedRows.isEmpty ? _filtered.length : selectedRows.length} row(s) to CSV?',
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await _exportToCSV();
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('CSV exported successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Export'),
              ),
            ],
          ),
    );
  }

  Future<void> _exportToCSV() async {
    final source =
        selectedRows.isEmpty
            ? _filtered
            : selectedRows
                .where((i) => i < _filtered.length)
                .map((i) => _filtered[i])
                .toList();

    final headers = <String>[];
    if (selectedColumns['item'] == true) headers.add('Item No');
    if (selectedColumns['description'] == true) headers.add('Description');
    if (selectedColumns['category'] == true) headers.add('Category');
    if (selectedColumns['location'] == true) headers.add('Location');
    if (selectedColumns['reportNo'] == true) headers.add('Report No');
    if (selectedColumns['reportType'] == true) headers.add('Report Type');
    if (selectedColumns['reportName'] == true) headers.add('Report Name');
    if (selectedColumns['status'] == true) headers.add('Status');
    if (selectedColumns['inspectedOn'] == true) headers.add('Inspected On');
    if (selectedColumns['expiryDate'] == true) headers.add('Expiry Date');
    if (selectedColumns['pdf'] == true) headers.add('PDF URL');

    final lines = <List<String>>[headers];
    for (final r in source) {
      final row = <String>[];
      if (selectedColumns['item'] == true) row.add(_esc(_s(r, '_itemNo')));
      if (selectedColumns['description'] == true)
        row.add(_esc(_s(r, '_description')));
      if (selectedColumns['category'] == true)
        row.add(_esc(_s(r, '_categoryId')));
      if (selectedColumns['location'] == true)
        row.add(_esc(_s(r, '_locationId')));
      if (selectedColumns['reportNo'] == true) row.add(_esc(_s(r, 'reportNo')));
      if (selectedColumns['reportType'] == true)
        row.add(_esc(_s(r, 'documentCode')));
      if (selectedColumns['reportName'] == true)
        row.add(_esc(_s(r, 'reportName')));
      if (selectedColumns['status'] == true) row.add(_esc(_resolveStatus(r)));
      if (selectedColumns['inspectedOn'] == true)
        row.add(_esc(_inspectedOn(r)));
      if (selectedColumns['expiryDate'] == true) row.add(_esc(_expiryDate(r)));
      if (selectedColumns['pdf'] == true)
        row.add(_esc(r['pdfViewUrl']?.toString() ?? ''));
      lines.add(row);
    }

    final csv = lines.map((l) => l.join(',')).join('\n');
    try {
      await exportCSV(csv, context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _esc(String f) {
    if (f.contains(',') || f.contains('"') || f.contains('\n')) {
      return '"${f.replaceAll('"', '""')}"';
    }
    return f;
  }

  void _showColumnDialog(BuildContext context) {
    const labels = {
      'item': 'Item No',
      'description': 'Description',
      'category': 'Category',
      'location': 'Location',
      'reportNo': 'Report No',
      'reportType': 'Report Type',
      'reportName': 'Report Name',
      'status': 'Status',
      'inspectedOn': 'Inspected On',
      'expiryDate': 'Expiry Date',
      'pdf': 'PDF',
    };
    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setS) => AlertDialog(
                  title: Text(
                    'Column Visibility',
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            selectedColumns.entries.map((e) {
                              return CheckboxListTile(
                                title: Text(labels[e.key] ?? e.key),
                                value: e.value,
                                onChanged:
                                    (v) => setS(
                                      () => selectedColumns[e.key] = v ?? false,
                                    ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
          ),
    );
  }
}
