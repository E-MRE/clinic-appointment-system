part of 'patient_appointments_page.dart';

/// Date tile, summary and actions; actions wrap below on mobile.
final class _PatientAppointmentsNextCardBody extends StatelessWidget {
  const _PatientAppointmentsNextCardBody({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const AppPadding.allXl(),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: const AppRadius.large(),
      ),
      child: context.screenSize.isMobile
          ? _PatientAppointmentsNextCardBodyMobile(entry: entry)
          : Row(
              spacing: AppSizes.s24,
              children: [
                _PatientAppointmentsDateTile(entry: entry),
                Expanded(child: _PatientAppointmentsNextSummary(entry: entry)),
                _PatientAppointmentsNextCardActions(entry: entry),
              ],
            ),
    );
  }
}
