part of 'patient_appointments_page.dart';

/// The next appointment card above the appointments table.
final class _PatientAppointmentsPrimaryColumn extends StatelessWidget {
  const _PatientAppointmentsPrimaryColumn({required this.overview});

  final PatientAppointmentsOverview overview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s24,
      children: [
        if (overview.next case final next?)
          _PatientAppointmentsNextCard(entry: next),
        _PatientAppointmentsListCard(overview: overview),
      ],
    );
  }
}
