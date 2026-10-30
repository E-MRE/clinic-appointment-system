import 'package:clinic_appointment_system/features/institution/domain/models/institution_draft.dart';

/// Department creation input before a repository assigns its identifier.
final class DepartmentDraft extends InstitutionDraft {
  /// Creates a department draft with its branch and raw name.
  const DepartmentDraft({required this.branchId, required super.name});

  /// The identifier of the branch that will own this department.
  final String branchId;

  @override
  DepartmentDraft trimmed() {
    return DepartmentDraft(branchId: branchId, name: name.trim());
  }
}
