import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/widgets.dart';

/// Display initials derived independently of the stored full name.
extension StaffInitials on Staff {
  /// First letters of the first and last name words, or one for a single word.
  String get initials {
    final words = fullName.trim().split(RegExp(r'\s+'));
    if (words.first.isEmpty) return '';
    final first = words.first.characters.first;
    if (words.length == 1) return first.toUpperCase();
    return '$first${words.last.characters.first}'.toUpperCase();
  }
}
