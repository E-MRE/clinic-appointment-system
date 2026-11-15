part of 'branch_detail_page.dart';

/// Branch heading, hours and department details.
final class _BranchDetailBody extends StatelessWidget {
  const _BranchDetailBody({required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(title: branch.name, subtitle: branch.address),
        Expanded(child: _buildSections(context)),
      ],
    );
  }

  /// Builds the branch's hours and department sections.
  Widget _buildSections(BuildContext context) {
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
