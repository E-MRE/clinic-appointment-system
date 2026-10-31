import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

/// Pre-fills staff forms through polymorphic role dispatch.
final class StaffFormValuesVisitor implements StaffVisitor<StaffFormValues> {
  /// Creates the staff form values visitor.
  const StaffFormValuesVisitor();

  @override
  StaffFormValues visitDoctor(Doctor staff) {
    return _sharedValues(staff).copyWith(specialty: staff.specialty);
  }

  @override
  StaffFormValues visitTechnician(Technician staff) => _sharedValues(staff);

  StaffFormValues _sharedValues(Staff staff) {
    return StaffFormValues(
      role: staff.role,
      fullName: staff.fullName,
      email: staff.email,
      branchId: staff.branchId,
      departmentId: staff.departmentId,
      serviceIds: List<String>.unmodifiable(staff.serviceIds),
    );
  }
}
