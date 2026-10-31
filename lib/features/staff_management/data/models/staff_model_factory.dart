import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/users/data/models/doctor_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/technician_model.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Builds staff profiles from stored doctor and technician documents.
final class StaffModelFactory {
  /// Creates the staff profile model factory.
  const StaffModelFactory();

  /// Reads staff fields, including legacy assignment defaults.
  /// Throws [ArgumentError] for unsupported roles, [TypeError] for missing roles
  /// and `CheckedFromJsonException` for malformed profile fields.
  Staff fromJson(Map<String, dynamic> json) {
    final UserRole role = UserRole.values.byName(
      json[FirestoreConstants.role] as String,
    );
    return switch (role) {
      UserRole.doctor => DoctorModel.fromJson(json),
      UserRole.technician => TechnicianModel.fromJson(json),
      UserRole.patient || UserRole.admin => throw ArgumentError.value(
        role.name,
        FirestoreConstants.role,
        'Expected a staff role',
      ),
    };
  }
}
