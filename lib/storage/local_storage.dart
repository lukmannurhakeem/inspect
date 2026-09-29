import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool get isInitialized => _prefs != null;

  static SharedPreferences get _instance {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'LocalStorage not initialised. Await LocalStorage.init() in main().',
      );
    }
    return prefs;
  }

  static Future<void> reload() => _instance.reload();

  static Future<bool> setString(String key, String value) =>
      _instance.setString(key, value);

  static String getString(String key, {String defaultValue = ''}) =>
      _instance.getString(key) ?? defaultValue;

  static String? getStringOrNull(String key) => _instance.getString(key);

  static Future<bool> setInt(String key, int value) =>
      _instance.setInt(key, value);

  static int getInt(String key, {int defaultValue = 0}) =>
      _instance.getInt(key) ?? defaultValue;

  static int? getIntOrNull(String key) => _instance.getInt(key);

  static Future<bool> setDouble(String key, double value) =>
      _instance.setDouble(key, value);

  static double getDouble(String key, {double defaultValue = 0.0}) =>
      _instance.getDouble(key) ?? defaultValue;

  static double? getDoubleOrNull(String key) => _instance.getDouble(key);

  static Future<bool> setBool(String key, bool value) =>
      _instance.setBool(key, value);

  static bool getBool(String key, {bool defaultValue = false}) =>
      _instance.getBool(key) ?? defaultValue;

  static bool? getBoolOrNull(String key) => _instance.getBool(key);

  static Future<bool> setStringList(String key, List<String> value) =>
      _instance.setStringList(key, value);

  static List<String> getStringList(String key) =>
      List<String>.from(_instance.getStringList(key) ?? const <String>[]);

  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      return await _instance.setString(key, json.encode(value));
    } catch (_) {
      return false;
    }
  }

  static Map<String, dynamic>? getJson(String key) {
    try {
      final raw = _instance.getString(key);
      if (raw == null || raw.isEmpty) return null;
      return Map<String, dynamic>.from(json.decode(raw) as Map);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setJsonList(
      String key,
      List<Map<String, dynamic>> value,
      ) async {
    try {
      return await _instance.setString(key, json.encode(value));
    } catch (_) {
      return false;
    }
  }

  static List<Map<String, dynamic>> getJsonList(String key) {
    try {
      final raw = _instance.getString(key);
      if (raw == null || raw.isEmpty) return [];
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> setObject<T>(
      String key,
      T value,
      Map<String, dynamic> Function(T) toJson,
      ) =>
      setJson(key, toJson(value));

  static T? getObject<T>(
      String key,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    final map = getJson(key);
    if (map == null) return null;
    try {
      return fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setObjectList<T>(
      String key,
      List<T> value,
      Map<String, dynamic> Function(T) toJson,
      ) =>
      setJsonList(key, value.map(toJson).toList());

  static List<T> getObjectList<T>(
      String key,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    final result = <T>[];
    for (final map in getJsonList(key)) {
      try {
        result.add(fromJson(map));
      } catch (_) {}
    }
    return result;
  }

  static Future<bool> remove(String key) => _instance.remove(key);

  static Future<void> removeAll(Iterable<String> keys) async {
    await Future.wait(keys.map(_instance.remove));
  }

  static Future<bool> clear() => _instance.clear();

  static bool containsKey(String key) => _instance.containsKey(key);

  static Set<String> getKeys() => _instance.getKeys();
}