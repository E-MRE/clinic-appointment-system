part of 'patient_book_page.dart';

/// The localized request failure, if any, above the request button.
final class _PatientBookSubmitArea extends StatelessWidget {
  const _PatientBookSubmitArea({
    required this.selection,
    required this.patient,
  });

  final BookingSelection selection;
  final PatientAppointmentActor patient;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s16,
          children: [
            if (state case BookAppointmentFailure(:final errorCode))
              AppMessageBanner(
                message: errorCode.message,
                variant: AppMessageBannerVariant.error,
              ),
            _PatientBookSubmitButton(
              selection: selection,
              patient: patient,
              isBusy: state is BookAppointmentInProgress,
            ),
          ],
        );
      },
    );
  }
}
