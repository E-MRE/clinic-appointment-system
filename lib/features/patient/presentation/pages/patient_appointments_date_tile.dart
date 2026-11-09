part of 'patient_appointments_page.dart';

/// Month, day and weekday of the next appointment.
final class _PatientAppointmentsDateTile extends StatelessWidget {
  const _PatientAppointmentsDateTile({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.appointmentDateTileWidth,
      padding: const AppPadding.verticalMd(),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const AppRadius.large(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.caption(entry.monthLabel, tone: TextTone.muted),
          AppText.display(entry.dayLabel),
          AppText.caption(
            entry.weekdayLabel,
            tone: TextTone.muted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
