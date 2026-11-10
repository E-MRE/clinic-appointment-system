part of 'patient_appointments_page.dart';

/// Asks the patient to confirm a cancellation; pops `true` to confirm.
final class _PatientAppointmentsCancelConfirmDialog extends StatelessWidget {
  const _PatientAppointmentsCancelConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppText.sectionTitle(
        LocaleKeys.patient_appointments_confirmCancel_title.translate(),
      ),
      content: AppText.body(
        LocaleKeys.patient_appointments_confirmCancel_message.translate(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            LocaleKeys.patient_appointments_confirmCancel_dismiss.translate(),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            LocaleKeys.patient_appointments_confirmCancel_confirm.translate(),
          ),
        ),
      ],
    );
  }
}
