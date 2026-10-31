import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Staff profile boundary. Implementations must throw [UserException] on failure.
abstract interface class StaffRepository {
  /// Implementations must watch every doctor and technician profile.
  /// Failures are [UserException] stream errors; setup may throw synchronously.
  Stream<DataResult<List<Staff>>> watchStaff();

  /// Implementations must write the profile under [Staff.id], the auth uid.
  /// Throws [UserException] when the profile cannot be created.
  Future<DataResult<Staff>> createStaff(Staff staff);

  /// Implementations must save only fullName, specialty (doctors) and serviceIds.
  /// Role, email, branch and department must never change.
  /// Throws [UserException] when the profile cannot be updated.
  Future<DataResult<Staff>> updateStaff(Staff staff);
}
