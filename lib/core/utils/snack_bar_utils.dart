import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    // Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // duration: duration,
        action: action,
      ),
    );
  }
}
