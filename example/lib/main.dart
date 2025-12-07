import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_generator_extended/password_generator_extended.dart';

import 'strategies/custom_pin_strategy.dart';
import 'strategies/memorable_password_strategy.dart';
import 'strategies/pronounceable_password_strategy.dart';

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
  PasswordGenerator _generator = PasswordGenerator();
  String _password = '';
  late PasswordStrength _strength;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Add password generation parameters
  double _length = 12;
  bool _useUpperCase = true;
  bool _useLowerCase = true;
  bool _useNumbers = true;
  bool _useSpecialChars = true;
  bool _excludeAmbiguousChars = false;

  // Strategy selection
  final List<IPasswordGenerationStrategy> _strategies = [
    RandomPasswordStrategy(),
    MemorablePasswordStrategy(),
    PronounceablePasswordStrategy(),
    CustomPinStrategy(),
  ];
  late IPasswordGenerationStrategy _selectedStrategy;

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
  final TextEditingController _prefixController = TextEditingController(
    text: 'USER',
  );

  @override
  void initState() {
    super.initState();
    _selectedStrategy = _strategies[0];
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
      try {
        _generator.updateConfig(
          PasswordGeneratorConfig(
            length: _length.round(),
            useUpperCase: _useUpperCase,
            useLowerCase: _useLowerCase,
            useNumbers: _useNumbers,
            useSpecialChars: _useSpecialChars,
            excludeAmbiguousChars: _excludeAmbiguousChars,
            extra: {
              'prefix': _prefixController.text,
            },
          ),
        );
        _password = _generator.generatePassword();
        _strength = _generator.estimateStrength(_password);
      } catch (e) {
        _password = 'Error: ${e.toString()}';
        _strength = PasswordStrength.veryWeak;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
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
    _numbersController.dispose();
    _specialCharsController.dispose();
    _prefixController.dispose();
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

  String _getStrategyName(IPasswordGenerationStrategy strategy) {
    if (strategy is RandomPasswordStrategy) {
      return 'Random';
    } else if (strategy is MemorablePasswordStrategy) {
      return 'Memorable';
    } else if (strategy is PronounceablePasswordStrategy) {
      return 'Pronounceable';
    } else if (strategy is CustomPinStrategy) {
      return 'Custom PIN';
    }
    return 'Unknown';
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
                      const SizedBox(height: 16),
                      PasswordStrengthIndicator(strength: _strength),
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
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Generation Strategy',
                          border: OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<IPasswordGenerationStrategy>(
                            value: _selectedStrategy,
                            isDense: true,
                            items: _strategies.map((strategy) {
                              return DropdownMenuItem<
                                  IPasswordGenerationStrategy>(
                                value: strategy,
                                child: Text(_getStrategyName(strategy)),
                              );
                            }).toList(),
                            onChanged: (strategy) {
                              if (strategy != null) {
                                setState(() {
                                  _selectedStrategy = strategy;
                                  // Clamp length to valid range for the selected strategy
                                  if (_selectedStrategy
                                      is RandomPasswordStrategy) {
                                    if (_length < 12) _length = 12;
                                    if (_length > 32) _length = 32;
                                  } else if (_selectedStrategy
                                      is MemorablePasswordStrategy) {
                                    if (_length < 4) _length = 4;
                                    if (_length > 8) _length = 8;
                                  } else if (_selectedStrategy
                                      is PronounceablePasswordStrategy) {
                                    if (_length < 8) _length = 8;
                                    if (_length > 20) _length = 20;
                                  } else if (_selectedStrategy
                                      is CustomPinStrategy) {
                                    if (_length < 4) _length = 4;
                                    if (_length > 12) _length = 12;
                                  }

                                  _generator = PasswordGenerator(
                                    generationStrategy: _selectedStrategy,
                                  );
                                  _generator.updateConfig(
                                    PasswordGeneratorConfig(
                                      length: _length.round(),
                                      useUpperCase: _useUpperCase,
                                      useLowerCase: _useLowerCase,
                                      useNumbers: _useNumbers,
                                      useSpecialChars: _useSpecialChars,
                                      excludeAmbiguousChars:
                                          _excludeAmbiguousChars,
                                    ),
                                  );
                                  _generatePassword();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedStrategy is RandomPasswordStrategy)
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Length: ${_length.round()}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Slider(
                                    value: _length,
                                    min: 12,
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
                                if (value == false &&
                                    !_useLowerCase &&
                                    !_useNumbers &&
                                    !_useSpecialChars) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'At least one character type must be selected'),
                                    ),
                                  );
                                  return;
                                }
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
                                if (value == false &&
                                    !_useUpperCase &&
                                    !_useNumbers &&
                                    !_useSpecialChars) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'At least one character type must be selected'),
                                    ),
                                  );
                                  return;
                                }
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
                                if (value == false &&
                                    !_useUpperCase &&
                                    !_useLowerCase &&
                                    !_useSpecialChars) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'At least one character type must be selected'),
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  _useNumbers = value ?? true;
                                  _generatePassword();
                                });
                              },
                            ),
                            CheckboxListTile(
                              title:
                                  const Text('Special Characters (!@#\$...)'),
                              value: _useSpecialChars,
                              onChanged: (value) {
                                if (value == false &&
                                    !_useUpperCase &&
                                    !_useLowerCase &&
                                    !_useNumbers) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'At least one character type must be selected'),
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  _useSpecialChars = value ?? true;
                                  _generatePassword();
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('Exclude Ambiguous Characters'),
                              subtitle: const Text('(e.g. I, l, 1, O, 0)'),
                              value: _excludeAmbiguousChars,
                              onChanged: (value) {
                                setState(() {
                                  _excludeAmbiguousChars = value ?? false;
                                  _generatePassword();
                                });
                              },
                            ),
                          ],
                        )
                      else if (_selectedStrategy is MemorablePasswordStrategy)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Number of Words: ${_length.round()}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Slider(
                                value: _length,
                                min: 4,
                                max: 8,
                                divisions: 4,
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
                        )
                      else if (_selectedStrategy
                          is PronounceablePasswordStrategy)
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
                                max: 20,
                                divisions: 12,
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
                        )
                      else if (_selectedStrategy is CustomPinStrategy)
                        Column(
                          children: [
                            TextField(
                              controller: _prefixController,
                              decoration: const InputDecoration(
                                labelText: 'Prefix',
                                helperText: 'e.g. USER, PIN, KEY',
                              ),
                              onChanged: (_) => _generatePassword(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Length: ${_length.round()}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Slider(
                                    value: _length,
                                    min: 4,
                                    max: 12,
                                    divisions: 8,
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
                          ],
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

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  static const Map<PasswordStrength, Map<String, dynamic>> _strengthMap = {
    PasswordStrength.veryWeak: {
      'text': 'Very Weak',
      'color': Colors.red,
      'widthFactor': 0.2,
    },
    PasswordStrength.weak: {
      'text': 'Weak',
      'color': Colors.orange,
      'widthFactor': 0.4,
    },
    PasswordStrength.medium: {
      'text': 'Medium',
      'color': Colors.yellow,
      'widthFactor': 0.6,
    },
    PasswordStrength.strong: {
      'text': 'Strong',
      'color': Colors.lightGreen,
      'widthFactor': 0.8,
    },
    PasswordStrength.veryStrong: {
      'text': 'Very Strong',
      'color': Colors.green,
      'widthFactor': 1.0,
    },
  };

  @override
  Widget build(BuildContext context) {
    final strengthData = _strengthMap[strength]!;
    final color = Theme.of(context).brightness == Brightness.dark
        ? strengthData['color']
        : Color.lerp(strengthData['color'], Colors.black, 0.2);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: strengthData['widthFactor'],
                  child: Container(
                    height: 10,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          strengthData['text'],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
