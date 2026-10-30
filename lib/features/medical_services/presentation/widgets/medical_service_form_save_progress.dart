part of 'medical_service_form.dart';

/// Announced progress indicator shown inside the save button.
final class _MedicalServiceFormSaveProgress extends StatelessWidget {
  const _MedicalServiceFormSaveProgress();

  @override
  Widget build(BuildContext context) {
    return AnnouncedSemantics(
      label: LocaleKeys.services_saving.tr(),
      child: SizedBox.square(
        dimension: AppSizes.s20,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.s2,
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
