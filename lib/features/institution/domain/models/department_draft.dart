/// Department creation input before a repository assigns its identifier.
final class DepartmentDraft {
  /// Creates a department draft with its branch and raw name.
  const DepartmentDraft({required this.branchId, required this.name});

  /// The identifier of the branch that will own this department.
  final String branchId;

  /// The department name to validate and save.
  final String name;
}
