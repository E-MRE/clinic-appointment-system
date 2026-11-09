part of 'patient_appointments_page.dart';

/// Service column cell: kind icon, name and kind or cancellation caption.
final class _PatientAppointmentsServiceCell extends StatelessWidget {
  const _PatientAppointmentsServiceCell({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.s12,
      children: [
        AppIconTile(icon: entry.kindIcon, size: AppIconTileSize.small),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.bodyStrong(entry.serviceName),
              AppText.caption(entry.serviceCaption, tone: TextTone.muted),
            ],
          ),
        ),
      ],
    );
  }
}
