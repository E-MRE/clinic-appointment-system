part of 'staff_management_page.dart';

/// Opens the staff editor from an avatar and name card.
final class _StaffManagementMobileCard extends StatelessWidget {
  const _StaffManagementMobileCard({required this.staff});

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.compact,
      child: AppListTile(
        leading: AppAvatar(initials: staff.initials),
        title: staff.fullName,
        subtitle: context.staffOverview.subtitle(staff),
        trailing: IconButton(
          onPressed: () => context.openStaffAvailability(staff),
          tooltip: LocaleKeys.staff_availabilityTooltip.tr(),
          icon: const Icon(Icons.event_available_outlined),
        ),
        onTap: () => context.openStaffEdit(staff),
      ),
    );
  }
}
