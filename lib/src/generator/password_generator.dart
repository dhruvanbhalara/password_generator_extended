import 'dart:math';
import '../config/password_generator_config.dart';
import '../validator/ipassword_validator.dart';
import '../validator/password_validator.dart';
import '../constants/password_constants.dart';
import 'ipassword_generator.dart';

class PasswordGenerator implements IPasswordGenerator {
  PasswordGenerator({
    int length = 12,
    bool useUpperCase = true,
    bool useLowerCase = true,
    bool useNumbers = true,
    bool useSpecialChars = true,
    IPasswordValidator? validator,
  }) : _config = PasswordGeneratorConfig(
         length: length,
         useUpperCase: useUpperCase,
         useLowerCase: useLowerCase,
         useNumbers: useNumbers,
         useSpecialChars: useSpecialChars,
       ),
       _validator = validator ?? PasswordValidator();
  final Random _random = Random.secure();
  final IPasswordValidator _validator;
  PasswordGeneratorConfig _config;
  String? _lastGeneratedPassword;

  String? get lastPassword => _lastGeneratedPassword;

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

  @override
  String refreshPassword() {
    String password;
    do {
      password = generatePassword();
    } while (!_validator.isStrongPassword(password));
    return password;
  }

  @override
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

    String password = '';
    List<int> usedIndices = [];
    for (int i = 0; i < settings.length; i++) {
      if (characterPool.isEmpty) {
        throw ArgumentError(
          'Not enough unique characters to generate password',
        );
      }
      int randomIndex;
      do {
        randomIndex = _random.nextInt(characterPool.length);
      } while (usedIndices.contains(randomIndex));
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
}
