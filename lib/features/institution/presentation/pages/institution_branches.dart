part of 'institution_page.dart';

/// Responsive branch list and selected branch details.
final class _InstitutionBranches extends StatelessWidget {
  const _InstitutionBranches({
    required this.branches,
    required this.createDepartmentSaveCubit,
  });

  final List<Branch> branches;
  final DepartmentSaveCubit Function() createDepartmentSaveCubit;

  @override
  Widget build(BuildContext context) {
    final selection = InstitutionSelectionScope.of(context);
    final selected = branches.firstWhere(
      (item) => item.id == selection.branchId,
      orElse: () => branches.first,
    );
    final list = ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (_, _) => const EmptySize.s8Height(),
      itemBuilder: (context, index) {
        final branch = branches[index];
        if (context.screenSize.isMobile) {
          return InstitutionBranchCard(
            branch: branch,
            onTap: () {
              selection.selectBranch(branch.id);
              context.go(AppRoutes.branchDetail(branch.clinicId, branch.id));
            },
          );
        }
        return AppSurface(
          child: AppListTile(
            title: branch.name,
            subtitle:
                '${branch.address} · ${branch.workingHours.localizedSummary}',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => selection.selectBranch(branch.id),
          ),
        );
      },
    );
    if (context.screenSize.isMobile) return list;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: list),
        const EmptySize.s16Width(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                WorkingHoursSection(
                  hours: selected.workingHours,
                  onEdit: () => context.go(
                    AppRoutes.branchEdit(selected.clinicId, selected.id),
                  ),
                ),
                const EmptySize.s16Height(),
                DepartmentSection(
                  key: ValueKey(selected.id),
                  branchId: selected.id,
                  createSaveCubit: createDepartmentSaveCubit,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
