part of 'patient_appointments_page.dart';

/// Shows the current appointment details while keeping the dialog's entry as a fallback.
final class _PatientAppointmentsDetailsContent extends StatelessWidget {
  const _PatientAppointmentsDetailsContent({
    required this.appointmentId,
    required this.initialEntry,
  });

  final String appointmentId;
  final PatientAppointmentEntry initialEntry;

  Widget _dateTimeRow(PatientAppointmentEntry entry) {
    return AppDefinitionRow(
      label: LocaleKeys.patient_appointments_dialog_dateTime.translate(),
      child: AppText.bodyStrong(entry.longDateTimeLabel),
    );
  }

  Widget _staffRow(PatientAppointmentEntry entry) {
    return AppDefinitionRow(
      label: LocaleKeys.patient_appointments_dialog_staff.translate(),
      child: AppText.bodyStrong(entry.staffName),
    );
  }

  Widget _locationRow(PatientAppointmentEntry entry) {
    return AppDefinitionRow(
      label: LocaleKeys.patient_appointments_dialog_location.translate(),
      child: AppText.bodyStrong(entry.location),
    );
  }

  Widget _feeRow(PatientAppointmentEntry entry) {
    return AppDefinitionRow(
      label: LocaleKeys.patient_appointments_dialog_fee.translate(),
      child: AppText.bodyStrong(entry.fee),
    );
  }

  Widget _statusRow(PatientAppointmentEntry entry) {
    return AppDefinitionRow(
      label: LocaleKeys.patient_appointments_dialog_status.translate(),
      child: AppointmentStatusBadge(status: entry.appointment.status),
    );
  }

  Widget _noteRow(PatientAppointmentEntry entry) {
    return AppDefinitionRow(
      label: LocaleKeys.patient_appointments_dialog_note.translate(),
      child: AppText.bodyStrong(entry.cancellationNote ?? ''),
    );
  }

  Widget _dialog(PatientAppointmentEntry entry) {
    return AppFormDialog(
      title: entry.serviceName,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          _dateTimeRow(entry),
          _staffRow(entry),
          _locationRow(entry),
          _feeRow(entry),
          _statusRow(entry),
          if (entry.cancellationNote != null) _noteRow(entry),
          const _PatientAppointmentsCancelError(),
          _PatientAppointmentsDialogActions(entry: entry),
        ],
      ),
    );
  }

  PatientAppointmentEntry _currentEntry(
    PatientAppointmentsState appointmentsState,
    ClinicCatalogState catalogState,
  ) {
    if (appointmentsState is! PatientAppointmentsLoaded ||
        catalogState is! ClinicCatalogLoaded) {
      return initialEntry;
    }
    final overview = PatientAppointmentsOverview(
      appointments: appointmentsState.appointments,
      catalog: catalogState.catalog,
      now: AppDependency.injector.get<Clock>().now(),
      patient: PatientAppointmentActor(id: initialEntry.appointment.patientId),
    );
    for (final entry in overview.all) {
      if (entry.appointment.id == appointmentId) return entry;
    }
    return initialEntry;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
      builder: (context, appointmentsState) {
        final catalogState = context.watch<ClinicCatalogCubit>().state;
        return _dialog(_currentEntry(appointmentsState, catalogState));
      },
    );
  }
}
