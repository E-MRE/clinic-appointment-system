part of 'patient_book_page.dart';

/// Recoverable catalog failure that restarts the catalog watch.
final class _PatientBookFailure extends StatelessWidget {
  const _PatientBookFailure();

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: LocaleKeys.patient_book_failureTitle.translate(),
      message: LocaleKeys.appointment_errors_unavailable.translate(),
      icon: Icon(
        Icons.error_outline,
        color: context.colorScheme.onErrorContainer,
      ),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: () => context.read<ClinicCatalogCubit>().watch(),
        child: AppText.label(
          LocaleKeys.patient_book_retry.translate(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
