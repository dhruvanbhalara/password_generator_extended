import 'ipassword_validator.dart';

class PasswordValidator implements IPasswordValidator {
  @override
  bool isStrongPassword(String password) {
    if (password.length < 12) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'\d').hasMatch(password)) return false;
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) return false;
    return true;
  }

  static bool containsUpperCase(String password) =>
      password.contains(RegExp(r'[A-Z]'));
  static bool containsLowerCase(String password) =>
      password.contains(RegExp(r'[a-z]'));
  static bool containsNumber(String password) =>
      password.contains(RegExp(r'[0-9]'));
  static bool containsSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'));
}
