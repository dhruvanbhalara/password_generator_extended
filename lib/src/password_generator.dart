import 'dart:math';
import 'constants/password_constants.dart';
import 'utils/password_validator.dart';

/// Configuration for password generation
class PasswordGeneratorConfig {
  final int length;
  final bool useUpperCase;
  final bool useLowerCase;
  final bool useNumbers;
  final bool useSpecialChars;

  const PasswordGeneratorConfig({
    required this.length,
    required this.useUpperCase,
    required this.useLowerCase,
    required this.useNumbers,
    required this.useSpecialChars,
  });
}

/// A utility class for generating secure random passwords
class PasswordGenerator {
  final Random _random = Random.secure();
  String? _lastGeneratedPassword;

  /// Gets the last generated password
  String? get lastPassword => _lastGeneratedPassword;

  // Store password settings with medium defaults
  PasswordGeneratorConfig _config; // Remove final to allow updates

  /// Creates a PasswordGenerator with optional custom settings
  PasswordGenerator({
    int length = 12,
    bool useUpperCase = true,
    bool useLowerCase = true,
    bool useNumbers = true,
    bool useSpecialChars = true,
  }) : _config = PasswordGeneratorConfig(
         length: length,
         useUpperCase: useUpperCase,
         useLowerCase: useLowerCase,
         useNumbers: useNumbers,
         useSpecialChars: useSpecialChars,
       );

  /// Updates the password generation configuration
  void updateConfig({
    int? length,
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
  }) {
    _config = PasswordGeneratorConfig(
      length: length ?? _config.length,
      useUpperCase: useUpperCase ?? _config.useUpperCase,
      useLowerCase: useLowerCase ?? _config.useLowerCase,
      useNumbers: useNumbers ?? _config.useNumbers,
      useSpecialChars: useSpecialChars ?? _config.useSpecialChars,
    );
  }

  /// Refreshes and returns a new password using the current configuration
  String refreshPassword() {
    String password;
    do {
      password = generatePassword(
        length: _config.length,
        useUpperCase: _config.useUpperCase,
        useLowerCase: _config.useLowerCase,
        useNumbers: _config.useNumbers,
        useSpecialChars: _config.useSpecialChars,
      );
    } while (!isStrongPassword(password)); // Regenerate if not strong

    return password;
  }

  /// Generates a random password based on the specified criteria
  ///
  /// Parameters:
  /// - [length]: Length of the password (default: 12)
  /// - [useUpperCase]: Include uppercase letters (default: true)
  /// - [useLowerCase]: Include lowercase letters (default: true)
  /// - [useNumbers]: Include numbers (default: true)
  /// - [useSpecialChars]: Include special characters (default: true)
  ///
  /// Throws [ArgumentError] if length is less than 1 or no character types are selected
  String generatePassword({
    int? length,
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
  }) {
    final settings = PasswordGeneratorConfig(
      length: length ?? _config.length,
      useUpperCase: useUpperCase ?? _config.useUpperCase,
      useLowerCase: useLowerCase ?? _config.useLowerCase,
      useNumbers: useNumbers ?? _config.useNumbers,
      useSpecialChars: useSpecialChars ?? _config.useSpecialChars,
    );

    if (settings.length < 12) {
      throw ArgumentError('Password length must be at least 12');
    }

    if (!settings.useUpperCase &&
        !settings.useLowerCase &&
        !settings.useNumbers &&
        !settings.useSpecialChars) {
      throw ArgumentError('At least one character type must be selected');
    }

    // Build the character pool based on selected options
    String characterPool = '';
    if (settings.useUpperCase) {
      characterPool += PasswordConstants.upperCaseLetters;
    }
    if (settings.useLowerCase) {
      characterPool += PasswordConstants.lowerCaseLetters;
    }
    if (settings.useNumbers) characterPool += PasswordConstants.numbers;
    if (settings.useSpecialChars) {
      characterPool += PasswordConstants.specialCharacters;
    }

    // Generate the password without repeating characters
    String password = '';
    List<int> usedIndices = []; // Track used indices
    for (int i = 0; i < settings.length; i++) {
      if (characterPool.isEmpty) {
        throw ArgumentError(
          'Not enough unique characters to generate password',
        );
      }
      int randomIndex;
      do {
        randomIndex = _random.nextInt(characterPool.length);
      } while (usedIndices.contains(randomIndex)); // Ensure no repeats
      usedIndices.add(randomIndex);
      password += characterPool[randomIndex];
    }

    // Ensure at least one character from each selected type is included
    if (password.isNotEmpty) {
      List<String> passwordChars = password.split('');
      int position = 0;

      if (settings.useUpperCase &&
          !PasswordValidator.containsUpperCase(password)) {
        passwordChars[position] =
            PasswordConstants.upperCaseLetters[_random.nextInt(
              PasswordConstants.upperCaseLetters.length,
            )];
        position++;
      }
      if (settings.useLowerCase &&
          !PasswordValidator.containsLowerCase(password)) {
        passwordChars[position] =
            PasswordConstants.lowerCaseLetters[_random.nextInt(
              PasswordConstants.lowerCaseLetters.length,
            )];
        position++;
      }
      if (settings.useNumbers && !PasswordValidator.containsNumber(password)) {
        passwordChars[position] =
            PasswordConstants.numbers[_random.nextInt(
              PasswordConstants.numbers.length,
            )];
        position++;
      }
      if (settings.useSpecialChars &&
          !PasswordValidator.containsSpecialChar(password)) {
        passwordChars[position] =
            PasswordConstants.specialCharacters[_random.nextInt(
              PasswordConstants.specialCharacters.length,
            )];
        position++;
      }

      password = passwordChars.join();
    }

    _lastGeneratedPassword = password;
    return password;
  }

  // Optional: Method to evaluate password strength
  bool isStrongPassword(String password) {
    // Check minimum length
    if (password.length < 12) {
      return false;
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return false;
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return false;
    }

    // Check for at least one digit
    if (!RegExp(r'\d').hasMatch(password)) {
      return false;
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return false;
    }

    return true; // Password is strong
  }
}
