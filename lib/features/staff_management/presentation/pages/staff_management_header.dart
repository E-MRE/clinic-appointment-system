part of 'staff_management_page.dart';

/// Presents clinic-wide staff counts and the non-mobile add action.
final class _StaffManagementHeader extends StatelessWidget {
  const _StaffManagementHeader();

  @override
  Widget build(BuildContext context) {
    final overview = context.staffOverview;
    final state = context.watch<StaffListCubit>().state;
    return PageHeader(
      title: LocaleKeys.staff_title.tr(),
      subtitle:
          state is InstitutionListLoaded<Staff> && overview.branchCount > 0
          ? context.screenSize.select(
              mobile: overview.mobileSubtitle,
              tablet: overview.wideSubtitle,
              desktop: overview.wideSubtitle,
            )
          : null,
      actions: context.screenSize.isMobile
          ? null
          : const _StaffManagementAddButton(),
    );
  }
}
