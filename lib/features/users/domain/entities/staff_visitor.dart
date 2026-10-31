import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

/// Polymorphic staff operations; implementations must handle both staff roles.
abstract interface class StaffVisitor<R> {
  /// Implementations must handle a doctor profile and return its result.
  R visitDoctor(Doctor staff);

  /// Implementations must handle a technician profile and return its result.
  R visitTechnician(Technician staff);
}
