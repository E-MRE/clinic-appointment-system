part of 'patient_appointments_page.dart';

/// Cancel (when the domain allows it) and details actions of the next card.
final class _PatientAppointmentsNextActions extends StatelessWidget {
  const _PatientAppointmentsNextActions({required this.entry});

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
