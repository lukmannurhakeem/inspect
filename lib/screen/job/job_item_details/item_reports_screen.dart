import 'dart:convert';
import 'dart:io' as io;
import 'package:inspect/constant/app_constant.dart';
import 'package:inspect/core/utils/web_window_helper_stub.dart';
import 'package:archive/archive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/network/api_endpoint.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/report_sync_manager_provider.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/screen/job/job_item_details/pdf_viewer_screen.dart';
import 'package:inspect/screen/job/job_item_details/pending_report_widget.dart';
import 'package:inspect/screen/job/job_item_details/report_field_screen.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/widget/common_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ItemReportScreen extends StatefulWidget {
  final Item item;

  const ItemReportScreen({super.key, required this.item});

  @override
  State<ItemReportScreen> createState() => _ItemReportScreenState();
}

class _ItemReportScreenState extends State<ItemReportScreen> {
  bool _isDownloadingAll = false;

  List<Map<String, dynamic>> _localReports = [];
  bool _isLoadingLocal = false;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  bool _isLoadedFromCache = false;
  String? _localError;
  int _reportTypeFetchAttempts = 0;

  int _lastRefreshCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadLocalReports();
      final syncManager = context.read<ReportSyncManagerProvider>();
      await syncManager.initialize(context);
      await syncManager.clearQueue();
      await _syncFromApi(silent: true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final count = context.watch<JobProvider>().itemReportRefreshCount;
    if (count != _lastRefreshCount) {
      _lastRefreshCount = count;
      if (!_isLoadingLocal && !_isSyncing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncFromApi(silent: true);
        });
      }
    }
  }

  // ── Local storage ─────────────────────────────────────────────────────────

  Future<void> _loadLocalReports({bool fromOnlineSync = false}) async {
    if (!mounted) return;
    setState(() {
      _isLoadingLocal = true;
      _localError = null;
    });

    try {
      final reports = await JobItemStorage.getItemReports(
        widget.item.itemId ?? '',
      );
      if (mounted) {
        setState(() {
          _localReports = reports;
          _isLoadingLocal = false;
          if (!fromOnlineSync) {
            _isLoadedFromCache = reports.isNotEmpty;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _localError = e.toString();
          _isLoadingLocal = false;
        });
      }
    }
  }

  // ── Full sync ─────────────────────────────────────────────────────────────

  Future<void> _syncFromApi({bool silent = false}) async {
    if (!mounted) return;

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity.any((r) => r != ConnectivityResult.none);
    if (!isOnline) {
      await _loadLocalReports();
      if (mounted) setState(() => _isLoadedFromCache = true);
      return;
    }

    if (!silent) setState(() => _isSyncing = true);

    int pulled = 0;

    try {
      pulled = await _pullFromServer();

      final didSubmit = await _submitPendingReports();
      if (didSubmit && mounted) {
        await _pullFromServer();
      }

      await _loadLocalReports(fromOnlineSync: true);

      if (mounted) {
        setState(() {
          _lastSyncTime = DateTime.now();
          _isLoadedFromCache = false;
          _isSyncing = false;
        });

        if (!silent && pulled > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fetched $pulled report(s)'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSyncing = false);
        if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sync failed: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  // ── Pull from server ──────────────────────────────────────────────────────

  Future<int> _pullFromServer() async {
    int fetched = 0;

    try {
      final api = ServiceLocator().apiClient;
      final itemId = widget.item.itemId ?? '';
      if (itemId.isEmpty) return 0;

      // ── Step 1: Get report list for this item ─────────────────────────────
      final listResponse = await api.get(
        ApiEndpoint.getItemReport(itemId),
      );

      final rawData = listResponse.data;
      List<dynamic>? dataList;
      if (rawData is List) {
        dataList = rawData;
      } else if (rawData is Map<String, dynamic>) {
        final inner = rawData['data'];
        if (inner is List) dataList = inner;
      }

      final data = dataList ?? <dynamic>[];

      if (data.isEmpty) {
        // Still run merge so offline-pending rows stay visible
        final existingLocal = await JobItemStorage.getItemReports(
          itemId,
        );
        await JobItemStorage.saveItemReports(itemId, existingLocal);
        return 0;
      }

      // ── Step 2: Fetch full detail for each report via GET /reportData/:id ─
      final serverMaps = <Map<String, dynamic>>[];

      for (final r in data.whereType<Map<String, dynamic>>()) {
        final reportId = (r['reportID'] ?? r['reportId'] ?? '').toString();
        if (reportId.isEmpty) continue;

        try {
          final detailResponse = await api.get(
            ApiEndpoint.getReportDataByReportId(reportId),
          );

          final d = detailResponse.data;
          if (d is! Map<String, dynamic>) continue;

          // ── Resolve inspector name from personnel block ─────────────────
          final personnelBlock = d['personnel'] as Map<String, dynamic>?;
          final personnelInfo =
              personnelBlock?['personnel'] as Map<String, dynamic>?;
          final inspectedByName =
              d['inspectedBy']?.toString().isNotEmpty == true &&
                      !RegExp(
                        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
                        caseSensitive: false,
                      ).hasMatch(d['inspectedBy'].toString())
                  ? d['inspectedBy'].toString()
                  : [
                        personnelInfo?['firstName'],
                        personnelInfo?['middleName'],
                        personnelInfo?['lastName'],
                      ]
                      .where((s) => s != null && s.toString().trim().isNotEmpty)
                      .join(' ');

          final inspectedById =
              personnelInfo?['personnelID']?.toString() ??
              d['inspectedBy']?.toString() ??
              '';

          // ── Parse reportData ────────────────────────────────────────────
          final rawReportData = d['reportData'] as Map<String, dynamic>? ?? {};
          final flatFieldValues = _flattenReportData(rawReportData);

          serverMaps.add(<String, dynamic>{
            'reportID': reportId,
            'reportId': reportId,
            'reportNo': d['reportNo']?.toString() ?? '',
            'reportName': d['reportName']?.toString() ?? '',
            'reportTypeID': d['reportTypeID']?.toString() ?? '',
            'reportTypeId': d['reportTypeID']?.toString() ?? '',
            'reportDate': d['reportDate']?.toString() ?? '',
            'createdAt': d['createdAt']?.toString() ?? '',
            'updatedAt': d['updatedAt']?.toString() ?? '',
            'status': d['status']?.toString() ?? '',
            'approvalStatus': d['approvalStatus']?.toString() ?? '',
            'inspectStatus': d['inspectStatus']?.toString() ?? '',
            // Resolved display name for view mode
            'inspectedBy': inspectedByName,
            // Raw UUID for submission / copy mode inspector pre-selection
            'inspectedById': inspectedById,
            'regulation': d['regulationName']?.toString() ?? '',
            'regulationId': d['regulationId']?.toString() ?? '',
            // Full server reportData (label-keyed with section/type/image)
            'reportData': rawReportData,
            // Flat map — label → value (or image map) for ReportFieldsScreen
            'fieldValues': flatFieldValues,
            // PDF URLs from detail response
            'pdfUrlView': d['pdfViewUrl']?.toString() ?? '',
            'pdfUrl': d['pdfDownloadUrl']?.toString() ?? '',
            'isPending': false,
          });

          fetched++;
        } catch (e) {
          debugPrint('⚠️ Failed to fetch detail for report $reportId: $e');
          // Fall back to basic list-level data so the row still appears
          final fallbackReportData =
              r['reportData'] as Map<String, dynamic>? ?? {};
          serverMaps.add(<String, dynamic>{
            'reportID': reportId,
            'reportId': reportId,
            'reportNo': r['reportNo']?.toString() ?? '',
            'reportName': r['reportName']?.toString() ?? '',
            'reportTypeID': r['reportTypeID'] ?? r['reportTypeId'] ?? '',
            'reportTypeId': r['reportTypeID'] ?? r['reportTypeId'] ?? '',
            'reportDate': r['reportDate']?.toString() ?? '',
            'createdAt': r['createdAt']?.toString() ?? '',
            'status': r['status']?.toString() ?? '',
            'approvalStatus':
                r['approvalStatus'] ??
                r['approval_status'] ??
                r['status'] ??
                '',
            'inspectedBy': r['inspectedBy']?.toString() ?? '',
            'inspectedById': r['inspectedBy']?.toString() ?? '',
            'regulation': r['regulation']?.toString() ?? '',
            'reportData': fallbackReportData,
            'fieldValues': _flattenReportData(fallbackReportData),
            'pdfUrlView': r['pdfViewUrl'] ?? r['pdfUrlView'] ?? '',
            'pdfUrl': r['pdfDownloadUrl'] ?? r['pdfUrl'] ?? '',
            'isPending': false,
          });
        }
      }

      // ── Step 3: Merge with offline-only rows ──────────────────────────────
      final existingLocal = await JobItemStorage.getItemReports(itemId);

      final serverIds =
          serverMaps
              .map((r) => r['reportId']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toSet();

      final offlineOnlyRows =
          existingLocal.where((local) {
            final localId = local['reportId']?.toString() ?? '';
            if (localId.isEmpty) return true;
            return !serverIds.contains(localId);
          }).toList();

      final merged = [...serverMaps, ...offlineOnlyRows];
      await JobItemStorage.saveItemReports(itemId, merged);
    } catch (e) {
      debugPrint('❌ _pullFromServer error: $e');
      rethrow;
    }

    return fetched;
  }

  // ── Submit pending offline reports ────────────────────────────────────────

  Future<bool> _submitPendingReports() async {
    if (!mounted) return false;
    final itemId = widget.item.itemId ?? '';
    if (itemId.isEmpty) return false;

    final allLocal = await JobItemStorage.getItemReports(itemId);
    final pending =
        allLocal.where((r) {
          return r['isPending'] == true ||
              (r['status'] ?? '').toString().toLowerCase() ==
                  'pending_submission';
        }).toList();

    if (pending.isEmpty) return false;
    if (!context.mounted) return false;

    final systemProvider = context.read<SystemProvider>();

    final Map<String, Map<String, dynamic>> replacements = {};

    for (final p in pending) {
      final tempId = p['reportId']?.toString() ?? '';
      try {
        final reportDate = p['reportDate']?.toString() ?? '';
        final inspectedById =
            p['inspectedById']?.toString() ??
            p['inspectedBy']?.toString() ??
            '';
        final reportTypeId =
            p['reportTypeId']?.toString() ??
            p['reportTypeID']?.toString() ??
            '';

        if (reportDate.isEmpty ||
            inspectedById.isEmpty ||
            reportTypeId.isEmpty) {
          debugPrint('⚠️ Skipping — missing fields on $tempId');
          continue;
        }

        final storedReportData =
            (p['reportData'] as Map<String, dynamic>?) ?? {};

        final wrappedFieldValues =
            storedReportData.isNotEmpty
                ? storedReportData
                : () {
                  final raw =
                      (p['fieldValues'] as Map?)?.cast<String, dynamic>() ?? {};
                  final rebuilt = <String, dynamic>{};
                  raw.forEach((k, v) {
                    if (k.endsWith('_filename')) return;
                    rebuilt[k] = {'value': v?.toString() ?? '', 'type': 'text'};
                  });
                  return rebuilt;
                }();

        final payload = <String, dynamic>{
          'reportTypeID': reportTypeId,
          'itemID': itemId,
          'itemNo': widget.item.itemNo ?? '',
          'status': 'draft',
          'inspectedBy': inspectedById,
          'reportDate': reportDate,
          'regulation': p['regulation']?.toString() ?? '',
          'reportData': wrappedFieldValues,
        };

        Map<String, PlatformFile>? attachedFiles;
        final storedFiles = JobItemStorage.loadReportFiles(tempId);
        if (storedFiles.isNotEmpty) {
          attachedFiles = {};
          for (final entry in storedFiles.entries) {
            try {
              final pipeIdx = entry.value.indexOf('|');
              final String filename;
              final String b64;
              if (pipeIdx > 0) {
                filename = entry.value.substring(0, pipeIdx);
                b64 = entry.value.substring(pipeIdx + 1);
              } else {
                filename = '${entry.key}.jpg';
                b64 = entry.value;
              }
              final bytes = base64Decode(b64);
              attachedFiles[entry.key] = PlatformFile(
                name: filename,
                size: bytes.length,
                bytes: bytes,
              );
            } catch (e) {
              debugPrint('⚠️ Failed to decode stored file ${entry.key}: $e');
            }
          }
        }

        final result = await systemProvider.pushReportPayload(
          payload,
          files: attachedFiles,
        );

        if (result == null || result['queued'] == true) {
          debugPrint('⏳ $tempId still queued — retry next sync');
          continue;
        }

        final reportMap = result['report'] as Map<String, dynamic>?;
        final serverReportId =
            reportMap?['reportID']?.toString() ??
            reportMap?['reportId']?.toString() ??
            result['reportId']?.toString() ??
            result['id']?.toString() ??
            '';

        if (serverReportId.isNotEmpty && tempId.isNotEmpty) {
          await JobItemStorage.deleteReportFiles(tempId);
          replacements[tempId] = <String, dynamic>{
            'reportId': serverReportId,
            'reportID': serverReportId,
            'reportNo':
                reportMap?['reportNo']?.toString() ??
                result['reportNo']?.toString() ??
                '',
            'reportName': p['reportName'] ?? '',
            'reportTypeId': reportTypeId,
            'reportTypeID': reportTypeId,
            'reportDate': reportDate,
            'createdAt': reportMap?['createdAt']?.toString() ?? reportDate,
            'status':
                reportMap?['status']?.toString() ??
                result['status']?.toString() ??
                'draft',
            'approvalStatus': reportMap?['approvalStatus']?.toString() ?? '',
            'inspectedBy': p['inspectedBy'] ?? '',
            'inspectedById': inspectedById,
            'regulation': p['regulation']?.toString() ?? '',
            'fieldValues': p['fieldValues'] ?? {},
            'reportData': p['reportData'] ?? {},
            'isPending': false,
            'pdfUrlView':
                result['pdfUrlView']?.toString() ??
                result['pdfUrl_view']?.toString() ??
                '',
            'pdfUrl': result['pdfUrl']?.toString() ?? '',
          };
          debugPrint('✅ Offline report synced: $tempId → $serverReportId');
        }
      } catch (e) {
        debugPrint('⚠️ Failed to submit $tempId: $e');
      }
    }

    if (replacements.isEmpty) return false;

    final updated =
        allLocal.map((r) {
          final id = r['reportId']?.toString() ?? '';
          return replacements.containsKey(id) ? replacements[id]! : r;
        }).toList();
    await JobItemStorage.saveItemReports(itemId, updated);

    return true;
  }

  // ── Flatten server reportData into fieldValues ────────────────────────────
  // Stores label → value for text fields.
  // Stores label → {type, url, fileUrl, fileName} for image fields.
  // Also stores snake_case key as fallback.
  static Map<String, dynamic> _flattenReportData(
    Map<String, dynamic> reportData,
  ) {
    final flat = <String, dynamic>{};
    reportData.forEach((label, entry) {
      if (entry is Map<String, dynamic>) {
        final type = entry['type']?.toString() ?? 'text';

        if (type == 'image') {
          final imageBlock = entry['image'] as Map<String, dynamic>?;
          final valueUrl = entry['value']?.toString() ?? '';
          final fileUrl = imageBlock?['fileUrl']?.toString() ?? '';
          final fileName = imageBlock?['fileName']?.toString() ?? '';

          final imageMap = <String, dynamic>{
            'type': 'image',
            'url': valueUrl.isNotEmpty ? valueUrl : fileUrl,
            'fileUrl': fileUrl,
            'fileName': fileName,
          };
          flat[label] = imageMap;

          // snake_case fallback
          final nameKey = label
              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
              .replaceAll(RegExp(r'_+'), '_')
              .replaceAll(RegExp(r'^_|_$'), '');
          flat[nameKey] = imageMap;
        } else {
          final value = entry['value'];
          flat[label] = value;

          final nameKey = label
              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
              .replaceAll(RegExp(r'_+'), '_')
              .replaceAll(RegExp(r'^_|_$'), '');
          flat[nameKey] = value;
        }
      }
    });
    return flat;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  List<Map<String, dynamic>> get _displayReports {
    return List<Map<String, dynamic>>.from(_localReports);
  }

  List<Map<String, dynamic>> get _pendingReports =>
      _localReports
          .where(
            (r) =>
                r['isPending'] == true ||
                (r['status'] ?? '').toString().toLowerCase() ==
                    'pending_submission',
          )
          .toList();

  String _resolveStatus(Map<String, dynamic> report) {
    if (report['isPending'] == true) return 'pending_submission';
    final approvalStatus = report['approvalStatus']?.toString() ?? '';
    final status = report['status']?.toString() ?? '';
    return approvalStatus.isNotEmpty ? approvalStatus : status;
  }

  String _getReportLabel(Map<String, dynamic> report) {
    final reportNo = report['reportNo']?.toString() ?? '';
    if (reportNo.isNotEmpty) return reportNo;
    return report['reportId']?.toString() ?? '-';
  }

  // ── Status badge ──────────────────────────────────────────────────────────

  Widget _reportStatusBadge(String status) {
    Color color;
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'APPROVED';
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.cancel;
        label = 'REJECTED';
        break;
      case 'submitted':
        color = Colors.blue;
        icon = Icons.upload;
        label = 'SUBMITTED';
        break;
      case 'pending':
        color = Colors.orange;
        icon = Icons.pending;
        label = 'PENDING';
        break;
      case 'pending_submission':
        color = Colors.deepOrange;
        icon = Icons.cloud_upload_outlined;
        label = 'OFFLINE';
        break;
      default:
        color = Colors.orange;
        icon = Icons.pending;
        label = status.isEmpty ? 'PENDING' : status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.45), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ── Copy report ───────────────────────────────────────────────────────────

  void _copyReport(BuildContext context, Map<String, dynamic> report) {
    final reportTypeId = _getLocalValue(report, 'reportTypeId');
    final reportName = _getLocalValue(report, 'reportName');

    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (_) => ReportFieldsScreen(
              reportTypeId: reportTypeId != '-' ? reportTypeId : '',
              reportName: reportName != '-' ? reportName : 'Report',
              item: widget.item,
              reportData: report,
              isCopyMode: true,
            ),
      ),
    ).then((submitted) async {
      if (submitted == true && mounted) {
        await _loadLocalReports();
        if (mounted) _syncFromApi(silent: true);
      }
    });
  }

  // ── Edit report ───────────────────────────────────────────────────────────

  void _editReport(BuildContext context, Map<String, dynamic> report) {
    final reportTypeId = _getLocalValue(report, 'reportTypeId');
    final reportName = _getLocalValue(report, 'reportName');

    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (_) => ReportFieldsScreen(
              reportTypeId: reportTypeId != '-' ? reportTypeId : '',
              reportName: reportName != '-' ? reportName : 'Report',
              item: widget.item,
              reportData: report,
              isEditMode: true,
            ),
      ),
    ).then((updated) async {
      if (updated == true && mounted) {
        await _loadLocalReports();
        if (mounted) _syncFromApi(silent: true);
      }
    });
  }

  // ── Sync button ───────────────────────────────────────────────────────────

  Widget _buildSyncButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_lastSyncTime != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Icon(
                    _isLoadedFromCache ? Icons.offline_pin : Icons.cloud_done,
                    size: 16,
                    color: context.colors.primary.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isLoadedFromCache
                        ? 'Offline'
                        : _formatTime(_lastSyncTime!),
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon:
                _isSyncing
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
            onPressed:
                _isSyncing
                    ? null
                    : () async {
                      await _syncFromApi(silent: false);
                      if (mounted && !_isSyncing) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _lastSyncTime != null
                                  ? 'Synced at ${_formatTime(_lastSyncTime!)}'
                                  : 'Sync completed',
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
            tooltip: 'Sync reports',
          ),
        ],
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.primary.withOpacity(0.1),
                      Colors.purple.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 60,
                  color: context.colors.primary.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Reports Yet',
                style: context.topology.textTheme.titleLarge?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Submitted reports will appear here.',
                textAlign: TextAlign.center,
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text('Create Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildSyncButton(context),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.purple.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Report Benefits:',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      context,
                      Icons.analytics_outlined,
                      'Track inspection history',
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      context,
                      Icons.picture_as_pdf_outlined,
                      'Generate PDF documents',
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      context,
                      Icons.cloud_upload_outlined,
                      'Share and archive reports',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.purple),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _syncFromApi(silent: false),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoadingLocal && _localReports.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_localError != null && _localReports.isEmpty) {
      return _buildErrorState(context, _localError!);
    }

    if (_displayReports.isEmpty && !_isLoadingLocal && !_isSyncing) {
      return _buildEmptyState(context);
    }

    return context.isTablet
        ? _buildTabletLayout(context)
        : _buildMobileLayout(context);
  }

  // ── Tablet layout ─────────────────────────────────────────────────────────

  Widget _buildTabletLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, con) {
        return RefreshIndicator(
          onRefresh: () => _syncFromApi(silent: false),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Header bar ──────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.colors.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.description,
                            color: context.colors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reports',
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_displayReports.length}',
                              style: context.topology.textTheme.titleLarge
                                  ?.copyWith(
                                    color: context.colors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildSyncButton(context),
                        const SizedBox(width: 8),
                        if (_displayReports.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isDownloadingAll
                                      ? null
                                      : () => _downloadAllPdfs(context),
                              icon:
                                  _isDownloadingAll
                                      ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(Icons.download, size: 18),
                              label: Text(
                                _isDownloadingAll
                                    ? 'Downloading...'
                                    : 'Download All',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ElevatedButton.icon(
                          onPressed: () => _showCreateDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Create Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const PendingReportsWidget(),

              // ── Sync / cache status banner ───────────────────────────────
              if (_isLoadedFromCache || _isSyncing)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _isSyncing
                            ? Colors.blue.withOpacity(0.08)
                            : Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _isSyncing
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSyncing ? Icons.sync : Icons.offline_pin,
                        size: 16,
                        color: _isSyncing ? Colors.blue : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSyncing
                            ? 'Syncing reports...'
                            : 'Showing cached data. Pull to refresh.',
                        style: context.topology.textTheme.bodySmall?.copyWith(
                          color: _isSyncing ? Colors.blue : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // ── Horizontal-scrollable DataTable ──────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: con.maxWidth),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: context.colors.primary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          context.colors.primary.withOpacity(0.08),
                        ),
                        columns: [
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Report No',
                                style: context.topology.textTheme.titleSmall
                                    ?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Report Type',
                                style: context.topology.textTheme.titleSmall
                                    ?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Date',
                                style: context.topology.textTheme.titleSmall
                                    ?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Status',
                                style: context.topology.textTheme.titleSmall
                                    ?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Action',
                                style: context.topology.textTheme.titleSmall
                                    ?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                        rows: List.generate(_displayReports.length, (index) {
                          final report = _displayReports[index];
                          final isEven = index % 2 == 0;
                          final status = _resolveStatus(report);
                          final displayLabel = _getReportLabel(report);
                          final isPending = report['isPending'] == true;

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (states) =>
                                  isEven
                                      ? context.colors.primary.withOpacity(0.03)
                                      : null,
                            ),
                            cells: [
                              DataCell(
                                InkWell(
                                  onTap:
                                      () => _viewReportDetails(context, report),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: context.colors.primary
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.tag,
                                          size: 14,
                                          color: context.colors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        displayLabel,
                                        style: context
                                            .topology
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: context.colors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.open_in_new,
                                        size: 12,
                                        color: context.colors.primary
                                            .withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  _getLocalValue(report, 'reportName'),
                                  style: context.topology.textTheme.bodySmall
                                      ?.copyWith(color: context.colors.primary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatLocalDate(report),
                                      style: context
                                          .topology
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: context.colors.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(_reportStatusBadge(status)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isPending) ...[
                                      // PDF button
                                      ElevatedButton.icon(
                                        onPressed:
                                            () => _printPdf(
                                              context,
                                              _getLocalValue(
                                                report,
                                                'reportId',
                                              ),
                                              pdfUrlView:
                                                  report['pdfUrlView']
                                                      ?.toString() ??
                                                  '',
                                              pdfUrl:
                                                  report['pdfUrl']
                                                      ?.toString() ??
                                                  '',
                                            ),
                                        icon: const Icon(
                                          Icons.picture_as_pdf,
                                          size: 16,
                                        ),
                                        label: const Text('PDF'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              context.colors.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    // View button
                                    ElevatedButton.icon(
                                      onPressed:
                                          () => _viewReportDetails(
                                            context,
                                            report,
                                          ),
                                      icon: const Icon(
                                        Icons.visibility,
                                        size: 16,
                                      ),
                                      label: const Text('View'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: context.colors.primary
                                            .withOpacity(0.15),
                                        foregroundColor: context.colors.primary,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (!isPending) ...[
                                      const SizedBox(width: 8),
                                      // Copy button
                                      OutlinedButton.icon(
                                        onPressed:
                                            () => _copyReport(context, report),
                                        icon: const Icon(
                                          Icons.copy_outlined,
                                          size: 16,
                                        ),
                                        label: const Text('Copy'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              context.colors.primary,
                                          side: BorderSide(
                                            color: context.colors.primary
                                                .withOpacity(0.5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Edit button
                                      OutlinedButton.icon(
                                        onPressed:
                                            () => _editReport(context, report),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                        ),
                                        label: const Text('Edit'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.green[700],
                                          side: BorderSide(
                                            color: Colors.green.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Mobile layout ─────────────────────────────────────────────────────────

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.primary.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(
                color: context.colors.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reports',
                    style: context.topology.textTheme.titleMedium?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_displayReports.length} '
                    '${_displayReports.length == 1 ? 'report' : 'reports'}',
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildSyncButton(context),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: () => _showCreateDialog(context),
                    backgroundColor: context.colors.primary,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        const PendingReportsWidget(),
        if (_isLoadedFromCache || _isSyncing)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color:
                _isSyncing
                    ? Colors.blue.withOpacity(0.08)
                    : Colors.orange.withOpacity(0.08),
            child: Row(
              children: [
                Icon(
                  _isSyncing ? Icons.sync : Icons.offline_pin,
                  size: 14,
                  color: _isSyncing ? Colors.blue : Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  _isSyncing
                      ? 'Syncing reports...'
                      : 'Showing cached data. Pull to refresh.',
                  style: context.topology.textTheme.bodySmall?.copyWith(
                    color: _isSyncing ? Colors.blue : Colors.orange,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _syncFromApi(silent: false),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _displayReports.length,
              itemBuilder: (context, index) {
                final report = _displayReports[index];
                final status = _resolveStatus(report);
                final displayLabel = _getReportLabel(report);
                final isPending = report['isPending'] == true;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: context.colors.primary.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _viewReportDetails(context, report),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.tag,
                                      size: 14,
                                      color: context.colors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      displayLabel,
                                      style: context
                                          .topology
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: context.colors.primary,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.open_in_new,
                                      size: 11,
                                      color: context.colors.primary.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            _reportStatusBadge(status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getLocalValue(report, 'reportName'),
                          style: context.topology.textTheme.titleSmall
                              ?.copyWith(
                                color: context.colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatLocalDate(report),
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // ── Row 1: View + PDF ────────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    () => _viewReportDetails(context, report),
                                icon: const Icon(Icons.visibility, size: 18),
                                label: const Text('View Details'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colors.primary
                                      .withOpacity(0.15),
                                  foregroundColor: context.colors.primary,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            if (!isPending) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      () => _printPdf(
                                        context,
                                        _getLocalValue(report, 'reportId'),
                                        pdfUrlView:
                                            report['pdfUrlView']?.toString() ??
                                            '',
                                        pdfUrl:
                                            report['pdfUrl']?.toString() ?? '',
                                      ),
                                  icon: const Icon(
                                    Icons.picture_as_pdf,
                                    size: 18,
                                  ),
                                  label: const Text('PDF'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.colors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (isPending)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.deepOrange.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        size: 14,
                                        color: Colors.deepOrange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Pending sync',
                                        style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // ── Row 2: Copy + Edit (only for non-pending) ────
                        if (!isPending) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _copyReport(context, report),
                                  icon: const Icon(
                                    Icons.copy_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Copy'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: context.colors.primary,
                                    side: BorderSide(
                                      color: context.colors.primary.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _editReport(context, report),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Edit'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.green[700],
                                    side: BorderSide(
                                      color: Colors.green.withOpacity(0.5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _getLocalValue(Map<String, dynamic> report, String key) {
    final value = report[key];
    if (value == null || value.toString().isEmpty) return '-';
    return value.toString();
  }

  String _formatLocalDate(Map<String, dynamic> report) {
    final raw = report['createdAt'] ?? report['reportDate'] ?? '';
    if (raw.toString().isEmpty) return '-';
    try {
      final date = DateTime.parse(raw.toString());
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
      return '${date.day.toString().padLeft(2, '0')}-'
          '${months[date.month - 1]}-${date.year}';
    } catch (_) {
      return raw.toString();
    }
  }

  // ── Create dialog ─────────────────────────────────────────────────────────

  void _showCreateDialog(BuildContext context) {
    final provider = context.read<SystemProvider>();
    final reports = provider.getReportTypeModel?.data ?? [];

    if (reports.isEmpty) {
      if (_reportTypeFetchAttempts >= 2) {
        _reportTypeFetchAttempts = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Offline \u2014 no cached report types available. Connect once to cache them.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

      _reportTypeFetchAttempts++;
      provider.fetchReportType().then((_) {
        if (mounted) _showCreateDialog(context);
      });
      return;
    }

    _reportTypeFetchAttempts = 0;

    CommonDialog.show(
      context,
      widget: StatefulBuilder(
        builder: (context, setDialogState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colors.primary.withOpacity(0.1),
                        context.colors.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.assignment,
                              color: context.colors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Select Report Type',
                            style: context.topology.textTheme.titleMedium
                                ?.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: context.colors.primary,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _handleAction(
                            context,
                            report.reportType?.reportTypeId ?? '',
                            report.reportType?.reportName ?? 'Report',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.colors.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.description,
                                  color: context.colors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  report.reportType?.reportName ?? '',
                                  style: context.topology.textTheme.bodyMedium
                                      ?.copyWith(color: context.colors.primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _viewReportDetails(BuildContext context, Map<String, dynamic> report) {
    final reportTypeId = _getLocalValue(report, 'reportTypeId');
    final reportName = _getLocalValue(report, 'reportName');

    NavigationService().navigateTo(
      NavigationRoutes.reportFieldsScreen,
      arguments: {
        'reportTypeId': reportTypeId != '-' ? reportTypeId : '',
        'reportName': reportName != '-' ? reportName : 'Report Details',
        'item': widget.item,
        'reportData': report,
        'isViewMode': true,
      },
    );
  }

  void _handleAction(
    BuildContext context,
    String reportTypeId,
    String reportName,
  ) {
    NavigationService()
        .navigateTo(
          NavigationRoutes.reportFieldsScreen,
          arguments: {
            'reportTypeId': reportTypeId,
            'reportName': reportName,
            'item': widget.item,
          },
        )
        .then((_) async {
          if (!mounted) return;
          await _loadLocalReports();
          if (mounted) _syncFromApi(silent: true);
        });
  }

  // ── PDF viewer ────────────────────────────────────────────────────────────

  Future<void> _printPdf(
    BuildContext context,
    String reportId, {
    String pdfUrlView = '',
    String pdfUrl = '',
  }) async {
    if (reportId.isEmpty || reportId == '-') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report ID is missing, cannot open PDF.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (kIsWeb) {
      final url =
          pdfUrlView.isNotEmpty
              ? pdfUrlView
              : '${AppConstants.apiBaseUrl}'
                  '/reportData/$reportId/view-pdf';

      debugPrint('📄 Opening PDF in browser: $url');
      openInNewTab(url);
      return;
    }

    final systemProvider = Provider.of<SystemProvider>(context, listen: false);

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
      final pdfBytes = await systemProvider.fetchPdfReportById(reportId);

      if (context.mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (pdfBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'PDF not available. The report may still be processing.',
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
      debugPrint('❌ _printPdf error: $e');
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
    }
  }

  // ── Download all ──────────────────────────────────────────────────────────

  Future<void> _downloadAllPdfs(BuildContext context) async {
    if (_displayReports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No reports available to download'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isDownloadingAll = true);

    int successCount = 0;
    int failCount = 0;

    try {
      final archive = Archive();
      final provider = context.read<SystemProvider>();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Preparing ${_displayReports.length} reports for download...',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      for (var report in _displayReports) {
        final reportId = report['reportId']?.toString() ?? '';
        if (reportId.isEmpty || reportId == '-') continue;
        try {
          final pdfBytes = await provider.fetchPdfReportById(reportId);
          if (pdfBytes != null) {
            final label = _getReportLabel(report);
            final fileName = '${_sanitizeFileName(label)}.pdf';
            archive.addFile(ArchiveFile(fileName, pdfBytes.length, pdfBytes));
            successCount++;
          } else {
            failCount++;
          }
        } catch (e) {
          debugPrint('❌ Failed to fetch PDF for $reportId: $e');
          failCount++;
        }
      }

      if (successCount > 0) {
        final zipBytes = ZipEncoder().encode(archive);
        if (zipBytes != null) {
          final zipFileName = 'Reports_${_getDateTimeString()}.zip';
          if (kIsWeb) {
            downloadBlob(zipBytes, 'application/zip', zipFileName);
          } else {
            await _saveMobileZipFile(zipBytes, zipFileName, context);
          }
        }
      }

      if (context.mounted) {
        final message =
            failCount == 0 && successCount > 0
                ? 'Successfully downloaded $successCount reports as ZIP'
                : successCount == 0
                ? 'Failed to download all reports'
                : 'Downloaded $successCount reports, $failCount failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: failCount == 0 ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create ZIP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloadingAll = false);
    }
  }

  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
  }

  String _getDateTimeString() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '_${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _saveMobileZipFile(
    List<int> zipBytes,
    String fileName,
    BuildContext context,
  ) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) status = await Permission.storage.request();

      if (io.Platform.isAndroid) {
        var manageStatus = await Permission.manageExternalStorage.status;
        if (!manageStatus.isGranted) {
          manageStatus = await Permission.manageExternalStorage.request();
        }
      }

      if (status.isGranted ||
          (io.Platform.isAndroid &&
              await Permission.manageExternalStorage.isGranted)) {
        io.Directory? downloadsDir;
        if (io.Platform.isAndroid) {
          downloadsDir = io.Directory('/storage/emulated/0/Download');
          if (!await downloadsDir.exists()) {
            downloadsDir = await getExternalStorageDirectory();
          }
        } else if (io.Platform.isIOS) {
          downloadsDir = await getApplicationDocumentsDirectory();
        }
        if (downloadsDir != null) {
          final file = io.File('${downloadsDir.path}/$fileName');
          await file.writeAsBytes(zipBytes);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ZIP saved to: ${downloadsDir.path}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission required'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save ZIP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
