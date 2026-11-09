part of 'patient_book_page.dart';

/// Announced progress indicator shown inside the request button.
final class _PatientBookSubmitProgress extends StatelessWidget {
  const _PatientBookSubmitProgress();

  @override
  Widget build(BuildContext context) {
    return AnnouncedSemantics(
      label: LocaleKeys.patient_book_submitting.translate(),
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
