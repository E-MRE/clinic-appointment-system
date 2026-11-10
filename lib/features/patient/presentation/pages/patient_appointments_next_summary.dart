part of 'patient_appointments_page.dart';

/// Label, status, service name and detail line of the next appointment.
final class _PatientAppointmentsNextSummary extends StatelessWidget {
  const _PatientAppointmentsNextSummary({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s8,
      children: [
        Wrap(
          spacing: AppSizes.s8,
          runSpacing: AppSizes.s4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppText.badge(
              LocaleKeys.patient_appointments_nextLabel.translate(),
              tone: TextTone.onPrimaryContainer,
            ),
            AppointmentStatusBadge(status: entry.appointment.status),
          ],
        ),
        AppText.sectionTitle(
          entry.serviceName,
          tone: TextTone.onPrimaryContainer,
        ),
        AppText.body(entry.detailLine, tone: TextTone.onPrimaryContainer),
      ],
    );
  }
}
