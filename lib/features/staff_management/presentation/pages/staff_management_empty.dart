part of 'staff_management_page.dart';

/// Shows the clinic-scoped empty state even when other clinics have staff.
final class _StaffManagementEmpty extends StatelessWidget {
  const _StaffManagementEmpty();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: LocaleKeys.staff_emptyTitle.tr(),
      message: LocaleKeys.staff_emptyMessage.tr(),
      icon: const Icon(Icons.group_outlined),
      iconBackground: context.colorScheme.surfaceContainerHighest,
      primaryAction: context.screenSize.isDesktop
          ? null
          : const _StaffManagementAddButton(),
    );
  }
}
