import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:flutter/widgets.dart';

/// Display parts derived independently of the stored full name.
extension UserDisplayName on User {
  /// First letters of the first and last name words, or one for a single word.
  String get initials {
    final words = _words;
    if (words.first.isEmpty) return '';
    final first = words.first.characters.first;
    if (words.length == 1) return first.toUpperCase();
    return '$first${words.last.characters.first}'.toUpperCase();
  }

  /// The first word of the full name, or an empty string for a blank name.
  String get firstName => _words.first;

  List<String> get _words => fullName.trim().split(RegExp(r'\s+'));
}
