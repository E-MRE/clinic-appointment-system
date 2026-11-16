part of 'patient_appointments_page.dart';

/// Shows the cancellation and details actions for an appointment.
final class _PatientAppointmentsNextCardActions extends StatelessWidget {
  const _PatientAppointmentsNextCardActions({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      alignment: WrapAlignment.end,
      children: [
        if (entry.canCancel) _PatientAppointmentsNextCancelButton(entry: entry),
        _PatientAppointmentsNextDetailsButton(entry: entry),
      ],
    );
  }
}
