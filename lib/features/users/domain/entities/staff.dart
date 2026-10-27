import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

/// A clinic staff profile assigned to a branch and department.
abstract class Staff extends User {
  /// Creates a staff profile assigned to a branch and department.
  const Staff({
    required super.id,
    required super.fullName,
    required super.email,
    required this.branchId,
    required this.departmentId,
  });

  /// The identifier of the staff member's branch.
  @JsonKey(required: true)
  final String branchId;

  /// The identifier of the staff member's department.
  @JsonKey(required: true)
  final String departmentId;
}
