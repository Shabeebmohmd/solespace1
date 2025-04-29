//validations

import 'package:flutter/widgets.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateConfirmPassword(String? value, String text) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != text) {
    return 'Passwords do not match';
  }
  return null;
}

// Global SizedBox widgets
const SizedBox smallSpacing = SizedBox(height: 8);
const SizedBox mediumSpacing = SizedBox(height: 16);
const SizedBox extraMediumSpacing = SizedBox(height: 32);
const SizedBox largeSpacing = SizedBox(height: 48);
