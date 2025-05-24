class ValidationUtils {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a $fieldName';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }
    final trimmedValue = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    final trimmedValue = value.trim();
    if (trimmedValue.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateNumber(
    String? value,
    String fieldName, {
    bool allowDecimal = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a $fieldName';
    }
    final trimmedValue = value.trim();
    if (allowDecimal) {
      if (double.tryParse(trimmedValue) == null) {
        return 'Please enter a valid number for a $fieldName';
      }
    } else {
      if (int.tryParse(trimmedValue) == null) {
        return 'Please enter a valid integer for a $fieldName';
      }
    }
    return null;
  }

  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }
}
