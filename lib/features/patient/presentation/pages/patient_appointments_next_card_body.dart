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
          ? _buildMobile()
          : Row(
              spacing: AppSizes.s24,
              children: [
                _PatientAppointmentsDateTile(entry: entry),
                Expanded(child: _PatientAppointmentsNextSummary(entry: entry)),
                _PatientAppointmentsNextActions(entry: entry),
              ],
            ),
    );
  }

  Column _buildMobile() {
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
        _PatientAppointmentsNextActions(entry: entry),
      ],
    );
  }
}
