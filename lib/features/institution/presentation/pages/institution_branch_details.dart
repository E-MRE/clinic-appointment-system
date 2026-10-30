part of 'institution_page.dart';

/// Selected branch hours and departments on larger screens.
final class _InstitutionBranchDetails extends StatelessWidget {
  const _InstitutionBranchDetails({required this.branches});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context) {
    final branchId = InstitutionSelectionScope.of(context).branchId;
    final selected = branches.firstWhere(
      (item) => item.id == branchId,
      orElse: () => branches.first,
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          WorkingHoursSection(
            hours: selected.workingHours,
            onEdit: () => context.go(
              AppRoutes.branchEdit(selected.clinicId, selected.id),
            ),
          ),
          const EmptySize.s16Height(),
          DepartmentSection(key: ValueKey(selected.id), branchId: selected.id),
        ],
      ),
    );
  }
}
