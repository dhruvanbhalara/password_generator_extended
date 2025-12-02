import 'dart:math';

import '../config/password_generator_config.dart';
import '../constants/password_constants.dart';
import 'ipassword_generation_strategy.dart';

/// A password generation strategy that creates a random password.
///
/// This is the default strategy for the [PasswordGenerator]. It generates a
/// password by randomly selecting characters from a pool of allowed characters,
/// which can include uppercase letters, lowercase letters, numbers, and special
/// characters, as specified by the [PasswordGeneratorConfig].
class RandomPasswordStrategy implements IPasswordGenerationStrategy {
  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    final charSet = _buildCharacterSet(config);
    final random = Random.secure();
    final buffer = StringBuffer();

    for (var i = 0; i < config.length; i++) {
      final randomIndex = random.nextInt(charSet.length);
      buffer.write(charSet[randomIndex]);
    }

    return buffer.toString();
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    if (config.length < 12) {
      throw ArgumentError('Password length must be at least 12');
    }
    if (!config.useUpperCase &&
        !config.useLowerCase &&
        !config.useNumbers &&
        !config.useSpecialChars) {
      throw ArgumentError('At least one character type must be selected');
    }
  }

  String _buildCharacterSet(PasswordGeneratorConfig config) {
    final upper =
        config.excludeAmbiguousChars
            ? PasswordConstants.upperCaseLettersNonAmbiguous
            : PasswordConstants.upperCaseLetters;
    final lower =
        config.excludeAmbiguousChars
            ? PasswordConstants.lowerCaseLettersNonAmbiguous
            : PasswordConstants.lowerCaseLetters;
    final numbers =
        config.excludeAmbiguousChars
            ? PasswordConstants.numbersNonAmbiguous
            : PasswordConstants.numbers;
    final special =
        config.excludeAmbiguousChars
            ? PasswordConstants.specialCharactersNonAmbiguous
            : PasswordConstants.specialCharacters;

    String characterPool = '';
    if (config.useUpperCase) characterPool += upper;
    if (config.useLowerCase) characterPool += lower;
    if (config.useNumbers) characterPool += numbers;
    if (config.useSpecialChars) characterPool += special;

    return characterPool;
  }
}
