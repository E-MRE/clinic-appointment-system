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

  /// Builds the appointment details and cancel action content.
  Widget _buildDialog(PatientAppointmentEntry entry) {
    return AppFormDialog(
      title: entry.presentation.serviceName,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          _buildRow(
            LocaleKeys.patient_appointments_dialog_dateTime.translate(),
            AppText.bodyStrong(entry.presentation.longDateTimeLabel),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_staff.translate(),
            AppText.bodyStrong(entry.presentation.staffName),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_location.translate(),
            AppText.bodyStrong(entry.presentation.location),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_fee.translate(),
            AppText.bodyStrong(entry.presentation.fee),
          ),
          _buildRow(
            LocaleKeys.patient_appointments_dialog_status.translate(),
            AppointmentStatusBadge(status: entry.appointment.status),
          ),
          if (entry.presentation.cancellationNote != null)
            _buildRow(
              LocaleKeys.patient_appointments_dialog_note.translate(),
              AppText.bodyStrong(entry.presentation.cancellationNote ?? ''),
            ),
          _buildCancelError(),
          _PatientAppointmentsDialogActions(entry: entry),
        ],
      ),
    );
  }

  /// Builds the localized cancel failure banner within the dialog.
  BlocBuilder<PatientAppointmentCancelCubit, AppointmentActionState>
  _buildCancelError() {
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

  /// Builds one labeled appointment detail row.
  AppDefinitionRow _buildRow(String label, Widget child) {
    return AppDefinitionRow(label: label, child: child);
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
