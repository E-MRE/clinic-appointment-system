import 'package:clinic_appointment_system/core/extensions/turkish_case_folding.dart';

/// Provides Turkish alphabetical ordering for [String] values.
extension TurkishAlphabeticalComparison on String {
  /// Compares this string with [other] using the Turkish alphabet.
  ///
  /// The comparison uses Turkish case mapping. Spaces, digits and punctuation
  /// sort before letters, and characters outside the Turkish alphabet sort
  /// after it by Unicode code point. Prefixes sort first, and names equal under
  /// this ordering use [String.compareTo] as a deterministic tie-breaker.
  int compareTurkishAlphabetically(String other) {
    final firstCharacters = turkishLowercase.runes.iterator;
    final secondCharacters = other.turkishLowercase.runes.iterator;

    while (true) {
      final hasFirstCharacter = firstCharacters.moveNext();
      final hasSecondCharacter = secondCharacters.moveNext();
      if (!hasFirstCharacter || !hasSecondCharacter) {
        if (hasFirstCharacter != hasSecondCharacter) {
          return hasFirstCharacter ? 1 : -1;
        }
        return compareTo(other);
      }

      final characterOrder = _rank(
        firstCharacters.current,
      ).compareTo(_rank(secondCharacters.current));
      if (characterOrder != _equalOrder) {
        return characterOrder;
      }
    }
  }

  String get _turkishAlphabet => 'abcçdefgğhıijklmnoöprsştuüvyz';
  int get _equalOrder => 0;
  int get _firstAlphabetIndex => 0;
  int get _firstLetter => 0x61;
  int get _letterBase => 0x100;
  int get _afterLetters => 0x200;

  int _rank(int character) {
    final alphabetIndex = _turkishAlphabet.indexOf(
      String.fromCharCode(character),
    );
    if (alphabetIndex >= _firstAlphabetIndex) {
      return _letterBase + alphabetIndex;
    }
    if (character < _firstLetter) return character;
    return _afterLetters + character;
  }
}
