import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';

/// Boundary for reading user profiles and creating patient profiles.
abstract interface class UserRepository {
  /// Fetches the profile stored for the authentication [uid].
  /// Implementations return a failure result when the profile cannot be fetched.
  Future<DataResult<User>> getUser(String uid);

  /// Creates the patient profile for a newly registered user.
  /// Implementations return the created profile or a failure result.
  Future<DataResult<Patient>> createPatient(Patient patient);
}
