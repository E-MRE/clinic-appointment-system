import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

/// Selects only the fields an existing staff profile may change.
final class StaffEditableFieldsVisitor
    implements StaffVisitor<Map<String, dynamic>> {
  /// Creates the staff update field selector.
  const StaffEditableFieldsVisitor();

  /// Selects the doctor name, specialty and assigned services.
  @override
  Map<String, dynamic> visitDoctor(Doctor staff) {
    return {
      FirestoreConstants.fullName: staff.fullName,
      FirestoreConstants.specialty: staff.specialty,
      FirestoreConstants.serviceIds: staff.serviceIds,
    };
  }

  /// Selects the technician name and assigned services.
  @override
  Map<String, dynamic> visitTechnician(Technician staff) {
    return {
      FirestoreConstants.fullName: staff.fullName,
      FirestoreConstants.serviceIds: staff.serviceIds,
    };
  }
}
