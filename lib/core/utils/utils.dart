//validations

import 'package:flutter/material.dart';

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

Future<void> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  String confirmText = 'OK',
  String cancelText = 'Cancel',
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}

// Global SizedBox widgets
const SizedBox smallSpacing = SizedBox(height: 8);
const SizedBox mediumSpacing = SizedBox(height: 16);
const SizedBox extraMediumSpacing = SizedBox(height: 32);
const SizedBox largeSpacing = SizedBox(height: 48);
