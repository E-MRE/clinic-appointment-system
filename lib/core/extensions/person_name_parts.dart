import 'package:flutter/widgets.dart';

/// Display parts of a person's full name.
extension PersonNameParts on String {
  /// First letters of the first and last words, or one for a single word;
  /// empty for a blank name.
  String get initials {
    final words = _words;
    if (words.first.isEmpty) return '';
    final first = words.first.characters.first;
    if (words.length == 1) return first.toUpperCase();
    return '$first${words.last.characters.first}'.toUpperCase();
  }

  /// The first word, or an empty string for a blank name.
  String get firstName => _words.first;

  List<String> get _words => trim().split(RegExp(r'\s+'));
}
