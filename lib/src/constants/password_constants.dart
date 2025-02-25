/// Constants used for password generation
class PasswordConstants {
  static String upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static String lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  static String numbers = '0123456789';
  static String specialCharacters = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static void customize({
    String? upperCase,
    String? lowerCase,
    String? numbers,
    String? special,
  }) {
    if (upperCase != null) {
      upperCaseLetters = upperCase;
    }
    if (lowerCase != null) {
      lowerCaseLetters = lowerCase;
    }
    if (numbers != null) {
      numbers = numbers;
    }
    if (special != null) {
      specialCharacters = special;
    }
  }

  static void resetToDefaults() {
    upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    numbers = '0123456789';
    specialCharacters = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  }
}
