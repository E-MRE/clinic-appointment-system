part of 'institution_page.dart';

/// Creates or renames a clinic in a focused name dialog.
final class _ClinicNameDialog extends StatelessWidget {
  const _ClinicNameDialog({
    required this.clinic,
    required this.controller,
    required this.selection,
  });

  final Clinic? clinic;
  final TextEditingController controller;
  final InstitutionSelection selection;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClinicSaveCubit, InstitutionSaveState<Clinic>>(
      listener: (context, state) {
        if (state is InstitutionSaveSaved<Clinic>) {
          selection.selectClinic(state.value.id);
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        title: AppText.sectionTitle(
          clinic == null
              ? LocaleKeys.institution_newClinic.tr()
              : LocaleKeys.institution_editClinic.tr(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: LocaleKeys.institution_clinicName.tr(),
              controller: controller,
            ),
            BlocBuilder<ClinicSaveCubit, InstitutionSaveState<Clinic>>(
              builder: (context, state) {
                if (state is InstitutionSaveFailure<Clinic>) {
                  return AppText.caption(
                    state.code.message,
                    tone: TextTone.error,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText.label(LocaleKeys.institution_cancel.tr()),
          ),
          FilledButton(
            onPressed: () => _save(context),
            child: AppText.label(
              LocaleKeys.institution_save.tr(),
              tone: TextTone.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context) {
    final save = context.read<ClinicSaveCubit>();
    final name = controller.text.trim();
    if (clinic case final existing?) {
      save.update(existing, name);
    } else {
      save.create(name);
    }
  }
}
