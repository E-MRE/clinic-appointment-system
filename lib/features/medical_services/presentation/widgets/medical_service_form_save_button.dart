part of 'medical_service_form.dart';

/// Save action showing progress and ignoring taps while saving.
final class _MedicalServiceFormSaveButton extends StatelessWidget {
  const _MedicalServiceFormSaveButton({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      MedicalServiceSaveCubit,
      InstitutionSaveState<MedicalService>
    >(
      builder: (context, state) {
        if (state is InstitutionSaveSaving<MedicalService>) {
          return const FilledButton(
            onPressed: null,
            child: _MedicalServiceFormSaveProgress(),
          );
        }
        return FilledButton(
          onPressed: onSave,
          child: AppText.label(
            LocaleKeys.services_saveService.tr(),
            tone: TextTone.onPrimary,
          ),
        );
      },
    );
  }
}
