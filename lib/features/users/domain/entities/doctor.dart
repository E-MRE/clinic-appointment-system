import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:clinic_appointment_system/features/users/domain/visitors/doctor_service_eligibility.dart';

/// A doctor profile.
base class Doctor extends Staff {
  /// Creates a doctor profile.
  const Doctor({
    required super.id,
    required super.fullName,
    required super.email,
    required super.branchId,
    required super.departmentId,
    required super.serviceIds,
    required this.specialty,
  });

  /// The doctor's clinical specialty.
  final String specialty;

  @override
  UserRole get role => UserRole.doctor;

  @override
  MedicalServiceVisitor<bool> get serviceEligibility =>
      const DoctorServiceEligibility();

  @override
  UserErrorCode? get detailsError {
    if (specialty.trim().isEmpty) {
      return UserErrorCode.specialtyRequired;
    }
    return null;
  }

  @override
  R accept<R>(StaffVisitor<R> visitor) => visitor.visitDoctor(this);

  @override
  Doctor trimmed() {
    return Doctor(
      id: id,
      fullName: fullName.trim(),
      email: email.trim(),
      branchId: branchId.trim(),
      departmentId: departmentId.trim(),
      serviceIds: serviceIds.map((String id) => id.trim()).toList(),
      specialty: specialty.trim(),
    );
  }

  @override
  Doctor withId(String id) {
    return Doctor(
      id: id,
      fullName: fullName,
      email: email,
      branchId: branchId,
      departmentId: departmentId,
      serviceIds: serviceIds,
      specialty: specialty,
    );
  }
}
