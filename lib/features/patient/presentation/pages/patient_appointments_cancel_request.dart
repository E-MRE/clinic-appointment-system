part of 'patient_appointments_page.dart';

/// The confirm-then-cancel step shared by the next card and details dialog.
extension _PatientAppointmentsCancelRequest on BuildContext {
  /// Asks for confirmation, then cancels [entry] as the signed-in patient
  /// through the nearest [PatientAppointmentCancelCubit].
  Future<void> requestAppointmentCancel(PatientAppointmentEntry entry) async {
    final cubit = read<PatientAppointmentCancelCubit>();
    final session = read<AuthCubit>().state;
    if (session is! AuthSignedIn) return;
    final confirmed = await showDialog<bool>(
      context: this,
      builder: (_) => const _PatientAppointmentsCancelConfirmDialog(),
    );
    if (confirmed != true) return;
    await cubit.cancel(
      entry.appointment,
      patient: PatientAppointmentActor(id: session.user.id),
    );
  }
}
