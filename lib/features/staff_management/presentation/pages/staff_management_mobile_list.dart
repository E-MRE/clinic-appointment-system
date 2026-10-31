part of 'staff_management_page.dart';

/// Lists touch-friendly staff cards with room to scroll above the mobile FAB.
final class _StaffManagementMobileList extends StatelessWidget {
  const _StaffManagementMobileList({required this.staff});

  final List<Staff> staff;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final member in staff) ...[
          _StaffManagementMobileCard(staff: member),
          const EmptySize.s8Height(),
        ],
        const EmptySize.s96Height(),
      ],
    );
  }
}
