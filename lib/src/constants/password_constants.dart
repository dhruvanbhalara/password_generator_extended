/// Constants and utilities for password generation.
class PasswordConstants {
  /// The set of uppercase letters used in password generation.
  static String upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// The set of lowercase letters used in password generation.
  static String lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';

  /// The set of numeric characters used in password generation.
  static String numbers = '0123456789';

  /// The set of special characters used in password generation.
  static String specialCharacters = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  /// Customizes the character sets used for password generation.
  ///
  /// You can override any of the default character sets by providing a new value.
  static void customize({
    String? upperCase,
    String? lowerCase,
    String? numbersParam,
    String? special,
  }) {
    if (upperCase != null) {
      upperCaseLetters = upperCase;
    }
    if (lowerCase != null) {
      lowerCaseLetters = lowerCase;
    }
    if (numbersParam != null) {
      numbers = numbersParam;
    }
    if (special != null) {
      specialCharacters = special;
    }
  }

  /// Resets all character sets to their default values.
  static void resetToDefaults() {
    upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    numbers = '0123456789';
    specialCharacters = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  }
}
