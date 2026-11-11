part of 'patient_book_page.dart';

/// The localized request failure, if any, above the request button.
final class _PatientBookSubmitArea extends StatelessWidget {
  const _PatientBookSubmitArea({
    required this.selection,
    required this.patient,
    required this.patientName,
  });

  final BookingSelection selection;
  final PatientAppointmentActor patient;
  final String patientName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s16,
          children: [
            if (state is BookAppointmentFailure)
              AppMessageBanner(
                message: state.errorCode.message,
                variant: AppMessageBannerVariant.error,
              ),
            _PatientBookSubmitButton(
              selection: selection,
              patient: patient,
              patientName: patientName,
              isBusy: state is BookAppointmentInProgress,
            ),
          ],
        );
      },
    );
  }
}
