import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }
}
