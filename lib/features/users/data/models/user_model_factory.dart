import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/users/data/models/admin_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/doctor_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/patient_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/technician_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/user_model.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Builds the profile model that matches a stored document's role.
final class UserModelFactory {
  /// Creates the profile model factory.
  const UserModelFactory();

  /// Creates the model for the role stored in [json].
  ///
  /// Throws [ArgumentError] for an unknown role, [TypeError] for a missing
  /// one and `CheckedFromJsonException` for missing or malformed fields.
  UserModel fromJson(Map<String, dynamic> json) {
    final role = UserRole.values.byName(
      json[FirestoreConstants.role] as String,
    );
    return switch (role) {
      UserRole.patient => PatientModel.fromJson(json),
      UserRole.admin => AdminModel.fromJson(json),
      UserRole.doctor => DoctorModel.fromJson(json),
      UserRole.technician => TechnicianModel.fromJson(json),
    };
  }
}
