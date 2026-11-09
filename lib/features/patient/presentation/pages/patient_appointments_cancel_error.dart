part of 'patient_appointments_page.dart';

/// The localized failure of the dialog's cancel request, when there is one.
final class _PatientAppointmentsCancelError extends StatelessWidget {
  const _PatientAppointmentsCancelError();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      PatientAppointmentCancelCubit,
      PatientAppointmentCancelState
    >(
      builder: (context, state) {
        if (state case PatientAppointmentCancelFailure(:final errorCode)) {
          return AppMessageBanner(
            message: errorCode.message,
            variant: AppMessageBannerVariant.error,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
