/// Abstract interface for password generators.
///
/// Implement this interface to provide custom password generation logic.
abstract class IPasswordGenerator {
  /// Generates a password using the specified or default settings.
  ///
  /// [length] - The length of the password.
  /// [useUpperCase] - Whether to include uppercase letters.
  /// [useLowerCase] - Whether to include lowercase letters.
  /// [useNumbers] - Whether to include numbers.
  /// [useSpecialChars] - Whether to include special characters.
  String generatePassword({
    int? length,
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
  });

  /// Generates a new password, possibly using different logic or validation.
  String refreshPassword();
}
