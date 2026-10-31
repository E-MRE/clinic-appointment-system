part of 'staff_form.dart';

/// Shows saving progress or the creation/edit action.
final class _StaffFormSaveButton extends StatelessWidget {
  const _StaffFormSaveButton({required this.isEditing, required this.onSave});

  final bool isEditing;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffSaveCubit, StaffSaveState>(
      builder: (context, state) {
        if (state is StaffSaveSaving) {
          return const FilledButton(
            onPressed: null,
            child: _StaffFormSaveProgress(),
          );
        }
        return FilledButton(
          onPressed: onSave,
          child: AppText.label(_labelKey.tr(), tone: TextTone.onPrimary),
        );
      },
    );
  }

  String get _labelKey {
    if (isEditing) return LocaleKeys.staff_save;
    return LocaleKeys.staff_createAccount;
  }
}
