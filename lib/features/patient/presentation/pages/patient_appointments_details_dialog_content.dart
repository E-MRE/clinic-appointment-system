part of 'patient_appointments_page.dart';

/// Shows the selected appointment's details and cancellation controls.
final class _PatientAppointmentsDetailsDialogContent extends StatelessWidget {
  const _PatientAppointmentsDetailsDialogContent({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
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
}
