import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/strategies/staff_form_strategy.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_specialty_field.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/widgets.dart';

/// Builds doctor profiles from staff draft values.
final class DoctorFormStrategy extends StaffFormStrategy {
  /// Creates the doctor form strategy.
  const DoctorFormStrategy();

  @override
  Widget specialtySection() {
    return const StaffSpecialtyField();
  }

  @override
  Staff create(StaffFormValues values, {required String id}) {
    return Doctor(
      id: id,
      fullName: values.fullName,
      email: values.email,
      branchId: values.branchId,
      departmentId: values.departmentId,
      serviceIds: values.serviceIds,
      specialty: values.specialty,
    );
  }
}
