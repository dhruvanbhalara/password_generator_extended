import 'ipassword_validator.dart';

/// Default implementation of [IPasswordValidator] for password strength validation.
class PasswordValidator implements IPasswordValidator {
  @override
  /// Checks if the given [password] is strong according to the following rules:
  /// - At least 12 characters
  /// - Contains uppercase, lowercase, number, and special character
  bool isStrongPassword(String password) {
    if (password.length < 12) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'\d').hasMatch(password)) return false;
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) return false;
    return true;
  }

  /// Checks if the password contains at least one uppercase letter.
  static bool containsUpperCase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  /// Checks if the password contains at least one lowercase letter.
  static bool containsLowerCase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  /// Checks if the password contains at least one number.
  static bool containsNumber(String password) =>
      password.contains(RegExp(r'[0-9]'));

  /// Checks if the password contains at least one special character.
  static bool containsSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'));
}
