part of 'staff_management_page.dart';

/// Hosts the unchanged reusable form in a dismissible tablet dialog.
final class _StaffManagementFormDialog extends StatelessWidget {
  const _StaffManagementFormDialog({this.staff});

  final Staff? staff;

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: staff == null
          ? LocaleKeys.staff_addTitle.tr()
          : LocaleKeys.staff_editTitle.tr(),
      child: StaffForm(
        staff: staff,
        onCancel: () => Navigator.of(context).pop(),
        onSaved: (_) => Navigator.of(context).pop(),
      ),
    );
  }
}
