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
        return _buildDialog(_currentEntry(appointmentsState));
      },
    );
  }

  Widget _buildDialog(PatientAppointmentEntry entry) {
    return AppFormDialog(
      title: entry.serviceName,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          _buildRow(
            LocaleKeys.patient_appointments_dialog_dateTime.translate(),
            AppText.bodyStrong(entry.longDateTimeLabel),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_staff.translate(),
            AppText.bodyStrong(entry.staffName),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_location.translate(),
            AppText.bodyStrong(entry.location),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_fee.translate(),
            AppText.bodyStrong(entry.fee),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_status.translate(),
            AppointmentStatusBadge(status: entry.appointment.status),
          ),
          if (entry.cancellationNote != null)
            _buildRow(
              LocaleKeys.patient_appointments_dialog_note.translate(),
              AppText.bodyStrong(entry.cancellationNote ?? ''),
            ),
          const _PatientAppointmentsCancelError(),
          _PatientAppointmentsDialogActions(entry: entry),
        ],
      ),
    );
  }

  AppDefinitionRow _buildRow(String label, Widget child) {
    return AppDefinitionRow(label: label, child: child);
  }

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
