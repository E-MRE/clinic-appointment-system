part of 'staff_management_page.dart';

/// Preserves filters when no staff match their combined selection.
final class _StaffManagementFilteredEmpty extends StatelessWidget {
  const _StaffManagementFilteredEmpty();

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _StaffManagementFilters(),
          const EmptySize.s32Height(),
          AppMutedMessage(message: LocaleKeys.staff_filterEmpty.tr()),
          const EmptySize.s16Height(),
        ],
      ),
    );
  }
}
