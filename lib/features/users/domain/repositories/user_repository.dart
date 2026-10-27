import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';

/// User profile boundary. Success uses results; failures throw [UserException].
abstract interface class UserRepository {
  /// Watches the profile stored for the authentication [uid].
  /// Failures are emitted as [UserException] stream errors.
  /// Stream setup failures can throw synchronously and must also be handled.
  Stream<DataResult<User>> watchUser(String uid);

  /// Creates the patient profile for a newly registered user.
  /// Throws [UserException] if profile creation fails.
  Future<DataResult<Patient>> createPatient(Patient patient);
}
