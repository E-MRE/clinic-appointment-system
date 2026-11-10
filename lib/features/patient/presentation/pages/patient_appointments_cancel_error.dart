part of 'patient_appointments_page.dart';

/// The localized failure of the dialog's cancel request, when there is one.
final class _PatientAppointmentsCancelError extends StatelessWidget {
  const _PatientAppointmentsCancelError();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientAppointmentCancelCubit, AppointmentActionState>(
      builder: (context, state) {
        if (state is AppointmentActionFailure) {
          return AppMessageBanner(
            message: state.errorCode.message,
            variant: AppMessageBannerVariant.error,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
