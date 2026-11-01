import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// A clinic staff profile assigned to a branch and department.
/// Subclasses provide role eligibility, details, visitor dispatch and copies.
abstract base class Staff extends User {
  /// Creates a staff profile assigned to a branch and department.
  const Staff({
    required super.id,
    required super.fullName,
    required super.email,
    required this.branchId,
    required this.departmentId,
    required this.serviceIds,
  });

  /// The identifier of the staff member's branch.
  final String branchId;

  /// The identifier of the staff member's department.
  final String departmentId;

  /// Identifiers of the medical services assigned to this staff member.
  final List<String> serviceIds;

  /// This staff profile, preserving its concrete role and identity.
  @override
  Staff get staffProfile => this;

  /// Subclasses must supply a visitor deciding which service kinds they allow.
  MedicalServiceVisitor<bool> get serviceEligibility;

  /// Requires the same branch, department and an eligible service kind.
  bool canProvide(MedicalService service) =>
      service.branchId == branchId &&
      service.departmentId == departmentId &&
      service.accept(serviceEligibility);

  /// Role-specific input error, or null when role details are valid.
  UserErrorCode? get detailsError => null;

  /// Subclasses must dispatch to their corresponding method on [visitor].
  R accept<R>(StaffVisitor<R> visitor);

  /// Subclasses must copy their own type with all input text trimmed.
  /// The existing profile id must be preserved.
  Staff trimmed();

  /// Subclasses must copy their own type with [id], preserving other fields.
  Staff withId(String id);
}
