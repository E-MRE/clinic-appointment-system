part of 'staff_management_page.dart';

/// Displays the revision-keyed form for the current desktop edit target.
final class _StaffManagementDesktopPanelBody extends StatelessWidget {
  const _StaffManagementDesktopPanelBody();

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<StaffEditorCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          editor.isEditing
              ? LocaleKeys.staff_editTitle.tr()
              : LocaleKeys.staff_addTitle.tr(),
        ),
        const EmptySize.s16Height(),
        StaffForm(
          key: ValueKey<int>(editor.revision),
          staff: editor.record,
          onCancel: editor.isEditing
              ? context.read<StaffEditorCubit>().startCreate
              : null,
          onSaved: (_) {
            context.read<StaffEditorCubit>().startCreate();
          },
        ),
      ],
    );
  }
}
