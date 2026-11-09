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
    final message = switch (state) {
      AppointmentActionSuccess() =>
        LocaleKeys.patient_appointments_cancelled.translate(),
      AppointmentActionFailure(:final errorCode) => errorCode.message,
      AppointmentActionIdle() || AppointmentActionInProgress() => null,
    };
    if (message == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
