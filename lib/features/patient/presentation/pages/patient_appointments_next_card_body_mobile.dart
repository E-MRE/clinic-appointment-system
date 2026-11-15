part of 'patient_appointments_page.dart';

/// Stacks the next appointment date, summary and actions on mobile.
final class _PatientAppointmentsNextCardBodyMobile extends StatelessWidget {
  const _PatientAppointmentsNextCardBodyMobile({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSizes.s16,
          children: [
            _PatientAppointmentsDateTile(entry: entry),
            Expanded(child: _PatientAppointmentsNextSummary(entry: entry)),
          ],
        ),
        _PatientAppointmentsNextCardActions(entry: entry),
      ],
    );
  }
}
