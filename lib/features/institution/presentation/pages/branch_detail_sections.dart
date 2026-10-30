part of 'branch_detail_page.dart';

/// Scrollable working hours and departments for a branch.
final class _BranchDetailSections extends StatelessWidget {
  const _BranchDetailSections({required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WorkingHoursSection(
            hours: branch.workingHours,
            onEdit: () =>
                context.go(AppRoutes.branchEdit(branch.clinicId, branch.id)),
          ),
          const EmptySize.s16Height(),
          DepartmentSection(key: ValueKey(branch.id), branchId: branch.id),
        ],
      ),
    );
  }
}
