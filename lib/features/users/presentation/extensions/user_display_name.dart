import 'package:clinic_appointment_system/core/extensions/person_name_parts.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';

/// Display parts derived independently of the stored full name.
extension UserDisplayName on User {
  /// First letters of the first and last name words, or one for a single word.
  String get initials => fullName.initials;

  /// The first word of the full name, or an empty string for a blank name.
  String get firstName => fullName.firstName;
}
