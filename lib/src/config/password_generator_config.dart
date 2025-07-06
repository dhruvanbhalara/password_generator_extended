class PasswordGeneratorConfig {
  const PasswordGeneratorConfig({
    required this.length,
    required this.useUpperCase,
    required this.useLowerCase,
    required this.useNumbers,
    required this.useSpecialChars,
  });
  final int length;
  final bool useUpperCase;
  final bool useLowerCase;
  final bool useNumbers;
  final bool useSpecialChars;
}
