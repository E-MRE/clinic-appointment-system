import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';

/// An immutable medical department inside a branch.
base class Department extends InstitutionRecord {
  /// Creates a department from already validated values.
  const Department({
    required super.id,
    required super.name,
    required this.branchId,
  });

  /// The identifier of the branch that owns this department.
  final String branchId;
}
