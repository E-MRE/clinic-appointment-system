part of 'patient_appointments_page.dart';

/// Shows the current appointment details while keeping the dialog's entry as a fallback.
final class _PatientAppointmentsDetailsContent extends StatelessWidget {
  const _PatientAppointmentsDetailsContent({
    required this.appointmentId,
    required this.initialEntry,
  });

  final String appointmentId;
  final PatientAppointmentEntry initialEntry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
      builder: (context, appointmentsState) {
        return _PatientAppointmentsDetailsDialogContent(
          entry: _currentEntry(appointmentsState),
        );
      },
    );
  }

  /// Finds the latest entry while retaining the dialog's initial fallback.
  PatientAppointmentEntry _currentEntry(
    PatientAppointmentsState appointmentsState,
  ) {
    if (appointmentsState is! PatientAppointmentsLoaded) {
      return initialEntry;
    }
    for (final entry in appointmentsState.overview.all) {
      if (entry.appointment.id == appointmentId) return entry;
    }
    return initialEntry;
  }
}
