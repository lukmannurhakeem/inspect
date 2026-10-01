import 'package:flutter/foundation.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';

typedef JsonMap = Map<String, dynamic>;

class JobStorage {
  JobStorage._();

  static const String _pendingStatus = 'pending';

  static String _now() => DateTime.now().toIso8601String();

  static String _newId() => DateTime.now().millisecondsSinceEpoch.toString();

  static List<JsonMap> _readList(String key, String label) {
    try {
      return LocalStorage.getJsonList(key);
    } catch (e) {
      debugPrint('Error getting $label: $e');
      return [];
    }
  }

  static Future<bool> _writeList(
      String key,
      List<JsonMap> items,
      String label,
      ) async {
    try {
      return await LocalStorage.setJsonList(key, items);
    } catch (e) {
      debugPrint('Error saving $label: $e');
      return false;
    }
  }

  static Future<bool> saveDraft(JsonMap jobData) async {
    final now = _now();
    final draft = {
      ...jobData,
      'draftId': _newId(),
      'savedAt': now,
    };

    final success = await _writeList(
      LocalStorageConstant.jobDrafts,
      [...getDrafts(), draft],
      'job draft',
    );

    if (success) {
      try {
        await LocalStorage.setString(
          LocalStorageConstant.lastJobDraftTimestamp,
          now,
        );
      } catch (e) {
        debugPrint('Error saving draft timestamp: $e');
      }
    }

    return success;
  }

  static List<JsonMap> getDrafts() =>
      _readList(LocalStorageConstant.jobDrafts, 'job drafts');

  static Future<bool> deleteDraft(String draftId) {
    final drafts =
    getDrafts().where((draft) => draft['draftId'] != draftId).toList();
    return _writeList(LocalStorageConstant.jobDrafts, drafts, 'job drafts');
  }

  static Future<bool> clearAllDrafts() async {
    try {
      return await LocalStorage.remove(LocalStorageConstant.jobDrafts);
    } catch (e) {
      debugPrint('Error clearing job drafts: $e');
      return false;
    }
  }

  static List<JsonMap> getPendingQueue() =>
      _readList(LocalStorageConstant.pendingJobsQueue, 'pending queue');

  static Future<bool> _writeQueue(List<JsonMap> queue) =>
      _writeList(LocalStorageConstant.pendingJobsQueue, queue, 'pending queue');

  static Future<bool> addToPendingQueue(JsonMap jobData) {
    final item = {
      ...jobData,
      'queueId': _newId(),
      'queuedAt': _now(),
      'status': _pendingStatus,
      'retryCount': 0,
    };
    return _writeQueue([...getPendingQueue(), item]);
  }

  static Future<bool> updateQueueItemStatus(
      String queueId,
      String status, {
        String? errorMessage,
      }) {
    final queue = getPendingQueue();
    final index = queue.indexWhere((item) => item['queueId'] == queueId);

    if (index == -1) return Future.value(false);

    final item = queue[index];
    item
      ..['status'] = status
      ..['updatedAt'] = _now();

    if (errorMessage != null) {
      item
        ..['errorMessage'] = errorMessage
        ..['retryCount'] = ((item['retryCount'] as int?) ?? 0) + 1;
    }

    return _writeQueue(queue);
  }

  static Future<bool> removeFromQueue(String queueId) {
    final queue =
    getPendingQueue().where((item) => item['queueId'] != queueId).toList();
    return _writeQueue(queue);
  }

  static int getPendingJobCount() => getPendingQueue()
      .where((job) => job['status'] == _pendingStatus)
      .length;

  static bool hasPendingJobs() => getPendingQueue()
      .any((job) => job['status'] == _pendingStatus);

  static Future<bool> clearProcessedJobs() {
    final pendingOnly = getPendingQueue()
        .where((job) => job['status'] == _pendingStatus)
        .toList();
    return _writeQueue(pendingOnly);
  }

  static String? getLastDraftTimestamp() {
    final timestamp = LocalStorage.getString(
      LocalStorageConstant.lastJobDraftTimestamp,
    );
    return timestamp.isEmpty ? null : timestamp;
  }
}