import 'dart:math';

import 'package:clinic_appointment_system/features/staff_management/domain/services/temporary_password_generator.dart';

/// Generates grouped passwords with uppercase, lowercase and digit guarantees.
/// The alphabet excludes ambiguous characters `0 O o 1 l I`.
final class SecureTemporaryPasswordGenerator
    implements TemporaryPasswordGenerator {
  /// Injects the random source. Production callers must pass [Random.secure].
  SecureTemporaryPasswordGenerator(this._random);

  static const String _uppercase = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const String _lowercase = 'abcdefghijkmnpqrstuvwxyz';
  static const String _digits = '23456789';
  static const String _alphabet = '$_uppercase$_lowercase$_digits';
  static const int _firstGroupLength = 3;
  static const int _middleGroupLength = 4;
  static const int _lastGroupLength = 3;
  static const int _characterCount =
      _firstGroupLength + _middleGroupLength + _lastGroupLength;
  static const List<int> _groupLengths = [
    _firstGroupLength,
    _middleGroupLength,
    _lastGroupLength,
  ];
  static const int _startOffset = 0;
  static const String _separator = '-';

  final Random _random;

  @override
  String generate() {
    final List<String> characters = [
      _choose(_uppercase),
      _choose(_lowercase),
      _choose(_digits),
    ];
    while (characters.length < _characterCount) {
      characters.add(_choose(_alphabet));
    }
    characters.shuffle(_random);
    final List<String> groups = [];
    int offset = _startOffset;
    for (final int length in _groupLengths) {
      final int end = offset + length;
      groups.add(characters.sublist(offset, end).join());
      offset = end;
    }
    return groups.join(_separator);
  }

  String _choose(String alphabet) => alphabet[_random.nextInt(alphabet.length)];
}
