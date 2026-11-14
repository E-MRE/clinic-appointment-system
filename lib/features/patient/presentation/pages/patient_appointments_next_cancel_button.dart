part of 'patient_appointments_page.dart';

/// Requests cancellation of the next appointment when no request is running.
final class _PatientAppointmentsNextCancelButton extends StatelessWidget {
  const _PatientAppointmentsNextCancelButton({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    final onPrimaryContainer = context.colorScheme.onPrimaryContainer;
    return BlocBuilder<PatientAppointmentCancelCubit, AppointmentActionState>(
      builder: (context, state) {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: onPrimaryContainer,
            side: BorderSide(color: onPrimaryContainer),
          ),
          onPressed: state is AppointmentActionInProgress
              ? null
              : () => context.requestAppointmentCancel(entry),
          child: AppText.label(
            LocaleKeys.patient_appointments_cancel.translate(),
            tone: TextTone.onPrimaryContainer,
          ),
        );
      },
    );
  }
}
