import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalCategoryStorage {
  static const String _keyPrefix = 'category_fields_';

  static String _getKey(String categoryId) {
    return '$_keyPrefix$categoryId';
  }

  static Future<bool> saveFields(
    String categoryId,
    List<Map<String, dynamic>> fields,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKey(categoryId);
      final jsonString = json.encode(fields);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      print('Error saving category fields: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getFields(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKey(categoryId);
      final jsonString = prefs.getString(key);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {

      return [];
    }
  }

  static Future<bool> clearFields(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKey(categoryId);
      return await prefs.remove(key);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasFields(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKey(categoryId);
      return prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>> getAllCategoryIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      return keys
          .where((key) => key.startsWith(_keyPrefix))
          .map((key) => key.replaceFirst(_keyPrefix, ''))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> clearAllFields() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_keyPrefix)) {
          await prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
