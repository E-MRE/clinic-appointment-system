part of 'staff_management_page.dart';

/// Explains the branch prerequisite when no clinic branches are available.
final class _StaffManagementNoBranch extends StatelessWidget {
  const _StaffManagementNoBranch();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: LocaleKeys.staff_noBranchTitle.tr(),
      message: LocaleKeys.staff_noBranchMessage.tr(),
      icon: const Icon(Icons.domain_outlined),
      iconBackground: context.colorScheme.surfaceContainerHighest,
      primaryAction: const _StaffManagementInstitutionButton(),
    );
  }
}
