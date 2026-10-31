part of 'staff_management_page.dart';

/// Keeps mobile filters visible above the scrollable staff cards.
final class _StaffManagementMobileView extends StatelessWidget {
  const _StaffManagementMobileView({required this.staff});

  final List<Staff> staff;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StaffManagementFilters(),
        const EmptySize.s16Height(),
        Expanded(
          child: staff.isEmpty
              ? AppMutedMessage(message: LocaleKeys.staff_filterEmpty.tr())
              : _StaffManagementMobileList(staff: staff),
        ),
      ],
    );
  }
}
