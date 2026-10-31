part of 'staff_management_page.dart';

/// Waits for clinic branches before displaying staff or the no-branch prompt.
final class _StaffManagementBranchContent extends StatelessWidget {
  const _StaffManagementBranchContent();

  @override
  Widget build(BuildContext context) {
    final clinicId = InstitutionSelectionScope.of(context).clinicId;
    if (clinicId == null) return const _StaffManagementNoBranch();
    return InstitutionListView<Branch, BranchListCubit>(
      emptyTitle: LocaleKeys.staff_noBranchTitle.tr(),
      emptyMessage: LocaleKeys.staff_noBranchMessage.tr(),
      onRetry: () => context.read<BranchListCubit>().watch(clinicId),
      emptyAction: const _StaffManagementInstitutionButton(),
      loadedBuilder: (_) {
        if (context.staffOverview.branchCount == 0) {
          return const _StaffManagementNoBranch();
        }
        return const _StaffManagementContent();
      },
    );
  }
}
