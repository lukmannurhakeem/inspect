import 'dart:convert';
import 'package:inspect/storage/job_item_storage.dart';
import 'package:inspect/storage/local_storage.dart';

class ReportDropdownOptionsService {
  static String _key(String id) => 'report_dropdown_opts_$id';

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Saves [optionsMap] under report name (always) and report type ID (when known).
  static Future<void> save({
    required String reportName,
    required Map<String, List<String>> optionsMap,
    String? reportTypeId,
  }) async {
    if (optionsMap.isEmpty) return;

    final cleaned = Map<String, List<String>>.fromEntries(
      optionsMap.entries.where((e) => e.value.isNotEmpty),
    );
    if (cleaned.isEmpty) return;

    final encoded = jsonEncode(cleaned);

    // Always save under report name (available immediately in create mode)
    if (reportName.trim().isNotEmpty) {
      await LocalStorage.setString(_key(reportName.trim()), encoded);
    }

    // Also save under real ID when available (edit mode / post-submit)
    if (reportTypeId != null && reportTypeId.trim().isNotEmpty) {
      await LocalStorage.setString(_key(reportTypeId.trim()), encoded);
    }
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Loads options by [reportTypeId] first, then falls back to [reportName].
  static Map<String, List<String>> load({
    required String reportTypeId,
    String? reportName,
  }) {
    final byId = _loadByKey(reportTypeId);
    if (byId.isNotEmpty) return byId;

    if (reportName != null && reportName.trim().isNotEmpty) {
      return _loadByKey(reportName.trim());
    }

    return {};
  }

  static Map<String, List<String>> _loadByKey(String key) {
    if (key.trim().isEmpty) return {};
    final raw = LocalStorage.getString(_key(key.trim()));
    if (raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
            (fieldName, value) => MapEntry(
          fieldName,
          (value as List<dynamic>).map((e) => e.toString()).toList(),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  static Future<void> clear({
    required String reportName,
    String? reportTypeId,
  }) async {
    if (reportName.trim().isNotEmpty) {
      await LocalStorage.remove(_key(reportName.trim()));
    }
    if (reportTypeId != null && reportTypeId.trim().isNotEmpty) {
      await LocalStorage.remove(_key(reportTypeId.trim()));
    }
  }
}
