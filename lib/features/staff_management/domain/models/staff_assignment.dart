import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Staff input and the branch catalogue used to validate assigned service ids.
base class StaffAssignment {
  /// Creates input with the staff member's branch service catalogue.
  const StaffAssignment({required this.staff, required this.availableServices});

  /// The staff profile being validated or saved.
  final Staff staff;

  /// Services of the staff member's branch against which assignments are checked.
  final List<MedicalService> availableServices;
}
