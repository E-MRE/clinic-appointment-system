part of 'medical_service_form.dart';

/// Cancel action, disabled while a save is in progress.
final class _MedicalServiceFormCancelButton extends StatelessWidget {
  const _MedicalServiceFormCancelButton({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      MedicalServiceSaveCubit,
      InstitutionSaveState<MedicalService>
    >(
      builder: (context, state) {
        final isSaving = state is InstitutionSaveSaving<MedicalService>;
        return TextButton(
          onPressed: isSaving ? null : onCancel,
          child: AppText.label(LocaleKeys.institution_cancel.tr()),
        );
      },
    );
  }
}
