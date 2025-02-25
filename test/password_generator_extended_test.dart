import 'package:flutter_test/flutter_test.dart';

import 'package:password_generator_extended/password_generator_extended.dart';

void main() {
  late PasswordGenerator generator;

  setUp(() {
    generator = PasswordGenerator();
  });

  group('PasswordGenerator', () {
    test('generates password with default settings', () {
      final password = generator.generatePassword();
      expect(password.length, equals(12)); // Default length is 12
      expect(
        password,
        matches(
          RegExp(r'^[A-Za-z0-9!@#\$%\^&\*\(\)_\+\-=\[\]\{\}\|;:,\.<>\?]+$'),
        ),
      );
    });

    test('generates password with custom length', () {
      final password = generator.generatePassword(length: 20);
      expect(password.length, equals(20));
    });

    test('generates password with only lowercase letters', () {
      generator.updateConfig(
        useUpperCase: false,
        useLowerCase: true,
        useNumbers: false,
        useSpecialChars: false,
      );

      final password = generator.generatePassword();
      expect(password, matches(RegExp(r'^[a-z]+$')));
    });

    test('generates password with all character types when enabled', () {
      final password = generator.generatePassword();

      // Should contain at least one of each type
      expect(password, contains(RegExp(r'[A-Z]'))); // Uppercase
      expect(password, contains(RegExp(r'[a-z]'))); // Lowercase
      expect(password, contains(RegExp(r'[0-9]'))); // Numbers
      expect(password, contains(RegExp(r'[!@#\$%\^&\*]'))); // Special
    });

    test('throws error for invalid length', () {
      expect(() => generator.generatePassword(length: 0), throwsArgumentError);
      expect(() => generator.generatePassword(length: -1), throwsArgumentError);
    });

    test('throws error when all character types are disabled', () {
      generator.updateConfig(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: false,
      );

      expect(() => generator.generatePassword(), throwsArgumentError);
    });
  });
}
