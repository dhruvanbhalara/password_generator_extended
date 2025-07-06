/// Abstract interface for password strength validation.
abstract class IPasswordValidator {
  /// Checks if the given [password] meets the strength requirements.
  bool isStrongPassword(String password);
}
