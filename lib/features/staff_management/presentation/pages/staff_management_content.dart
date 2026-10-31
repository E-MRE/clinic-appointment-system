part of 'staff_management_page.dart';

/// Renders staff request states beside the desktop editor when loaded.
final class _StaffManagementContent extends StatelessWidget {
  const _StaffManagementContent();

  @override
  Widget build(BuildContext context) {
    return _StaffManagementDesktopLayout(
      child: InstitutionListView<Staff, StaffListCubit>(
        emptyTitle: LocaleKeys.staff_emptyTitle.tr(),
        emptyMessage: LocaleKeys.staff_emptyMessage.tr(),
        onRetry: context.read<StaffListCubit>().watch,
        emptyAction: context.screenSize.isDesktop
            ? null
            : const _StaffManagementAddButton(),
        loadedBuilder: (_) {
          return const _StaffManagementLoaded();
        },
      ),
    );
  }
}
