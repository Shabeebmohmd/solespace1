// lib/utils/validation_utils.dart

class ValidationUtils {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $fieldName';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    // Simple email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateNumber(
    String? value,
    String fieldName, {
    bool allowDecimal = false,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $fieldName';
    }
    if (allowDecimal) {
      if (double.tryParse(value) == null) {
        return 'Please enter a valid number for a $fieldName';
      }
    } else {
      if (int.tryParse(value) == null) {
        return 'Please enter a valid integer for a $fieldName';
      }
    }
    return null;
  }

  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }
}
