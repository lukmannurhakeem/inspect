// location_storage_service.dart
//
// Upgraded from a single-key location store to a generic multi-key
// MRU (most-recently-used) picker store.
//
// Pre-defined keys live in [PickerStorageKey] — one per picker field
// so each field's history stays isolated.
//
// Backwards compatible: the original [LocationStorageService] class
// is kept at the bottom as a shim so no other files need to change.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ── Named keys ────────────────────────────────────────────────────────────────

class PickerStorageKey {
  PickerStorageKey._();

  /// General job location (job_add_new_details_screen)
  static const String jobLocation = 'inspect_picker_job_location';

  /// Offshore location (job_add_new_details_screen)
  static const String offshoreLocation = 'inspect_picker_offshore_location';

  /// Applicable Code (job_add_new_details_screen)
  static const String applicableCode = 'inspect_picker_applicable_code';

  /// Item location used by job item fields (job_item_create_screen)
  static const String itemLocation = 'inspect_picker_item_location';

// Add more keys here as new pickers are created, e.g.:
// static const String projectStandard = 'inspect_picker_project_standard';
}

// ── Service ───────────────────────────────────────────────────────────────────

class PickerStorageService {
  static const int _maxEntries = 50;

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Returns stored entries for [key] in MRU order (most recent first).
  static Future<List<String>> getAll(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      print('❌ PickerStorageService[$key]: Error reading: $e');
      return [];
    }
  }

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Adds [value] to the list for [key].
  /// - Case-insensitive de-dup (existing match removed first)
  /// - Inserted at front (MRU order)
  /// - Capped at [_maxEntries]
  static Future<void> add(String key, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    try {
      final existing = await getAll(key);
      existing.removeWhere((v) => v.toLowerCase() == trimmed.toLowerCase());
      existing.insert(0, trimmed);
      final bounded = existing.take(_maxEntries).toList();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(bounded));

      print(
        '💾 PickerStorageService[$key]: saved "$trimmed" (${bounded.length} total)',
      );
    } catch (e) {
      print('❌ PickerStorageService[$key]: Error saving: $e');
    }
  }

  /// Removes a single [value] from the list for [key].
  static Future<void> remove(String key, String value) async {
    try {
      final existing = await getAll(key);
      existing.removeWhere(
            (v) => v.toLowerCase() == value.trim().toLowerCase(),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(existing));
    } catch (e) {
      print('❌ PickerStorageService[$key]: Error removing: $e');
    }
  }

  /// Clears the entire list for [key].
  static Future<void> clearKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      print('❌ PickerStorageService[$key]: Error clearing: $e');
    }
  }

  /// Clears ALL picker storage (e.g. on logout / app reset).
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in [
        PickerStorageKey.jobLocation,
        PickerStorageKey.offshoreLocation,
        PickerStorageKey.applicableCode,
        PickerStorageKey.itemLocation,
      ]) {
        await prefs.remove(key);
      }
    } catch (e) {
      print('❌ PickerStorageService: Error clearing all: $e');
    }
  }
}

// ── Backwards-compatible shim ─────────────────────────────────────────────────
// All existing code that imports LocationStorageService continues to compile
// and work without any changes.

class LocationStorageService {
  static Future<List<String>> getCustomLocations() =>
      PickerStorageService.getAll(PickerStorageKey.itemLocation);

  static Future<void> addLocation(String location) =>
      PickerStorageService.add(PickerStorageKey.itemLocation, location);

  static Future<void> removeLocation(String location) =>
      PickerStorageService.remove(PickerStorageKey.itemLocation, location);

  static Future<void> clearAll() =>
      PickerStorageService.clearKey(PickerStorageKey.itemLocation);
}
