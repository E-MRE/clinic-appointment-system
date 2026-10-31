import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:clinic_appointment_system/features/users/domain/visitors/technician_service_eligibility.dart';

/// A technician profile.
base class Technician extends Staff {
  /// Creates a technician profile.
  const Technician({
    required super.id,
    required super.fullName,
    required super.email,
    required super.branchId,
    required super.departmentId,
    required super.serviceIds,
  });

  @override
  UserRole get role => UserRole.technician;

  @override
  MedicalServiceVisitor<bool> get serviceEligibility =>
      const TechnicianServiceEligibility();

  @override
  R accept<R>(StaffVisitor<R> visitor) => visitor.visitTechnician(this);

  @override
  Technician trimmed() {
    return Technician(
      id: id,
      fullName: fullName.trim(),
      email: email.trim(),
      branchId: branchId.trim(),
      departmentId: departmentId.trim(),
      serviceIds: serviceIds.map((String id) => id.trim()).toList(),
    );
  }

  @override
  Technician withId(String id) {
    return Technician(
      id: id,
      fullName: fullName,
      email: email,
      branchId: branchId,
      departmentId: departmentId,
      serviceIds: serviceIds,
    );
  }
}
