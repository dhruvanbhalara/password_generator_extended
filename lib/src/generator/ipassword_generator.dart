abstract class IPasswordGenerator {
  String generatePassword({
    int? length,
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
  });
  String refreshPassword();
}
