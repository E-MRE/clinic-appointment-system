part of 'patient_appointments_page.dart';

/// Appointment details with the patient's cancel action.
/// Owns its cancel request: closes with a confirmation on success and
/// shows the localized error in place on failure.
final class _PatientAppointmentsDetailsDialog extends StatelessWidget {
  const _PatientAppointmentsDetailsDialog({required this.entry});

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
            child: AppFormDialog(
              title: entry.serviceName,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSizes.s16,
                children: [
                  AppDefinitionRow(
                    label: LocaleKeys.patient_appointments_dialog_dateTime
                        .translate(),
                    child: AppText.bodyStrong(entry.longDateTimeLabel),
                  ),
                  AppDefinitionRow(
                    label: LocaleKeys.patient_appointments_dialog_staff
                        .translate(),
                    child: AppText.bodyStrong(entry.staffName),
                  ),
                  AppDefinitionRow(
                    label: LocaleKeys.patient_appointments_dialog_location
                        .translate(),
                    child: AppText.bodyStrong(entry.location),
                  ),
                  AppDefinitionRow(
                    label: LocaleKeys.patient_appointments_dialog_fee
                        .translate(),
                    child: AppText.bodyStrong(entry.fee),
                  ),
                  AppDefinitionRow(
                    label: LocaleKeys.patient_appointments_dialog_status
                        .translate(),
                    child: AppointmentStatusBadge(
                      status: entry.appointment.status,
                    ),
                  ),
                  if (entry.cancellationNote case final note?)
                    AppDefinitionRow(
                      label: LocaleKeys.patient_appointments_dialog_note
                          .translate(),
                      child: AppText.bodyStrong(note),
                    ),
                  const _PatientAppointmentsCancelError(),
                  _PatientAppointmentsDialogActions(entry: entry),
                ],
              ),
            ),
          ),
    );
  }

  /// Closes the dialog and confirms a successful cancellation.
  void _onCancelState(BuildContext context, AppointmentActionState state) {
    if (state is! AppointmentActionSuccess) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.patient_appointments_cancelled.translate()),
      ),
    );
  }
}
