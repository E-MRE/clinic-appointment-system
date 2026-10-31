import 'package:clinic_appointment_system/features/staff_management/presentation/visitors/staff_form_values_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:equatable/equatable.dart';

/// Immutable draft values for creating or editing staff profiles.
final class StaffFormValues extends Equatable {
  /// Creates draft values, defaulting to an empty doctor form.
  const StaffFormValues({
    this.role = UserRole.doctor,
    this.fullName = '',
    this.specialty = '',
    this.email = '',
    this.password = '',
    this.branchId = '',
    this.departmentId = '',
    this.serviceIds = const [],
  });

  /// Creates an empty doctor form without a generated password.
  const StaffFormValues.empty() : this();

  /// Pre-fills role-specific values without exposing a stored password.
  factory StaffFormValues.fromStaff(Staff staff) {
    return staff.accept(const StaffFormValuesVisitor());
  }

  /// The selected staff role.
  final UserRole role;

  /// The full name input.
  final String fullName;

  /// The doctor specialty input, unused for technicians.
  final String specialty;

  /// The sign-in email input.
  final String email;

  /// The exact temporary password, empty when editing.
  final String password;

  /// The selected branch identifier.
  final String branchId;

  /// The selected department identifier.
  final String departmentId;

  /// The assigned service identifiers in selection order.
  final List<String> serviceIds;

  /// Copies draft values with the supplied fields replaced.
  StaffFormValues copyWith({
    UserRole? role,
    String? fullName,
    String? specialty,
    String? email,
    String? password,
    String? branchId,
    String? departmentId,
    List<String>? serviceIds,
  }) {
    return StaffFormValues(
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      specialty: specialty ?? this.specialty,
      email: email ?? this.email,
      password: password ?? this.password,
      branchId: branchId ?? this.branchId,
      departmentId: departmentId ?? this.departmentId,
      serviceIds: serviceIds ?? this.serviceIds,
    );
  }

  @override
  List<Object> get props => [
    role,
    fullName,
    specialty,
    email,
    password,
    branchId,
    departmentId,
    serviceIds,
  ];
}
