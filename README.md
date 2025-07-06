<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Password Generator Extended

A secure password generator package for Flutter applications that creates strong, customizable passwords.

## Features

- Cryptographically secure random password generation
- Customizable password length and character sets
- Ensures at least one character from each selected type

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  password_generator_extended: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:password_generator_extended/password_generator_extended.dart';

// Create a generator with default settings
final generator = PasswordGenerator();

// Generate a password
String password = generator.generate(); // Creates a 16-character password with all character types
```

### Customized Usage

```dart
final generator = PasswordGenerator(
  length: 20,              // Password length
  useUppercase: true,      // Include uppercase letters
  useLowercase: true,      // Include lowercase letters
  useNumbers: true,        // Include numbers
  useSpecialCharacter: true,        // Include special characters
);

// Generate with custom length
String password = generator.generate(length: 24);

// Change settings after initialization
generator.length = 18;
generator.useSpecialCharacter = false;
```

### Flutter Widget Example

```dart
class PasswordWidget extends StatefulWidget {
  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  final generator = PasswordGenerator();
  String password = '';

  @override
  void initState() {
    super.initState();
    password = generator.generate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableText(password),
        ElevatedButton(
          onPressed: () {
            setState(() {
              password = generator.generate();
            });
          },
          child: Text('Generate New Password'),
        ),
      ],
    );
  }
}
```

## Configuration Options

| Parameter           | Type | Default | Description                   |
| ------------------- | ---- | ------- | ----------------------------- |
| length              | int  | 12      | Password length (minimum: 12) |
| useUppercase        | bool | true    | Include uppercase letters     |
| useLowercase        | bool | true    | Include lowercase letters     |
| useNumbers          | bool | true    | Include numbers               |
| useSpecialCharacter | bool | true    | Include special characters    |

## Security Notes

- Uses `Random.secure()` for cryptographically secure random number generation
- Ensures at least one character from each selected type is included
- Minimum password length of 8 characters recommended
- Validates input parameters to prevent weak passwords

## Additional Information

- Source code: [GitHub Repository](https://github.com/dhruvanbhalara/password_generator_extended)
- Bug reports and feature requests: [Issue Tracker](https://github.com/dhruvanbhalara/password_generator_extended/issues)
- For detailed examples, check the [example](example) folder

## License

MIT License - see the [LICENSE](LICENSE) file for details
