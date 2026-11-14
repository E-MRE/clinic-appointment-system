part of 'patient_appointments_page.dart';

/// Recoverable failure that restarts the catalog and appointment watches.
final class _PatientAppointmentsFailure extends StatelessWidget {
  const _PatientAppointmentsFailure({required this.errorCode});

  final AppointmentErrorCode errorCode;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: LocaleKeys.patient_appointments_failureTitle.translate(),
      message: errorCode.message,
      icon: Icon(
        Icons.error_outline,
        color: context.colorScheme.onErrorContainer,
      ),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: () {
          context.read<ClinicCatalogCubit>().watch();
          context.read<PatientAppointmentsCubit>().retry();
        },
        child: AppText.label(
          LocaleKeys.patient_appointments_retry.translate(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
