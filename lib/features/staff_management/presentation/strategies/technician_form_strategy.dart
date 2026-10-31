import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/strategies/staff_form_strategy.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

/// Builds technician profiles from staff draft values.
final class TechnicianFormStrategy extends StaffFormStrategy {
  /// Creates the technician form strategy.
  const TechnicianFormStrategy();

  @override
  Staff create(StaffFormValues values, {required String id}) {
    return Technician(
      id: id,
      fullName: values.fullName,
      email: values.email,
      branchId: values.branchId,
      departmentId: values.departmentId,
      serviceIds: values.serviceIds,
    );
  }
}
