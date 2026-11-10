part of 'patient_appointments_page.dart';

/// Highlighted card for the earliest upcoming appointment.
/// Owns the cancel request started from its own cancel button.
final class _PatientAppointmentsNextCard extends StatelessWidget {
  const _PatientAppointmentsNextCard({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientAppointmentCancelCubit>(
      create: (_) {
        return AppDependency.injector.get<PatientAppointmentCancelCubit>();
      },
      child:
          BlocListener<PatientAppointmentCancelCubit, AppointmentActionState>(
            listener: _onCancelState,
            child: _PatientAppointmentsNextCardBody(entry: entry),
          ),
    );
  }

  /// Reports the outcome of a cancel request started from this card.
  void _onCancelState(BuildContext context, AppointmentActionState state) {
    String? message;
    if (state is AppointmentActionSuccess) {
      message = LocaleKeys.patient_appointments_cancelled.translate();
    } else if (state is AppointmentActionFailure) {
      message = state.errorCode.message;
    }

    if (message == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
