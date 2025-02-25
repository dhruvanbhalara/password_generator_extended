import 'package:flutter/material.dart';
import 'package:password_generator_extended/password_generator_extended.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const PasswordExample(),
    );
  }
}

class PasswordExample extends StatefulWidget {
  const PasswordExample({super.key});

  @override
  State<PasswordExample> createState() => _PasswordExampleState();
}

class _PasswordExampleState extends State<PasswordExample>
    with SingleTickerProviderStateMixin {
  final PasswordGenerator _generator = PasswordGenerator();
  String _password = '';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Add password generation parameters
  double _length = 12;
  bool _useUpperCase = true;
  bool _useLowerCase = true;
  bool _useNumbers = true;
  bool _useSpecialChars = true;

  // Add controllers for text fields
  final TextEditingController _upperCaseController = TextEditingController(
    text: PasswordConstants.upperCaseLetters,
  );
  final TextEditingController _lowerCaseController = TextEditingController(
    text: PasswordConstants.lowerCaseLetters,
  );
  final TextEditingController _numbersController = TextEditingController(
    text: PasswordConstants.numbers,
  );
  final TextEditingController _specialCharsController = TextEditingController(
    text: PasswordConstants.specialCharacters,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _generatePassword();
  }

  void _generatePassword() {
    setState(() {
      _password = _generator.generatePassword(
        length: _length.round(),
        useUpperCase: _useUpperCase,
        useLowerCase: _useLowerCase,
        useNumbers: _useNumbers,
        useSpecialChars: _useSpecialChars,
      );
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _upperCaseController.dispose();
    _lowerCaseController.dispose();
    _numbersController.dispose();
    _specialCharsController.dispose();
    super.dispose();
  }

  void _showCustomizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customize Character Sets'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _upperCaseController,
                decoration: const InputDecoration(
                  labelText: 'Uppercase Letters',
                  helperText: 'Default: A-Z',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _lowerCaseController,
                decoration: const InputDecoration(
                  labelText: 'Lowercase Letters',
                  helperText: 'Default: a-z',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _numbersController,
                decoration: const InputDecoration(
                  labelText: 'Numbers',
                  helperText: 'Default: 0-9',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _specialCharsController,
                decoration: const InputDecoration(
                  labelText: 'Special Characters',
                  helperText: 'Default: !@#\$%^&*()_+-=[]{}|;:,.<>?',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              PasswordConstants.resetToDefaults();
              _upperCaseController.text = PasswordConstants.upperCaseLetters;
              _lowerCaseController.text = PasswordConstants.lowerCaseLetters;
              _numbersController.text = PasswordConstants.numbers;
              _specialCharsController.text =
                  PasswordConstants.specialCharacters;
              _generatePassword();
              Navigator.of(context).pop();
            },
            child: const Text('Reset to Defaults'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              PasswordConstants.customize(
                upperCase: _upperCaseController.text,
                lowerCase: _lowerCaseController.text,
                numbersParam: _numbersController.text,
                special: _specialCharsController.text,
              );
              _generatePassword();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showCustomizeDialog,
            tooltip: 'Customize Character Sets',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Generated Password:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SelectableText(
                          _password,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _password));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Password'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _generatePassword,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Generate New Password'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Password Options',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Length: ${_length.round()}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Slider(
                              value: _length,
                              min: 8,
                              max: 32,
                              divisions: 24,
                              label: _length.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _length = value;
                                  _generatePassword();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: const Text('Uppercase Letters (A-Z)'),
                        value: _useUpperCase,
                        onChanged: (value) {
                          setState(() {
                            _useUpperCase = value ?? true;
                            _generatePassword();
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Lowercase Letters (a-z)'),
                        value: _useLowerCase,
                        onChanged: (value) {
                          setState(() {
                            _useLowerCase = value ?? true;
                            _generatePassword();
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Numbers (0-9)'),
                        value: _useNumbers,
                        onChanged: (value) {
                          setState(() {
                            _useNumbers = value ?? true;
                            _generatePassword();
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Special Characters (!@#\$...)'),
                        value: _useSpecialChars,
                        onChanged: (value) {
                          setState(() {
                            _useSpecialChars = value ?? true;
                            _generatePassword();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
