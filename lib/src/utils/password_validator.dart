/// Utility class for password validation
class PasswordValidator {
  /// Checks if the password contains at least one uppercase letter
  static bool containsUpperCase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  /// Checks if the password contains at least one lowercase letter
  static bool containsLowerCase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  /// Checks if the password contains at least one number
  static bool containsNumber(String password) =>
      password.contains(RegExp(r'[0-9]'));

  /// Checks if the password contains at least one special character
  static bool containsSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'));
}
