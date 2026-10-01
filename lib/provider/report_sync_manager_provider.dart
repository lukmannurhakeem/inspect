import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inspect/provider/system_provider.dart';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:provider/provider.dart';

class ReportSyncManagerProvider extends ChangeNotifier {
  static const _pendingReportsKey = 'pending_reports_queue';
  static const _maxRetries = 3;
  static const _ignoredFieldSuffixes = ['_filename', '_size', '_bytes'];

  List<Map<String, dynamic>> _pendingReports = [];
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  String? _lastError;

  List<Map<String, dynamic>> get pendingReports =>
      List.unmodifiable(_pendingReports);
  int get pendingCount => _pendingReports.length;
  bool get hasPending => _pendingReports.isNotEmpty;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get lastError => _lastError;

  Future<void> initialize(BuildContext context) async {
    await _loadQueue();
    _log('initialized with ${_pendingReports.length} pending reports');
  }

  Future<void> refresh() => _loadQueue();

  Future<void> clearQueue() async {
    if (_pendingReports.isEmpty) return;
    _pendingReports = [];
    await _saveQueue();
    notifyListeners();
    _log('queue cleared');
  }

  Future<void> enqueue(Map<String, dynamic> payload) async {
    final now = DateTime.now();
    final entry = {
      ...payload,
      'queuedAt': now.toIso8601String(),
      'retryCount': 0,
      'pendingId': 'pending_${now.millisecondsSinceEpoch}',
    };

    _pendingReports.add(entry);
    await _saveQueue();

    final itemId = _str(payload['itemId']);
    if (itemId.isNotEmpty) {
      await JobItemStorage.addItemReport(
        itemId,
        _buildStoredReport(
          entry,
          reportId: entry['pendingId'] as String,
          createdAt: entry['queuedAt'] as String,
          isPending: true,
          defaultStatus: 'draft',
        ),
      );
    }

    _log('enqueued report for item $itemId (${_pendingReports.length} pending)');
    notifyListeners();
  }

  Future<void> syncReports(BuildContext context, {bool silent = false}) async {
    if (_isSyncing || _pendingReports.isEmpty) return;

    _isSyncing = true;
    _lastError = null;
    notifyListeners();

    final systemProvider = context.read<SystemProvider>();
    final stillPending = <Map<String, dynamic>>[];
    var successCount = 0;
    var failCount = 0;

    _log('syncing ${_pendingReports.length} pending reports');

    for (final entry in List<Map<String, dynamic>>.from(_pendingReports)) {
      try {
        await _syncEntry(systemProvider, entry);
        successCount++;
      } catch (e) {
        failCount++;
        final retry = _retryEntry(entry, e);
        if (retry != null) stillPending.add(retry);
      }
    }

    _pendingReports = stillPending;
    await _saveQueue();

    _isSyncing = false;
    _lastSyncTime = DateTime.now();
    if (failCount > 0) _lastError = '$failCount report(s) failed to sync';
    notifyListeners();

    if (!silent && context.mounted) {
      _showResult(context, successCount, failCount);
    }

    _log(
      'sync complete: $successCount success, $failCount failed, '
          '${_pendingReports.length} still pending',
    );
  }

  Future<void> _syncEntry(
      SystemProvider provider,
      Map<String, dynamic> entry,
      ) async {
    final itemId = _str(entry['itemId']);
    final pendingId = _str(entry['pendingId']);

    final result = await provider.createReportData(
      reportTypeId: _str(entry['reportTypeId']),
      itemId: itemId,
      itemNo: _str(entry['itemNo']),
      status: _str(entry['status'], 'draft'),
      inspectedBy: _str(entry['inspectedBy']),
      reportDate: _str(entry['reportDate']),
      regulation: _str(entry['regulation']),
      reportData: _buildReportData(entry['fieldValues']),
      files: null,
    );

    final report = result?['report'] as Map<String, dynamic>?;
    final reportId = _firstNonNull([
      report?['reportID'],
      report?['reportId'],
      result?['reportId'],
      result?['id'],
    ], pendingId);
    final reportNo = _firstNonNull([report?['reportNo'], result?['reportNo']]);

    if (itemId.isNotEmpty) {
      await JobItemStorage.deleteItemReport(itemId, pendingId);
      await JobItemStorage.addItemReport(
        itemId,
        _buildStoredReport(
          entry,
          reportId: reportId,
          reportNo: reportNo,
          approvalStatus: _str(report?['approvalStatus']),
          createdAt: _str(
            report?['createdAt'],
            DateTime.now().toIso8601String(),
          ),
          isPending: false,
        ),
      );
    }

    _log('report synced ($reportId / $reportNo)');
  }

  Map<String, dynamic>? _retryEntry(Map<String, dynamic> entry, Object error) {
    final retryCount = (entry['retryCount'] as int?) ?? 0;
    if (retryCount >= _maxRetries) {
      _log('max retries reached for ${entry['pendingId']}, dropping');
      return null;
    }
    _log('retry ${retryCount + 1}/$_maxRetries for ${entry['pendingId']}: $error');
    return {
      ...entry,
      'retryCount': retryCount + 1,
      'lastError': error.toString(),
    };
  }

  Map<String, Map<String, String>> _buildReportData(dynamic rawFieldValues) {
    if (rawFieldValues is! Map) return {};
    return {
      for (final e in rawFieldValues.entries)
        if (!_ignoredFieldSuffixes.any(e.key.toString().endsWith))
          e.key.toString(): {'value': e.value.toString()},
    };
  }

  Map<String, dynamic> _buildStoredReport(
      Map<String, dynamic> entry, {
        required String reportId,
        required String createdAt,
        required bool isPending,
        String reportNo = '',
        String? approvalStatus,
        String defaultStatus = '',
      }) {
    return {
      'reportId': reportId,
      if (!isPending) 'reportNo': reportNo,
      'reportName': _str(entry['reportName']),
      'reportTypeId': _str(entry['reportTypeId']),
      'status': _str(entry['status'], defaultStatus),
      if (!isPending) 'approvalStatus': approvalStatus ?? '',
      'createdAt': createdAt,
      'reportDate': _str(entry['reportDate']),
      'itemId': _str(entry['itemId']),
      'itemNo': _str(entry['itemNo']),
      'inspectedBy': _str(entry['inspectedBy']),
      'regulation': _str(entry['regulation']),
      'isPending': isPending,
      'fieldValues': entry['fieldValues'] ?? {},
    };
  }

  void _showResult(BuildContext context, int success, int failed) {
    final message = failed == 0
        ? 'Synced $success report(s) successfully'
        : '$success synced, $failed failed';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: failed == 0 ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadQueue() async {
    try {
      final raw = LocalStorage.getString(_pendingReportsKey);
      if (raw.isNotEmpty) {
        _pendingReports = (jsonDecode(raw) as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
    } catch (e) {
      _log('error loading queue: $e');
      _pendingReports = [];
    }
    notifyListeners();
  }

  Future<void> _saveQueue() async {
    try {
      await LocalStorage.setString(
        _pendingReportsKey,
        jsonEncode(_pendingReports),
      );
    } catch (e) {
      _log('error saving queue: $e');
    }
  }

  String _str(dynamic value, [String fallback = '']) {
    final s = value?.toString() ?? '';
    return s.isEmpty ? fallback : s;
  }

  String _firstNonNull(List<dynamic> values, [String fallback = '']) {
    for (final v in values) {
      if (v != null) return v.toString();
    }
    return fallback;
  }

  void _log(String message) => debugPrint('ReportSyncManager: $message');
}