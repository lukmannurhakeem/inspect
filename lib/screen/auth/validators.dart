import 'package:flutter/widgets.dart';

abstract final class Validators {
  static const minPasswordLength = 8;

  static final _email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _letterAndDigit = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    if (!_email.hasMatch(text)) return 'Please enter a valid email';
    return null;
  }

  static String? newPassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    if (!_letterAndDigit.hasMatch(text)) {
      return 'Password must contain both letters and numbers';
    }
    return null;
  }

  static FormFieldValidator<String> confirmPassword(
    TextEditingController original,
  ) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return 'Please confirm your password';
      if (text != original.text.trim()) return 'Passwords do not match';
      return null;
    };
  }
}
