import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:inspect/storage/local_storage.dart';

class JobItemStorage {
  static const _draftPrefix = 'job_item_draft_';
  static const _pendingPrefix = 'job_item_pending_';
  static const _itemsPrefix = 'job_items_';
  static const _reportsPrefix = 'item_reports_';
  static const _reportFilesPrefix = 'item_report_files_';

  static String _draftKey(String id) => '$_draftPrefix$id';

  static String _pendingKey(String id) => '$_pendingPrefix$id';

  static String _itemsKey(String jobId) => '$_itemsPrefix$jobId';

  static String _reportsKey(String itemId) => '$_reportsPrefix$itemId';

  static String _draftIndexKey(String jobId) => '${_draftPrefix}index_$jobId';

  static String _pendingIndexKey(String jobId) =>
      '${_pendingPrefix}index_$jobId';

  static Future<bool> saveDraft(String jobId, Map<String, dynamic> data) async {
    try {
      final itemId = _resolveId(data);

      final payload = {
        ...data,
        'itemId': itemId,
        'jobId': jobId,
        'status': 'draft',
        'savedAt': DateTime.now().toIso8601String(),
      };

      final success = await LocalStorage.setString(
        _draftKey(itemId),
        jsonEncode(payload),
      );

      if (success) {
        await _updateIndex(_draftIndexKey(jobId), itemId, add: true);
      }

      return success;
    } catch (e) {
      debugPrint('saveDraft error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getDraft(String itemId) async {
    return _readMap(_draftKey(itemId));
  }

  static Future<List<Map<String, dynamic>>> getJobDrafts(String jobId) async {
    return _readIndexedItems(_draftIndexKey(jobId), getDraft);
  }

  static Future<bool> deleteDraft(String itemId) async {
    try {
      return await LocalStorage.remove(_draftKey(itemId));
    } catch (e) {
      debugPrint('deleteDraft error: $e');
      return false;
    }
  }

  static Future<bool> addToPendingQueue(
    String jobId,
    Map<String, dynamic> data,
  ) async {
    try {
      final itemId = _resolveId(data);

      final payload = {
        ...data,
        'itemId': itemId,
        'jobId': jobId,
        'status': 'pending_submission',
        'retryCount': 0,
        'queuedAt': DateTime.now().toIso8601String(),
      };

      final success = await LocalStorage.setString(
        _pendingKey(itemId),
        jsonEncode(payload),
      );

      if (success) {
        await _updateIndex(_pendingIndexKey(jobId), itemId, add: true);
      }

      return success;
    } catch (e) {
      debugPrint('addToPendingQueue error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getPendingItem(String itemId) async {
    return _readMap(_pendingKey(itemId));
  }

  static Future<List<Map<String, dynamic>>> getPendingItems(
    String jobId,
  ) async {
    return _readIndexedItems(_pendingIndexKey(jobId), getPendingItem);
  }

  static Future<bool> updatePendingItemStatus(
    String itemId,
    String status, {
    String? errorMessage,
  }) async {
    try {
      final item = await getPendingItem(itemId);

      if (item == null) return false;

      item['status'] = status;
      item['updatedAt'] = DateTime.now().toIso8601String();

      if (errorMessage != null) {
        item['errorMessage'] = errorMessage;
        item['retryCount'] = (item['retryCount'] ?? 0) + 1;
      }

      if (status == 'submitted') {
        item['submittedAt'] = DateTime.now().toIso8601String();
      }

      return LocalStorage.setString(_pendingKey(itemId), jsonEncode(item));
    } catch (e) {
      debugPrint('updatePendingItemStatus error: $e');
      return false;
    }
  }

  static Future<bool> removeItem(String jobId, String itemId) async {
    await deleteDraft(itemId);
    await LocalStorage.remove(_pendingKey(itemId));

    await _updateIndex(_draftIndexKey(jobId), itemId, add: false);

    await _updateIndex(_pendingIndexKey(jobId), itemId, add: false);

    final items = await getJobItems(jobId);

    items.removeWhere((e) => e['itemId']?.toString() == itemId);

    return saveJobItems(jobId, items);
  }

  static Future<bool> clearJobDrafts(String jobId) async {
    try {
      final indexKey = _draftIndexKey(jobId);

      for (final id in _readIndex(indexKey)) {
        await deleteDraft(id);
      }

      return await LocalStorage.remove(indexKey);
    } catch (e) {
      debugPrint('clearJobDrafts error: $e');
      return false;
    }
  }

  static Future<bool> clearJobItems(String jobId) async {
    try {
      return await LocalStorage.remove(_itemsKey(jobId));
    } catch (e) {
      debugPrint('clearJobItems error: $e');
      return false;
    }
  }

  static Future<bool> saveCompletedItem(
    String jobId,
    Map<String, dynamic> data,
  ) async {
    try {
      final itemId = _resolveId(data);

      final items = await getJobItems(jobId);

      final payload = {
        ...data,
        'itemId': itemId,
        'jobId': jobId,
        'status': 'submitted',
        'submittedAt': DateTime.now().toIso8601String(),
      };

      final index = items.indexWhere((e) => e['itemId'] == itemId);

      if (index >= 0) {
        items[index] = payload;
      } else {
        items.add(payload);
      }

      return saveJobItems(jobId, items);
    } catch (e) {
      debugPrint('saveCompletedItem error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getJobItems(String jobId) async {
    final data = LocalStorage.getString(_itemsKey(jobId));

    if (data.isEmpty) return [];

    try {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    } catch (_) {
      return [];
    }
  }

  static Future<bool> saveJobItems(
    String jobId,
    List<Map<String, dynamic>> items,
  ) {
    return LocalStorage.setString(_itemsKey(jobId), jsonEncode(items));
  }

  static Future<bool> deleteJobItem(String jobId, String itemId) async {
    final items = await getJobItems(jobId);

    items.removeWhere((e) => e['itemId']?.toString() == itemId);

    return saveJobItems(jobId, items);
  }

  static Future<bool> updateItem(
    String jobId,
    String itemId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = DateTime.now().toIso8601String();

      final completedItems = await getJobItems(jobId);

      final completedIndex = completedItems.indexWhere(
        (e) => e['itemId']?.toString() == itemId,
      );

      if (completedIndex >= 0) {
        completedItems[completedIndex] = {
          ...completedItems[completedIndex],
          ...updates,
        };

        return saveJobItems(jobId, completedItems);
      }

      final pending = await getPendingItem(itemId);

      if (pending != null) {
        return LocalStorage.setString(
          _pendingKey(itemId),
          jsonEncode({...pending, ...updates}),
        );
      }

      final draft = await getDraft(itemId);

      if (draft != null) {
        return LocalStorage.setString(
          _draftKey(itemId),
          jsonEncode({...draft, ...updates}),
        );
      }

      return saveCompletedItem(jobId, {...updates, 'itemId': itemId});
    } catch (e) {
      debugPrint('updateItem error: $e');
      return false;
    }
  }

  static Future<bool> markItemAsSubmitted(String jobId, String itemId) async {
    try {
      Map<String, dynamic>? item;

      item = await getPendingItem(itemId);

      if (item != null) {
        await LocalStorage.remove(_pendingKey(itemId));

        await _updateIndex(_pendingIndexKey(jobId), itemId, add: false);
      }

      item ??= await getDraft(itemId);

      if (item != null) {
        await deleteDraft(itemId);
      }

      item ??= {'itemId': itemId, 'jobId': jobId};

      return saveCompletedItem(jobId, {
        ...item,
        'status': 'submitted',
        'isPending': false,
      });
    } catch (e) {
      debugPrint('markItemAsSubmitted error: $e');
      return false;
    }
  }

  static Future<bool> removeFromPendingQueue(String itemId) async {
    try {
      final item = await getPendingItem(itemId);

      if (item == null) return false;

      final jobId = item['jobId']?.toString();

      final success = await LocalStorage.remove(_pendingKey(itemId));

      if (success && jobId != null) {
        await _updateIndex(_pendingIndexKey(jobId), itemId, add: false);
      }

      return success;
    } catch (e) {
      debugPrint('removeFromPendingQueue error: $e');
      return false;
    }
  }

  static Future<int> getPendingItemCount(String jobId) async {
    final items = await getPendingItems(jobId);

    return items.where((e) => e['status'] == 'pending_submission').length;
  }

  static Future<bool> hasPendingItems(String jobId) async {
    return await getPendingItemCount(jobId) > 0;
  }

  static Future<bool> clearProcessedItems(String jobId) async {
    try {
      final items = await getPendingItems(jobId);

      for (final item in items) {
        final id = item['itemId']?.toString();
        final status = item['status'];

        if (id != null && status != 'pending_submission') {
          await removeFromPendingQueue(id);
        }
      }

      return true;
    } catch (e) {
      debugPrint('clearProcessedItems error: $e');
      return false;
    }
  }

  static Future<bool> saveItemReports(
    String itemId,
    List<Map<String, dynamic>> reports,
  ) {
    if (itemId.isEmpty) {
      return Future.value(false);
    }

    return LocalStorage.setString(_reportsKey(itemId), jsonEncode(reports));
  }

  static Future<List<Map<String, dynamic>>> getItemReports(
    String itemId,
  ) async {
    if (itemId.isEmpty) return [];

    final data = LocalStorage.getString(_reportsKey(itemId));

    if (data.isEmpty) return [];

    try {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    } catch (_) {
      return [];
    }
  }

  static Future<bool> addItemReport(
    String itemId,
    Map<String, dynamic> report,
  ) async {
    final reports = await getItemReports(itemId);

    final id = report['reportId']?.toString();

    if (id != null && id.isNotEmpty) {
      final index = reports.indexWhere((e) => e['reportId']?.toString() == id);

      if (index >= 0) {
        reports[index] = report;
      } else {
        reports.add(report);
      }
    } else {
      reports.add(report);
    }

    return saveItemReports(itemId, reports);
  }

  static Future<bool> deleteItemReport(String itemId, String reportId) async {
    final reports = await getItemReports(itemId);

    reports.removeWhere((e) => e['reportId']?.toString() == reportId);

    return saveItemReports(itemId, reports);
  }

  static Future<bool> clearItemReports(String itemId) {
    return LocalStorage.remove(_reportsKey(itemId));
  }

  static Future<List<Map<String, dynamic>>> getReportsByJobId(
    String jobId,
  ) async {
    if (jobId.isEmpty) return [];

    try {
      final items = await getJobItems(jobId);
      final reports = <Map<String, dynamic>>[];

      for (final item in items) {
        final itemId = item['itemId']?.toString();

        if (itemId == null || itemId.isEmpty) {
          continue;
        }

        final itemReports = await getItemReports(itemId);

        reports.addAll(
          itemReports.map(
            (report) => {
              ...report,
              '_itemId': itemId,
              '_itemNo': item['itemNo']?.toString() ?? itemId,
            },
          ),
        );
      }

      return reports;
    } catch (e) {
      debugPrint('getReportsByJobId error: $e');
      return [];
    }
  }

  static Future<void> saveReportFiles(
    String reportId,
    Map<String, String> files,
  ) async {
    if (reportId.isEmpty || files.isEmpty) return;

    try {
      await LocalStorage.setString(
        '$_reportFilesPrefix$reportId',
        jsonEncode(files),
      );
    } catch (e) {
      debugPrint('saveReportFiles error: $e');
    }
  }

  static Map<String, String> loadReportFiles(String reportId) {
    if (reportId.isEmpty) return {};

    try {
      final data = LocalStorage.getString('$_reportFilesPrefix$reportId');

      if (data.isEmpty) return {};

      return Map<String, String>.from(jsonDecode(data));
    } catch (e) {
      debugPrint('loadReportFiles error: $e');
      return {};
    }
  }

  static Future<void> deleteReportFiles(String reportId) async {
    if (reportId.isEmpty) return;

    try {
      await LocalStorage.remove('$_reportFilesPrefix$reportId');
    } catch (e) {
      debugPrint('deleteReportFiles error: $e');
    }
  }

  static Future<Map<String, dynamic>> getStorageStats(String jobId) async {
    try {
      final drafts = await getJobDrafts(jobId);
      final pending = await getPendingItems(jobId);
      final completed = await getJobItems(jobId);

      return {
        'jobId': jobId,
        'drafts': drafts.length,
        'pending': pending.length,
        'completed': completed.length,
        'total': drafts.length + pending.length + completed.length,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('getStorageStats error: $e');
      return {};
    }
  }

  static Future<List<Map<String, dynamic>>> _readIndexedItems(
    String indexKey,
    Future<Map<String, dynamic>?> Function(String) getter,
  ) async {
    try {
      final ids = _readIndex(indexKey);
      final items = <Map<String, dynamic>>[];

      for (final id in ids) {
        final item = await getter(id);

        if (item != null) {
          items.add(item);
        }
      }

      return items;
    } catch (e) {
      debugPrint('_readIndexedItems error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> _readMap(String key) async {
    try {
      final value = LocalStorage.getString(key);

      if (value.isEmpty) return null;

      return Map<String, dynamic>.from(jsonDecode(value));
    } catch (e) {
      debugPrint('_readMap error: $e');
      return null;
    }
  }

  static List<String> _readIndex(String key) {
    try {
      final value = LocalStorage.getString(key);

      if (value.isEmpty) return [];

      return List<String>.from(jsonDecode(value));
    } catch (_) {
      return [];
    }
  }

  static Future<void> _updateIndex(
    String key,
    String itemId, {
    required bool add,
  }) async {
    try {
      final ids = _readIndex(key);

      if (add) {
        if (!ids.contains(itemId)) {
          ids.add(itemId);
        }
      } else {
        ids.remove(itemId);
      }

      await LocalStorage.setString(key, jsonEncode(ids));
    } catch (e) {
      debugPrint('_updateIndex error: $e');
    }
  }

  static String _resolveId(Map<String, dynamic> data) {
    return data['itemId']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
  }
}
