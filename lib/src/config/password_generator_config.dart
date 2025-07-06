/// Configuration for password generation.
///
/// This class holds the settings used to generate a password, such as length and character types.
class PasswordGeneratorConfig {
  /// Creates a [PasswordGeneratorConfig] with the given settings.
  const PasswordGeneratorConfig({
    required this.length,
    required this.useUpperCase,
    required this.useLowerCase,
    required this.useNumbers,
    required this.useSpecialChars,
  });

  /// The length of the password to generate.
  final int length;

  /// Whether to include uppercase letters in the password.
  final bool useUpperCase;

  /// Whether to include lowercase letters in the password.
  final bool useLowerCase;

  /// Whether to include numbers in the password.
  final bool useNumbers;

  /// Whether to include special characters in the password.
  final bool useSpecialChars;
}
