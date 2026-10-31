import 'package:clinic_appointment_system/core/constants/staff_constants.dart';
import 'package:clinic_appointment_system/core/constants/validation_constants.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_assignment.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// Staff input rules shared by use cases and form fields.
/// Each check returns the first failing code, or null when valid.
mixin StaffInputValidationMixin {
  /// Requires a staff name without imposing culturally specific name formats.
  UserErrorCode? staffFullNameError(String fullName) {
    if (fullName.trim().isEmpty) return UserErrorCode.fullNameRequired;
    return null;
  }

  /// Checks identity, placement, role details, then service assignment limits,
  /// duplicates and eligibility, in that order. Empty assignments are valid.
  UserErrorCode? staffError(StaffAssignment assignment) {
    final Staff staff = assignment.staff;
    final UserErrorCode? nameError = staffFullNameError(staff.fullName);
    if (nameError != null) return nameError;
    if (!ValidationConstants.emailPattern.hasMatch(staff.email.trim())) {
      return UserErrorCode.invalidEmail;
    }
    if (staff.branchId.trim().isEmpty) {
      return UserErrorCode.branchRequired;
    }
    if (staff.departmentId.trim().isEmpty) {
      return UserErrorCode.departmentRequired;
    }
    final UserErrorCode? detailsError = staff.detailsError;
    if (detailsError != null) {
      return detailsError;
    }
    if (staff.serviceIds.length > StaffConstants.maxAssignedServices) {
      return UserErrorCode.tooManyServices;
    }
    if (staff.serviceIds.toSet().length != staff.serviceIds.length) {
      return UserErrorCode.duplicateService;
    }
    for (final String id in staff.serviceIds) {
      final bool eligible = assignment.availableServices.any(
        (MedicalService service) =>
            service.id == id && staff.canProvide(service),
      );
      if (!eligible) {
        return UserErrorCode.ineligibleService;
      }
    }
    return null;
  }

  /// Throws [UserException] with [error] when a staff input check failed.
  void ensureStaffValid(UserErrorCode? error) {
    if (error != null) {
      throw UserException(error);
    }
  }
}
